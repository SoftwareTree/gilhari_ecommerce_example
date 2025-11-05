Copyright (c) 2025 Software Tree

# Gilhari E-commerce Microservice

> **Automated e-commerce microservice with PostgreSQL integration and Docker deployment**

This repository contains a complete e-commerce microservice built with Gilhari ORM, featuring **automatic environment detection** for seamless local development and Docker deployment. The system automatically handles database connectivity across different environments without manual configuration.

## 🎯 Key Features

- **🔄 Automated Environment Detection**: Automatically switches between local and Docker configurations
- **🐳 Docker-Ready**: Complete containerization with proper networking
- **📊 PostgreSQL Integration**: Full CRUD operations with complex business relationships
- **🚀 One-Command Build**: Complete automation from reverse engineering to deployment
- **🤖 ORMCP Compatible**: Ready for AI-powered database interactions
- **📈 Business Intelligence**: Advanced queries and aggregations

## 🏗️ Architecture Overview

The microservice provides RESTful APIs for six core e-commerce entities with sophisticated business relationships. This example uses a sophisticated object model found in a typical eCommerce application. For example:

- **Supplier** has a 1-many relationship with **Product**
- **Customer** has a 1-many relationship with **CustomerOrder**. Customer also has a 1-many relationship with **Address**
- **CustomerOrder** has a 1-many relationship with **OrderItem**
- **Product** has a 1-many relationship with **OrderItem**

The above model was automatically inferred from an existing database schema by the reverse-engineering tool shipped with the Gilhari SDK. Please see [REVERSE_ENGINEERING.md](REVERSE_ENGINEERING.md) to learn how you can easily work with an existing relational schema and use its data in an intuitive object-oriented way without writing any SQL code.

### 🎯 **Entity Descriptions:**

- **Supplier**: Company information with contact details and ratings
- **Product**: Product catalog with SKU, pricing, inventory, and supplier relationships  
- **Customer**: Customer information with loyalty tiers and spending history
- **Address**: Customer addresses for shipping and billing
- **CustomerOrder**: Order information with status tracking
- **OrderItem**: Individual items within orders with pricing and discounts

## 📁 Project Structure

```
gilhari_ecommerce/
├── src/                                    # Generated Java model classes
│   └── com/acme/ecommerce/model/           # Package structure
├── config/                                 # Configuration files
│   ├── ecommerce_template_postgres.config              # Local development config
│   ├── ecommerce_template_postgres_docker.config      # Docker config
│   ├── ecommerce_template_postgres.config.revjdx      # Local ORM spec
│   ├── ecommerce_template_postgres_docker.config.revjdx # Docker ORM spec
│   ├── classnames_map_ecommerce.js        # Class name mappings
│   └── postgresql-42.7.8.jar             # PostgreSQL JDBC driver
├── bin/                                    # Compiled .class files
├── logs/                                   # Build and runtime logs (gitignored)
├── Dockerfile                             # Docker image definition
├── gilhari_service.config                 # Service configuration
├── setEnvironment.sh / setEnvironment.cmd  # Environment setup (Unix/Windows)
├── smart_reverse_engineer.sh / .cmd       # Automated reverse engineering
├── reverse_engineer.sh / .cmd             # Environment-aware reverse engineering
├── compile.sh / compile.cmd               # Java compilation
├── build_all.sh / build_all.cmd           # Complete automated build
├── .gitignore                             # Git ignore rules
├── README.md                              # This file
└── REVERSE_ENGINEERING.md                 # Reverse engineering guide
```

## 🚀 Quick Start

### Prerequisites
- **Docker** installed and running
- **PostgreSQL** running on localhost:5432
- **Database**: `ecommerce` with proper schema
- **Credentials**: `postgres` / `<password>`

### One-Command Build (Recommended)
```bash
cd gilhari_ecommerce
./build_all.sh
```

This single command handles:
- ✅ Smart reverse engineering
- ✅ Java compilation
- ✅ Docker image build
- ✅ Container deployment
- ✅ Service testing

### Manual Steps (If Needed)
```bash
# 1. Smart reverse engineering
./smart_reverse_engineer.sh

# 2. Compile Java classes
./compile.sh

# 3. Build Docker image
docker build -t gilhari_ecommerce:1.0 .

# 4. Run container
docker run -d --name gilhari_ecommerce_container -p 8081:8081 gilhari_ecommerce:1.0
```

## 🔧 How the Automation Works

### Environment Detection
The system automatically detects the environment and uses appropriate configurations:

**Local Development:**
```bash
JDX_DATABASE JDX:jdbc:postgresql://127.0.0.1:5432/ecommerce
```

