$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"
$root = Join-Path $env:GITHUB_WORKSPACE "e32-probe"
New-Item -ItemType Directory -Force -Path $root | Out-Null
$sdkArchive = Join-Path $root "s60-sdk.tar.gz"
$gccArchive = Join-Path $root "gcce14.zip"
$sdkRoot = Join-Path $root "sdk"
$gccRoot = Join-Path $root "gcc"

Write-Host "Downloading pinned S60 3.1 FP1 SDK devkit"
curl.exe -fL --retry 3 -H "Authorization: Bearer $env:GITHUB_TOKEN" -H "Accept: application/octet-stream" "https://api.github.com/repos/Shakalx3/Shadowkey/releases/assets/723972349" -o $sdkArchive
$sdkHash = (Get-FileHash -Algorithm SHA256 $sdkArchive).Hash.ToLower()
if ($sdkHash -ne "7ed8b62b15f191ca47d2f6ca97ee5ce74cd02ce3e42b74bc7b1f9513d7df87b5") { throw "Pinned SDK SHA-256 mismatch: $sdkHash" }
New-Item -ItemType Directory -Force -Path $sdkRoot | Out-Null
tar.exe -xzf $sdkArchive -C $sdkRoot

Write-Host "Downloading GCCE4Symbian 14.2.0 Windows toolchain"
$gccUrl = "https://downloads.sourceforge.net/project/gcce4symbian/GCC-14.2.0_BINUTILS-2.29.1/gcc-14.2.0_win32.zip"
curl.exe -fL --retry 3 $gccUrl -o $gccArchive
$gccHash = (Get-FileHash -Algorithm SHA256 $gccArchive).Hash.ToLower()
Expand-Archive -Force $gccArchive $gccRoot

$gcc = Get-ChildItem -Path $gccRoot -Recurse -Filter "arm-none-symbianelf-gcc.exe" | Select-Object -First 1
$ld = Get-ChildItem -Path $gccRoot -Recurse -Filter "arm-none-symbianelf-ld.exe" | Select-Object -First 1
$readelf = Get-ChildItem -Path $gccRoot -Recurse -Filter "arm-none-symbianelf-readelf.exe" | Select-Object -First 1
if (-not $gcc -or -not $ld -or -not $readelf) { throw "GCCE toolchain executables not found in downloaded archive" }

$version = (& $gcc.FullName --version 2>&1 | Out-String)
$probeSource = Join-Path $root "probe.c"
$probeObject = Join-Path $root "probe.o"
$probeElf = Join-Path $root "probe.elf"
Set-Content -Encoding ascii $probeSource "int E32Main(void) { return 0; }"

Write-Host "Compiling a freestanding ARMv5TE E32Main probe"
$compileOutput = (& $gcc.FullName -march=armv5te -mfloat-abi=soft -ffreestanding -fno-builtin -fno-exceptions -fno-rtti -c $probeSource -o $probeObject 2>&1 | Out-String)
$compileExit = $LASTEXITCODE
if ($compileExit -ne 0) { throw "GCCE compile failed ($compileExit): $compileOutput" }

$objectHeader = (& $readelf.FullName -h $probeObject 2>&1 | Out-String)
$objectFlags = (& $readelf.FullName -A $probeObject 2>&1 | Out-String)
Write-Host "Linking a freestanding ELF executable"
$linkOutput = (& $ld.FullName -e E32Main -Ttext 0x10000 -o $probeElf $probeObject 2>&1 | Out-String)
$linkExit = $LASTEXITCODE
$elfHeader = ""
$elfFlags = ""
if ($linkExit -eq 0 -and (Test-Path $probeElf)) {
  $elfHeader = (& $readelf.FullName -h $probeElf 2>&1 | Out-String)
  $elfFlags = (& $readelf.FullName -A $probeElf 2>&1 | Out-String)
}

$elf2e32 = Join-Path $sdkRoot "Epoc32\tools\elf2e32.exe"
if (-not (Test-Path $elf2e32)) { $elf2e32 = Get-ChildItem -Path $sdkRoot -Recurse -Filter "elf2e32.exe" | Select-Object -First 1 -ExpandProperty FullName }
if (-not $elf2e32) { throw "SDK elf2e32.exe not found" }
$helpOutput = (& $elf2e32 --help 2>&1 | Out-String)
$helpExit = $LASTEXITCODE

$conversionOutput = ""
$conversionExit = -999
$e32Path = Join-Path $root "probe.exe"
if ($linkExit -eq 0 -and (Test-Path $probeElf)) {
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
}

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
  object_attributes = $objectFlags
  link_exit = $linkExit
  link_output = $linkOutput
  elf_header = $elfHeader
  elf_attributes = $elfFlags
  elf2e32_path = $elf2e32
  elf2e32_help_exit = $helpExit
  elf2e32_help = $helpOutput
  conversion_exit = $conversionExit
  conversion_output = $conversionOutput
  e32_created = (Test-Path $e32Path)
}
$report | ConvertTo-Json -Depth 8 | Set-Content -Encoding utf8 (Join-Path $root "step71-e32-toolchain-probe.json")
$report | Format-List | Out-String | Set-Content -Encoding utf8 (Join-Path $root "STEP71_E32_TOOLCHAIN_PROBE.txt")
if (Test-Path $e32Path) {
  Get-FileHash -Algorithm SHA256 $e32Path | Format-List | Out-String | Set-Content -Encoding utf8 (Join-Path $root "probe-e32-sha256.txt")
}
Write-Host "GCCE compile exit: $compileExit; ELF link exit: $linkExit; elf2e32 exit: $conversionExit; E32 created: $(Test-Path $e32Path)"
