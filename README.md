💊 Pharmaceutical Sales Analysis

A complete end-to-end data analysis project built with MySQL and Google Data Studio, using 6 years of real daily sales data from a pharmacy.

📌 Project Overview

This project answers one core question:


How does a pharmacy sell, when does it sell, and what should it do differently?


I built a relational MySQL database, wrote 10 business-driven SQL queries, and visualized the results in a 3-page interactive dashboard.

🗂️ Project Structure

pharma-sales-analysis/
│
├── sql/
│   └── pharma_analysis_documented.sql   # All 10 queries with full comments
│
├── dashboard/
│   └── screenshots/
│       ├── page1_sales_overview.png
│       ├── page2_patterns_insights.png
│       └── page3_recommendations.png
│
└── README.md

🗃️ Database Schema

The database contains 5 tables built in MySQL:

TableDescriptionsales_dailyCore fact table — one row per day, all 8 medicine columnssales_hourlySame structure at hourly granularitysales_weeklyWeekly aggregated totalssales_monthlyMonthly aggregated totalsdrug_categoriesLookup table — maps ATC codes to medicine names and categories

8 medicines tracked (by ATC code):

CodeMedicineCategoryN02BEParacetamolAnalgesicM01ABIbuprofenAnti-inflammatoryM01AEDiclofenacAnti-inflammatoryN02BAAspirinAnalgesicN05BDiazepamAnxiolyticN05CNitrazepamSedativeR03SalbutamolRespiratoryR06LoratadineAntihistamine

🔍 SQL Queries — 10 Business Questions

#QuestionKey Technique1Which medicines sell the most?UNION ALL unpivot + JOIN2How does revenue trend month by month?DATE_FORMAT + GROUP BY3Which season drives the highest sales?CASE statement + AVG4How has revenue grown year over year?GROUP BY Year + SUM5Which day of the week performs best?GROUP BY Weekday + AVG6What time of day are sales highest?Hourly table + GROUP BY Hour7How do we rate each month's performance?CASE thresholds on aggregates8Do weekends outperform weekdays?CASE grouping + COUNT9What is the cumulative revenue over time?Window function SUM() OVER10Do high Paracetamol days lift all sales?CASE bucketing + correlation

All queries are fully documented with plain-English comments explaining the business reasoning, the approach, and the key findings. See sql/pharma_analysis_documented.sql

📊 Dashboard — Google Data Studio (3 Pages)

Page 1 — Sales Overview

High-level summary of total sales by medicine, monthly revenue trend, and seasonal patterns.

Show Image

Page 2 — Patterns & Insights

Day-of-week breakdown, peak hours heatmap, and product mix pie chart.

Show Image

Page 3 — Business Recommendations

Three data-driven recommendations presented for management action.

Show Image

💡 Key Findings


Paracetamol accounts for ~50% of total revenue and is the clear #1 product
Winter is the peak season — Paracetamol and Salbutamol spike October–January
Spring drives Loratadine (antihistamine) — allergy season confirmed in the data
Saturday is the highest revenue day — €65.67 average vs €57.18 on Thursday
2017 saw a 23% revenue drop from the 2016 peak — an anomaly worth investigating
On high Paracetamol days, all other medicines also sell more — demand is correlated


📋 Business Recommendations

1. Increase Paracetamol stock before Winter
Paracetamol is 50% of revenue and peaks every October–January. Stock levels should increase by at least 30% every September to avoid shortages during peak demand.

2. Optimize weekend staffing
Saturday generates the highest average daily revenue. Recommend maximum staff on Saturdays and reduced capacity on Thursdays to optimize labor costs without affecting service.

3. Investigate the 2017 revenue drop
Revenue dropped 23% from €25,235 in 2016 to €19,399 in 2017. Whether it was pricing, competition, or supply — identifying the cause could recover up to €5,800 in annual revenue.

🛠️ Tools Used


MySQL — database design and all SQL queries
MySQL Workbench — EER diagram and query development
Google Data Studio — interactive dashboard and visualizations
Excel — initial data exploration and cleaning


👤 About


This project was built by Gerti Gonxhi as part of a personal portfolio to practice real-world data analysis, from building a database to creating a business dashboard.

📧 Email: Geerttsh@gmail.com
🔗 LinkedIN: https://www.linkedin.com/in/gerti-gonxhi-40539a391
