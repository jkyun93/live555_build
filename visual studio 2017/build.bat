@echo off
set OUT_TMP=*.obj *.lib
if "%1"=="x86" goto BUILD_x86
if "%1"=="x64" goto BUILD_x64
if "%1"=="both" goto BUILD_BOTH
echo syntax:
echo build.bat x86^|x64^|both [-i]
echo -i : copy include files
goto END
:BUILD_x86
echo build x86
rem call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" x86
call "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\Common7\Tools" -arch=x86
call genWindowsMakefiles.cmd
set TARGET_DIR=build\x86
goto BUILD
:BUILD_x64
echo build x64
rem call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" x86_amd64
call "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\Common7\Tools" -arch=x64
rem call genWindowsMakefiles_x64.cmd
call genWindowsMakefiles.cmd
set TARGET_DIR=build\x64
goto BUILD
:BUILD
cd liveMedia
del %OUT_TMP%
nmake /B -f liveMedia.mak
cd ..\groupsock
del %OUT_TMP%
nmake /B -f groupsock.mak
cd ..\UsageEnvironment
del %OUT_TMP%
nmake /B -f UsageEnvironment.mak
cd ..\BasicUsageEnvironment
del %OUT_TMP%
nmake /B -f BasicUsageEnvironment.mak
cd ../testProgs
del %OUT_TMP%
nmake /B -f testProgs.mak
cd ../mediaServer
del %OUT_TMP%
nmake /B -f mediaServer.mak
cd ../proxyServer
del %OUT_TMP%
nmake /B -f proxyServer.mak
cd ..
if NOT EXIST %TARGET_DIR% mkdir %TARGET_DIR%
echo Copying libs to %TARGET_DIR%
copy /Y liveMedia\*.lib %TARGET_DIR%\
copy /Y groupsock\*.lib %TARGET_DIR%\
copy /Y UsageEnvironment\*.lib %TARGET_DIR%\
copy /Y BasicUsageEnvironment\*.lib %TARGET_DIR%\
goto BUILD_END
:BUILD_BOTH
call build.bat x86
call build.bat x64
:BUILD_END
if NOT "%2"=="-i" goto END
set INC_TARGET_DIR=build\include
if NOT EXIST %INC_TARGET_DIR%\liveMedia mkdir %INC_TARGET_DIR%\liveMedia
if NOT EXIST %INC_TARGET_DIR%\groupsock mkdir %INC_TARGET_DIR%\groupsock
if NOT EXIST %INC_TARGET_DIR%\UsageEnvironment mkdir %INC_TARGET_DIR%\UsageEnvironment
if NOT EXIST %INC_TARGET_DIR%\BasicUsageEnvironment mkdir %INC_TARGET_DIR%\BasicUsageEnvironment
echo Deleting old include files....
del /Q %INC_TARGET_DIR%\liveMedia\*.*
del /Q %INC_TARGET_DIR%\groupsock\*.*
del /Q %INC_TARGET_DIR%\UsageEnvironment\*.*
del /Q %INC_TARGET_DIR%\BasicUsageEnvironment\*.*
echo Copying include files....
copy /Y liveMedia\include\*.* %INC_TARGET_DIR%\liveMedia\
copy /Y groupsock\include\*.* %INC_TARGET_DIR%\groupsock\
copy /Y UsageEnvironment\include\*.* %INC_TARGET_DIR%\UsageEnvironment\
copy /Y BasicUsageEnvironment\include\*.* %INC_TARGET_DIR%\BasicUsageEnvironment\
:END
set TARGET_DIR=
set OUT_TMP=
set INC_TARGET_DIR=

