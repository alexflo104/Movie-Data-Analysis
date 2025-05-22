# 1. Which film has the highest score with more than 300,000 votes after the year 1985 - 1990
SELECT year, name, company, Score, votes
FROM movie_project.data
WHERE votes > 300000
HAVING year > 1985 AND year < 1990
ORDER BY score DESC;

# 2. List all companies that have produced more than 10 movies and have an average gross over $100 million.
SELECT company, COUNT(name) AS number_movies, AVG(gross - budget) AS profit
FROM movie_project.data
GROUP BY company
HAVING number_movies > 10 AND profit > 50000000
ORDER BY profit DESC;

# 3. Which film is profitble and has a score less than 5
SELECT name, score, gross, budget, (gross - budget) AS profit
FROM movie_project.data
WHERE score < 5
ORDER BY profit DESC;

# 4. Which country has the highest profitable film from a country other than the United States
SELECT country, name, company,  gross, budget, (gross - budget) AS profit
FROM movie_project.data
WHERE country != 'United States'
ORDER BY profit DESC
LIMIT 1;

# 5. What is the least profitable R rated movie from the United States
SELECT name, rating, country, company, gross, budget, (gross - budget) AS profit
FROM movie_project.data
WHERE rating = 'R' AND country = 'United States'
ORDER BY profit ASC
LIMIT 1;

# 6. The top 20 studio with their highest profit movie
WITH movie_profit AS (
	SELECT company, name, (gross - budget) AS profit
    FROM movie_project.data
),
	max_movie_profit AS (
		SELECT company, max(profit) AS max_profit
		FROM movie_profit
		GROUP BY company
	)

SELECT p.company, p.name, mp.max_profit
FROM movie_profit p
join max_movie_profit mp
	ON p.company = mp.company AND p.profit = mp.max_profit
ORDER BY profit DESC
LIMIT 20;

# 7. Find all movies where the budget was higher than the average budget for their genre.
WITH average_budget AS (
	SELECT genre, avg(budget) AS avg_budget
    FROM movie_project.data
    GROUP BY genre
)
SELECT d.genre, d.name, (d.gross - d.budget) AS budget, ab.avg_budget
FROM average_budget ab
join movie_project.data d
	ON ab.genre = d.genre
HAVING budget > ab.avg_budget;

# 8. List movies that had a lower score than the average score of other movies released in the same year, but received more than 100,000 votes.
WITH year_avg_score AS (
	SELECT year, avg(score) AS avg_score
    FROM movie_project.data
	GROUP BY year
)

SELECT d.name, d.year, d.votes, d.score, avs.avg_score
FROM movie_project.data  AS d
join year_avg_score AS avs
	ON d.year = avs.year
WHERE d.score < avs.avg_score AND d.votes > 100000;

# 9. Highest Profitable Movie from each month
WITH profit_month AS (
	SELECT 
	CASE
		WHEN released LIKE 'January%' THEN 'January'
        WHEN released LIKE 'February%' THEN 'February'
        WHEN released LIKE 'March%' THEN 'March'
        WHEN released LIKE 'April%' THEN 'April'
        WHEN released LIKE 'May%' THEN 'May'
        WHEN released LIKE 'June%' THEN 'June'
		WHEN released LIKE 'July%' THEN 'July'
        WHEN released LIKE 'August%' THEN 'August'
        WHEN released LIKE 'September%' THEN 'September'
        WHEN released LIKE 'October%' THEN 'October'
        WHEN released LIKE 'Novemeber%' THEN 'Novemeber'
        WHEN released LIKE 'December%' THEN 'December'
		End AS month,
        name,
        (gross - budget) AS profit
	FROM movie_project.data
),

month_max_profit AS (
	SELECT month, max(profit) AS max_profit
    FROM profit_month
    GROUP BY month
)

SELECT pm.month, mmp.max_profit, pm.name
FROM profit_month pm
join month_max_profit mmp
	ON pm.month = mmp.month AND pm.profit = mmp.max_profit
ORDER BY max_profit DESC;

# 10. Most profitable movie depending ON region where movie is from
WITH region_profit AS (
SELECT
	CASE 
	    WHEN country IN ('United States', 'Mexico', 'Canada') THEN 'North America'
        WHEN country IN ('United Kingdom', 'West Germany', 'Italy', 'Sweden', 'Spain', 'Switzerland', 'France', 'Yugoslavia', 'Ireland', 'Germany') THEN 'Europe'
        WHEN country IN ('South Korea', 'Hong Kong', 'Japan') THEN 'Asia'
        WHEN country IN ('New Zealand', 'Australia') THEN 'Oceania'
        ELSE 'Africa'
	END AS region,
    name,
    (gross - budget) AS profit
FROM movie_project.data
),

region_max_profit AS (
	SELECT region, max(profit) AS max_profit
    FROM region_profit
    GROUP BY region
)

SELECT rp.region, rp.profit, rp.name
FROM region_profit AS rp
JOIN region_max_profit AS rmp
	ON rp.region = rmp.region AND rp.profit = rmp.max_profit
ORDER BY profit DESC;