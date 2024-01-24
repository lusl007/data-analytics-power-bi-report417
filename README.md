# Data Analytics Power BI Project
--------------------------------------------------------

# Overview
This project was part of the AiCore Data Analytics Skills Bootcamp.

**Description:**

You have recently been approached by a medium-sized international retailer who is keen on elevating their business intelligence practices. With operations spanning across different regions, they've accumulated large amounts of sales from disparate sources over the years.

Recognizing the value of this data, they aim to transform it into actionable insights for better decision-making. Your goal is to use Microsoft Power BI to design a comprehensive Quarterly report. This will involve extracting and transforming data from various origins, designing a robust data model rooted in a star-based schema, and then constructing a multi-page report.

The report will present a high-level business summary tailored for C-suite executives, and also give insights into their highest value customers segmented by sales region, provide a detailed analysis of top-performing products categorised by type against their sales targets, and a visually appealing map visual that spotlights the performance metrics of their retail outlets across different territories.


# Table of Contents
1. [Installation and Usage](#installation-and-usage)
2. [Importing Data/Tables](#importing-datatables)
3. [Creating the Data Model](#creating-the-data-model)
4. [Setting up the Report](#setting-up-the-Report)
5. [Building the Customer Detail Page](#building-the-Customer-Detail-Page)
6. [Creating the Executive Summary Page](#creating-the-Executive-Summary-Page)
7. [Creating the Product Detail Page](#creating-the-Product-Detail-Page)
8. [Creating a Stores Map Page](#creating-a-stores-map-page)
9. [Cross-Filtering and Navigation](#cross-filtering-and-navigation)
10. [SQL Metrics for Users Outside the Company](#sql-metrics-for-users-outside-the-company)
11. [License Information](#license-Information)


# Installation and Usage
Clone the repository:
    ```bash
    git clone https://github.com/lusl007/data-analytics-power-bi-report417.git

Open the Power BI file `Power_BI_Project_AiCore.pbix` in Power BI Desktop.
Follow the README steps.


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



# Creating the Data Model

## Date Table
1. Create a Date Table:
    - From start of the year containing the earliest date in the Orders['Order Date'] column to the end of the year containing the latest date in the Orders['Shipping Date'] column
    - DAX measures: `Day of Week`, `Month Number` (i.e. Jan = 1), `Month Name`, `Quarter`, `Year`, `Start of Year`, `Start of Quarter`, `Start of Month`, `Start of Week`


## Star Schema
1. Relationships between tables:
    - Orders[product_code] to Products[product_code]
    - Orders[Store Code] to Stores[store code]
    - Orders[User ID] to Customers[User UUID]
    - Orders[Order Date] to Date[date]
    - Orders[Shipping Date] to Date[date]


## Measure Table and Key Measures
- **Total Orders:** that counts the number of orders in the Orders table
- **Total Revenue:** that multiplies the Orders[Product Quantity] column by the Products[Sale_Price] column for each row, and then sums the result
- **Total Profit:** which performs the following calculation:
    - For each row, subtract the Products[Cost_Price] from the Products[Sale_Price], and then multiply the result by the Orders[Product Quantity]
    - Sums the result for all rows

- **Total Customers:** that counts the number of unique customers in the Orders table. This measure needs to change as the Orders table is filtered, so do not just count the rows of the Customers table!
- **Total Quantity:** that counts the number of items sold in the Orders table
- **Profit YTD:** that calculates the total profit for the current year
- **Revenue YTD:** that calculates the total revenue for the current year


## Date and Geography Hierarchies
1. Order of Date Hierarchy:
    - Start of Year
    - Start of Quarter
    - Start of Month
    - Start of Week
    - Date

2. Order of Date Hierarchy:
    - World Region
    - Country
    - Country Region

3. Create a new calculated column in the Stores table called Country that creates a full country name for each row, based on the Stores[Country Code] column, according to the following scheme:
    - **GB:** United Kingdom
    - **US:** United States
    - **DE:** Germany

4. Create a new calculated column in the Stores table called Geography that creates a full geography name for each row, based on the Stores[Country Region], and Stores[Country] columns, separated by a comma and a space.

5. Ensure these columns have the correct data category:
    - **World Region:** Continent
    - **Country:** Country
    - **Country Region:** State or Province


# Setting up the Report

## Report Pages
- Executive Summary
- Customer Detail
- Product Detail
- Stores Map

## Navigation Bar
- Add a rectangle shape to the first page, covering a narrow strip on the left side of the page. Set fill colour to a contrasting colour of your choice. 
- Will be used to navigate between pages.


# Building the Customer Detail Page

## Card Visuals
- Create two rectangles and arrange them in the top left corner of the page. These will serve as the backgrounds for the card visuals.

- Add a card visual for the [Total Customers] measure we created earlier. Rename the field Unique Customers.

- Create a new measure in your Measures Table called [Revenue per Customer]. This should be the [Total Revenue] divided by the [Total Customers].

- Add a card visual for the [Revenue per Customer] measure


## Summary Charts
- Add a Donut Chart visual showing the total customers for each country, using the Users[Country] column to filter the [Total Customers] measure

- Add a Column Chart visual showing the number of customers who purchased each product category, using the Products[Category] column to filter the [Total Customers] measure


## Line Chart
- Add a Line Chart visual to the top of the page. It should show [Total Customers] on the Y axis, and use the Date Hierarchy we created previously for the X axis. Allow users to drill down to the month level, but not to weeks or individual dates.

- Add a trend line, and a forecast for the next 10 periods with a 95% confidence interval


## Customer Table
- Create a new table, which displays the top 20 customers, filtered by revenue. The table should show each customer's full name, revenue, and number of orders.

- Add conditional formatting to the revenue column, to display data bars for the revenue values


## Top Customer Card
- Create a set of three card visuals that provide insights into the top customer by revenue. They should display the top customer's name, the number of orders made by the customer, and the total revenue generated by the customer.


## Date Slicer
- Add a date slicer to allow users to filter the page by year, using the between slicer style.



# Creating the Executive Summary Page

## Card Visuals
- Copy one of your grouped card visuals from the Customer Detail page and paste it onto the Executive Summary page

- Duplicate it two more times, and arrange the three cards so that they span about half of the width of the page

- Assign them to your Total Revenue, Total Orders and Total Profit measures

- Use the Format > Callout Value pane to ensure no more than 2 decimal places in the case of the revenue and profit cards, and only 1 decimal place in the case of the Total Orders measure


## Line Chart
- Set X axis to your Date Hierarchy, with only the Start of Year, Start of Quarter and Start of Month levels displayed
- Set Y-axis to Total Revenue
- Position the line chart just below the cards


## Donut Chart
- Add a pair of donut charts, showing Total Revenue broken down by Store[Country] and Store[Store Type] respectively. Position these to the right of the cards along the top of the page. Again, you should be able to copy the formatting from the Customer Detail page to save time.


## Bar Chart
- Copy the Total Customers by Product Category donut chart from the Customer Detail page
- In the on-object Build a visual pane, change the visual type to Clustered bar chart
- Change the X axis field from Total Customers to Total Orders
- With the Format pane open, click on one of the bars to bring up the Colors tab, and select an appropriate colour for your theme


## KPI Visuals
1. Create KPIs for Quarterly Revenue, Orders and Profit. To do so we will need to create a set of new measures for the quarterly targets. Create measures for:
    - Previous Quarter Profit
    - Previous Quarter Revenue
    - Previous Quarter Orders
    - Targets, equal to 5% growth in each measure compared to the previous quarter

2. Add a new KPI for the revenue:
    - Value field should be Total Revenue
    - Trend Axis should be Start of Quarter
    - Target should be Target Revenue

3. In the Format pane, set the Trend Axis to On, expand the associated tab, and set the values as follows:
    - **Direction:** High is Good
    - **Bad Colour:** red
    - **Transparency:** 15%

4. Format the Callout Value so that it only shows to 1 decimal place


5. Duplicate the card two more times, and set the appropriate values for the Profit and Orders cards


6. Arrange the three cards below the revenue line chart



# Creating the Product Detail Page

## Gauge Visuals
Add a set of three gauges, showing the current-quarter performance of Orders, Revenue and Profit against a quarterly target. The CEO has told you that they are targeting 10% quarter-on-quarter growth in all three metrics.

1. In your measures table, define DAX measures for the three metrics, and for the quarterly targets for each metric

2. Create three gauge filters, and assign the measures you have created. In each case, the maximum value of the gauge should be set to the target, so that the gauge shows as full when the target is met.

3. Apply conditional formatting to the callout value (the number in the middle of the gauge), so that it shows as red if the target is not yet met, and black otherwise. You may use different colours if it first better with your colour scheme.

4. Arrange your gauges so that they are evenly spaced along the top of the report, but leave another similarly-sized space for the card visuals that will display which slicer states are currently selected


## Area Chart
1. Add a new area chart, and apply the following fields:
    - X axis should be Dates[Start of Quarter]
    - Y axis values should be Total Revenue
    - Legend should be Products[Category]


## Table
1. Add a top 10 products table underneath the area chart. You can copy the top customer table from the Customer Detail page to speed up formatting. The table should have the following fields:
    - Product Description
    - Total Revenue
    - Total Customers
    - Total Orders
    - Profit per Order


## Scatter Graph
1. Create a new calculated column called [Profit per Item] in your Products table, using a DAX formula to work out the profit per item

2. Add a new Scatter chart to the page, and configure it as follows:
    - Values should be Products[Description]
    - X-Axis should be Products[Profit per Item]
    - Y-Axis should be Products[Total Quantity]
    - Legend should be Products[Category]


## Sclicer Toolbar
1. Download this zip file with a collection of custom icons. We will use these for all of our navigation bar icons.

2. Add a new blank button to the top of your navigation bar, set the icon type to Custom in the Format pane, and choose Filter_icon.png as the icon image. Also set the tooltip text to Open Slicer Panel.

3. Add a new rectangle shape in the same colour as your navigation bar. Its dimensions should be the same height as the page, and about 3-5X the width of the navigation bar itself. Open the Selection pane and bring it to the top of the stacking order.

4. Add two new slicers. One should be set to Products[Category], and the other to Stores[Country]. Change the titles to Product Category and Country respectively.
    - They should be in Vertical List slicer style
    - It should be possible to select multiple items in the Product Category slicer, but only one option should be selected in the Country slicer
    - Configure the Country slicer so that there is a Select All option
    - Ensure the formatting is neat, and fits with your chosen report style. An example layout can be seen here .
    - In the Selection pane group the slicers with your slicer toolbar shape

5. We need to add a Back button so that we can hide the slicer toolbar when it's not in use.
    - Add a new button, and select the Back button type
    - Position it somewhere sensible, for example in the top-right corner of the toolbar
    - In the Selection pane, drag the back button into the group with the slicers and toolbar shape

6. Open the Bookmarks pane and add two new bookmarks: one with the toolbar group hidden in the Selection pane, and one with it visible. Name them Slicer Bar Closed and Slicer Bar Open. Right-click each bookmark in turn, and ensure that Data is unchecked. This will prevent the bookmarks from altering the slicer state when we open and close the toolbar.


7. Assign the actions on our buttons to the bookmarks. Open the Format pane and turn the Action setting on for both your Filter button and your Back button.

8. For each button, set the Type to Bookmark, and select the appropriate bookmark. Finally, test your buttons and slicers. Remember you need to Ctrl-Click to use buttons while designing the report in Power BI Desktop.


# Creating a Stores Map Page

## Map Visual
1. On the Stores Map page, add a new map visual. It should take up the majority of the page, just leaving a narrow band at the top of the page for a slicer. Set the style to your satisfaction in the Format pane, and make sure Show Labels is set to On.

2. Set the controls of your map as follows:
    - **Auto-Zoom:** On
    - **Zoom buttons:** Off
    - **Lasso button:** Off

3. Assign your Geography hierarchy to the Location field, and ProfitYTD to the Bubble size field


## Country Slicer
Add a slicer above the map, set the slicer field to Stores[Country], and in the Format section set the slicer style as Tile and the Selection settings to Multi-select with Ctrl/Cmd and Show "Select All" as an option in the slicer.


## Stores Drillthrough Page
Create:
- A table showing the top 5 products, with columns: Description, Profit YTD, Total Orders, Total Revenue
- A column chart showing Total Orders by product category for the store
- Gauges for Profit YTD against a profit target of 20% year-on-year growth vs. the same period in the previous year. The target should use the Target field, not the Maximum Value field, as the target will change as we move through the year.
- A Card visual showing the currently selected store

1. Create a new page named Stoes Drillthrough. Open the format pane and expand the Page information tab. Set the Page type to Drillthrough and set Drill through when to Used as category. Set Drill through from to country region.

2. Add measures for the gauges:
    - **Profit YTD** and **Revenue YTD:** You should have already created this earlier
    - **Profit Goal** and **Revenue Goal:** should be a 20% increase on the previous year's year-to-date profit or revenue at the current point in the year

3. Add the visuals to the drillthrough page


## Stores Tooltip Page
You want users to be able to see each store's year-to-date profit performance against the profit target just by hovering the mouse over a store on the map. To do this, create a custom tooltip page, and copy over the profit gauge visual, then set the tooltip of the visual to the tooltip page you have created.


# Cross-Filtering and Navigation

## Fix Cross-Filtering
1. Executive Summary Page: Product Category bar chart and Top 10 Products table should not filter the card visuals or KPIs

2. Customer Detail Page:
    - Top 20 Customers table should not filter any of the other visuals - Total Customers by Product Donut Chart should not affect the Customers line graph - Total Customers by Country donut chart should cross-filter Total Customers by Product donut Chart

3. Product Detail Page:
    - Orders vs. Profitability scatter graph should not affect any other visuals - Top 10 Products table should not affect any other visuals


## Finish Navigation Bar
1. For each page, there is a custom icon available in the custom icons collection you downloaded earlier in the project. For each icon there are two colour variants. We will use the white version for the default button appearance, and the cyan one so that the button changes colour when hovered over with the mouse pointer. If you have decided on a report theme that would work better with a different colour, you can quickly and easily recolour your images with this  web tool. In the sidebar of the Executive Summary page, add four new blank buttons, and in the Format > Button Style pane, make sure the Apply settings to field is set to Default, and set each button icon to the relevant white png in the Icon tab.

2. For each button, go to Format > Button Style > Apply settings to and set it to On Hover, and then select the alternative colourway of the relevant button under the Icon tab

3. For each button, turn on the Action format option, and select the type as Page navigation, and then select the correct page under Destination

4. Finally, group the buttons together, and copy them across to the other pages


# SQL Metrics for Users Outside the Company

## Questions and Queries
1. How many staff are there in all of the UK stores? > [question_1.sql](https://github.com/lusl007/data-analytics-power-bi-report417/blob/main/SQL%20Queries/question_1.sql)
2. Which month in 2022 has had the highest revenue? > [question_2.sql](https://github.com/lusl007/data-analytics-power-bi-report417/blob/main/SQL%20Queries/question_2.sql)
3. Which German store type had the highest revenue for 2022? > [question_3.sql](https://github.com/lusl007/data-analytics-power-bi-report417/blob/main/SQL%20Queries/question_3.sql)
4. Create a view where the rows are the store types and the columns are the total sales, percentage of total sales and the count of orders > TBD
5. Which product category generated the most profit for the "Wiltshire, UK" region in 2021? > TBD


# License Information
Licensed under the [MIT](https://github.com/lusl007/hangman591/blob/main/LICENSE) license.
