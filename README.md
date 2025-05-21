# Movie Data Analysis

## Introduction

Hello everybody the following is a project to practice even more on my data analysis skills. Unlike my previous project on used car data this one is based on movie data FROM 1980 through 1991. In this project I wanted to learn more complex sql problems and wanted to include the use of ctes in some solutions. Below I  provided the data and what it includes

## Data

The data was retrieved FROM kaggle and includes the following variables:

Query:

![Data](<README images/movie data.JPG>)

You can acess the data page from kaggle using the following link - 
[Movie Data](https://www.kaggle.com/datasets/danielgrijalvas/movies/data)

## SQL

1. Which film has the highest score with more than 300,000 votes between the year 1985 - 1990

- First thing I decided to do is determine the variables I needed. So I needed the year, name, company, score, and votes.
- I decided to include company so tha the stakeholder has more context about the film other than the name.
- From here we seperated the movies to show only those with 300,000 votes or above
- We also made sure to that the year was between the year 1985 - 1990
- Lastly we ordered it by score and descending in order to display the highest score film at the top.

Query:

````sql
SELECT year, name, company, Score, votes
FROM movie_project.data
WHERE votes > 300000
HAVING year > 1985 AND year < 1990
ORDER BY score DESC;
````

Result:

![Result1](<README images/Result_1.JPG>)

From the result above we can determine that the highest scored film with more than 300,000 votes was tied bewtween 2 movies Aliens and Full Metal Jacket with a score of 8.3. In second ther is a three way tie with Die Hard, My Neighbor Totoro, and Indiana Jone and the Last Crusade with a score of 8.2.

***

2. List all companies that have produced more than 10 movies and have an average gross over $50 million.

- First we need to retrieve the company, the count of films, and the profit average of the studio.
- We group it by data so that it knows to count the number of films by studio.
- We now make it where the number of movies is greeater than 10 and the profit is more than $50 Million
- I decided to order it by profit to show the most profitable studio with more than 10 films

Query:

````sql
SELECT company, COUNT(name) AS number_movies, AVG(gross - budget) AS profit
FROM movie_project.data
GROUP BY company
HAVING number_movies > 10 AND profit > 50000000
ORDER BY profit DESC;
````

Result:

![Result1](<README images/Result_2.JPG>)

From the result above I can determine that the most profitbale stuido with more than 10 movies is Touchstone Picturesw with 25 movies and a profit of $73,101,036.48. In second is Paramount pictures with 80 films and a profit of $66,752,109.61

***

3. Which film is profitble and has a score less than 5

- First we need to retrive the name, score, gross, budget, and profit by subtracting the gross by the budget.
- we than filter it to only schow films with a score less than 5
- we than order it by profit and descending so that we get the most profitable movie on top

Query:

```sql
SELECT name, score, gross, budget, (gross - budget) AS profit
FROM movie_project.data
WHERE score < 5
ORDER BY profit DESC;
```

Result:

![Result1](<README images/Result_3.JPG>)

From the results above I can determine that Jaws 3-D was the highest profitable movie with $67,487,055 and a score of 3.7. Behind Jaws 3-D is a film Staying Alive with a profit of $42,892,670 and a score of 4.7. I wanted to find these films because there are always those films that are rated low but are profitble becuase of its important name, or funny story that gravitates people to watch it no matter the score.

***

4. Which country has the highest profitable film from a country other than the United States

- First we need to retrieve the country, name, company, gross, budget, and the profit.
- We then filter out all the countrys that are not the United States
- We then order it by profit descending to get the highes profitable movie at the top
- We then limit it to 1.

Query:

```sql
SELECT country, name, company,  gross, budget, (gross - budget) AS profit
FROM movie_project.data
WHERE country != 'United States'
ORDER BY profit DESC
LIMIT 1;
```

Result:

![Result1](<README images/Result_4.JPG>)

From the results above we can determine that the most profitable movie not from the United States is the movie Corcodile Dundee from Australia with a profit of $319,403,506

***

5. What is the least profitable R rated movie from the United States

```sql
SELECT name, rating, country, company, gross, budget, (gross - budget) AS profit
FROM movie_project.data
WHERE rating = 'R' AND country = 'United States'
ORDER BY profit ASC
LIMIT 1;
```

(ANSWER)

***

6. The top 20 studio with their highest profit movie

```sql
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
```

(ANSWER)

***

7. Find all movies where the budget was higher than the average budget for their genre.

```sql
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
```

(ANSWER)

***

8. List movies that had a lower score than the average score of other movies released in the same year, but received more than 100,000 votes.

```sql
WITH test AS (
	SELECT year, avg(score) AS avg_score
    FROM movie_project.data
	GROUP BY year
)

SELECT d.name, d.year, d.votes, d.score, t.avg_score
FROM movie_project.data  AS d
join test AS t
	ON d.year = t.year
WHERE d.score < t.avg_score AND d.votes > 100000;
```

(ANSWER)

***

9. Highest Profitable Movie from each month

```sql
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
		END AS month,
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
```

(ANSWER)

***

10. Most profitable movie depending ON region where movie is from

```sql
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
join region_max_profit AS rmp
	ON rp.region = rmp.region AND rp.profit = rmp.max_profit
ORDER BY profit DESC;
```

(ANSWER)

## Conclusion