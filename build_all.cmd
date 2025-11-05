@echo off
setlocal enabledelayedexpansion

REM Complete build script for ecommerce microservice
REM Handles reverse engineering, compilation, and Docker build automatically

set ROOT_DIR=%~dp0

echo Complete Ecommerce Microservice Build
echo ========================================

REM Step 1: Smart Reverse Engineering
echo Step 1: Running smart reverse engineering...
if exist "%ROOT_DIR%smart_reverse_engineer.cmd" (
    call "%ROOT_DIR%smart_reverse_engineer.cmd"
) else if exist "%ROOT_DIR%smart_reverse_engineer.sh" (
    echo Warning: Smart reverse engineer not found, using standard method...
    call "%ROOT_DIR%reverse_engineer.cmd"
) else (
    call "%ROOT_DIR%reverse_engineer.cmd"
)

REM Step 2: Compile Java Classes
echo Step 2: Compiling Java classes...
call "%ROOT_DIR%compile.cmd"

REM Step 3: Build Docker Image
echo Step 3: Building Docker image...
docker build -t gilhari_ecommerce:1.0 "%ROOT_DIR%"

REM Step 4: Stop old container and start new one
echo Step 4: Updating running container...
docker stop gilhari_ecommerce_container 2>nul
docker rm gilhari_ecommerce_container 2>nul

echo Step 5: Starting new container...
docker run -d --name gilhari_ecommerce_container -p 8081:8081 gilhari_ecommerce:1.0

REM Step 6: Wait and test
echo Step 6: Waiting for service to start...
timeout /t 8 /nobreak >nul

echo Step 7: Testing microservice...
curl -s http://localhost:8081/gilhari/v1/getObjectModelSummary/now >nul 2>&1
if !errorlevel! equ 0 (
    echo Microservice is running successfully!
    echo.
    echo Build Complete!
    echo ==================
    echo Local URL:     http://localhost:8081/gilhari/v1/
    echo Container:    gilhari_ecommerce_container
    echo Object Model:  http://localhost:8081/gilhari/v1/getObjectModelSummary/now
    echo.
    echo Database URLs:
    echo    Local:       127.0.0.1:5432/ecommerce
    echo    Docker:      host.docker.internal:5432/ecommerce
) else (
    echo Microservice failed to start. Check logs:
    echo    docker logs gilhari_ecommerce_container
    exit /b 1
)

