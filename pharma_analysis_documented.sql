-- ============================================================
-- PHARMACEUTICAL SALES ANALYSIS
-- MySQL Database | pharma_analysis
-- ============================================================
-- Dataset: 6 years of daily pharmacy sales data (Serbia)
-- 8 medicine categories tracked by ATC code
-- 5 tables: sales_daily, sales_hourly, sales_weekly,
--           sales_monthly, drug_categories
-- Goal: Understand what sells, when it sells, and what to do about it
-- ============================================================


-- ============================================================
-- QUERY 1: Which are the best selling medicines?
-- ============================================================
-- WHY I WROTE THIS:
--   I wanted to rank all 8 medicines by total revenue over 6 years.
--   Simple question — what is our #1 product?
--
-- THE CHALLENGE:
--   In this dataset, each medicine is stored as its own column.
--   That's a problem because SQL can't easily compare columns side by side.
--   I needed to turn those columns INTO rows first.
--
-- HOW I SOLVED IT:
--   I used UNION ALL to "stack" each medicine column on top of each other
--   into one big list with two columns: the drug code and the sales value.
--   This is called "unpivoting" the data.
--   Then I joined that result to my drug_categories table so the output
--   shows "Paracetamol" instead of the raw code "N02BE".
--
-- WHAT IT TELLS US:
--   Paracetamol is the #1 seller by a large margin.
--   Pain relievers and respiratory medicines dominate overall.
-- ============================================================

USE pharma_analysis;

SELECT 
    d.drug_name,
    d.category,
    ROUND(SUM(sales), 2) as total_sales
FROM (
    SELECT 'M01AB' as code, M01AB as sales FROM sales_daily
    UNION ALL SELECT 'M01AE', M01AE FROM sales_daily
    UNION ALL SELECT 'N02BA', N02BA FROM sales_daily
    UNION ALL SELECT 'N02BE', N02BE FROM sales_daily
    UNION ALL SELECT 'N05B',  N05B  FROM sales_daily
    UNION ALL SELECT 'N05C',  N05C  FROM sales_daily
    UNION ALL SELECT 'R03',   R03   FROM sales_daily
    UNION ALL SELECT 'R06',   R06   FROM sales_daily
) as unpivoted
JOIN drug_categories d ON unpivoted.code = d.code
GROUP BY d.drug_name, d.category
ORDER BY total_sales DESC;


-- ============================================================
-- QUERY 2: How has total revenue trended month by month?
-- ============================================================
-- WHY I WROTE THIS:
--   I wanted to see if the business is growing over time,
--   and which months are consistently busy or slow.
--
-- HOW IT WORKS:
--   DATE_FORMAT(datum, '%Y-%m') groups all rows by year and month.
--   I summed up the top medicines individually AND as a total.
--   That way you can see both the overall trend AND which medicine
--   is driving it in any given month.
--
-- WHAT IT TELLS US:
--   Revenue spikes every winter (October to January).
--   Paracetamol is the main driver of those peaks.
--   This is expected — cold and flu season drives pharmacy demand.
-- ============================================================

SELECT 
    CONCAT(DATE_FORMAT(datum, '%Y-%m')) as sale_month,
    ROUND(SUM(N02BE), 2) as Paracetamol,
    ROUND(SUM(M01AB), 2) as Ibuprofen,
    ROUND(SUM(R03),   2) as Salbutamol,
    ROUND(SUM(N05B),  2) as Diazepam,
    ROUND(SUM(M01AB + M01AE + N02BA + N02BE + N05B + N05C + R03 + R06), 2) as total_revenue
FROM sales_daily
GROUP BY CONCAT(DATE_FORMAT(datum, '%Y-%m'))
ORDER BY sale_month;


-- ============================================================
-- QUERY 3: Which season drives the highest medicine sales?
-- ============================================================
-- WHY I WROTE THIS:
--   Month by month is detailed but hard to summarize quickly.
--   Grouping into seasons gives a cleaner story for decision-making.
--   Is it really winter that drives sales, or is it another season?
--
-- HOW IT WORKS:
--   I used a CASE statement — basically an if/else — to label each
--   month as Winter, Spring, Summer or Autumn based on month number.
--   I used AVG instead of SUM because seasons have different numbers
--   of days. AVG gives a fair comparison — otherwise Winter would
--   look bigger just because it has more data points.
--
-- WHAT IT TELLS US:
--   Winter is the peak for Paracetamol and Salbutamol (respiratory).
--   Spring is the peak for Loratadine — that's the antihistamine,
--   so it makes sense: allergy season. The data is clinically logical
--   which also tells us the dataset is reliable.
-- ============================================================