**Docker Container:**
```bash
JDX_DATABASE JDX:jdbc:postgresql://host.docker.internal:5432/ecommerce
```

### Configuration Files
- `ecommerce_template_postgres.config` - Local development config
- `ecommerce_template_postgres_docker.config` - Docker config
- `ecommerce_template_postgres.config.revjdx` - Generated local ORM spec
- `ecommerce_template_postgres_docker.config.revjdx` - Generated Docker ORM spec

### Smart Scripts
- `smart_reverse_engineer.sh` - Handles environment detection and creates both configs
- `build_all.sh` - Complete automated build pipeline
- `reverse_engineer.sh` - Environment-aware reverse engineering
- `compile.sh` - Java compilation with proper classpath

## 🌐 Service Endpoints

Once running, access the microservice at:

**Base URL:** `http://localhost:8081/gilhari/v1/`

### Core Endpoints
```
GET  /gilhari/v1/getObjectModelSummary/now    # Object model overview
GET  /gilhari/v1/Supplier                     # Supplier operations
GET  /gilhari/v1/Product                      # Product operations
GET  /gilhari/v1/Customer                     # Customer operations
GET  /gilhari/v1/Address                      # Address operations
GET  /gilhari/v1/CustomerOrder                # Order operations
GET  /gilhari/v1/OrderItem                    # Order item operations
```

### Supported HTTP Methods
| Method | Purpose | Example |
|--------|---------|---------|
| GET | Retrieve objects | `GET /gilhari/v1/Product` |
| POST | Create objects | `POST /gilhari/v1/Product` |
| PUT | Update objects | `PUT /gilhari/v1/Product` |
| PATCH | Partial update | `PATCH /gilhari/v1/Product` |
| DELETE | Delete objects | `DELETE /gilhari/v1/Product` |

## 📊 Example Operations

### Get Object Model Summary
```bash
curl -X GET "http://localhost:8081/gilhari/v1/getObjectModelSummary/now"
```

### Create a Product
```bash
curl -X POST http://localhost:8081/gilhari/v1/Product \
  -H "Content-Type: application/json" \
  -d '{
    "entity": {
      "id": 1,
      "sku": "LAPTOP-001",
      "name": "UltraBook Pro 15",
      "description": "High-performance laptop",
      "category": "Electronics",
      "price": 1299.99,
      "stockQuantity": 45,
      "supplierId": 1,
      "isActive": true
    }
  }'
```

### Query Products by Category
```bash
curl -X GET "http://localhost:8081/gilhari/v1/Product?filter=category='Electronics'" \
  -H "Content-Type: application/json"
```

### Get Average Product Price
```bash
curl -X GET "http://localhost:8081/gilhari/v1/Product/getAggregate?attribute=price&aggregateType=AVG" \
  -H "Content-Type: application/json"
```

## 🤖 ORMCP Server Integration

This microservice is designed to work seamlessly with the ORMCP Server for AI-powered database interactions. The object-oriented nature of the tools and the availability of the `getObjectModelSummary` tool help LLMs make optimized MCP tool calls.

### Current Setup
- **ORMCP Server**: Running on `https://1a81a816d1d4.ngrok-free.app/mcp`
- **Ecommerce Microservice**: Running on `http://localhost:8081`
- **Database**: PostgreSQL with complete e-commerce schema

### Key LLM Features
- **Object Model Summary**: The `getObjectModelSummary` tool provides LLMs with complete entity and relationship information
- **Natural Language Queries**: LLMs can perform complex operations without SQL knowledge
- **SQL Debugging**: Set `DEBUG_LEVEL=3` to monitor SQL statements generated by Gilhari/JDX
- **Object Navigation**: Intuitive relationship traversal using generated navigation methods

### ORMCP Capabilities
The ORMCP Server can perform natural language queries like:
- "Show me all products in the Electronics category"
- "What's the average price of products from TechSupply Inc?"
- "Find all customers with Gold tier status"
- "Calculate total revenue from delivered orders"
- "Add a new product with SKU LAPTOP-002"

## 🐳 Docker Configuration

### Container Details
- **Base Image**: `softwaretree/gilhari`
- **Working Directory**: `/opt/gilhari_ecommerce`
- **Port**: `8081`
- **Environment**: `GILHARI_DOCKER_MODE=1`

### Database Connectivity
- **Local Development**: `127.0.0.1:5432/ecommerce`
- **Docker Container**: `host.docker.internal:5432/ecommerce`

### Container Management
```bash
# View running containers
docker ps

# View container logs
docker logs gilhari_ecommerce_container

# Stop container
docker stop gilhari_ecommerce_container

# Remove container
docker rm gilhari_ecommerce_container
```

## 📈 Generated Artifacts

