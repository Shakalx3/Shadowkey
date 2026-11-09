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

$eabi4Object = Join-Path $workRoot "probe-eabi4.o"
$eabi4Elf = Join-Path $workRoot "probe-eabi4.elf"
$eabi4E32 = Join-Path $workRoot "probe-eabi4.exe"
$eabi4CompileOutput = ""
$eabi4CompileExit = -999
$eabi4ObjectHeader = ""
$eabi4ObjectAttributes = ""
$eabi4LinkOutput = ""
$eabi4LinkExit = -999
$eabi4ElfHeader = ""
$eabi4ConversionOutput = ""
$eabi4ConversionExit = -999
$eabi4E32Hash = ""
$eabi4E32Size = 0
$eabi4E32HeaderBytes = ""
$eabi4CompileOutput = (& $gcc.FullName -march=armv5te -mfloat-abi=soft -meabi=4 -ffreestanding -fno-builtin -fno-exceptions -fno-rtti -c $probeSource -o $eabi4Object 2>&1 | Out-String)
$eabi4CompileExit = $LASTEXITCODE
if ($eabi4CompileExit -eq 0 -and (Test-Path $eabi4Object)) {
  $eabi4ObjectHeader = (& $readelf.FullName -h $eabi4Object 2>&1 | Out-String)
  $eabi4ObjectAttributes = (& $readelf.FullName -A $eabi4Object 2>&1 | Out-String)
  $eabi4LinkOutput = (& $ld.FullName -e E32Main -Ttext 0x10000 -o $eabi4Elf $eabi4Object 2>&1 | Out-String)
  $eabi4LinkExit = $LASTEXITCODE
  if ($eabi4LinkExit -eq 0 -and (Test-Path $eabi4Elf)) {
    $eabi4ElfHeader = (& $readelf.FullName -h $eabi4Elf 2>&1 | Out-String)
    $eabi4Args = @(
      "--elfinput=$eabi4Elf", "--output=$eabi4E32", "--targettype=EXE",
      "--uid1=0x1000007A", "--uid2=0x20000001", "--uid3=0x20000001",
      "--sid=0x20000001", "--capability=none", "--version=1.0",
      "--stack=8192", "--heap=4096,1048576", "--libpath=$libPath"
    )
    $eabi4ConversionOutput = (& $elf2e32 @eabi4Args 2>&1 | Out-String)
    $eabi4ConversionExit = $LASTEXITCODE
    if ($eabi4ConversionExit -eq 0 -and (Test-Path $eabi4E32)) {
      $eabi4Bytes = [IO.File]::ReadAllBytes($eabi4E32)
      $eabi4E32Size = $eabi4Bytes.Length
      $eabi4E32HeaderBytes = [BitConverter]::ToString($eabi4Bytes[0..([Math]::Min(63, $eabi4Bytes.Length - 1))])
      $eabi4E32Hash = (Get-FileHash -Algorithm SHA256 $eabi4E32).Hash.ToLower()
      Copy-Item $eabi4E32 (Join-Path $reportRoot "probe-eabi4.e32")
    }
  }
}
$coneDsoHeader = (& $readelf.FullName -h (Join-Path $libPath "cone.dso") 2>&1 | Out-String)
$euserDsoHeader = (& $readelf.FullName -h (Join-Path $libPath "euser.dso") 2>&1 | Out-String)


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
  eabi4_compile_exit = $eabi4CompileExit
  eabi4_compile_output = $eabi4CompileOutput
  eabi4_object_header = $eabi4ObjectHeader
  eabi4_object_attributes = $eabi4ObjectAttributes
  eabi4_link_exit = $eabi4LinkExit
  eabi4_link_output = $eabi4LinkOutput
  eabi4_elf_header = $eabi4ElfHeader
  eabi4_conversion_exit = $eabi4ConversionExit
  eabi4_conversion_output = $eabi4ConversionOutput
  eabi4_e32_created = (Test-Path $eabi4E32)
  eabi4_e32_size = $eabi4E32Size
  eabi4_e32_sha256 = $eabi4E32Hash
  eabi4_e32_first_64_bytes = $eabi4E32HeaderBytes
  cone_dso_header = $coneDsoHeader
  euser_dso_header = $euserDsoHeader
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
Write-Host "GCCE default EABI compile/link/convert: $compileExit/$linkExit/$conversionExit; E32 size: $e32Size; SHA-256: $e32Hash; EABI4 compile/link/convert: $eabi4CompileExit/$eabi4LinkExit/$eabi4ConversionExit; EABI4 E32 created: $(Test-Path $eabi4E32)"
Write-Host $objectHeader
Write-Host $objectAttributes
Write-Host $elfHeader
Write-Host $elfAttributes
Write-Host $eabi4ObjectHeader
Write-Host $eabi4ElfHeader
Write-Host $coneDsoHeader
Write-Host $euserDsoHeader
