Copyright (c) 2025 Software Tree

# Reverse Engineering with Gilhari SDK

> **Transform existing relational databases into intuitive object-oriented models for LLM-powered applications**

This document provides a comprehensive guide to the reverse engineering capabilities of the Gilhari SDK, which automatically converts existing relational database schemas into object-oriented models that are perfectly suited for LLM MCP (Model Context Protocol) tool interactions.

## 🎯 Why Reverse Engineering Matters for LLMs

### The LLM Challenge
Large Language Models excel at understanding and manipulating object-oriented data structures, but struggle with complex SQL queries and relational database concepts. Traditional database interactions require:
- Complex JOIN operations
- Manual relationship management
- SQL syntax knowledge
- Database-specific query optimization

### The Gilhari Solution
Reverse engineering bridges this gap by:
- **Automatic Relationship Detection**: Infers foreign key relationships from database metadata
- **Object-Oriented Mapping**: Creates intuitive Java classes with relationship arrays for object navigation
- **LLM-Friendly Structure**: Generates models that LLMs can easily understand and manipulate
- **Zero SQL Required**: Eliminates the need for complex SQL queries

## 🔍 How Reverse Engineering Works

### 1. Database Schema Analysis
The JDX reverse engineering tool analyzes your existing database schema by:
- Examining table structures and column definitions
- Identifying foreign key constraints
- Mapping data types to Java equivalents
- Detecting business relationships

### 2. Relationship Inference
The tool automatically infers relationships by analyzing:
- **Foreign Key Constraints**: Direct database relationships
- **Column Naming Patterns**: Common naming conventions
- **Data Type Compatibility**: Matching key types
- **Business Logic Patterns**: Real-world relationship patterns

### 3. Java Class Generation
For each relationship, the tool generates:
- **Entity Classes**: Main business objects with relationship arrays
- **Constructors**: Default and JSON-based constructors
- **JSON Support**: Built-in serialization/deserialization through `JDX_JSONObject`

## 📊 E-commerce Example: Relationship Analysis

### Database Schema
Our e-commerce example uses a typical PostgreSQL schema with these tables:
- `supplier` - Product suppliers
- `product` - Product catalog
- `customer` - Customer information
- `address` - Customer addresses
- `customerorder` - Customer orders
- `orderitem` - Order line items

### Automatically Inferred Relationships

#### 1. **Supplier → Product (1:Many)**
```sql
-- Database relationship
supplier.id → product.supplierid
```
**Generated Java Structure:**
```java
// 
// JDX (version: 05.05) reverse engineered class
// JDX is a product of Software Tree, LLC.
// 
package com.acme.ecommerce.model;

import org.json.JSONException;
import org.json.JSONObject;
import com.softwaretree.jdx.JDX_JSONObject;

public class Supplier extends JDX_JSONObject {
    public  Product[]  listProduct;

    public Supplier() {
        super();
    }

    public Supplier(JSONObject jsonObject) throws JSONException {
        super(jsonObject);
    }
}
```
**What This Enables:**
- The relationship array `listProduct` is generated in the Java class
- At runtime, JDX automatically populates this array when you access it after loading a Supplier entity
- Field attributes like `name` are defined as VIRTUAL_ATTRIB in the `.revjdx` file and accessed through JDX's dynamic attribute system
- No SQL queries are required in your code - JDX handles the relationship queries automatically

#### 2. **Customer → CustomerOrder (1:Many)**
```sql
-- Database relationship
customer.id → customerorder.customerid
```
**Generated Java Structure:**
```java
// 
// JDX (version: 05.05) reverse engineered class
// JDX is a product of Software Tree, LLC.
// 
package com.acme.ecommerce.model;

import org.json.JSONException;
import org.json.JSONObject;
import com.softwaretree.jdx.JDX_JSONObject;

public class Customer extends JDX_JSONObject {
    public  CustomerOrder[]  listCustomerOrder;
    public  Address[]  listAddress;

    public Customer() {
        super();
    }

    public Customer(JSONObject jsonObject) throws JSONException {
        super(jsonObject);
    }
}
```
**What This Enables:**
- The relationship arrays `listCustomerOrder` and `listAddress` are generated in the Java class
- At runtime, JDX automatically populates these arrays when you access them after loading a Customer entity
- Field attributes like `totalamount` are defined as VIRTUAL_ATTRIB in the `.revjdx` file and accessed through JDX's dynamic attribute system
- JDX handles the relationship queries automatically without requiring SQL in your code

