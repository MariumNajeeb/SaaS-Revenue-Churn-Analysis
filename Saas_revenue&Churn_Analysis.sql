-- -------------------------------------------
-- Project: SaaS Revenue & Churn Analysis-----
-- -------------------------------------------

--  (Data Validation):
-- changing datatypes 
-- standardizing (if needed)
-- handeling nulls,blanks,missing values
-- finding duplicates (if any)


SELECT * 
FROM monthly_revenue;

SELECT * 
FROM subscriptions;

-- ---------------------------------------------------------------------------

  -- Creating a staging table to work on: (for monthly_revenue)

SELECT * 
FROM monthly_revenue;

CREATE TABLE monthly_revenue_staging
LIKE monthly_revenue;

INSERT INTO monthly_revenue_staging
SELECT * FROM monthly_revenue;

SELECT * 
FROM monthly_revenue_staging;

-- changing the data type of month (from text to date & adding day)

SELECT * 
FROM monthly_revenue_staging;

SELECT DISTINCT `month`
FROM monthly_revenue_staging;

SELECT `month`, LENGTH(`month`) AS length
FROM monthly_revenue_staging;

ALTER TABLE monthly_revenue_staging
ADD COLUMN month_date DATE;

UPDATE monthly_revenue_staging
SET month_date = STR_TO_DATE(CONCAT(`month`, '-01'), '%Y-%m-%d');

SELECT * 
FROM monthly_revenue_staging
WHERE month_date IS NULL;

ALTER TABLE monthly_revenue_staging
DROP COLUMN `month`;

ALTER TABLE monthly_revenue_staging
CHANGE month_date `date` DATE;

ALTER TABLE monthly_revenue_staging
CHANGE `date`  `month` DATE;

ALTER TABLE  monthly_revenue_staging
MODIFY COLUMN `month` DATE FIRST;

SELECT * 
FROM monthly_revenue_staging;
-- ----------------------------------------------------

/*Changing the data type of 
customer_id, company_size, signup_date, churn_date.*/

-- Creating a staging table to work on: (for subscriptions):

SELECT * 
FROM subscriptions;

CREATE TABLE subscriptions_staging
LIKE subscriptions;

SELECT * 
FROM subscriptions_staging;

INSERT INTO subscriptions_staging
SELECT * FROM subscriptions;

/* changing the data types of 
(signup_date, churn_date) text to date.
(customer_id, company_size) text to varchar */

-- changing data type of signupdate (text to date): 

SELECT * 
FROM subscriptions_staging;

SELECT DISTINCT signup_date 
FROM subscriptions_staging;

SELECT sign_date, LENGTH(sign_date) AS length
FROM subscriptions_staging;

ALTER TABLE subscriptions_staging
ADD COLUMN signup_date_new DATE;

UPDATE subscriptions_staging
SET signup_date_new= STR_TO_DATE(signup_date, '%Y-%m-%d');

SELECT *
FROM  subscriptions_staging
WHERE signup_date_new IS NULL;

ALTER TABLE subscriptions_staging
DROP COLUMN signup_date;

ALTER TABLE subscriptions_staging
CHANGE signup_date_new signup_date DATE;

ALTER TABLE marketing_spend_staging
MODIFY `month` DATE FIRST;

ALTER TABLE subscriptions_staging
MODIFY signup_date DATE AFTER churned;

SELECT * 
FROM  subscriptions_staging;

-- changing data type of churn_date (text to date): 

SELECT * 
FROM subscriptions_staging;

SELECT DISTINCT churn_date 
FROM subscriptions_staging;

SELECT churn_date, LENGTH(churn_date) AS length
FROM subscriptions_staging;

ALTER TABLE subscriptions_staging
ADD COLUMN churn_date_new DATE;

UPDATE subscriptions_staging
SET churn_date_new= CASE
	WHEN churn_date= '' OR churn_date IS NULL THEN NULL
    ELSE STR_TO_DATE(churn_date, '%Y-%m-%d')
END;
    
 SELECT churn_date, churn_date_new
 FROM subscriptions_staging;
 
ALTER TABLE subscriptions_staging
DROP COLUMN churn_date;

ALTER TABLE subscriptions_staging
CHANGE churn_date_new churn_date DATE;

ALTER TABLE subscriptions_staging
MODIFY churn_date DATE AFTER signup_date;

SELECT *
FROM subscriptions_staging;
-- ---------------------------------------------

-- changing datatype of custmer_id (text to varchar)

SELECT * 
FROM subscriptions_staging;

ALTER TABLE subscriptions_staging
MODIFY customer_id VARCHAR(50) NOT NULL PRIMARY KEY;
-- -----------------------------------------------

