#!/bin/bash

# JDX/Gilhari environment for macOS + PostgreSQL for the ecommerce project

# Set JX_HOME to the Gilhari_SDK root
export JX_HOME="/Users/theairc/Documents/Programs/Projects/ai_ml/Internship_Project-gilhari/v2_ormcp_server-0.4.3/Gilhari_SDK"

# PostgreSQL JDBC jar location
export JDBC_JAR="$JX_HOME/config/postgresql-42.7.8.jar"

# Verify JDBC jar exists
if [ ! -f "$JDBC_JAR" ]; then
  echo "ERROR: JDBC jar not found at $JDBC_JAR" >&2
  exit 1
fi

# Build classpath
export CLASSPATH=".:$JX_HOME/config:$JX_HOME/libs/jxclasses.jar:$JX_HOME/libs/jdxtools.jar:$JX_HOME/external_libs/json-20240303.jar:$JDBC_JAR"

echo "JX_HOME=$JX_HOME"
echo "CLASSPATH=$CLASSPATH"