SELECT 
    CASE 
        WHEN Month IN (12,1,2)  THEN 'Winter'
        WHEN Month IN (3,4,5)   THEN 'Spring'
        WHEN Month IN (6,7,8)   THEN 'Summer'
        WHEN Month IN (9,10,11) THEN 'Autumn'
    END as season,
    ROUND(AVG(N02BE), 2) as Paracetamol,
    ROUND(AVG(R03),   2) as Salbutamol,
    ROUND(AVG(R06),   2) as Loratadine,
    ROUND(AVG(N05B),  2) as Diazepam,
    ROUND(AVG(M01AB), 2) as Ibuprofen
FROM sales_daily
GROUP BY season
ORDER BY FIELD(season, 'Winter', 'Spring', 'Summer', 'Autumn');


-- ============================================================
-- QUERY 4: How has revenue grown year over year per medicine?
-- ============================================================
-- WHY I WROTE THIS:
--   I wanted to zoom out and see the big picture across all 6 years.
--   Are we growing? Shrinking? Is any medicine losing ground?
--
-- HOW IT WORKS:
--   Simple GROUP BY Year with SUM for each medicine.
--   One row per year, easy to read.
--
-- WHAT IT TELLS US:
--   2016 was the peak year at around €25,000 total revenue.
--   2017 dropped by about 23% — that's a big, unexplained dip.
--   Then it slowly recovered. That 2017 drop became one of my
--   three business recommendations because something clearly happened
--   and the pharmacy should find out what.
-- ============================================================

SELECT 
    Year,
    ROUND(SUM(N02BE), 2) as Paracetamol,
    ROUND(SUM(M01AB), 2) as Ibuprofen,
    ROUND(SUM(R03),   2) as Salbutamol,
    ROUND(SUM(N05B),  2) as Diazepam,
    ROUND(SUM(R06),   2) as Loratadine,
    ROUND(SUM(M01AB + M01AE + N02BA + N02BE + N05B + N05C + R03 + R06), 2) as total_revenue
FROM sales_daily
GROUP BY Year
ORDER BY Year;


-- ============================================================
-- QUERY 5: Which day of the week has the highest sales?
-- ============================================================
-- WHY I WROTE THIS:
--   Not all days are equal. If Saturday is consistently your best day,
--   you should have more staff. If Thursday is quiet, you can cut back.
--   This directly helps with labor cost decisions.
--
-- HOW IT WORKS:
--   GROUP BY Weekday_Name, then AVG the total revenue per day.
--   I used AVG not SUM so that all days are compared fairly
--   regardless of how many of each day appear in 6 years.
--   ORDER BY avg_total_revenue so the best day appears first.
--
-- WHAT IT TELLS US:
--   Saturday is the best day. Thursday is one of the weakest.
--   This feeds directly into Recommendation 2 about staffing.
-- ============================================================

SELECT 
    Weekday_Name,
    ROUND(AVG(N02BE), 2) as Paracetamol,
    ROUND(AVG(M01AB), 2) as Ibuprofen,
    ROUND(AVG(R03),   2) as Salbutamol,
    ROUND(AVG(M01AB + M01AE + N02BA + N02BE + N05B + N05C + R03 + R06), 2) as avg_total_revenue
FROM sales_daily
GROUP BY Weekday_Name
ORDER BY avg_total_revenue DESC;


-- ============================================================
-- QUERY 6: At what time of day are medicine sales highest?
-- ============================================================
-- WHY I WROTE THIS:
--   Even within a day, demand is not evenly spread.
--   Knowing the peak hours helps with shift scheduling and
--   making sure a pharmacist is always available at busy times.
--
-- HOW IT WORKS:
--   This query uses the sales_hourly table — not sales_daily.
--   That table has one row per hour instead of per day.
--   I grouped by Hour and averaged the revenue across all days.
--   ORDER BY Hour so it reads chronologically like a clock.
--
-- WHAT IT TELLS US:
--   You can clearly see morning and lunch peaks when most
--   customers visit. Useful for opening hours and staffing shifts.
-- ============================================================

