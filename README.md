# 🛒 Amazon E-commerce Sales Analysis

## 📌 Project Overview

This project analyzes Amazon e-commerce sales data using Microsoft SQL Server to uncover sales patterns, product performance, customer locations, order behavior, fulfillment activity, and shipping trends.

The project also demonstrates data cleaning and advanced SQL techniques used to transform raw sales data into meaningful business insights.

---

## 🎯 Project Objectives

The main objectives of this project are to:

- Analyze overall sales performance
- Identify top-performing product categories and SKUs
- Analyze sales trends over time
- Identify high-performing states and cities
- Understand order and fulfillment performance
- Analyze cancellation patterns
- Examine shipping activity
- Apply advanced SQL techniques
- Clean and standardize the dataset
- Generate actionable business insights

---

## 🛠️ Tools & Technologies

- **SQL**
- **Microsoft SQL Server**
- **SQL Server Management Studio (SSMS)**
- **Visual Studio Code**
- **GitHub**

---

## 📊 Dataset

The project uses an Amazon e-commerce sales dataset containing information about:

- Orders
- Products
- Categories
- Sales amounts
- Quantities
- Fulfillment
- Shipping
- Customer locations
- Order status
- Promotions
- B2B transactions

The dataset contains approximately **129,000 records** and multiple fields covering the complete order lifecycle.

---

## 🔍 Analysis Performed

### 1. Data Validation

- Total record count
- Dataset structure
- Column and data type analysis
- Missing value analysis
- Duplicate order analysis

### 2. Sales Performance

- Total orders
- Total quantity sold
- Sales by category
- Sales by SKU
- Daily sales
- Monthly sales trends

### 3. Geographic Analysis

- Sales by state
- Sales by city
- Top geographic markets

### 4. Order & Fulfillment Analysis

- Fulfillment methods
- Order status
- Cancellation rate
- Cancellations by category
- Cancellations by fulfillment method

### 5. Pricing & Product Analysis

- Sales amount analysis
- Sales by quantity
- Average order value
- Sales amount distribution
- Top-performing SKUs

### 6. Shipping Analysis

- Shipping service levels
- Orders by shipping state
- Courier status

### 7. Advanced SQL Analysis

The project applies advanced SQL techniques including:

- Common Table Expressions (CTEs)
- `RANK()`
- `PARTITION BY`
- Window functions
- Running totals
- Subqueries
- Aggregations

### 8. Data Cleaning

The dataset was cleaned and standardized by:

- Creating a separate cleaned dataset
- Removing unnecessary whitespace
- Standardizing categorical text values
- Handling blank values
- Cleaning date values
- Cleaning numerical values
- Converting postal codes to an appropriate text data type
- Standardizing product and geographic identifiers

---

## 💡 Business Insights

The analysis is designed to identify:

- The strongest-performing product categories
- Top-performing SKUs
- High-value geographic markets
- Monthly sales patterns
- Order cancellation patterns
- Fulfillment performance
- Shipping trends
- Products that may require further investigation

Detailed findings and recommendations are based on the results generated from the SQL analysis.

---

## 📁 Project Structure

```text
Amazon_Sales_Data_Analysis/
│
├── README.md
├── amazon_sales_analysis.sql
├── data_dictionary.md
└── screenshots/