# **Favorita Retails Sales analysis and Forecast**
_**Author**: Thu Pham | **Date**: 03/2025_

## _**1. Project Background**_


<p style="text-indent: 20px;"> Favorita is one of the most prominent retail chains in Ecuador, boasting nationwide presence and offering an extensive range of goods across various categories. With retail being a rapidly growing sector in the region, Favorita has the opportunity to leverage market expansion trends to boost performance. <p> 

<p style="text-indent: 20px;"> This project aims to analyze Favorita's retail sales data and forecast sales for the next 12–24 months. The insights will assist the Supply Chain team in optimizing inventory management, while also supporting Store Management teams in improving store performance (total revenues, growth, average sales,…) and capitalizing on emerging opportunities in Ecuador's dynamic retail sector. <p> 

Insights and recommendations are provided on the following key objectives:
-	**Objective 1**: Indentify sales trend and revenue growth, discover seasonality patterns.
-	**Objective 2**: Regional performances and product category-level insights, pinpoint weak areas and high-performer, derive insights into market demand in products. 
-	**Objective 3**: Utilize advanced forecasting models to predict sales trends accurately, expected revenue growth to offer recommendations on inventory optimizations. 


The Python codes used to inspect and clean the data for this analysis can be found here [link].

Targed SQL queries regarding various business questions can be found here [link].

An interactive Tableau dashboard used to report and explore sales trends can be found here [link].

## _**2. Data Structure & Initial Checks**_
The companies main database structure as seen below consists of four tables: `sale_table`, `transaction`, `holiday_events`, `store` and `oil_price` with a total row count of over 300,000 records. A description of each table is as follows: 

**`sale_table`** (`train` in the original dataset):
- Each row represents the total sales by store and product family (identifies the type of product sold) at a given date.
- Additionally, the **`onpromotion`** column provides the total number of items in a product family that were promoted at a store.

**`transaction`**:
- Represents the total number of transactions that occurred in a store on a given date.

**`oil_price`**:
- Records the daily oil price.
- "WTI" refers to West Texas Intermediate, a grade of crude oil used as a benchmark in oil pricing.

**`holiday_events`**:
- Contains details about holidays or events that occurred by date, including their types, locations (e.g., National, Regional, Local), and specific location names (e.g., city or state).
- Includes a brief description of the holiday or event.
- The **`transferred`** column indicates whether the holiday was transferred to another date (True or False).

**`store_table`**:
- Contains information about the stores, including their unique identifiers, location, type, and cluster.

**`family_info`**:
- A table created by the analyst to re-categorize the product family for easier summarization.

[Entity Relationship Diagram](images/ERD/ERD-Favorita.png)

## _**3. Executive Summary**_
### *Overview of Findings*
Favorita's revenue grew from $140M (2013) to $289M (2016) (). Transactions slightly increased (29K to 31K), but average transaction value rose to $9.7 (from $4.8), showing higher customer spending.
Seasonal sales patterns show a clear peak in December around the Christmas holiday, followed by a decline in early January. Maintaining a robust supply chain is crucial to capitalize on these seasonal fluctuations. The grocery/food product category remains the primary driver of our performance.
Revenue contribution is heavily concentrated geographically, with Pinchita representing our largest market, contributing over 54% of total revenue and the highest number of stores (19 locations accounting for 35.2% nationally).
