# Builds MemoryLauncher.apk with raw Android SDK tools (no Gradle needed).
$ErrorActionPreference = 'Stop'
$root = $PSScriptRoot
$sdk  = "$env:LOCALAPPDATA\Android\Sdk"
$bt   = "$sdk\build-tools\36.0.0"
$jar  = "$sdk\platforms\android-35\android.jar"
$out  = "$root\build"
Remove-Item $out -Recurse -Force -ErrorAction SilentlyContinue
New-Item -ItemType Directory "$out\compiled","$out\classes","$out\gen" | Out-Null

& "$bt\aapt2.exe" compile --dir "$root\res" -o "$out\compiled"
$flat = Get-ChildItem "$out\compiled" -Filter *.flat | ForEach-Object FullName
& "$bt\aapt2.exe" link -o "$out\base.apk" -I $jar --manifest "$root\AndroidManifest.xml" --java "$out\gen" @flat
if ($LASTEXITCODE) { throw "aapt2 link failed" }

$srcs = Get-ChildItem "$root\src","$out\gen" -Filter *.java -Recurse | ForEach-Object FullName
& javac -source 8 -target 8 -bootclasspath $jar -d "$out\classes" @srcs
if ($LASTEXITCODE) { throw "javac failed" }

$cls = Get-ChildItem "$out\classes" -Filter *.class -Recurse | ForEach-Object FullName
& "$bt\d8.bat" --min-api 26 --lib $jar --output $out @cls
if ($LASTEXITCODE) { throw "d8 failed" }

Push-Location $out
& jar uf base.apk classes.dex
Pop-Location

$ks = "$root\debug.keystore"
if (-not (Test-Path $ks)) {
  & keytool -genkeypair -keystore $ks -storepass android -keypass android -alias key -keyalg RSA -keysize 2048 -validity 36500 -dname "CN=MemoryLauncher"
}
& "$bt\zipalign.exe" -f -p 4 "$out\base.apk" "$out\aligned.apk"
& "$bt\apksigner.bat" sign --ks $ks --ks-pass pass:android --key-pass pass:android --out "$root\MemoryLauncher.apk" "$out\aligned.apk"
if ($LASTEXITCODE) { throw "apksigner failed" }
Write-Host "Built $root\MemoryLauncher.apk"