#### 3. **Customer → Address (1:Many)**
```sql
-- Database relationship
customer.id → address.customerid
```
**Note:** This relationship is included in the Customer class shown above (see `listAddress` field).

#### 4. **CustomerOrder → OrderItem (1:Many)**
```sql
-- Database relationship
customerorder.id → orderitem.orderid
```
**Generated Java Structure:**
```java
// 
// JDX (version: 05.05) reverse engineered class
// JDX is a product of Software Tree, LLC.
// 
package com.acme.ecommerce.model;

import org.json.JSONException;
import org.json.JSONObject;
import com.softwaretree.jdx.JDX_JSONObject;

public class CustomerOrder extends JDX_JSONObject {
    public  OrderItem[]  listOrderItem;

    public CustomerOrder() {
        super();
    }

    public CustomerOrder(JSONObject jsonObject) throws JSONException {
        super(jsonObject);
    }
}
```
**What This Enables:**
- The relationship array `listOrderItem` is generated in the Java class
- At runtime, JDX automatically populates this array when you access it after loading a CustomerOrder entity
- Field attributes like `quantity` are defined as VIRTUAL_ATTRIB in the `.revjdx` file and accessed through JDX's dynamic attribute system
- JDX handles the relationship queries automatically

#### 5. **Product → OrderItem (1:Many)**
```sql
-- Database relationship
product.id → orderitem.productid
```
**Generated Java Structure:**
```java
// 
// JDX (version: 05.05) reverse engineered class
// JDX is a product of Software Tree, LLC.
// 
package com.acme.ecommerce.model;

import org.json.JSONException;
import org.json.JSONObject;
import com.softwaretree.jdx.JDX_JSONObject;

public class Product extends JDX_JSONObject {
    public  OrderItem[]  listOrderItem;

    public Product() {
        super();
    }

    public Product(JSONObject jsonObject) throws JSONException {
        super(jsonObject);
    }
}
```
**What This Enables:**
- The relationship array `listOrderItem` is generated in the Java class
- At runtime, JDX automatically populates this array when you access it after loading a Product entity
- Field attributes like `orderid` are defined as VIRTUAL_ATTRIB in the `.revjdx` file and accessed through JDX's dynamic attribute system
- JDX handles the relationship queries automatically

## 🚀 LLM MCP Tool Integration

### Object Model Summary
The `getObjectModelSummary` tool provides LLMs with a complete overview of the generated object model. This tool returns information about all entities, their fields (as defined in the `.revjdx` file), and their relationships (as defined by the generated relationship arrays in the Java classes).

### Natural Language Queries
With reverse engineering, LLMs can perform complex operations using natural language:

**Instead of SQL:**
```sql
SELECT p.*, s.name as supplier_name 
FROM product p 
JOIN supplier s ON p.supplierid = s.id 
WHERE s.name = 'TechSupply Inc'
```

**LLM can use:**
```
"Show me all products from TechSupply Inc"
```

**What Reverse Engineering Actually Generates:**
The reverse engineering process generates only the Java model classes with relationship arrays. The actual retrieval of entities and population of relationship arrays is handled by the JDX framework at runtime when you use JDX API methods. The generated `Supplier` class contains the `listProduct` relationship array, which JDX automatically populates when you access it after loading a Supplier entity.

## 🔧 Technical Implementation

### Configuration Files
The reverse engineering process creates several configuration files:

#### 1. **Database Configuration** (`ecommerce_template_postgres.config`)
The reverse engineering process creates a configuration file containing:
- Database connection string with JDBC URL, credentials, database type, and debug level
- JDBC driver specification
- Object model package name
- Superclass name (typically `JDX_JSONObject`)
- Settings for accessor method generation and JSON mappings

#### 2. **ORM Specification** (`.revjdx` files)
The reverse engineering process generates JDX configuration files (`.revjdx`) that define the object model structure. These files contain:
- **CLASS definitions**: Map each database table to a Java class with:
  - `VIRTUAL_ATTRIB` entries for each column (with Java type mappings)
  - `PRIMARY_KEY` specification
  - `RELATIONSHIP` declarations linking to collection classes
  - `SQLMAP` entries for nullable fields
- **COLLECTION_CLASS definitions**: Define array-based collections for 1:Many relationships, specifying the element class, table, and foreign key