SELECT 
    Hour,
    ROUND(AVG(N02BE), 2) as Paracetamol,
    ROUND(AVG(M01AB), 2) as Ibuprofen,
    ROUND(AVG(R03),   2) as Salbutamol,
    ROUND(AVG(M01AB + M01AE + N02BA + N02BE + N05B + N05C + R03 + R06), 2) as avg_revenue
FROM sales_hourly
GROUP BY Hour
ORDER BY Hour;


-- ============================================================
-- QUERY 7: How do we rate each month's performance?
-- ============================================================
-- WHY I WROTE THIS:
--   Raw revenue numbers are hard to interpret quickly.
--   A manager doesn't want to read 72 rows of numbers —
--   they want to know: was this month good or bad?
--   I added a label system to make the data instantly readable.
--
-- HOW IT WORKS:
--   I calculated monthly totals for all medicines,
--   then added a CASE statement that assigns a rating label
--   based on total revenue thresholds:
--     €2500+  = Excellent
--     €2000+  = Good
--     €1500+  = Average
--     Below   = Poor
--   The thresholds came from looking at the data distribution
--   and picking meaningful breakpoints.
--
-- WHAT IT TELLS US:
--   At a glance you can see which months consistently perform well
--   and which months underperform. This could trigger early warnings
--   for management if a usually-good month comes in as "Average".
-- ============================================================

SELECT 
    DATE_FORMAT(datum, '%Y-%m') as month,
    ROUND(SUM(N02BE), 2) as Paracetamol,
    ROUND(SUM(M01AB), 2) as Ibuprofen,
    ROUND(SUM(M01AE), 2) as Diclofenac,
    ROUND(SUM(N02BA), 2) as Aspirin,
    ROUND(SUM(N05B), 2)  as Diazepam,
    ROUND(SUM(N05C), 2)  as Nitrazepam,
    ROUND(SUM(R03), 2)   as Salbutamol,
    ROUND(SUM(R06), 2)   as Loratadine,
    ROUND(SUM(M01AB + M01AE + N02BA + N02BE + N05B + N05C + R03 + R06), 2) as total_revenue,
    CASE 
        WHEN SUM(M01AB + M01AE + N02BA + N02BE + N05B + N05C + R03 + R06) >= 2500 THEN 'Excellent'
        WHEN SUM(M01AB + M01AE + N02BA + N02BE + N05B + N05C + R03 + R06) >= 2000 THEN 'Good'
        WHEN SUM(M01AB + M01AE + N02BA + N02BE + N05B + N05C + R03 + R06) >= 1500 THEN 'Average'
        ELSE 'Poor'
    END as performance_rating
FROM sales_daily
GROUP BY DATE_FORMAT(datum, '%Y-%m')
ORDER BY total_revenue DESC;


-- ============================================================
-- QUERY 8: Do weekends significantly outperform weekdays?
-- ============================================================
-- WHY I WROTE THIS:
--   Query 5 showed Saturday is the best single day.
--   But I wanted to confirm: is the weekend as a whole better
--   than weekdays on average? That's a stronger business insight.
--
-- HOW IT WORKS:
--   Another CASE statement — if the day is Saturday or Sunday,
--   label it "Weekend", otherwise "Weekday".
--   Then AVG the total revenue per group.
--   I also included COUNT(*) to show how many days are in each group.
--   That's important — it proves the comparison is fair and not
--   based on just a handful of days.
--
-- WHAT IT TELLS US:
--   Weekends average higher revenue per day than weekdays.
--   Combined with Query 5, this confirms the staffing recommendation:
--   maximize capacity on Saturdays and Sundays.
-- ============================================================

SELECT 
    CASE 
        WHEN Weekday_Name IN ('Saturday', 'Sunday') THEN 'Weekend'
        ELSE 'Weekday'
    END as day_type,
    ROUND(AVG(N02BE), 2) as avg_Paracetamol,
    ROUND(AVG(M01AB), 2) as avg_Ibuprofen,
    ROUND(AVG(M01AE), 2) as avg_Diclofenac,
    ROUND(AVG(N02BA), 2) as avg_Aspirin,
    ROUND(AVG(N05B), 2)  as avg_Diazepam,
    ROUND(AVG(R03), 2)   as avg_Salbutamol,
    ROUND(AVG(R06), 2)   as avg_Loratadine,
    ROUND(AVG(M01AB + M01AE + N02BA + N02BE + N05B + N05C + R03 + R06), 2) as avg_total_revenue,
    COUNT(*) as number_of_days
