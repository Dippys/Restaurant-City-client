@echo off
REM ============================================================================
REM  Rebuild game.swf from decompiled ActionScript 3 source.
REM
REM  Uses the Apache Flex SDK at C:\flex (the same one habbo-client-cc builds
REM  with, invoked directly via `java -jar mxmlc.jar` to avoid the broken
REM  node .bat shim).
REM
REM  This is a "bare" compile: the default flex-config is suppressed and only
REM  playerglobal.swc is linked (external). That way the decompiled
REM  mx.* / away3d.* / com.* source is authoritative -- no Flex-framework
REM  version is pulled in, matching how this game was originally built
REM  (a plain AS3 project, not an MXML/Flex app).
REM ============================================================================
setlocal

set "FLEX=C:\flex"
set "MXMLC_JAR=%FLEX%\lib\mxmlc.jar"
set "PG=%FLEX%\frameworks\libs\player\25.0\playerglobal.swc"
set "PROJ=%~dp0"
set "MAIN=%PROJ%scripts\com\playfish\games\cooking\Engine.as"
set "OUT=%PROJ%bin\game.swf"

REM Pass "debug" as the first argument to embed source-debug info so the VS Code
REM SWF debugger can bind breakpoints (see .vscode/launch.json). Default: release.
set "DEBUG=false"
if /I "%~1"=="debug" set "DEBUG=true"

if not exist "%PROJ%bin" mkdir "%PROJ%bin"

echo Compiling %MAIN%  (debug=%DEBUG%)
echo   -^> %OUT%
echo.

java -jar "%MXMLC_JAR%" ^
  +flexlib="%FLEX%\frameworks" ^
  -load-config= ^
  -source-path+="%PROJ%scripts" ^
  -external-library-path+="%PG%" ^
  -target-player=25.0 ^
  -swf-version=25 ^
  -default-size 760 600 ^
  -default-frame-rate=25 ^
  -static-link-runtime-shared-libraries=true ^
  -includes+=away3d.events.BillboardEvent ^
  -warnings=false ^
  -debug=%DEBUG% ^
  -output="%OUT%" ^
  -- "%MAIN%"

echo.
echo Exit code: %ERRORLEVEL%
endlocal
