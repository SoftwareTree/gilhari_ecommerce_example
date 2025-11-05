@echo off
REM JDX/Gilhari environment for Windows + PostgreSQL for the ecommerce project

REM Set JX_HOME to the Gilhari_SDK root
REM Update this path to match your actual Gilhari_SDK location
set JX_HOME=C:\path\to\Gilhari_SDK

REM PostgreSQL JDBC jar location
set JDBC_JAR=%JX_HOME%\config\postgresql-42.7.8.jar

REM Verify JDBC jar exists
if not exist "%JDBC_JAR%" (
    echo ERROR: JDBC jar not found at %JDBC_JAR%
    exit /b 1
)

REM Build classpath
set CLASSPATH=.;%JX_HOME%\config;%JX_HOME%\libs\jxclasses.jar;%JX_HOME%\libs\jdxtools.jar;%JX_HOME%\external_libs\json-20240303.jar;%JDBC_JAR%

echo JX_HOME=%JX_HOME%
echo CLASSPATH=%CLASSPATH%

