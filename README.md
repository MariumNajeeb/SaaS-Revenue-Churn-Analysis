# SaaS Revenue & Churn Analysis – CloudTask Pro

Evidence-Based Problem Solving, Not Just Diagnosis

Portfolio Case Study | Business Intelligence & Strategic Analysis

**Prepared by:** Marium Najeeb – Business Intelligence Analyst  
**Date:** May 2026

---

## Project Overview

CloudTask Pro is a SaaS company that has grown from **0 to 600 customers since 2022**. While revenue has been growing, the board raised concerns about a high churn rate. The CFO needed answers to four critical questions:

1. **What is our overall churn rate, and how has the monthly churn rate trended over the past 4 years? Is it improving?**
2. **Which subscription plan (Starter, Professional, Business, Enterprise) has the highest churn rate? Does billing cycle (monthly vs. annual) significantly impact retention?**
3. **What are the top 3 reasons customers churn, and do these reasons differ by plan type or company size?**
4. **What is the average Customer Lifetime Value (CLV) by plan? Compare this to Customer Acquisition Cost (CAC). Which plans are the most and least profitable?**

As the Business Intelligence Analyst, I cleaned and validated two datasets (subscriptions and monthly revenue) using SQL, built an interactive Power BI dashboard (5 pages), and performed a deep‑dive churn & profitability analysis. This repository contains the final dashboard, cleaned data, SQL scripts and full documentation.

---

## Tools Used

| Tool      | Purpose                                                |
|-----------|--------------------------------------------------------|
| SQL       | Data cleaning, validation, cohort analysis, churn metrics |
| Power BI  | Dashboard creation, DAX measures, visualizations, conditional formatting |
| Excel     | Initial data exploration                               |
| GitHub    | Project documentation and version control              |

---

## Data Sources

| File                        | Rows | Key Columns |
|-----------------------------|------|--------------|
| `subscriptions_cleaned.csv` | 600  | customer_id, plan, billing_cycle, churned, churn_reason, signup_date, churn_date, monthly_revenue|
| `monthly_revenue_cleaned.csv` | 47 | month, total_active_customers, churned_customers, monthly_churn_rate_pct, total_mrr, customer_acquisition_cost|

---

## Executive Summary (For the Board)

| Metric                                      | Value                     | Insight                                                                 |
|---------------------------------------------|---------------------------|-------------------------------------------------------------------------|
| **Overall Churn Rate** (since 2022)         | 52.17% (313 of 600)       | 1 in 2 customers churned – high, but improving from early years.        |
| **Churn Trend Over 4 Years**                | See yearly breakdown below | 2022 worst (7 critical months), 2023 (2 critical), 2024 best (0 critical), 2025 reversal (2 critical). |
| **Plan with Highest Churn**                 | Starter – 70.5%           | 3x higher than Enterprise. Price + poor onboarding likely drivers.      |
| **Billing Cycle Impact**                    | Monthly 60.5% vs Annual 40.3% | Annual contracts cut churn by 20 points – strong retention lever.   |
| **Most Profitable Plan** (by CLV:CAC)       | Enterprise – 322.5x        | High revenue + long lifetime (22 months) → best unit economics.         |
| **Least Profitable Plan**                   | Starter – 9x               | Low CLV ($1,813) + high churn → near break‑even after CAC.              |

**Top CEO Recommendations:**

1. **Convert Starter monthly to annual only** (or add a premium monthly plan) – could cut Starter churn by 15‑20 points.
2. **Launch a lower‑priced “Essential” plan** ($29‑39/mo) to reduce price‑driven churn among small businesses.
3. **Fix product gaps for mid‑market** (Professional/Business): missing features and poor support are top reasons – invest in a public roadmap and dedicated account managers for >$1k MRR customers.
4. **Double down on Enterprise & Business** – they drive 80% of profit. Shift 20% of marketing spend from Starter to high‑LTV segments.
5. **Implement an early‑warning system** (NPS < 5 + support tickets > 3 in a month) to flag at‑risk customers before they churn.

---

## Detailed Analysis (Q1–Q4)

### Q1: Overall & Monthly Churn Rate Trend (4‑Year View)

**📌 One‑Sentence Summary**  
Overall churn is 52.2%. Monthly churn improved dramatically from 2022 to 2024, but 2025 shows a reversal with 2 critical months as were in 2023.

