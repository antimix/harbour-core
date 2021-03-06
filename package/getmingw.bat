@echo off

:: Copyright 2015 Viktor Szakats (vszakats.net/harbour)

setlocal
pushd "%~dp0"

set "_MINGW_32=https://www.mirrorservice.org/sites/dl.sourceforge.net/pub/sourceforge/m/mi/mingw-w64/Toolchains targetting Win32/Personal Builds/mingw-builds/5.1.0/threads-posix/sjlj/i686-5.1.0-release-posix-sjlj-rt_v4-rev0.7z"
set "_MINGW_64=https://www.mirrorservice.org/sites/dl.sourceforge.net/pub/sourceforge/m/mi/mingw-w64/Toolchains targetting Win64/Personal Builds/mingw-builds/5.1.0/threads-posix/sjlj/x86_64-5.1.0-release-posix-sjlj-rt_v4-rev0.7z"

set _URL_CLIENT=%_MINGW_32%
if not exist "harbour.exe" (
   echo Error: This script has to be run from a Harbour binary installation.
   exit /b
)
harbour.exe -build 2>&1 | findstr "64-bit" > nul 2>&1 && set _URL_CLIENT=%_MINGW_64%

if "%_URL_CLIENT%" == "%_MINGW_32%" echo Downloading 32-bit hosted dual MinGW...
if "%_URL_CLIENT%" == "%_MINGW_64%" echo Downloading 64-bit hosted dual MinGW...

set _DL_URL=%_URL_CLIENT%
set _DL_DST=%TEMP%\mingw.7z
set _TMP=%TEMP%\_webdl.tmp
echo var http = new ActiveXObject(^"WinHttp.WinHttpRequest.5.1^");> "%_TMP%"
echo http.Open(^"GET^", ^"%_DL_URL%^", false);>> "%_TMP%"
echo http.Send();>> "%_TMP%"
echo if(http.Status() == 200) {>> "%_TMP%"
echo    var f = new ActiveXObject(^"ADODB.Stream^");>> "%_TMP%"
echo    f.type = 1; f.open(); f.write(http.responseBody);>> "%_TMP%"
echo    f.savetofile(^"%_DL_DST:\=\\%^", 2);>> "%_TMP%"
echo }>> "%_TMP%"
cscript //nologo /e:jscript "%_TMP%"
del "%_TMP%"

pushd ..
set _TRG=%CD%\comp\
popd

echo Unpacking to '%_TRG%'...
if exist "%TEMP%\mingw.7z" (
   7za x -y -o..\comp "%TEMP%\mingw.7z" > nul
   del "%TEMP%\mingw.7z"
)

popd
endlocal
