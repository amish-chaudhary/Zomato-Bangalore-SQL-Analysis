# 🍽️ Zomato Bangalore Restaurant Analysis — SQL Project

## 📌 Project Overview

This project performs a comprehensive **business-driven SQL analysis** on the Zomato Bangalore restaurant dataset. The goal is not just to query data, but to derive **actionable business insights** that Zomato can use to improve platform quality, expand into new locations, and increase revenue.

> *"Only 1 in 7 restaurants on Zomato Bangalore is a true Star restaurant — Zomato needs urgent quality improvement across the platform."*

---

## 📂 Dataset

- **Source:** [Zomato Bangalore Restaurants — Kaggle](https://www.kaggle.com/datasets/himanshupoddar/zomato-bangalore-restaurants)
- **Total Rows:** 51,717 restaurants
- **After Cleaning:** 41,654 restaurants
- **Location:** Bangalore, India
- **Key Columns:** name, location, cuisines, rate, votes, online_order, book_table, approx_cost

---

## 🛠️ Tools Used

| Tool | Purpose |
|---|---|
| MySQL 8.0 | Database & Query Execution |
| MySQL Workbench | SQL IDE |
| Python (pandas) | Data Import & Cleaning |
| GitHub | Project Documentation |

---

## 🧹 Data Cleaning

Before analysis the following cleaning steps were performed:

- Removed 21 rows with NULL location
- Removed 45 rows with NULL cuisines
- Created clean `rating` column from `rate` column (removed `/5` suffix)
- Created clean `cost` column from `approx_cost` (removed commas)
- Handled `NEW` and `-` values in rating column

```sql
-- Clean rating column
ALTER TABLE zomato ADD COLUMN rating DECIMAL(3,1);
UPDATE zomato
SET rating = CAST(SUBSTRING_INDEX(rate, '/', 1) AS DECIMAL(3,1))
WHERE rate NOT IN ('NEW', '-') AND rate IS NOT NULL;

-- Clean cost column
ALTER TABLE zomato ADD COLUMN cost DECIMAL(10,2);
UPDATE zomato
SET cost = CAST(REPLACE(approx_cost, ',', '') AS DECIMAL(10,2))
WHERE approx_cost IS NOT NULL;
```

---

## 📊 Business Analysis — 6 Areas, 23 Queries

---

### 🏆 Area 1 — Restaurant Performance & Quality

**Business Question:** Which restaurants should Zomato promote or delist?

| Query | Finding | Business Decision |
|---|---|---|
| Q1 — Platform Quality | 27.59% restaurants rated below 3.5 | Introduce minimum quality policy |
| Q2 — Overhyped Restaurants | Top overhyped mostly in Koramangala (900+ votes, <3.5 rating) | Add quality warning badge |
| Q3 — Hidden Gems | High rated restaurants (4.6+) with <150 votes in Koramangala | Promote on homepage |
| Q4 — Top Cuisines | Multi-cuisine restaurants consistently rate 4.9 | Prioritize in recommendations |

**Key Insight:**
> *"Nearly 1 in 4 restaurants on Zomato Bangalore have a rating below 3.5 — Zomato should introduce a minimum rating policy or send quality improvement notices to these 11,494 restaurants."*

---

### 📍 Area 2 — Location & Expansion Strategy

**Business Question:** Where should Zomato focus next?

| Query | Finding | Business Decision |
|---|---|---|
| Q5 — Best Food Zones | Lavelle Road #1 with 4.14 avg rating | Target for premium ads |
| Q6 — Oversaturated Zones | BTM has 3930 restaurants but only 3.57 rating | Pause new onboarding in BTM |
| Q7 — Underserved Zones | Sankey Road only 26 restaurants but 3.97 rating | #1 expansion opportunity |
| Q8 — Luxury Zones | Sankey Road avg cost ₹2505 — most premium zone | Target for Zomato Gold |

**Key Insight:**
> *"Lavelle Road and Sankey Road appear in every location analysis — high rating, underserved, premium pricing AND low delivery. These two zones are Zomato's single biggest opportunity in Bangalore."*

---

### 🚚 Area 3 — Online Delivery Strategy

**Business Question:** Is delivery investment worth it?

| Query | Finding | Business Decision |
|---|---|---|
| Q9 — Delivery Impact | Delivery restaurants rate 3.72 vs 3.66 non-delivery | Justify delivery investment |
| Q10 — Low Delivery Cuisines | Finger Food 269 restaurants only 1.49% delivery | Target for onboarding |
| Q11 — Delivery Gap Zones | Sankey Road 0% delivery despite 3.97 rating | Immediate expansion target |

**Key Insight:**
> *"Sankey Road has ZERO delivery despite being a premium zone with 3.97 rating — Zomato should immediately launch a delivery onboarding drive here to capture premium delivery revenue."*

---

### 🪑 Area 4 — Table Booking & Dine-in

**Business Question:** Should Zomato push table booking more?

| Query | Finding | Business Decision |
|---|---|---|
| Q12 — Booking Impact | Booking restaurants rate 4.14 vs 3.62 (0.52 gap!) | Aggressively market booking feature |
| Q13 — Premium Low Booking | Langford Town only premium zone with 0% booking | Sales team target |

**Key Insight:**
> *"Table booking shows the strongest quality correlation in our entire analysis — 0.52 rating difference. Only 15% of restaurants offer it — massive growth opportunity."*

---

### 💰 Area 5 — Pricing & Affordability

**Business Question:** How is Zomato serving different income segments?

| Query | Finding | Business Decision |
|---|---|---|
| Q14 — Price Segments | Premium 3.99 > Mid 3.62 > Budget 3.56 | Focus quality on Mid segment |
| Q15 — Overpriced Cuisines | North Indian/Continental/Chinese worst value (₹1282, 3.35 rating) | Add Value for Money badge |
| Q16 — Best Value Zones | Koramangala 5th Block best value (4.01 rating, ₹680) | Promote to price sensitive users |

**Key Insight:**
> *"Mid segment dominates with 57% of all restaurants but average 3.62 rating — improving quality in this segment would have the biggest impact on overall platform experience."*

---

### 🍜 Area 6 — Cuisine & Market Trends

**Business Question:** What food trends should Zomato capitalize on?

| Query | Finding | Business Decision |
|---|---|---|
| Q17 — Popular Cuisines | North Indian #1 with 558K votes but 3.59 rating | Recruit better North Indian restaurants |
| Q18 — Supply Gap | North Indian/European/Mediterranean 13 restaurants, 136K votes | Urgent recruitment drive |
| Q19 — Location Dominance | North Indian leads 9/10 locations, Jayanagar is South Indian hub | Hyperlocal marketing |

**Key Insight:**
> *"Fusion cuisines combining North Indian with European/Mediterranean have less than 20 restaurants each but 4.7+ ratings and massive votes — this is the single biggest growth opportunity on the platform."*

---

### 🎯 Advanced Queries — Window Functions & Subqueries

| Query | Technique | Finding |
|---|---|---|
| Q20 — Restaurant Segmentation | CASE WHEN | 67.7% restaurants are Avoid segment! |
| Q21 — Cuisine Rankings | RANK() OVER PARTITION BY | Galito's #1 in African/Burger cuisine |
| Q22 — Market Leader per Location | Subquery + Window Function | North Indian leads 8/10 locations |
| Q23 — True Local Champions | AVG() OVER PARTITION BY | Onesta dominates Banashankari with 2556 votes |

**Key Insight:**
> *"A shocking 67.7% of Zomato Bangalore restaurants fall in the Avoid segment — Zomato should implement smart filtering to show Star and Underdog restaurants first."*

---

## 🔥 Top 5 Overall Business Insights

1. **Platform Quality Crisis** — 67.7% restaurants are poor quality (Avoid segment) — urgent quality control needed
2. **Sankey Road Opportunity** — Premium zone, underserved, zero delivery, high rating — #1 expansion target
3. **Table Booking = Quality** — Strongest correlation found (0.52 rating gap) — push this feature aggressively
4. **Fusion Food Gap** — North Indian + European/Mediterranean cuisines have massive demand but zero supply
5. **BTM Oversaturation** — 3930 restaurants but below average quality — pause onboarding immediately

---

## 📁 Project Structure

```
zomato-sql-analysis/
│
├── data/
│   └── zomato.csv
│
├── sql/
│   ├── 01_data_cleaning.sql
│   ├── 02_restaurant_performance.sql
│   ├── 03_location_strategy.sql
│   ├── 04_delivery_analysis.sql
│   ├── 05_table_booking.sql
│   ├── 06_pricing_analysis.sql
│   ├── 07_cuisine_trends.sql
│   └── 08_advanced_queries.sql
│
├── insights/
│   └── key_findings.md
│
└── README.md
```

---

## 💡 SQL Concepts Used

| Concept | Queries Used In |
|---|---|
| WHERE, AND, OR | Q1, Q2, Q3 |
| GROUP BY, ORDER BY | Q4, Q5, Q8, Q17 |
| HAVING | Q6, Q7, Q10, Q18 |
| Aggregate Functions (COUNT, AVG, SUM) | All queries |
| CASE WHEN | Q14, Q19, Q20 |
| Subqueries | Q6, Q22 |
| Window Functions (RANK, AVG OVER) | Q21, Q22, Q23 |
| LIKE | Q19 |
| ROUND, CAST | Multiple queries |

---

## 👨‍💻 Author

**Amish Chaudhary**
- 📧 Connect on LinkedIn
- 🐙 GitHub Profile

---

## ⭐ If you found this project helpful, please give it a star!

