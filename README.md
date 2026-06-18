# 💊 Pharmaceutical Sales Analysis

A complete end-to-end data analysis project built with **MySQL** and **Google Data Studio**, using 6 years of real daily sales data from a pharmacy.

---

## 📌 Project Overview

This project answers one core question:

> **How does a pharmacy sell, when does it sell, and what should it do differently?**

I built a relational MySQL database, wrote 10 business-driven SQL queries, and visualized the results in a 3-page interactive dashboard.

---

## 🗂️ Project Structure

```
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
```

---

## 🗃️ Database Schema

The database contains **5 tables** built in MySQL:

| Table | Description |
|---|---|
| `sales_daily` | Core fact table — one row per day, all 8 medicine columns |
| `sales_hourly` | Same structure at hourly granularity |
| `sales_weekly` | Weekly aggregated totals |
| `sales_monthly` | Monthly aggregated totals |
| `drug_categories` | Lookup table — maps ATC codes to medicine names and categories |

**8 medicines tracked** (by ATC code):

| Code | Medicine | Category |
|---|---|---|
| N02BE | Paracetamol | Analgesic |
| M01AB | Ibuprofen | Anti-inflammatory |
| M01AE | Diclofenac | Anti-inflammatory |
| N02BA | Aspirin | Analgesic |
| N05B | Diazepam | Anxiolytic |
| N05C | Nitrazepam | Sedative |
| R03 | Salbutamol | Respiratory |
| R06 | Loratadine | Antihistamine |

---

## 🔍 SQL Queries — 10 Business Questions

| # | Question | Key Technique |
|---|---|---|
| 1 | Which medicines sell the most? | UNION ALL unpivot + JOIN |
| 2 | How does revenue trend month by month? | DATE_FORMAT + GROUP BY |
| 3 | Which season drives the highest sales? | CASE statement + AVG |
| 4 | How has revenue grown year over year? | GROUP BY Year + SUM |
| 5 | Which day of the week performs best? | GROUP BY Weekday + AVG |
| 6 | What time of day are sales highest? | Hourly table + GROUP BY Hour |
| 7 | How do we rate each month's performance? | CASE thresholds on aggregates |
| 8 | Do weekends outperform weekdays? | CASE grouping + COUNT |
| 9 | What is the cumulative revenue over time? | Window function SUM() OVER |
| 10 | Do high Paracetamol days lift all sales? | CASE bucketing + correlation |

All queries are fully documented with plain-English comments explaining the business reasoning, the approach, and the key findings. See [`sql/pharma_analysis_documented.sql`](sql/pharma_analysis_documented.sql)

---

## 📊 Dashboard — Google Data Studio (3 Pages)

### Page 1 — Sales Overview
High-level summary of total sales by medicine, monthly revenue trend, and seasonal patterns.

![Sales Overview](dashboard/screenshots/page1_sales_overview.png)

---

### Page 2 — Patterns & Insights
Day-of-week breakdown, peak hours heatmap, and product mix pie chart.

![Patterns and Insights](dashboard/screenshots/page2_patterns_insights.png)

---

### Page 3 — Business Recommendations
Three data-driven recommendations presented for management action.

![Business Recommendations](dashboard/screenshots/page3_recommendations.png)

---

## 💡 Key Findings

- **Paracetamol accounts for ~50% of total revenue** and is the clear #1 product
- **Winter is the peak season** — Paracetamol and Salbutamol spike October–January
- **Spring drives Loratadine** (antihistamine) — allergy season confirmed in the data
- **Saturday is the highest revenue day** — €65.67 average vs €57.18 on Thursday
- **2017 saw a 23% revenue drop** from the 2016 peak — an anomaly worth investigating
- **On high Paracetamol days, all other medicines also sell more** — demand is correlated

---

## 📋 Business Recommendations

**1. Increase Paracetamol stock before Winter**
Paracetamol is 50% of revenue and peaks every October–January. Stock levels should increase by at least 30% every September to avoid shortages during peak demand.

**2. Optimize weekend staffing**
Saturday generates the highest average daily revenue. Recommend maximum staff on Saturdays and reduced capacity on Thursdays to optimize labor costs without affecting service.

**3. Investigate the 2017 revenue drop**
Revenue dropped 23% from €25,235 in 2016 to €19,399 in 2017. Whether it was pricing, competition, or supply — identifying the cause could recover up to €5,800 in annual revenue.

---

## 🛠️ Tools Used

- **MySQL** — database design and all SQL queries
- **MySQL Workbench** — EER diagram and query development
- **Google Data Studio** — interactive dashboard and visualizations
- **Excel** — initial data exploration and cleaning

---

## 👤 About

Built by **Milan** as a portfolio project to demonstrate end-to-end data analysis skills — from database design to business storytelling.

📧 Email: Geerttsh@gmail.com
🔗 LinkedIN: https://www.linkedin.com/in/gerti-gonxhi-40539a391
