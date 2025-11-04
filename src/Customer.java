// 
// JDX (version: 05.05) reverse engineered class
// JDX is a product of Software Tree, LLC.
// 
// DBURL=jdbc:postgresql://127.0.0.1:5432/ecommerce, Database=PostgreSQL, Version: 14.18 (Homebrew)
// Date: Mon Oct 27 19:55:25 IST 2025
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
