#include <algorithm>
#include <cstddef>
#include <cstdint>
#include <cstdio>
#include <cstring>
#include <fstream>
#include <iostream>
#include <iterator>
#include <stdexcept>
#include <string>
#include <vector>

#include "common.hpp"
#include "e32common.h"

static_assert(sizeof(E32ImageHeader) == 0x7C, "unexpected E32 base header size");
static_assert(offsetof(E32ImageHeader, iCodeOffset) == 0x64, "unexpected iCodeOffset offset");
static_assert(sizeof(E32ImageHeaderJ) == 4, "unexpected E32 J extension size");
static_assert(sizeof(E32ImageHeaderV) == 0x1C, "unexpected E32 V extension size");

extern void DeCompressInflate(unsigned char* source, int sourceSize,
                              unsigned char* destination, int destinationSize);
extern uint32_t DecompressBPE(const char* source, char* destination);
extern uint32_t CompressBPE(const char* source, uint32_t sourceSize,
                            char* destination, uint32_t destinationSize);
extern size_t CompressDeflate(const char* source, int sourceSize,
                              const char* destination, int destinationSize);

void ReportError(const ErrorCodes err, const std::string& message,
                 const std::string& detail, int) {
    throw std::runtime_error("Symbian codec error " + std::to_string(static_cast<int>(err)) +
                             ": " + message + " " + detail);
}

