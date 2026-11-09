$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"
$reportRoot = Join-Path $env:GITHUB_WORKSPACE "e32-probe"
$workRoot = Join-Path $env:RUNNER_TEMP "e32-toolchain-work"
New-Item -ItemType Directory -Force -Path $reportRoot, $workRoot | Out-Null

$sdkArchive = Join-Path $workRoot "s60-sdk.tar.gz"
$gccArchive = Join-Path $workRoot "gcce14.zip"
$sdkRoot = Join-Path $workRoot "sdk"
$gccRoot = Join-Path $workRoot "gcc"

Write-Host "Downloading pinned S60 3.1 FP1 SDK devkit"
curl.exe -fL --retry 3 -H "Authorization: Bearer $env:GITHUB_TOKEN" -H "Accept: application/octet-stream" "https://api.github.com/repos/Shakalx3/Shadowkey/releases/assets/723972349" -o $sdkArchive
if ($LASTEXITCODE -ne 0) { throw "SDK download failed: $LASTEXITCODE" }
$sdkHash = (Get-FileHash -Algorithm SHA256 $sdkArchive).Hash.ToLower()
if ($sdkHash -ne "7ed8b62b15f191ca47d2f6ca97ee5ce74cd02ce3e42b74bc7b1f9513d7df87b5") { throw "Pinned SDK SHA-256 mismatch: $sdkHash" }
New-Item -ItemType Directory -Force -Path $sdkRoot | Out-Null
tar.exe -xzf $sdkArchive -C $sdkRoot
if ($LASTEXITCODE -ne 0) { throw "SDK extraction failed: $LASTEXITCODE" }

Write-Host "Downloading GCCE4Symbian 14.2.0 Windows toolchain"
$gccUrl = "https://downloads.sourceforge.net/project/gcce4symbian/GCC-14.2.0_BINUTILS-2.29.1/gcc-14.2.0_win32.zip"
curl.exe -fL --retry 3 $gccUrl -o $gccArchive
if ($LASTEXITCODE -ne 0) { throw "GCCE download failed: $LASTEXITCODE" }
$gccHash = (Get-FileHash -Algorithm SHA256 $gccArchive).Hash.ToLower()
Expand-Archive -Force $gccArchive $gccRoot

$gcc = Get-ChildItem -Path $gccRoot -Recurse -Filter "arm-none-symbianelf-gcc.exe" | Select-Object -First 1
$ld = Get-ChildItem -Path $gccRoot -Recurse -Filter "arm-none-symbianelf-ld.exe" | Select-Object -First 1
$readelf = Get-ChildItem -Path $gccRoot -Recurse -Filter "arm-none-symbianelf-readelf.exe" | Select-Object -First 1
if (-not $gcc -or -not $ld -or -not $readelf) { throw "GCCE toolchain executables not found in downloaded archive" }

$version = (& $gcc.FullName --version 2>&1 | Out-String)
$probeSource = Join-Path $workRoot "probe.c"
$probeObject = Join-Path $workRoot "probe.o"
$probeElf = Join-Path $workRoot "probe.elf"
$e32Path = Join-Path $workRoot "probe.exe"
Set-Content -Encoding ascii $probeSource "int E32Main(void) { return 0; }"

Write-Host "Compiling a freestanding ARMv5TE E32Main probe"
$compileOutput = (& $gcc.FullName -march=armv5te -mfloat-abi=soft -ffreestanding -fno-builtin -fno-exceptions -fno-rtti -c $probeSource -o $probeObject 2>&1 | Out-String)
$compileExit = $LASTEXITCODE
if ($compileExit -ne 0) { throw "GCCE compile failed ($compileExit): $compileOutput" }

$objectHeader = (& $readelf.FullName -h $probeObject 2>&1 | Out-String)
$objectAttributes = (& $readelf.FullName -A $probeObject 2>&1 | Out-String)
Write-Host "Linking a freestanding ELF executable"
$linkOutput = (& $ld.FullName -e E32Main -Ttext 0x10000 -o $probeElf $probeObject 2>&1 | Out-String)
$linkExit = $LASTEXITCODE
if ($linkExit -ne 0 -or -not (Test-Path $probeElf)) { throw "ELF link failed ($linkExit): $linkOutput" }
$elfHeader = (& $readelf.FullName -h $probeElf 2>&1 | Out-String)
$elfAttributes = (& $readelf.FullName -A $probeElf 2>&1 | Out-String)

