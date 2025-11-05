@echo off
setlocal enabledelayedexpansion

REM Ensure environment is set
call "%~dp0setEnvironment.cmd"

set ROOT_DIR=%~dp0
set CONFIG_DIR=%ROOT_DIR%config

REM Auto-detect environment and choose appropriate config
if defined DOCKER_CONTAINER (
    set CONFIG_FILE=%CONFIG_DIR%\ecommerce_template_postgres_docker.config
    echo Docker environment detected, using Docker config
) else if exist C:\\.dockerenv (
    set CONFIG_FILE=%CONFIG_DIR%\ecommerce_template_postgres_docker.config
    echo Docker environment detected, using Docker config
) else if defined GILHARI_DOCKER_MODE (
    set CONFIG_FILE=%CONFIG_DIR%\ecommerce_template_postgres_docker.config
    echo Docker environment detected, using Docker config
) else (
    set CONFIG_FILE=%CONFIG_DIR%\ecommerce_template_postgres.config
    echo Local environment detected, using local config
)

if not exist "%CONFIG_FILE%" (
    echo ERROR: Config not found: %CONFIG_FILE%
    exit /b 1
)

echo Running JDX reverse engineering for PostgreSQL using %CONFIG_FILE%

REM Run from the config directory
set LOG_DIR=%ROOT_DIR%logs
if not exist "%LOG_DIR%" mkdir "%LOG_DIR%"

cd /d "%CONFIG_DIR%"
for %%F in ("%CONFIG_FILE%") do set CONFIG_NAME=%%~nxF

java -DJX_HOME="%JX_HOME%" -Djdbc.drivers=org.postgresql.Driver -Djava.security.policy="%JX_HOME%\config\java2.security.policy" com.softwaretree.jdxtools.JDXSchema -reverseEng -IGNORE_WARNINGS "%CONFIG_NAME%" > "%LOG_DIR%\jdx_reverse.log" 2>&1

echo Reverse engineering complete. Organizing outputs...

REM Ensure target directories exist
if not exist "%ROOT_DIR%config" mkdir "%ROOT_DIR%config"
if not exist "%ROOT_DIR%src" mkdir "%ROOT_DIR%src"

REM Move .revjdx files to config/
for %%F in ("%ROOT_DIR%*.revjdx") do (
    if exist "%%F" move /y "%%F" "%ROOT_DIR%config\" >nul
)
for %%F in ("%CONFIG_DIR%*.revjdx") do (
    if exist "%%F" move /y "%%F" "%ROOT_DIR%config\" >nul
)

REM Determine package root from config and move generated Java package tree
for /f "tokens=2" %%A in ('findstr /b "^JDX_OBJECT_MODEL_PACKAGE" "%CONFIG_FILE%"') do (
    set PKG_DOTS=%%A
    set PKG_DOTS=!PKG_DOTS: =!
)

if defined PKG_DOTS (
    set PKG_PATH=!PKG_DOTS:.\=/!
    set PKG_PATH=!PKG_PATH:.=/!
    for /f "tokens=1 delims=/" %%D in ("!PKG_PATH!") do set TOP_DIR=%%D
    
    if exist "%ROOT_DIR%!TOP_DIR!" (
        if exist "%ROOT_DIR%src\!TOP_DIR!" rmdir /s /q "%ROOT_DIR%src\!TOP_DIR!"
        move /y "%ROOT_DIR%!TOP_DIR!" "%ROOT_DIR%src\" >nul
    ) else if exist "%CONFIG_DIR%!TOP_DIR!" (
        if exist "%ROOT_DIR%src\!TOP_DIR!" rmdir /s /q "%ROOT_DIR%src\!TOP_DIR!"
        move /y "%CONFIG_DIR%!TOP_DIR!" "%ROOT_DIR%src\" >nul
    )
)

REM As a fallback, move any top-level *.java into src/
for %%F in ("%ROOT_DIR%*.java") do (
    if exist "%%F" move /y "%%F" "%ROOT_DIR%src\" >nul
)
for %%F in ("%CONFIG_DIR%*.java") do (
    if exist "%%F" move /y "%%F" "%ROOT_DIR%src\" >nul
)

echo Outputs organized: .revjdx in config/, Java sources in src/.

cd /d "%ROOT_DIR%"