**📊 Insight**  
- **Overall churn:** 313 of 600 customers churned (52.17%).  
- **Performance by year (monthly churn rate categories):**  

| Year | Critical (>5%) | Good (<3%) | Average (3‑5%) |
|------|----------------|------------|----------------|
| 2022 | 7              | 4          | 1              |
| 2023 | 2              | 3          | 7              |
| 2024 | 0              | 1          | 11             |
| 2025 | 2              | 3          | 7              |

- **Worst year:** 2022 (7 critical months)
- **Best year:** 2024 (zero critical months).  
- **Concerning reversal:** 2025 has 2 critical months, as were in 2023. 2023 & 2025 have the exact same count of critical, good and avg months. 
- **Months since last critical:** 7 (as of Dec 2025) – a positive streak.

**✅ Recommendation**  
- Investigate changes in critical months of 2023 & 2025, i.e (product releases, pricing, support, competition).
- Compare changes, investigate the mistakes we made in 2023 and are repeating in 2025 again.     
- Build a **churn alert dashboard** that flags any month with churn >3% and triggers a root‑cause review.

**💰 Impact**  
-Eliminate critical months in 2026 – breaks the “7 critical → improvement → reversal” cycle seen across 2022‑2025.
-Save 3‑6 weeks of team firefighting currently spent on post‑critical‑month damage control.
  
---

### Q2: Churn by Plan & Billing Cycle

**📌 One‑Sentence Summary**  
Starter plan has the highest churn (70.5%), and monthly billing customers churn 20% more than annual subscribers – a clear retention lever.

**📊 Insight**

| Plan         | Churn Rate | Billing Cycle | Churn Rate |
|--------------|------------|---------------|------------|
| Starter      | 70.5%      | Monthly       | 60.5%      |
| Professional | 48.0%      | Annual        | 40.3%      |
| Business     | 41.3%      | **Difference**| **+20.2%** |
| Enterprise   | 22.0%      |               |            |

- **Key takeaway:** Customers who pay more (higher plans + annual contracts) stay significantly longer.  
- Starter + monthly = highest risk segment.

**✅ Recommendation**  
- **Eliminate monthly billing for Starter** (or make it significantly more expensive).  
- Offer a **discounted annual plan** with a clear “save 2 months free” message.  
- Implement a **Starter retention playbook**: automated onboarding, feature education, check‑in calls at days 7/30/60.

**💰 Impact**  
- Reduce Starter churn by 15‑20 percentage points within 2 quarters.  
- Shift 30% of monthly subscribers to annual → improve cash flow + retention.

---

### Q3: Top Churn Reasons by Plan & Company Size

**📌 One‑Sentence Summary**  
Churn drivers differ significantly by segment: price drives Starter churn, missing features and poor support drive mid‑market and Enterprise churn.

**📊 Insight – By Plan (% of churn within that plan)**

| Plan         | Top Reasons (% of plan churn)                                                                 |
|--------------|----------------------------------------------------------------------------------------------|
| **Starter**  | Budget Cuts 19%, Price Too High 19%, Company Closed 16%                                      |
| **Professional** | Budget Cuts 17%, Company Closed 16%, Price Too High 17%                                  |
| **Business** | Missing Features 18%, No Longer Needed 17%, Poor Support 17% (Budget Cuts 15%)               |
| **Enterprise** | Company Closed 27%, No Longer Needed 27%, Switched Competitor 18%                          |

**📊 Insight – By Company Size (% of churn within that size)**

| Size Range  | Top Reasons (% of size churn)                                                                 |
|-------------|----------------------------------------------------------------------------------------------|
| **1-10**    | Budget Cuts 22%, Price Too High 18%, Company Closed 15%                                      |
| **11-50**   | No Longer Needed 18%, Company Closed 17%, Poor Support 15%                                   |
| **51-200**  | Budget Cuts 18%, Price Too High 18%, Company Closed 17%                                      |
| **201-500** | Budget Cuts 23%, Missing Features 17%, Price Too High 17%, Switched Competitor 15%           |
| **500+**    | Company Closed 21%, Poor Support 21%                                                         |

