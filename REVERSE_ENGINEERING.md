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
- **Object-Oriented Mapping**: Creates intuitive Java classes with navigation methods
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
public class Supplier extends JDX_JSONObject {
    public Product[] listProduct;  // Generated relationship array
    
    public Supplier() { super(); }
    public Supplier(JSONObject jsonObject) throws JSONException { super(jsonObject); }
}
```
**LLM Benefits:**
- Natural language: "Show me all products from TechSupply Inc"
- Object navigation: `supplier.listProduct[0].name`
- No SQL required: The ORM layer automatically handles relationship queries

#### 2. **Customer → CustomerOrder (1:Many)**
```sql
-- Database relationship
customer.id → customerorder.customerid
```
**Generated Java Structure:**
```java
public class Customer extends JDX_JSONObject {
    public CustomerOrder[] listCustomerOrder;  // Generated relationship array
    public Address[] listAddress;  // Generated relationship array
    
    public Customer() { super(); }
    public Customer(JSONObject jsonObject) throws JSONException { super(jsonObject); }
}
```
**LLM Benefits:**
- Natural language: "Find all orders for customer John Smith"
- Object navigation: `customer.listCustomerOrder[0].totalAmount`
- The ORM layer automatically handles relationship queries without SQL

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
public class CustomerOrder extends JDX_JSONObject {
    public OrderItem[] listOrderItem;  // Generated relationship array
    
    public CustomerOrder() { super(); }
    public CustomerOrder(JSONObject jsonObject) throws JSONException { super(jsonObject); }
}
```
**LLM Benefits:**
- Natural language: "Show me all items in order #1001"
- Object navigation: `order.listOrderItem[0].quantity`
- The ORM layer automatically handles relationship queries

#### 5. **Product → OrderItem (1:Many)**
```sql
-- Database relationship
product.id → orderitem.productid
```
**Generated Java Structure:**
```java
public class Product extends JDX_JSONObject {
    public OrderItem[] listOrderItem;  // Generated relationship array
    
    public Product() { super(); }
    public Product(JSONObject jsonObject) throws JSONException { super(jsonObject); }
}
```
**LLM Benefits:**
- Natural language: "Find all orders containing product LAPTOP-001"
- Object navigation: `product.listOrderItem[0].orderId`
- The ORM layer automatically handles relationship queries

## 🚀 LLM MCP Tool Integration

### Object Model Summary
The `getObjectModelSummary` tool provides LLMs with a complete overview of the generated object model:

```json
{
  "entities": [
    {
      "name": "Supplier",
      "fields": ["id", "name", "contactEmail", "rating"],
      "relationships": ["listProduct"]
    },
    {
      "name": "Product", 
      "fields": ["id", "sku", "name", "price", "category"],
      "relationships": ["listOrderItem"]
    }
  ],
  "relationships": [
    {
      "from": "Supplier",
      "to": "Product",
      "type": "1:Many",
      "navigation": "listProduct"
    }
  ]
}
```

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

**Generated Java Code:**
```java
Supplier supplier = supplierService.findByName("TechSupply Inc");
Product[] products = supplier.listProduct;
```

## 🔧 Technical Implementation

### Configuration Files
The reverse engineering process creates several configuration files:

#### 1. **Database Configuration** (`ecommerce_template_postgres.config`)
```properties
JDX_DATABASE JDX:jdbc:postgresql://127.0.0.1:5432/ecommerce
JDX_USER postgres
JDX_PASSWORD <password>
```

#### 2. **ORM Specification** (`.revjdx` files)
The reverse engineering process generates JDX configuration files (`.revjdx`) that define the object model structure. These files use JDX-specific syntax to map database tables to Java classes and define relationships:

```properties
CLASS .Supplier TABLE supplier
    VIRTUAL_ATTRIB id ATTRIB_TYPE int
    VIRTUAL_ATTRIB name ATTRIB_TYPE java.lang.String
    VIRTUAL_ATTRIB contactemail ATTRIB_TYPE java.lang.String
    VIRTUAL_ATTRIB rating ATTRIB_TYPE java.math.BigDecimal
    PRIMARY_KEY id 
    RELATIONSHIP listProduct REFERENCES .ListProduct BYVALUE WITH id 
;

COLLECTION_CLASS .ListProduct COLLECTION_TYPE ARRAY ELEMENT_CLASS .Product ELEMENT_TABLE product
    PRIMARY_KEY supplierid 
;
```

#### 3. **Class Name Mapping** (`classnames_map_ecommerce.js`)
```javascript
{
  "supplier": "Supplier",
  "product": "Product", 
  "customer": "Customer",
  "address": "Address",
  "customerorder": "CustomerOrder",
  "orderitem": "OrderItem"
}
```

### Generated Java Classes

#### Entity Class Example
The reverse engineering tool generates Java classes that extend `JDX_JSONObject` with relationship arrays and constructors:

```java
package com.acme.ecommerce.model;

import org.json.JSONException;
import org.json.JSONObject;
import com.softwaretree.jdx.JDX_JSONObject;

public class Supplier extends JDX_JSONObject {
    public Product[] listProduct;  // Generated relationship array
    
    public Supplier() {
        super();
    }
    
    public Supplier(JSONObject jsonObject) throws JSONException {
        super(jsonObject);
    }
}
```

**Note:** The actual field attributes (like `id`, `name`, `contactEmail`, `rating`) are defined in the `.revjdx` configuration file as `VIRTUAL_ATTRIB` entries. The JDX framework handles these attributes dynamically at runtime, so they don't appear as explicit fields in the generated Java class. The relationship arrays (like `listProduct`) are the primary generated code elements that enable object navigation.

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
To see the SQL statements generated by Gilhari/JDX, set `DEBUG_LEVEL=3` in your configuration:

```properties
JDX_DEBUG_LEVEL 3
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
Enable debug logging to see how object operations translate to SQL:
```properties
JDX_DEBUG_LEVEL 3
```

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
