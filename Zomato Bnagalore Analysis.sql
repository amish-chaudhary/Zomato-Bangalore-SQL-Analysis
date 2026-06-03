-- CREATE DATABASE zomato_project;
USE zomato_project;

CREATE TABLE zomato (
    url TEXT,
    address TEXT,
    name VARCHAR(200),
    online_order VARCHAR(5),
    book_table VARCHAR(5),
    rate VARCHAR(10),
    votes INT,
    phone TEXT,
    location VARCHAR(100),
    rest_type VARCHAR(100),
    dish_liked TEXT,
    cuisines TEXT,
    approx_cost INT,
    reviews_list TEXT,
    menu_item TEXT,
    listed_in_type VARCHAR(100),
    listed_in_city VARCHAR(100)
);

SELECT * FROM zomato;

-- What % of restaurants have rating below 3.5?

SELECT 
    COUNT(*) AS total_restaurants,
    SUM(rating < 3.5) AS poor_rating_count,
    ROUND(SUM(rating < 3.5) * 100 / COUNT(*), 2) AS percentage
FROM zomato
WHERE rating IS NOT NULL;


-- Top10 restaurants that are overhyped — high votes (>500) but low rating (<3.5)?"

SELECT * FROM zomato;

SELECT name, location, rate, votes
FROM zomato
WHERE rating < 3.5 AND votes > 500
ORDER BY votes DESC
LIMIT 10;

-- Top 10 Hidden Gems

SELECT name, location, rating, votes
FROM zomato
WHERE rating > 4.5 AND votes < 150
ORDER BY rating DESC
LIMIT 10;

-- Which cuisines consistently deliver avg rating above 4.0?

SELECT cuisines, 
       ROUND(AVG(rating), 2) AS avg_rating
FROM zomato
WHERE rating IS NOT NULL
GROUP BY cuisines
HAVING AVG(rating) > 4.0
ORDER BY avg_rating DESC
LIMIT 10;

-- Which locations have highest average rating?

SELECT location,
       ROUND(AVG(rating), 2) AS avg_rating,
       COUNT(*) AS total_restaurants
FROM zomato
WHERE rating IS NOT NULL
GROUP BY location
ORDER BY avg_rating DESC
LIMIT 10;

-- Which locations have most restaurants but below average rating?

SELECT location,
       COUNT(*) AS total_restaurants,
       ROUND(AVG(rating), 2) AS avg_rating
FROM zomato
WHERE rating IS NOT NULL
GROUP BY location
HAVING AVG(rating) < (SELECT AVG(rating) FROM zomato)
ORDER BY total_restaurants DESC
LIMIT 10;

-- Underserved locations with high rating but few restaurants

SELECT location,
       COUNT(*) AS total_restaurants,
       ROUND(AVG(rating), 2) AS avg_rating
FROM zomato
WHERE rating IS NOT NULL
GROUP BY location
HAVING COUNT(*) < 500
AND AVG(rating) > 3.9
ORDER BY avg_rating DESC
LIMIT 10;

-- Top 5 luxury location in Bangalore

SELECT location,
       ROUND(AVG(cost), 2) AS avg_cost_for_two,
       COUNT(*) AS total_restaurants
FROM zomato
WHERE cost IS NOT NULL
GROUP BY location
ORDER BY avg_cost_for_two DESC
LIMIT 5;

-- Do restaurants with online delivery have better ratings?

SELECT online_order,
       COUNT(*) AS total_restaurants,
       ROUND(AVG(rating), 2) AS avg_rating
FROM zomato
WHERE rating IS NOT NULL
GROUP BY online_order;

-- Which cuisines have lowest online delivery adoption?

SELECT cuisines,
       COUNT(*) AS total_restaurants,
       SUM(online_order = 'Yes') AS delivery_count,
       ROUND(SUM(online_order = 'Yes') * 100 / COUNT(*), 2) AS delivery_percentage
FROM zomato
GROUP BY cuisines
HAVING COUNT(*) > 50
ORDER BY delivery_percentage ASC
LIMIT 10;

-- High rated locations with low delivery availability

SELECT location,
       ROUND(AVG(rating), 2) AS avg_rating,
       ROUND(SUM(online_order = 'Yes') * 100 / COUNT(*), 2) AS delivery_percentage
FROM zomato
WHERE rating IS NOT NULL
GROUP BY location
HAVING AVG(rating) > 3.9
AND SUM(online_order = 'Yes') * 100 / COUNT(*) < 50
ORDER BY avg_rating DESC
LIMIT 10;

-- Do restaurants with table booking get higher ratings?

SELECT book_table,
       COUNT(*) AS total_restaurants,
       ROUND(AVG(rating), 2) AS avg_rating
FROM zomato
WHERE rating IS NOT NULL
GROUP BY book_table;

-- Premium locations with low table booking adoption

SELECT location,
       COUNT(*) AS total_restaurants,
       ROUND(AVG(cost), 2) AS avg_cost,
       SUM(book_table = 'Yes') AS booking_yes,
       ROUND(SUM(book_table = 'Yes') * 100 / COUNT(*), 2) AS booking_percentage