-- changing datatype of company_size (text to varchar)

SELECT * 
FROM subscriptions_staging;

ALTER TABLE subscriptions_staging
MODIFY company_size VARCHAR(50);
-- ------------------------------------------------------------

-- no standardizing is needed in both tables:
--  (monthly_revenue_staging & subscriptions_staging)

-- ------------------------------------------------------------

-- handeling nulls, blanks, missing values(subscriptions_staging):

SELECT * 
FROM subscriptions_staging;

SELECT  (signup_date) ,(churn_date) ,(churn_reason)
FROM subscriptions_staging;

UPDATE subscriptions_staging
SET churn_reason= NULLIF(churn_reason, '')
WHERE churn_reason='';

SELECT churn_date, churn_reason
FROM subscriptions_staging
WHERE churn_date IS NULL AND churn_reason IS NULL;

-- -------------------------------------------------------------------------
/* note: the second table (monthly_revenue_staging) 
has no null, missing or blank values.*/
-- -------------------------------------------------------------------------

-- finding duplicates(if any)(monthly_revenue_staging)

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY `month`,total_active_customers,new_customers,
churned_customers,monthly_churn_rate_pct,total_mrr,
avg_revenue_per_customer,customer_acquisition_cost)
AS row_num
FROM monthly_revenue_staging;

WITH duplicate_cte AS 
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY `month`,total_active_customers,new_customers,
churned_customers,monthly_churn_rate_pct,total_mrr,
avg_revenue_per_customer,customer_acquisition_cost)
AS row_num
FROM monthly_revenue_staging
)
	SELECT * FROM duplicate_cte
    WHERE row_num >1;
    
-- note: there are no duplicates found in (monthly_revenue_staging)
-- -----------------------------------------------------------------

-- finding duplicates(if any)(subscriptions_staging)

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY customer_id,plan,billing_cycle,industry,company_size,seats,
monthly_revenue,acquisition_channel,region,churned,signup_date,churn_date,
churn_reason,support_tickets_12mo,nps_score,feature_usage_pct,upgraded)
AS row_num2
FROM subscriptions_staging;


WITH duplicate_cte2 AS 
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY customer_id,plan,billing_cycle,industry,company_size,seats,
monthly_revenue,acquisition_channel,region,churned,signup_date,churn_date,
churn_reason,support_tickets_12mo,nps_score,feature_usage_pct,upgraded)
AS row_num2
FROM subscriptions_staging
)
	SELECT * FROM duplicate_cte2
    WHERE row_num2 >1;
    
-- note: there are no duplicates found in subscriptions_staging either.
-- ----------------------------------------------------------------------

-- (Exploratory Data Analysis):

SELECT * 
FROM monthly_revenue_staging;

SELECT * 
FROM subscriptions_staging;

-- --------------------------
-- Questions to Answer:
-- --------------------------

/* Q1: What is the overall churn rate, 
and how has the monthly churn rate trended over
the past 4 years? 
Is churn improving or getting worse?*/

SELECT * 
FROM subscriptions_staging;

SELECT 
	COUNT(*) AS Total_customers,
    SUM(CASE WHEN churned= 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
	ROUND(SUM(CASE WHEN churned= 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) 
    AS overall_churn_rate
FROM subscriptions_staging;

SELECT * 
FROM monthly_revenue_staging;

SELECT 
    `month`,
    monthly_churn_rate_pct,
    CASE 
        WHEN total_active_customers < 10 THEN 'Early Stage'
        WHEN monthly_churn_rate_pct < 3 THEN 'Good'
        WHEN monthly_churn_rate_pct BETWEEN 3 AND 5 THEN 'Average'
        ELSE 'Critical'
    END AS performance
	FROM monthly_revenue_staging;

-- ---------------------------------------------------------------

/*Which subscription plan (Starter, Professional, Business, Enterprise)
has the highest churn rate? 
Does billing cycle (monthly vs. annual) significantly impact retention?*/

SELECT * FROM subscriptions_staging;

SELECT 
    plan,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churned = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        100.0 * SUM(CASE WHEN churned = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 
        1
    ) AS churn_rate_pct
FROM subscriptions
GROUP BY plan
ORDER BY churn_rate_pct DESC;



-- Churn rate by billing cycle

SELECT 
    billing_cycle,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churned = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        100.0 * SUM(CASE WHEN churned = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 
        1
    ) AS churn_rate_pct
FROM subscriptions
GROUP BY billing_cycle
ORDER BY churn_rate_pct DESC;

-- ----------------------------------------------------------

/*What are the top 3 reasons customers churn,
and do these reasons differ by plan type or company size?*/


-- Top churn reasons overall

SELECT * FROM subscriptions_staging;

SELECT 
    churn_reason,
    COUNT(*) AS churn_count,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM subscriptions WHERE churned = 'Yes'), 1)
    AS pct_of_total_churn
