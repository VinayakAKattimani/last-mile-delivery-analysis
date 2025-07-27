# Last Mile Delivery Analysis

This project analyzes last-mile delivery performance using SQL and Power BI. The aim is to identify time delays, detect inefficiencies in the delivery process, and generate actionable insights to improve on-time delivery rates. The analysis is well-suited for logistics, e-commerce, or hyperlocal delivery platforms.

## Data Cleaning

Before diving into the analysis, the raw dataset was cleaned to ensure accurate insights. The cleaning process involved:

To ensure the accuracy and reliability of the delivery dataset, several cleaning steps were performed:

Duplicate Orders Removal
The dataset was checked for duplicate order entries. If an order appeared more than once, the additional copies were removed to keep only unique deliveries.

Inconsistent Time Records Elimination
Records where the delivery time was recorded before the order was accepted were considered invalid and removed, as this indicates an error in the data.

Filtering Out Extremely Long Deliveries
Deliveries that took more than 48 hours to complete were removed. These extreme cases were likely outliers and could distort overall analysis.

Validation of Delivery Durations
After cleaning, we examined the minimum, maximum, average, and median delivery durations to ensure the dataset reflected realistic and consistent delivery times.

A cleaned dataset was stored in a new table `delivery_cleaned` to support reliable analysis.

## KPIs Tracked

1. **Average Delivery Duration**  
   Measures the mean time taken from order acceptance to delivery completion.

2. **On-Time Delivery Rate**  
   Percentage of orders delivered within a threshold time (e.g., 3 hours).

3. **Delay Contributors**  
   Identifies top regions, delivery zones, or couriers associated with longer delays.

4. **Median vs Average Delivery Time**  
   Compares central tendencies to identify skewness and outliers in delivery times.

## Business Questions Answered

- Who or what is responsible for delays in delivery?
- How can we improve on-time delivery rates?
- Are there specific locations or couriers consistently underperforming?

## Tools Used

- **SQL**: Data extraction, cleaning, transformation, and KPI computation.
- **Power BI**: Interactive dashboard creation and visualization of insights.
- **PostgreSQL**: Backend database engine for querying and cleaning.

## Dashboard

The Power BI dashboard showcases regional performance, average vs on-time deliveries, and delay patterns with interactive filters.

## How to Use

1. Clone the repository.
2. Load the cleaned dataset into your preferred SQL engine.
3. Open the Power BI file to explore the visualizations.


---