FROM zomato
WHERE cost IS NOT NULL
GROUP BY location
HAVING AVG(cost) > 800
AND SUM(book_table = 'Yes') * 100 / COUNT(*) < 20
ORDER BY avg_cost DESC
LIMIT 10;

-- Categorize restaurants into Budget, Mid and Premium

SELECT 
    CASE 
        WHEN cost < 300 THEN 'Budget'
        WHEN cost BETWEEN 300 AND 700 THEN 'Mid'
        WHEN cost > 700 THEN 'Premium'
    END AS price_category,
    COUNT(*) AS total_restaurants,
    ROUND(AVG(rating), 2) AS avg_rating
FROM zomato
WHERE cost IS NOT NULL
AND rating IS NOT NULL
GROUP BY price_category
ORDER BY avg_rating DESC;

-- Which cuisines are overpriced relative to their rating?

SELECT cuisines,
       ROUND(AVG(cost), 2) AS avg_cost,
       ROUND(AVG(rating), 2) AS avg_rating,
       COUNT(*) AS total_restaurants
FROM zomato
WHERE cost IS NOT NULL
AND rating IS NOT NULL
GROUP BY cuisines
HAVING COUNT(*) > 50
ORDER BY avg_cost DESC, avg_rating ASC
LIMIT 10;

-- Best value locations -- high rating low cost

SELECT location,
       ROUND(AVG(rating), 2) AS avg_rating,
       ROUND(AVG(cost), 2) AS avg_cost,
       COUNT(*) AS total_restaurants
FROM zomato
WHERE cost IS NOT NULL
AND rating IS NOT NULL
GROUP BY location
HAVING AVG(rating) > 3.7
AND AVG(cost) < 700
ORDER BY avg_rating DESC
LIMIT 10;

-- Top 10 most popular cuisines by total votes

SELECT cuisines,
       SUM(votes) AS total_votes,
       COUNT(*) AS total_restaurants,
       ROUND(AVG(rating), 2) AS avg_rating
FROM zomato
WHERE votes IS NOT NULL
GROUP BY cuisines
ORDER BY total_votes DESC
LIMIT 10;

-- Cuisines with high rating but very few restaurants (supply gap)

SELECT cuisines,
       COUNT(*) AS total_restaurants,
       ROUND(AVG(rating), 2) AS avg_rating,
       SUM(votes) AS total_votes
FROM zomato
WHERE rating IS NOT NULL
GROUP BY cuisines
HAVING COUNT(*) < 50
AND AVG(rating) > 4.0
ORDER BY avg_rating DESC, total_votes DESC
LIMIT 10;

-- North Indian vs South Indian vs Chinese -- which dominates most locations?

SELECT location,
       SUM(CASE WHEN cuisines LIKE '%North Indian%' THEN 1 ELSE 0 END) AS north_indian,
       SUM(CASE WHEN cuisines LIKE '%South Indian%' THEN 1 ELSE 0 END) AS south_indian,
       SUM(CASE WHEN cuisines LIKE '%Chinese%' THEN 1 ELSE 0 END) AS chinese
FROM zomato
GROUP BY location
ORDER BY north_indian DESC
LIMIT 10;

-- Segment every restaurant into Star, Underdog, Overhyped, Avoid

SELECT 
    CASE
        WHEN rating >= 4.0 AND votes >= 500 THEN 'Star'
        WHEN rating >= 4.0 AND votes < 500 THEN 'Underdog'
        WHEN rating < 4.0 AND votes >= 500 THEN 'Overhyped'
        WHEN rating < 4.0 AND votes < 500 THEN 'Avoid'
    END AS restaurant_segment,
    COUNT(*) AS total_restaurants
FROM zomato
WHERE rating IS NOT NULL
AND votes IS NOT NULL
GROUP BY 1
ORDER BY 2 DESC;

-- Rank restaurants within each cuisine by rating

SELECT name,
       cuisines,
       location,
       rating,
       RANK() OVER(PARTITION BY cuisines ORDER BY rating DESC) AS rank_in_cuisine
FROM zomato
WHERE rating IS NOT NULL
ORDER BY cuisines, rank_in_cuisine
LIMIT 20;

-- Find #1 cuisine per location using CTE + Window Function

WITH cuisine_counts AS (
    SELECT location,
           cuisines,
           COUNT(*) AS total_restaurants,
           RANK() OVER(PARTITION BY location ORDER BY COUNT(*) DESC) AS cuisine_rank
    FROM zomato
    GROUP BY location, cuisines
)
SELECT location,
       cuisines AS top_cuisine,
       total_restaurants
FROM cuisine_counts
WHERE cuisine_rank = 1
ORDER BY total_restaurants DESC
LIMIT 10;

-- Restaurants above both location avg rating AND location avg votes

SELECT name,
       location,
       rating,
       votes,
       location_avg_rating,
       location_avg_votes
FROM (
    SELECT name,
           location,
           rating,
           votes,
           ROUND(AVG(rating) OVER(PARTITION BY location), 2) AS location_avg_rating,
           ROUND(AVG(votes) OVER(PARTITION BY location), 2) AS location_avg_votes
    FROM zomato
    WHERE rating IS NOT NULL
    AND votes IS NOT NULL
) AS location_stats
WHERE rating > location_avg_rating
AND votes > location_avg_votes
ORDER BY location, rating DESC
LIMIT 20;
