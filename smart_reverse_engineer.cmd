@echo off
setlocal enabledelayedexpansion

set ROOT_DIR=%~dp0
set CONFIG_DIR=%ROOT_DIR%config

echo Smart Reverse Engineering for Ecommerce Microservice
echo ======================================================

REM Step 1: Run reverse engineering with local config
echo Step 1: Running reverse engineering with local config...
call "%ROOT_DIR%setEnvironment.cmd"

REM Use local config for reverse engineering
set LOCAL_CONFIG=%CONFIG_DIR%\ecommerce_template_postgres.config
if not exist "%LOCAL_CONFIG%" (
    echo ERROR: Local config not found: %LOCAL_CONFIG%
    exit /b 1
)

REM Run reverse engineering
set LOG_DIR=%ROOT_DIR%logs
if not exist "%LOG_DIR%" mkdir "%LOG_DIR%"

cd /d "%CONFIG_DIR%"
for %%F in ("%LOCAL_CONFIG%") do set CONFIG_NAME=%%~nxF

java -DJX_HOME="%JX_HOME%" -Djdbc.drivers=org.postgresql.Driver -Djava.security.policy="%JX_HOME%\config\java2.security.policy" com.softwaretree.jdxtools.JDXSchema -reverseEng -IGNORE_WARNINGS "%CONFIG_NAME%" > "%LOG_DIR%\jdx_reverse.log" 2>&1

echo Reverse engineering completed

REM Step 2: Organize outputs
echo Step 2: Organizing outputs...

REM Move .revjdx file to config/
for %%F in ("%ROOT_DIR%*.revjdx") do (
    if exist "%%F" move /y "%%F" "%CONFIG_DIR%\" >nul
)
for %%F in ("%CONFIG_DIR%*.revjdx") do (
    if exist "%%F" (
        REM Keep it in config
    )
)

REM Move Java sources to src/ with package structure
for /f "tokens=2" %%A in ('findstr /b "^JDX_OBJECT_MODEL_PACKAGE" "%LOCAL_CONFIG%"') do (
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

REM Fallback: move any top-level *.java into src/
for %%F in ("%ROOT_DIR%*.java") do (
    if exist "%%F" move /y "%%F" "%ROOT_DIR%src\" >nul
)
for %%F in ("%CONFIG_DIR%*.java") do (
    if exist "%%F" move /y "%%F" "%ROOT_DIR%src\" >nul
)

echo Outputs organized: .revjdx in config/, Java sources in src/

REM Step 3: Create Docker-compatible .revjdx file
echo Step 3: Creating Docker-compatible .revjdx file...

set REVJDX_FILE=%CONFIG_DIR%\ecommerce_template_postgres.config.revjdx
if exist "%REVJDX_FILE%" (
    REM Create a Docker version with host.docker.internal
    set DOCKER_REVJDX=%CONFIG_DIR%\ecommerce_template_postgres_docker.config.revjdx
    
    REM Copy the original and replace the database URL
    copy /y "%REVJDX_FILE%" "%DOCKER_REVJDX%" >nul
    
    REM Replace 127.0.0.1 with host.docker.internal for Docker compatibility
    powershell -Command "(Get-Content '%DOCKER_REVJDX%') -replace '127\.0\.0\.1', 'host.docker.internal' | Set-Content '%DOCKER_REVJDX%'"
    
    echo Created Docker-compatible .revjdx: %DOCKER_REVJDX%
) else (
    echo Warning: .revjdx file not found, skipping Docker version creation
)

REM Step 4: Update gilhari_service.config to use the correct .revjdx file
echo Step 4: Updating service configuration...

set SERVICE_CONFIG=%ROOT_DIR%gilhari_service.config
if exist "%SERVICE_CONFIG%" (
    REM Update the service config to use the Docker version
    powershell -Command "(Get-Content '%SERVICE_CONFIG%') -replace 'ecommerce_template_postgres\.config\.revjdx', 'ecommerce_template_postgres_docker.config.revjdx' | Set-Content '%SERVICE_CONFIG%'"
    
    echo Updated service config to use Docker-compatible .revjdx
) else (
    echo Warning: Service config not found
)

echo.
echo Smart Reverse Engineering Complete!
echo =====================================
echo Generated files:
echo    Local .revjdx:    %REVJDX_FILE%
echo    Docker .revjdx:   %DOCKER_REVJDX%
echo    Java sources:     %ROOT_DIR%src\
echo    Service config:   %SERVICE_CONFIG%
echo.
echo Ready for compilation and Docker build!

cd /d "%ROOT_DIR%"