namespace {
constexpr uint32_t DLL_UID = 0x10000079;
constexpr uint32_t EXE_UID = 0x1000007A;
constexpr uint32_t DEFLATE_UID = 0x101F7AFC;
constexpr uint32_t BYTEPAIR_UID = 0x102822AA;
constexpr size_t MAX_E32_SIZE = 64u * 1024u * 1024u;
constexpr uint32_t BPE_PAGE_SIZE = 4096;

uint16_t read_u16(const char* p) {
    const auto* b = reinterpret_cast<const unsigned char*>(p);
    return static_cast<uint16_t>(b[0] | (static_cast<uint16_t>(b[1]) << 8));
}

uint32_t read_u32(const char* p) {
    const auto* b = reinterpret_cast<const unsigned char*>(p);
    return static_cast<uint32_t>(b[0]) |
           (static_cast<uint32_t>(b[1]) << 8) |
           (static_cast<uint32_t>(b[2]) << 16) |
           (static_cast<uint32_t>(b[3]) << 24);
}

void write_u32(char* p, uint32_t value) {
    p[0] = static_cast<char>(value & 0xFF);
    p[1] = static_cast<char>((value >> 8) & 0xFF);
    p[2] = static_cast<char>((value >> 16) & 0xFF);
    p[3] = static_cast<char>((value >> 24) & 0xFF);
}

struct BpeBlockInfo {
    uint32_t compressedSize = 0;
    uint32_t outputSize = 0;
    uint16_t pageCount = 0;
};

BpeBlockInfo inspect_bpe_block(const char* source, size_t available) {
    if (available < 10) throw std::runtime_error("BytePair block header is truncated");
    const int32_t compressed = static_cast<int32_t>(read_u32(source));
    const int32_t output = static_cast<int32_t>(read_u32(source + 4));
    const uint16_t pages = read_u16(source + 8);
    if (compressed < 10 || static_cast<size_t>(compressed) > available)
        throw std::runtime_error("BytePair compressed block size is outside input");
    if (output < 0 || static_cast<size_t>(output) > MAX_E32_SIZE)
        throw std::runtime_error("BytePair output size is outside safety limit");
    const uint32_t expectedPages = output == 0 ? 0 :
        (static_cast<uint32_t>(output) + BPE_PAGE_SIZE - 1) / BPE_PAGE_SIZE;
    if (pages != expectedPages)
        throw std::runtime_error("BytePair page count does not match decompressed size");
    const size_t indexBytes = static_cast<size_t>(pages) * 2;
    if (10 + indexBytes > static_cast<size_t>(compressed))
        throw std::runtime_error("BytePair page index table exceeds block");
    return {static_cast<uint32_t>(compressed), static_cast<uint32_t>(output), pages};
}

struct ImageInfo {
    uint32_t compression = 0;
    uint32_t headerFormat = 0;
    uint32_t headerSize = 0;
    uint32_t uncompressedSize = 0;
    uint32_t codeSize = 0;
    uint32_t dataSize = 0;
    uint32_t decodedCodeSize = 0;
    uint32_t decodedDataSize = 0;
};

std::vector<char> decompress_image(const std::vector<char>& source, ImageInfo& info) {
    if (source.size() < 0x80 || std::memcmp(source.data() + 0x10, "EPOC", 4) != 0)
        throw std::runtime_error("input is not a complete E32 image header");

    const uint32_t uid1 = read_u32(source.data());
    if (uid1 != DLL_UID && uid1 != EXE_UID)
        throw std::runtime_error("EPOC image has unsupported UID1");

    info.compression = read_u32(source.data() + 0x1C);
    info.headerFormat = (read_u32(source.data() + 0x2C) & 0x0F000000) >> 24;
    info.headerSize = read_u32(source.data() + 0x64);
    info.uncompressedSize = read_u32(source.data() + 0x7C);
    info.codeSize = read_u32(source.data() + 0x30);
    info.dataSize = read_u32(source.data() + 0x34);

    if (info.compression == 0) return source;
    const uint32_t minimumHeader = info.headerFormat == 1 ? 0x80 :
                                   info.headerFormat == 2 ? 0x9C : 0;
    if (minimumHeader == 0)
        throw std::runtime_error("compressed E32 header format is not J or V");
    if (info.headerSize < minimumHeader || info.headerSize > source.size())
        throw std::runtime_error("iCodeOffset/header size is outside input");
    if (info.uncompressedSize == 0 ||
        info.uncompressedSize > MAX_E32_SIZE ||
        static_cast<uint64_t>(info.headerSize) + info.uncompressedSize > MAX_E32_SIZE)
        throw std::runtime_error("iUncompressedSize is outside safety limit");
    if ((info.headerSize + info.uncompressedSize) & 3)
        throw std::runtime_error("uncompressed E32 total size is not 4-byte aligned");

    std::vector<char> flat(static_cast<size_t>(info.headerSize) + info.uncompressedSize, 0);
    std::copy(source.begin(), source.begin() + info.headerSize, flat.begin());
    const char* compressedPayload = source.data() + info.headerSize;
    const size_t compressedPayloadSize = source.size() - info.headerSize;
    char* outputPayload = flat.data() + info.headerSize;

    if (info.compression == DEFLATE_UID) {
        if (compressedPayloadSize > static_cast<size_t>(INT32_MAX) ||
            info.uncompressedSize > static_cast<uint32_t>(INT32_MAX))
            throw std::runtime_error("Deflate input/output exceeds codec integer range");
        DeCompressInflate(
            reinterpret_cast<unsigned char*>(const_cast<char*>(compressedPayload)),
            static_cast<int>(compressedPayloadSize),
            reinterpret_cast<unsigned char*>(outputPayload),
            static_cast<int>(info.uncompressedSize));
        info.decodedCodeSize = info.uncompressedSize;
    } else if (info.compression == BYTEPAIR_UID) {
        const BpeBlockInfo codeBlock = inspect_bpe_block(compressedPayload, compressedPayloadSize);
        if (codeBlock.outputSize > info.uncompressedSize)
            throw std::runtime_error("BytePair code block exceeds iUncompressedSize");
        const uint32_t codeOut = DecompressBPE(compressedPayload, outputPayload);
        if (codeOut != codeBlock.outputSize)
            throw std::runtime_error("BytePair code output disagrees with block header");
        info.decodedCodeSize = codeOut;

        size_t consumed = codeBlock.compressedSize;
        size_t remainingOutput = info.uncompressedSize - codeOut;
        if (remainingOutput != 0) {
            if (consumed >= compressedPayloadSize)
                throw std::runtime_error("BytePair data block is missing");
            const BpeBlockInfo dataBlock = inspect_bpe_block(
                compressedPayload + consumed, compressedPayloadSize - consumed);
            if (dataBlock.outputSize != remainingOutput)
                throw std::runtime_error("BytePair data block size disagrees with remaining output");
            const uint32_t dataOut = DecompressBPE(
                nullptr, outputPayload + codeOut);
            if (dataOut != dataBlock.outputSize)
                throw std::runtime_error("BytePair data output disagrees with block header");
            info.decodedDataSize = dataOut;
            consumed += dataBlock.compressedSize;
        }
        if (info.decodedCodeSize + info.decodedDataSize != info.uncompressedSize)
            throw std::runtime_error("BytePair decoded size does not equal iUncompressedSize");
        if (compressedPayloadSize > consumed + 3)
            throw std::runtime_error("BytePair stream has unexplained trailing bytes");
    } else {
        throw std::runtime_error("unsupported E32 compression UID 0x" +
                                 std::to_string(info.compression));
    }

    write_u32(flat.data() + 0x1C, 0);
    return flat;
}

std::vector<char> read_file(const std::string& path) {
    std::ifstream input(path, std::ios::binary);
    if (!input) throw std::runtime_error("cannot open input file: " + path);
    return std::vector<char>((std::istreambuf_iterator<char>(input)),
                             std::istreambuf_iterator<char>());
}

void write_file(const std::string& path, const std::vector<char>& data) {
    std::ofstream output(path, std::ios::binary | std::ios::trunc);
    if (!output) throw std::runtime_error("cannot open output file: " + path);
    output.write(data.data(), static_cast<std::streamsize>(data.size()));
    if (!output) throw std::runtime_error("failed writing output file: " + path);
}

std::vector<char> make_v_header(uint32_t compression, uint32_t codeSize,
                                uint32_t dataSize, uint32_t uncompressedSize) {
    std::vector<char> header(0x9C, 0);
    write_u32(header.data(), DLL_UID);
    write_u32(header.data() + 4, 0x1000008D);
    write_u32(header.data() + 8, 0xE000BEEF);
    std::memcpy(header.data() + 0x10, "EPOC", 4);
    write_u32(header.data() + 0x1C, compression);
    write_u32(header.data() + 0x2C, 0x02000001);
    write_u32(header.data() + 0x30, codeSize);
    write_u32(header.data() + 0x34, dataSize);
    write_u32(header.data() + 0x64, 0x9C);
    write_u32(header.data() + 0x7C, uncompressedSize);
    write_u32(header.data() + 0x80, 0xE000BEEF);
    write_u32(header.data() + 0x84, 0x101FB657);
    return header;
}

void self_test() {
    std::vector<char> deflatePayload(8192);
    const std::string pattern = "Shadowkey-N95-Symbian-E32-native-deflate/";
    for (size_t i = 0; i < deflatePayload.size(); ++i)
        deflatePayload[i] = pattern[i % pattern.size()];
    std::vector<char> deflatePacked(deflatePayload.size() * 2 + 4096);
    const size_t deflateSize = CompressDeflate(
        deflatePayload.data(), static_cast<int>(deflatePayload.size()),
        deflatePacked.data(), static_cast<int>(deflatePacked.size()));
    if (deflateSize == 0 || deflateSize > deflatePacked.size())
        throw std::runtime_error("Symbian Deflate self-test encoder failed");
    std::vector<char> deflateFile = make_v_header(
        DEFLATE_UID, static_cast<uint32_t>(deflatePayload.size()), 0,
        static_cast<uint32_t>(deflatePayload.size()));
    deflateFile.insert(deflateFile.end(), deflatePacked.begin(), deflatePacked.begin() + deflateSize);
    ImageInfo deflateInfo;
    const std::vector<char> deflateFlat = decompress_image(deflateFile, deflateInfo);
    if (!std::equal(deflatePayload.begin(), deflatePayload.end(),
                    deflateFlat.begin() + 0x9C))
        throw std::runtime_error("Symbian Deflate self-test roundtrip mismatch");

    std::vector<char> code(5000);
    std::vector<char> data(3000);
    for (size_t i = 0; i < code.size(); ++i) code[i] = static_cast<char>((i / 17) & 0xFF);
    for (size_t i = 0; i < data.size(); ++i) data[i] = static_cast<char>((i / 11) & 0x7F);
    std::vector<char> packedCode(code.size() * 2 + 1024);
    std::vector<char> packedData(data.size() * 2 + 1024);
    const uint32_t packedCodeSize = CompressBPE(
        code.data(), static_cast<uint32_t>(code.size()),
        packedCode.data(), static_cast<uint32_t>(packedCode.size()));
    const uint32_t packedDataSize = CompressBPE(
        data.data(), static_cast<uint32_t>(data.size()),
        packedData.data(), static_cast<uint32_t>(packedData.size()));
    if (packedCodeSize == 0 || packedDataSize == 0)
        throw std::runtime_error("Symbian BytePair self-test encoder failed");
    std::vector<char> bpeFile = make_v_header(
        BYTEPAIR_UID, static_cast<uint32_t>(code.size()),
        static_cast<uint32_t>(data.size()),
        static_cast<uint32_t>(code.size() + data.size()));
    bpeFile.insert(bpeFile.end(), packedCode.begin(), packedCode.begin() + packedCodeSize);
    bpeFile.insert(bpeFile.end(), packedData.begin(), packedData.begin() + packedDataSize);
    ImageInfo bpeInfo;
    const std::vector<char> bpeFlat = decompress_image(bpeFile, bpeInfo);
    if (!std::equal(code.begin(), code.end(), bpeFlat.begin() + 0x9C) ||
        !std::equal(data.begin(), data.end(), bpeFlat.begin() + 0x9C + code.size()))
        throw std::runtime_error("Symbian BytePair self-test roundtrip mismatch");

    std::cout << "Step116 native Symbian E32 codec self-tests: PASS (Deflate + BytePair)\n";
}

} // namespace

int main(int argc, char** argv) {
    try {
        if (argc == 2 && std::string(argv[1]) == "--self-test") {
            self_test();
            return 0;
        }
        if (argc != 3) {
            std::cerr << "usage: e32inflate <input-e32> <output-e32> | --self-test\n";
            return 2;
        }
        const std::vector<char> source = read_file(argv[1]);
        ImageInfo info;
        const std::vector<char> flat = decompress_image(source, info);
        write_file(argv[2], flat);
        std::cout << "OK compression=0x" << std::hex << info.compression
                  << " format=" << std::dec << info.headerFormat
                  << " header=0x" << std::hex << info.headerSize
                  << " uncompressed=0x" << info.uncompressedSize
                  << " output=0x" << flat.size() << std::dec << "\n";
        return 0;
    } catch (const std::exception& exc) {
        std::cerr << "E32 inflate error: " << exc.what() << "\n";
        return 1;
    } catch (...) {
        std::cerr << "E32 inflate error: unknown exception\n";
        return 1;
    }
}