FROM subscriptions_staging
WHERE churned = 'Yes' AND churn_reason IS NOT NULL AND churn_reason != ''
GROUP BY churn_reason
ORDER BY churn_count DESC
LIMIT 10;


-- Churn reasons by plan type

SELECT 
    plan,
    churn_reason,
    COUNT(*) AS churn_count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY plan), 1) AS pct_of_plan_churn
FROM subscriptions
WHERE churned = 'Yes' AND churn_reason IS NOT NULL AND churn_reason != ''
GROUP BY plan, churn_reason
ORDER BY plan, churn_count DESC;


-- Churn reasons by company size

SELECT 
    company_size,
    churn_reason,
    COUNT(*) AS churn_count
FROM subscriptions
WHERE churned = 'Yes' AND churn_reason IS NOT NULL AND churn_reason != ''
GROUP BY company_size, churn_reason
ORDER BY company_size, churn_count DESC;


-- Cross-tab: Plan vs Company Size with top churn reason

SELECT 
    plan,
    company_size,
    churn_reason,
    COUNT(*) AS churn_count
FROM subscriptions
WHERE churned = 'Yes' AND churn_reason IS NOT NULL AND churn_reason != ''
GROUP BY plan, company_size, churn_reason
ORDER BY plan, company_size, churn_count DESC;

-- -------------------------------------------------------

/*Calculate the average Customer Lifetime Value (CLV) by plan. 
Compare this to the Customer Acquisition Cost (CAC).
Which plans are the most and least profitable?*/


WITH customer_lifetime AS (
    SELECT 
        plan,
        monthly_revenue,
        signup_date,
        churn_date,
        CASE 
            WHEN churned = 'Yes' THEN 
                TIMESTAMPDIFF(MONTH, signup_date, churn_date)
            ELSE 
                TIMESTAMPDIFF(MONTH, signup_date, '2025-12-31')
        END AS lifetime_months
    FROM subscriptions
)
SELECT 
    plan,
    ROUND(AVG(monthly_revenue), 0) AS avg_monthly_revenue,
    ROUND(AVG(lifetime_months), 1) AS avg_lifetime_months,
    ROUND(AVG(monthly_revenue * lifetime_months), 0) AS avg_clv,
    ROUND(AVG(monthly_revenue * lifetime_months) / 201.85, 1) AS clv_to_cac_ratio
FROM customer_lifetime
GROUP BY plan
ORDER BY avg_clv DESC;

-- Which plans are the most and least profitable?

WITH customer_lifetime AS (
    SELECT 
        plan,
        monthly_revenue,
        CASE 
            WHEN churned = 'Yes' THEN 
                TIMESTAMPDIFF(MONTH, signup_date, churn_date)
            ELSE 
                TIMESTAMPDIFF(MONTH, signup_date, '2025-12-31')
        END AS lifetime_months,
        CASE 
            WHEN churned = 'Yes' THEN 1 ELSE 0 
        END AS is_churned
    FROM subscriptions
),
plan_metrics AS (
    SELECT 
        plan,
        COUNT(*) AS total_customers,
        SUM(is_churned) AS churned_customers,
        ROUND(AVG(monthly_revenue), 0) AS avg_monthly_revenue,
        ROUND(AVG(lifetime_months), 1) AS avg_lifetime_months,
        ROUND(AVG(monthly_revenue * lifetime_months), 0) AS avg_clv,
        ROUND(100.0 * SUM(is_churned) / COUNT(*), 1) AS churn_rate_pct
    FROM customer_lifetime
    GROUP BY plan
)
SELECT 
    plan,
    total_customers,
    churned_customers,
    churn_rate_pct,
    avg_monthly_revenue,
    avg_lifetime_months,
    avg_clv,
    ROUND(avg_clv / 201.85, 1) AS clv_to_cac_ratio,
    ROUND(avg_clv / 201.85, 1) AS profitability_index,
    CASE 
        WHEN ROUND(avg_clv / 201.85, 1) >= 100 THEN 'Most Profitable'
        WHEN ROUND(avg_clv / 201.85, 1) >= 40 THEN 'Highly Profitable'
        WHEN ROUND(avg_clv / 201.85, 1) >= 20 THEN 'Moderately Profitable'
        ELSE 'Least Profitable'
    END AS profitability_tier
FROM plan_metrics
ORDER BY profitability_index DESC;

-- --------------------------------------------------------------

-- completed....


