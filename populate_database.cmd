@echo off
setlocal enabledelayedexpansion

REM Database Population Script for gilhari_ecommerce_example
REM This script creates the database schema and populates it with sample data

set ROOT_DIR=%~dp0
set SCHEMA_FILE=%ROOT_DIR%database\schema.sql
set DATA_FILE=%ROOT_DIR%database\sample_data.sql

REM Default database connection parameters
if "%DB_HOST%"=="" set DB_HOST=localhost
if "%DB_PORT%"=="" set DB_PORT=5432
if "%DB_NAME%"=="" set DB_NAME=ecommerce
if "%DB_USER%"=="" set DB_USER=postgres

echo Database Population Script
echo ================================
echo.

REM Check if psql is available
where psql >nul 2>&1
if errorlevel 1 (
    echo Error: psql command not found. Please install PostgreSQL client tools.
    exit /b 1
)

REM Check if schema file exists
if not exist "%SCHEMA_FILE%" (
    echo Error: Schema file not found: %SCHEMA_FILE%
    exit /b 1
)

REM Check if data file exists
if not exist "%DATA_FILE%" (
    echo Error: Sample data file not found: %DATA_FILE%
    exit /b 1
)

echo Step 1: Creating database schema...
echo    Database: %DB_NAME%
echo    Host: %DB_HOST%:%DB_PORT%
echo    User: %DB_USER%
echo.

REM Set PGPASSWORD if provided
if not "%DB_PASSWORD%"=="" (
    set PGPASSWORD=%DB_PASSWORD%
)

psql -h %DB_HOST% -p %DB_PORT% -U %DB_USER% -d %DB_NAME% -f "%SCHEMA_FILE%" >nul 2>&1
if errorlevel 1 (
    echo Warning: Schema creation had issues. Continuing...
) else (
    echo Schema created successfully!
)

echo.
echo Step 2: Populating database with sample data...
echo.

psql -h %DB_HOST% -p %DB_PORT% -U %DB_USER% -d %DB_NAME% -f "%DATA_FILE%" >nul 2>&1
if errorlevel 1 (
    echo Warning: Data insertion had issues. Check the database connection and permissions.
    exit /b 1
) else (
    echo Sample data inserted successfully!
)

echo.
echo Database population complete!
echo ================================
echo.
echo Ready to use! You can now run the reverse engineering and build scripts.