**✅ Recommendation**  
- **Starter / small companies (1‑50):** Launch an “Essential” plan ($29‑39/mo) to reduce price‑driven churn.  
- **Mid‑size (51‑200):** Expand support hours + dedicated account manager for >$1k MRR customers.  
- **Large (201‑500):** Prioritise missing features and competitor switching – conduct win‑back interviews.  
- **Enterprise (500+):** Build a public feature roadmap + quarterly business reviews (QBRs) to reduce “Company Closed” and “Poor Support”.

**💰 Impact**  
- Reduce price‑related churn by 25% with new entry‑level plan.  
- Decrease “Missing Features” churn by 40% over 3 quarters via roadmap transparency.  
- Improve NPS from current ~4‑6 to >30 within 1 year.

---

### Q4: CLV by Plan & Profitability (CLV vs CAC)

**📌 One‑Sentence Summary**  
Enterprise and Business plans are the most profitable (lowest churn, highest CLV:CAC ratio), while Starter is the least profitable – nearly unprofitable.

**📊 Insight**

| Plan         | Churn Rate | Avg Monthly Revenue | Avg Lifetime (months) | Avg CLV | CLV:CAC Ratio | Profitability Tier |
|--------------|------------|---------------------|-----------------------|---------|----------------|--------------------|
| Enterprise   | 22.0%      | $2,985              | 22.3                  | $64,515 | 322.5x         | Most Profitable    |
| Business     | 41.2%      | $1,304              | 16.6                  | $21,224 | 105.1x         | Most Profitable    |
| Professional | 48.0%      | $497                | 14.3                  | $7,901  | 39.1x          | Moderately Profitable |
| Starter      | 70.5%      | $216                | 8.2                   | $1,813  | 9.0x           | Least Profitable   |

- **Enterprise** generates 35x more CLV than Starter, with 3x lower churn.  
- **Starter CLV** is only ~9x CAC – dangerously close to unprofitable once support and overhead are included.

**✅ Recommendation**  
- **Reduce Starter CAC** – shift acquisition to lower‑cost channels (referral, organic, self‑serve).  
- **Increase Starter pricing** by $10‑15/mo after adding 2‑3 high‑request features.  
- **Double down on Enterprise/Business** – allocate 60% of sales & marketing spend to these segments.  

**💰 Impact**  
- Improve overall CLV:CAC ratio from ~12‑15x to 25‑30x.  
- Reduce Starter acquisition volume but increase per‑customer profit.  
- Grow Enterprise segment from ~15% to 25% of customers by end of 2026.

---

## Power BI Dashboard Walkthrough

The dashboard consists of **5 pages**, each answering a key board question.

| Page | Name                     | Content                                                                 |
|------|--------------------------|-------------------------------------------------------------------------|
| 1    | Churn Trend & Performance| KPI cards (total customers, churned, overall churn rate, good months %, months since last critical), stacked column chart (performance by year), donut chart (performance distribution) |
| 2    | Churn by Plan & Billing Cycle | Pie charts (churn by plan, churn by billing cycle), matrix (plan × billing cycle), cards for monthly vs annual churn rate and difference |
| 3    | Churn Reason Analysis (1) | Horizontal bar chart (top 5 reasons overall), matrix (reasons by plan and by company size) |
| 4    | Churn Reason Analysis (2) | Top 3 reasons overall and reasons by per plan and per size (filtered views)|
| 5    | CLV & Profitability       | Tables (plan, total customers, churned, churn rate, avg monthly revenue, avg lifetime, avg CLV, profitability tier), cards for “Most Profitable” and “Least Profitable” |

---

## About the Author

Hi, I'm Marium Najeeb a Business Intelligence Analyst, passionate about turning messy data into clear business insights. I'm specializing in SQL, Power BI, Excel and dashboard storytelling.

This project was built independently to demonstrate:

End‑to‑end data cleaning and analysis
Strategic thinking (finding the real business problem behind the numbers)
Executive communication (delivering actionable recommendations, not just charts)


**Connect with me:**  
- [LinkedIn] https://www.linkedin.com/in/marium-najeeb123/
- [GitHub] https://github.com/MariumNajeeb
- [Portfolio] https://www.datascienceportfol.io/shahzadnajeeb02
- Email: shahzadnajeeb02@gmail.com

I’m always open to feedback, collaboration, or full‑time opportunities in data analytics.

---
