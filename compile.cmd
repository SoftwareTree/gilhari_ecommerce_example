@echo off
setlocal enabledelayedexpansion

REM Ensure environment is set
call "%~dp0setEnvironment.cmd"

set ROOT_DIR=%~dp0
set SRC_DIR=%ROOT_DIR%src
set BIN_DIR=%ROOT_DIR%bin

if not exist "%BIN_DIR%" mkdir "%BIN_DIR%"

if not exist "%SRC_DIR%" (
    echo ERROR: Source directory not found: %SRC_DIR%
    exit /b 1
)

echo Compiling Java sources from %SRC_DIR% to %BIN_DIR%

REM Compile all Java sources preserving package structure
set SOURCES_FILE=%ROOT_DIR%.sources.list
del /q "%SOURCES_FILE%" 2>nul

for /r "%SRC_DIR%" %%f in (*.java) do (
    echo %%f >> "%SOURCES_FILE%"
)

if not exist "%SOURCES_FILE%" (
    echo No Java sources found to compile.
    exit /b 1
)

javac -cp "%CLASSPATH%" -d "%BIN_DIR%" -target 1.8 -source 1.8 @"%SOURCES_FILE%"

del /q "%SOURCES_FILE%" 2>nul

echo Compilation complete. Class files are in %BIN_DIR%