#### 3. **Class Name Mapping** (`classnames_map_ecommerce.js`)
The reverse engineering process generates a JavaScript JSON file that maps Java class names to their fully qualified package names (e.g., `"Supplier": "com.acme.ecommerce.model.Supplier"`).

### Generated Java Classes

#### Entity Class Structure
The reverse engineering tool generates Java classes with the following characteristics:
- Each class extends `JDX_JSONObject` from the JDX framework
- **Relationship arrays**: Public array fields for 1:Many relationships (e.g., `Product[] listProduct`)
- **Constructors**: Default constructor and JSON-based constructor for deserialization
- **Package structure**: Classes are placed in the package specified in the configuration
- **Imports**: Required imports for `JSONObject`, `JSONException`, and `JDX_JSONObject`

**Important Note:** The actual field attributes (like `id`, `name`, `contactemail`, `rating`) are defined in the `.revjdx` configuration file as `VIRTUAL_ATTRIB` entries using lowercase names matching the database column names. The JDX framework handles these attributes dynamically at runtime, so they don't appear as explicit fields in the generated Java class. The relationship arrays (like `listProduct`) are the primary generated code elements that enable object navigation.

## 🎯 Benefits for LLM Applications

### 1. **Natural Language Processing**
- LLMs can understand business relationships intuitively
- No need to translate between SQL and natural language
- Complex queries become simple object navigation

### 2. **Object-Oriented Thinking**
- Data structures match how humans think about business
- Relationships are explicit and navigable through relationship arrays
- Object navigation replaces complex SQL JOINs

### 3. **Zero SQL Knowledge Required**
- LLMs don't need to understand database internals
- No complex JOIN operations to manage
- Automatic query optimization handled by JDX

### 4. **Automatic Relationship Management**
- Foreign keys become object references
- 1:Many relationships become arrays (e.g., `Product[] listProduct`)
- The ORM layer automatically handles relationship queries

### 5. **JSON Integration**
- Built-in serialization/deserialization
- Perfect for REST API responses
- Seamless integration with web services

## 🔍 Debugging and Monitoring

### SQL Statement Logging
To see the SQL statements generated by Gilhari/JDX, set `DEBUG_LEVEL=3` (or higher) in the `JDX_DATABASE` line of your configuration file:

```properties
JDX_DATABASE JDX:jdbc:postgresql://127.0.0.1:5432/ecommerce;USER=postgres;PASSWORD=<password>;JDX_DBTYPE=POSTGRES;DEBUG_LEVEL=3
```

This will log all SQL operations, showing how the ORM translates object operations into database queries.

### Example SQL Output
```
DEBUG: Executing SQL: SELECT * FROM supplier WHERE id = ?
DEBUG: Executing SQL: SELECT * FROM product WHERE supplierid = ?
DEBUG: Executing SQL: SELECT * FROM orderitem WHERE productid = ?
```

## 🚀 Getting Started with Reverse Engineering

### 1. **Prepare Your Database**
Ensure your database has:
- Proper foreign key constraints
- Consistent naming conventions
- Complete table definitions
- Sample data for testing

### 2. **Run Reverse Engineering**
```bash
./smart_reverse_engineer.sh
```

### 3. **Review Generated Classes**
Check the `src/` directory for generated Java classes:
- Entity classes for each table with relationship arrays
- Constructors for object instantiation
- Relationship arrays enable object navigation without SQL

### 4. **Test with LLM**
Use the `getObjectModelSummary` tool to verify the model structure:
```bash
curl -X GET "http://localhost:8081/gilhari/v1/getObjectModelSummary/now"
```

### 5. **Monitor SQL Generation**
Enable debug logging to see how object operations translate to SQL by setting `DEBUG_LEVEL=3` in the `JDX_DATABASE` configuration line.

## 🎉 Conclusion

Reverse engineering with the Gilhari SDK transforms the complexity of relational databases into intuitive object-oriented models that LLMs can easily understand and manipulate. This approach:

- **Eliminates SQL complexity** for LLM applications
- **Provides natural object navigation** for business relationships
- **Automatically handles** foreign key management
- **Generates clean Java code** with proper relationships
- **Enables natural language queries** without database knowledge

The result is a powerful foundation for AI-powered database applications that can understand and manipulate complex business data using natural language, making database interactions as intuitive as human conversation.

---

**Ready to transform your database into an LLM-friendly object model?** Start with the [Quick Start Guide](../README.md#quick-start) and see how reverse engineering can revolutionize your AI applications!