### Java Classes (src/ → bin/)
```
com.acme.ecommerce.model/
├── Address.class
├── Customer.class
├── CustomerOrder.class
├── OrderItem.class
├── Product.class
└── Supplier.class
```

### Configuration Files
- **ORM Specifications**: `.revjdx` files with database mappings
- **Service Config**: `gilhari_service.config` (JSON)
- **Class Mapping**: `classnames_map_ecommerce.js`

## 🔍 Database Schema

The microservice works with these PostgreSQL tables:
- `supplier` - Product suppliers
- `product` - Product catalog
- `customer` - Customer information
- `address` - Customer addresses
- `customerorder` - Customer orders
- `orderitem` - Order line items

### Database Setup
1. **Create database**: `ecommerce`
2. **Run schema**: Use provided SQL files
3. **Verify connection**: `psql -h localhost -p 5432 -U postgres -d ecommerce`

## 🛠️ Development Tools

### Environment Setup
```bash
# Set up environment variables
source setEnvironment.sh

# Verify PostgreSQL connection
psql -h localhost -p 5432 -U postgres -d ecommerce -c "SELECT table_name FROM information_schema.tables WHERE table_schema = 'public';"
```

### Build Process
```bash
# Complete rebuild
./build_all.sh

# Individual steps
./smart_reverse_engineer.sh  # Auto-detects environment
./compile.sh                  # Compiles Java classes
docker build -t gilhari_ecommerce:1.0 .  # Builds image
```

### Testing
```bash
# Test microservice health
curl -i http://localhost:8081/gilhari/v1/getObjectModelSummary/now

# Test ORMCP server
curl -i https://1a81a816d1d4.ngrok-free.app/mcp
```

## 🎉 Benefits of Automation

✅ **Zero Manual Configuration**: No more editing database URLs  
✅ **Environment Agnostic**: Works locally and in Docker  
✅ **One Command Build**: Complete automation  
✅ **Future Proof**: Handles any environment changes  
✅ **Error Prevention**: Eliminates manual configuration mistakes  
✅ **Docker Ready**: Seamless containerization  
✅ **ORMCP Compatible**: AI-powered database interactions  

## 🔧 Troubleshooting

### Common Issues

**Problem**: Microservice fails to start
- **Solution**: Check container logs: `docker logs gilhari_ecommerce_container`
- **Check**: Database connectivity and credentials

**Problem**: Database connection errors
- **Solution**: Verify PostgreSQL is running and accessible
- **Check**: Database URL in configuration files

**Problem**: Build fails
- **Solution**: Ensure all prerequisites are installed
- **Check**: Environment variables and file permissions

**Problem**: ORMCP Server cannot connect
- **Solution**: Verify microservice is running and accessible
- **Check**: `getObjectModelSummary` endpoint

### Debug Commands
```bash
# Check container status
docker ps | grep gilhari_ecommerce

# View container logs
docker logs gilhari_ecommerce_container

# Test database connection
psql -h localhost -p 5432 -U postgres -d ecommerce -c "SELECT 1;"

# Test microservice endpoint
curl -i http://localhost:8081/gilhari/v1/getObjectModelSummary/now

# Enable SQL debugging (add to config file)
echo "JDX_DEBUG_LEVEL 3" >> config/ecommerce_template_postgres.config
```

### SQL Statement Monitoring
To see how LLM queries translate to SQL statements:
1. Set `DEBUG_LEVEL=3` in your configuration file
2. Monitor the logs to see generated SQL
3. This helps understand how object operations become database queries

## 📚 Additional Resources

- **Reverse Engineering Guide**: [REVERSE_ENGINEERING.md](REVERSE_ENGINEERING.md) - Detailed guide to automatic database-to-object mapping
- **Gilhari SDK**: Download from [https://softwaretree.com](https://softwaretree.com)
- **ORMCP Server**: [https://github.com/SoftwareTree/ormcp-server](https://github.com/SoftwareTree/ormcp-server)
- **PostgreSQL Documentation**: [https://www.postgresql.org/docs/](https://www.postgresql.org/docs/)
- **Docker Documentation**: [https://docs.docker.com/](https://docs.docker.com/)

## 🚀 Getting Started

**Ready to try it?** Start with the [Quick Start](#quick-start) section above!

The automated build system ensures you can get up and running with a single command, handling all the complexity of environment detection, configuration management, and deployment automatically.

---

**No more manual database URL changes needed!** The system automatically handles:
- ✅ Local development (`127.0.0.1:5432`)
- ✅ Docker containers (`host.docker.internal:5432`)
- ✅ Environment detection
- ✅ Configuration management
- ✅ Service deployment

**The JDX_DATABASE configuration is now fully automated!** 🎉