FROM sales_daily
GROUP BY 
    CASE 
        WHEN Weekday_Name IN ('Saturday', 'Sunday') THEN 'Weekend'
        ELSE 'Weekday'
    END
ORDER BY avg_total_revenue DESC;


-- ============================================================
-- QUERY 9: What is our cumulative revenue growth over time?
-- ============================================================
-- WHY I WROTE THIS:
--   Month by month you can see ups and downs, but it's hard to
--   feel the total growth. A running total — like a savings account
--   balance — makes the overall progress much easier to grasp.
--
-- HOW IT WORKS:
--   First I calculate monthly revenue the normal way (GROUP BY month).
--   Then I add a window function: SUM() OVER (ORDER BY month).
--   A window function is special — unlike GROUP BY, it doesn't
--   collapse rows. It looks at all the rows in order and keeps
--   adding up as it goes. Think of it as a running total column.
--   The nested SUM(SUM(...)) is needed because I'm applying
--   the window function on top of an already-grouped result.
--
-- WHAT IT TELLS US:
--   You can see the total revenue accumulate month by month over
--   6 years. It makes the scale of the business very clear and
--   shows where growth slowed down (like during 2017).
--
-- NOTE: This uses a window function — a slightly more advanced
--   SQL feature. It shows I understand SQL beyond just basic queries.
-- ============================================================

SELECT 
    DATE_FORMAT(datum, '%Y-%m') as month,
    ROUND(SUM(N02BE), 2) as Paracetamol,
    ROUND(SUM(M01AB), 2) as Ibuprofen,
    ROUND(SUM(R03), 2)   as Salbutamol,
    ROUND(SUM(M01AB + M01AE + N02BA + N02BE + N05B + N05C + R03 + R06), 2) as monthly_revenue,
    ROUND(SUM(SUM(M01AB + M01AE + N02BA + N02BE + N05B + N05C + R03 + R06)) 
        OVER (ORDER BY DATE_FORMAT(datum, '%Y-%m')), 2) as cumulative_revenue
FROM sales_daily
GROUP BY DATE_FORMAT(datum, '%Y-%m')
ORDER BY month;


-- ============================================================
-- QUERY 10: On high Paracetamol days, do other medicines also sell more?
-- ============================================================
-- WHY I WROTE THIS:
--   Paracetamol is our biggest seller. I wanted to know if it acts
--   as a signal for the whole pharmacy — meaning when Paracetamol
--   is flying off the shelves, is everything else too?
--   If yes, that changes how you manage inventory across the board.
--
-- HOW IT WORKS:
--   I split every day into three buckets based on Paracetamol sales:
--     High = 50+ units sold that day
--     Medium = 25 to 50 units
--     Low = under 25 units
--   Then I averaged all the other medicines within each bucket.
--   If the averages go up as Paracetamol goes up, there's a clear
--   correlation — demand moves together.
--
-- WHAT IT TELLS US:
--   On high Paracetamol days, other medicines also sell more.
--   This suggests demand is driven by the same trigger — likely
--   illness spikes. Practically, it means: if Paracetamol is selling
--   fast, you should also check stock levels on everything else,
--   not just reorder Paracetamol alone.
-- ============================================================

SELECT 
    CASE 
        WHEN N02BE >= 50 THEN 'High Paracetamol Day (50+)'
        WHEN N02BE >= 25 THEN 'Medium Paracetamol Day (25-50)'
        ELSE 'Low Paracetamol Day (under 25)'
    END as paracetamol_level,
    ROUND(AVG(M01AB), 2) as avg_Ibuprofen,
    ROUND(AVG(M01AE), 2) as avg_Diclofenac,
    ROUND(AVG(N02BA), 2) as avg_Aspirin,
    ROUND(AVG(N05B), 2)  as avg_Diazepam,
    ROUND(AVG(R03), 2)   as avg_Salbutamol,
    ROUND(AVG(R06), 2)   as avg_Loratadine,
    COUNT(*) as number_of_days
FROM sales_daily
GROUP BY 
    CASE 
        WHEN N02BE >= 50 THEN 'High Paracetamol Day (50+)'
        WHEN N02BE >= 25 THEN 'Medium Paracetamol Day (25-50)'
        ELSE 'Low Paracetamol Day (under 25)'
    END
ORDER BY avg_Ibuprofen DESC;