$elf2e32 = Join-Path $sdkRoot "Epoc32\tools\elf2e32.exe"
if (-not (Test-Path $elf2e32)) { $elf2e32 = Get-ChildItem -Path $sdkRoot -Recurse -Filter "elf2e32.exe" | Select-Object -First 1 -ExpandProperty FullName }
if (-not $elf2e32) { throw "SDK elf2e32.exe not found" }
$helpOutput = (& $elf2e32 --help 2>&1 | Out-String)
$helpExit = $LASTEXITCODE

$libPath = Join-Path $sdkRoot "Epoc32\release\armv5\lib"
$args = @(
  "--elfinput=$probeElf",
  "--output=$e32Path",
  "--targettype=EXE",
  "--uid1=0x1000007A",
  "--uid2=0x20000001",
  "--uid3=0x20000001",
  "--sid=0x20000001",
  "--capability=none",
  "--version=1.0",
  "--stack=8192",
  "--heap=4096,1048576",
  "--libpath=$libPath"
)
$conversionOutput = (& $elf2e32 @args 2>&1 | Out-String)
$conversionExit = $LASTEXITCODE
if ($conversionExit -ne 0 -or -not (Test-Path $e32Path)) { throw "elf2e32 conversion failed ($conversionExit): $conversionOutput" }

Write-Host "Re-reading the generated E32Image header"
$dumpExit = -998
$dumpOutput = "E32 dump utility was not invoked; raw header bytes and SHA-256 are recorded below."
$e32Bytes = [IO.File]::ReadAllBytes($e32Path)
$e32Hex = [BitConverter]::ToString($e32Bytes[0..([Math]::Min(63, $e32Bytes.Length - 1))])
$e32Hash = (Get-FileHash -Algorithm SHA256 $e32Path).Hash.ToLower()
$e32Size = $e32Bytes.Length

Copy-Item $e32Path (Join-Path $reportRoot "probe.e32")
Copy-Item $probeElf (Join-Path $reportRoot "probe.elf")
Copy-Item $probeObject (Join-Path $reportRoot "probe.o")

$report = [ordered]@{
  sdk_sha256 = $sdkHash
  gcc_toolchain_url = $gccUrl
  gcc_toolchain_sha256 = $gccHash
  gcc_path = $gcc.FullName
  ld_path = $ld.FullName
  readelf_path = $readelf.FullName
  gcc_version = $version
  compile_exit = $compileExit
  compile_output = $compileOutput
  object_header = $objectHeader
  object_attributes = $objectAttributes
  link_exit = $linkExit
  link_output = $linkOutput
  elf_header = $elfHeader
  elf_attributes = $elfAttributes
  elf2e32_path = $elf2e32
  elf2e32_help_exit = $helpExit
  elf2e32_help = $helpOutput
  conversion_exit = $conversionExit
  conversion_output = $conversionOutput
  e32_created = $true
  e32_size = $e32Size
  e32_sha256 = $e32Hash
  e32_first_64_bytes = $e32Hex
  e32_dump_exit = $dumpExit
  e32_dump_header = $dumpOutput
}
$report | ConvertTo-Json -Depth 8 | Set-Content -Encoding utf8 (Join-Path $reportRoot "step71-e32-toolchain-probe.json")
$report | Format-List | Out-String | Set-Content -Encoding utf8 (Join-Path $reportRoot "STEP71_E32_TOOLCHAIN_PROBE.txt")
Write-Host "GCCE compile exit: $compileExit; ELF link exit: $linkExit; elf2e32 exit: $conversionExit; E32 size: $e32Size; SHA-256: $e32Hash; header dump exit: $dumpExit"
Write-Host $objectHeader
Write-Host $objectAttributes
Write-Host $elfHeader
Write-Host $elfAttributes
Write-Host $dumpOutput
