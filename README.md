# Data Analytics Power BI Project
--------------------------------------------------------

# Overview
This project was part of the AiCore Data Analytics Skills Bootcamp.

**Description:**

You have recently been approached by a medium-sized international retailer who is keen on elevating their business intelligence practices. With operations spanning across different regions, they've accumulated large amounts of sales from disparate sources over the years.

Recognizing the value of this data, they aim to transform it into actionable insights for better decision-making. Your goal is to use Microsoft Power BI to design a comprehensive Quarterly report. This will involve extracting and transforming data from various origins, designing a robust data model rooted in a star-based schema, and then constructing a multi-page report.

The report will present a high-level business summary tailored for C-suite executives, and also give insights into their highest value customers segmented by sales region, provide a detailed analysis of top-performing products categorised by type against their sales targets, and a visually appealing map visual that spotlights the performance metrics of their retail outlets across different territories.


# Table of Contents
1. [Importing Data/Tables](#importing-datatables)
2. [Creating the Data Model](#Creating-the-Data-Model)
3. [Setting up the Report](#Setting-up-the-Report)
4. [Building the Customer Detail Page](#Building-the-Customer-Detail-Page)
5. [Creating the Executive Summary Page](#Creating-the-Executive-Summary-Page)
6. [Creating the Product Detail Page](#Creating-the-Product-Detail-Page)
7. [Creating a Stores Map Page](#creating-a-stores-map-page)
8. [Cross-Filtering and Navigation](#cross-filtering-and-navigation)
9. [SQL Metrics for Users Outside the Company](#sql-metrics-for-users-outside-the-company)
10. [License Information](#License-Information)


# Importing Data/Tables
Connect to the Azure SQL Database and import the orders_powerbi table using the Import option in Power BI. Use the Database credentials option.

## Orders Table:
- Main fact table
- Contains information about each order, including the order and shipping dates, the customer, store and product IDs, and the amount of each product ordered. 
- Each order in this table consists of an order of a single product type, so there is only one product code per order.


1. Navigate to the Power Query Editor and delete the column named [Card Number] to ensure data privacy

2. Use the Split Column feature to separate the [Order Date] and [Shipping Date] columns into two distinct columns each: one for the date and another for the time

3. Filter out and remove any rows where the [Order Date] column has missing or null values to maintain data integrity

4. Rename the columns in your dataset to align with Power BI naming conventions, ensuring consistency and clarity in your report


## Products Table:
- Contains information about each product sold by the company, including the product code, name, category, cost price, sale price, and weight.

1. Download the Products.csv file  and then use Power BI's Get Data option to import the file into your project

2. In the Data view, use the Remove Duplicates function on the product_code column to ensure each product code is unique


3. Follow the steps below to clean and transform the data in the weight column


    - In Power Query Editor, use the Column From Examples feature to generate two new columns from the weight column - one for the weight values and another for the units (e.g. kg, g, ml). You might need to sort the weight column by descending to get enough different examples to work with.
    - For the newly created units column, replace any blank entries with kg
    - For the values column, convert the data type to a decimal number
    - If any errors arise during the conversion, replace those error values with the number 1
    - From the Data view, create a new calculated column, such that if the unit in the units column is not kg, divide the corresponding value in the values column by 1000 to convert it to kilograms
    - Return to the Power Query Editor and delete any columns that are no longer needed

4. Rename the columns in your dataset to match Power BI naming conventions, ensuring a consistent and clear presentation in your report


## Stores Table:
- Contains information about each store, including the store code, store type, country, region, and address.
- Imported from given Azure Blob Storage

1. Rename the columns in your dataset to align with Power BI naming conventions, ensuring clarity and consistency in your report


## Customers Table:

1. Download the Customers.zip file and unzip it on your local machine. Inside the zip file is a folder containing three CSV files, each with the same column format, one for each of the regions in which the company operates.

2. Use the Get Data option in Power BI to import the Customers folder into your project. You'll need to use the Folder data connector. Navigate to your folder, and then select Combine and Transform to import the data. Power BI will automatically append the three files into one query.

3. Once the data are loaded into Power BI, create a Full Name column by combining the [First Name] and [Last Name] columns

4. Delete any obviously unused columns (eg. index columns) and rename the remaining columns to align with Power BI naming conventions


## Star Schema
1. Relationships between tables:
    - Orders[product_code] to Products[product_code]
    - Orders[Store Code] to Stores[store code]
    - Orders[User ID] to Customers[User UUID]
    - Orders[Order Date] to Date[date]
    - Orders[Shipping Date] to Date[date]
