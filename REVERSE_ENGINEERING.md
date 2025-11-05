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
- **Entity Classes**: Main business objects
- **Collection Classes**: `List*` classes for 1:Many relationships
- **Navigation Methods**: Easy access to related objects
- **JSON Support**: Built-in serialization/deserialization

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
    // ... supplier fields ...
    public Product[] listProduct;  // Generated collection
    public ListProduct listProductCollection;  // Navigation class
}
```
**LLM Benefits:**
- Natural language: "Show me all products from TechSupply Inc"
- Object navigation: `supplier.listProduct[0].name`
- No SQL required: `supplier.getProductsByCategory("Electronics")`

#### 2. **Customer → CustomerOrder (1:Many)**
```sql
-- Database relationship
customer.id → customerorder.customerid
```
**Generated Java Structure:**
```java
public class Customer extends JDX_JSONObject {
    // ... customer fields ...
    public CustomerOrder[] listCustomerOrder;  // Generated collection
    public ListCustomerOrder listCustomerOrderCollection;  // Navigation class
}
```
**LLM Benefits:**
- Natural language: "Find all orders for customer John Smith"
- Object navigation: `customer.listCustomerOrder[0].totalAmount`
- Business logic: `customer.getTotalSpent()`, `customer.getOrderHistory()`

#### 3. **Customer → Address (1:Many)**
```sql
-- Database relationship
customer.id → address.customerid
```
**Generated Java Structure:**
```java
public class Customer extends JDX_JSONObject {
    // ... customer fields ...
    public Address[] listAddress;  // Generated collection
    public ListAddress listAddressCollection;  // Navigation class
}
```
**LLM Benefits:**
- Natural language: "Get all addresses for customer ID 123"
- Object navigation: `customer.listAddress[0].street`
- Business logic: `customer.getShippingAddress()`, `customer.getBillingAddress()`

#### 4. **CustomerOrder → OrderItem (1:Many)**
```sql
-- Database relationship
customerorder.id → orderitem.orderid
```
**Generated Java Structure:**
```java
public class CustomerOrder extends JDX_JSONObject {
    // ... order fields ...
    public OrderItem[] listOrderItem;  // Generated collection
    public ListOrderItem2 listOrderItemCollection;  // Navigation class
}
```
**LLM Benefits:**
- Natural language: "Show me all items in order #1001"
- Object navigation: `order.listOrderItem[0].quantity`
- Business logic: `order.getTotalItems()`, `order.getSubtotal()`

#### 5. **Product → OrderItem (1:Many)**
```sql
-- Database relationship
product.id → orderitem.productid
```
**Generated Java Structure:**
```java
public class Product extends JDX_JSONObject {
    // ... product fields ...
    public OrderItem[] listOrderItem;  // Generated collection
    public ListOrderItem listOrderItemCollection;  // Navigation class
}
```
**LLM Benefits:**
- Natural language: "Find all orders containing product LAPTOP-001"
- Object navigation: `product.listOrderItem[0].orderId`
- Business logic: `product.getTotalSold()`, `product.getRevenue()`

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
```xml
<JDX_ORM_SPEC>
  <ENTITY name="Supplier" table="supplier">
    <FIELD name="id" column="id" type="INTEGER" primaryKey="true"/>
    <FIELD name="name" column="name" type="VARCHAR"/>
    <RELATIONSHIP name="listProduct" targetEntity="Product" type="1:Many"/>
  </ENTITY>
</JDX_ORM_SPEC>
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
```java
package com.acme.ecommerce.model;

public class Supplier extends JDX_JSONObject {
    public Integer id;
    public String name;
    public String contactEmail;
    public Double rating;
    
    // Generated relationship fields
    public Product[] listProduct;
    public ListProduct listProductCollection;
    
    // Generated constructors
    public Supplier() { super(); }
    public Supplier(JSONObject json) { super(json); }
    
    // Generated navigation methods
    public Product[] getListProduct() { return listProduct; }
    public void setListProduct(Product[] listProduct) { this.listProduct = listProduct; }
}
```

#### Collection Class Example
```java
public class ListProduct extends JDX_JSONObject {
    public Product[] items;
    public Integer count;
    
    public Product[] getItems() { return items; }
    public void setItems(Product[] items) { this.items = items; }
    public Integer getCount() { return count; }
    public void setCount(Integer count) { this.count = count; }
}
```

## 🎯 Benefits for LLM Applications

### 1. **Natural Language Processing**
- LLMs can understand business relationships intuitively
- No need to translate between SQL and natural language
- Complex queries become simple object navigation

### 2. **Object-Oriented Thinking**
- Data structures match how humans think about business
- Relationships are explicit and navigable
- Business logic can be expressed naturally

### 3. **Zero SQL Knowledge Required**
- LLMs don't need to understand database internals
- No complex JOIN operations to manage
- Automatic query optimization handled by JDX

### 4. **Automatic Relationship Management**
- Foreign keys become object references
- 1:Many relationships become arrays
- Many:Many relationships become collection classes

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
- Entity classes for each table
- Collection classes for relationships
- Navigation methods for object access

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
