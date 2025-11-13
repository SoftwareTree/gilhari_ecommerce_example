#!/bin/bash

# Database Population Script for gilhari_ecommerce_example
# This script creates the database schema and populates it with sample data

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
SCHEMA_FILE="$ROOT_DIR/database/schema.sql"
DATA_FILE="$ROOT_DIR/database/sample_data.sql"

# Default database connection parameters
DB_HOST="${DB_HOST:-localhost}"
DB_PORT="${DB_PORT:-5432}"
DB_NAME="${DB_NAME:-ecommerce}"
DB_USER="${DB_USER:-postgres}"
DB_PASSWORD="${DB_PASSWORD:-}"

echo "🗄️  Database Population Script"
echo "================================"
echo ""

# Check if psql is available
if ! command -v psql &> /dev/null; then
    echo "❌ Error: psql command not found. Please install PostgreSQL client tools."
    exit 1
fi

# Check if schema file exists
if [ ! -f "$SCHEMA_FILE" ]; then
    echo "❌ Error: Schema file not found: $SCHEMA_FILE"
    exit 1
fi

# Check if data file exists
if [ ! -f "$DATA_FILE" ]; then
    echo "❌ Error: Sample data file not found: $DATA_FILE"
    exit 1
fi

# Set PGPASSWORD if provided
if [ -n "$DB_PASSWORD" ]; then
    export PGPASSWORD="$DB_PASSWORD"
fi

echo "📋 Step 1: Creating database schema..."
echo "   Database: $DB_NAME"
echo "   Host: $DB_HOST:$DB_PORT"
echo "   User: $DB_USER"
echo ""

if psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -f "$SCHEMA_FILE" > /dev/null 2>&1; then
    echo "✅ Schema created successfully!"
else
    echo "⚠️  Warning: Schema creation had issues. Continuing..."
fi

echo ""
echo "📊 Step 2: Populating database with sample data..."
echo ""

if psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -f "$DATA_FILE" > /dev/null 2>&1; then
    echo "✅ Sample data inserted successfully!"
else
    echo "⚠️  Warning: Data insertion had issues. Check the database connection and permissions."
    exit 1
fi

echo ""
echo "🎉 Database population complete!"
echo "================================"
echo ""
echo "📊 Database Statistics:"
psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -t -c "
SELECT 
    'Suppliers: ' || COUNT(*) FROM supplier
UNION ALL
SELECT 
    'Products: ' || COUNT(*) FROM product
UNION ALL
SELECT 
    'Customers: ' || COUNT(*) FROM customer
UNION ALL
SELECT 
    'Addresses: ' || COUNT(*) FROM address
UNION ALL
SELECT 
    'Orders: ' || COUNT(*) FROM customerorder
UNION ALL
SELECT 
    'Order Items: ' || COUNT(*) FROM orderitem;
" 2>/dev/null || echo "   (Unable to retrieve statistics)"

echo ""
echo "✅ Ready to use! You can now run the reverse engineering and build scripts."

