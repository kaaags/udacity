--4. Video + Quiz: Write Your First Subquery %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*
1. Use the test environment below to find the number of events that occur for each day for each channel.
*/

SELECT  DATE_TRUNC('day', w.occurred_at) AS day,
        w.channel,
        COUNT(*) daily_events
    FROM  web_events w
  GROUP BY  1, 2
  ORDER BY  3 DESC;

/*
2. Now create a subquery that simply provides all of the data from your first query.
*/

SELECT  *
    FROM
      (SELECT DATE_TRUNC('day', w.occurred_at) AS day,
              w.channel,
              COUNT(*)  AS daily_events
          FROM  web_events w
        GROUP BY  1, 2
        ) sub
  ORDER BY  3 DESC;

/*
3. Now find the average number of events for each channel. Since you broke out by day earlier, this is giving you an average per day.
*/

SELECT  channel,
        AVG(daily_events) AS avg_daily_event_count
    FROM  (SELECT DATE_TRUNC('day', occurred_at) AS day,
                  channel,
                  COUNT(*) AS daily_events
              FROM  web_events
            GROUP BY  1, 2
            ) sub
  GROUP BY  1
  ORDER BY  1;

--7. Quiz: More on Subqueries %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*
1. Use DATE_TRUNC to pull month level information about the first order ever placed in the orders table.
*/

SELECT  *
  FROM  orders
  WHERE DATE_TRUNC('month',occurred_at) =
  (SELECT  DATE_TRUNC('month',MIN(occurred_at)) AS min
    FROM  orders
  )
  ORDER BY  occurred_at
  LIMIT 1;

/*
2. Use the result of the previous query to find only the orders that took place in the same month and year as the first order, and then pull the average for each type of paper qty in this month.
*/

SELECT  AVG(standard_qty) AS monthly_avg_standard,
        AVG(gloss_qty) AS monthly_avg_glossy,
        AVG(poster_qty) AS monthly_avg_poster,
        SUM(total_amt_usd) AS sum_total_amt_usd
  FROM  orders
  WHERE DATE_TRUNC('month',occurred_at) =
  (SELECT  DATE_TRUNC('month',MIN(occurred_at)) AS min
    FROM  orders
  );

--10. Quiz: Subquery Mania %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*
1. Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.
*/

SELECT t3.region,
       t3.sales_rep,
       t3.total_sales
FROM  (SELECT t1.region,
              MAX(total_sales) total_sales
      FROM (SELECT r.name region,
                   sr.name sales_rep,
                   SUM(o.total_amt_usd) total_sales
            FROM region r
            JOIN sales_reps sr
            ON r.id = sr.region_id
            JOIN accounts a
            ON sr.id = a.sales_rep_id
            JOIN orders o
            ON a.id = o.account_id
            GROUP BY 1,2) t1
      GROUP BY 1) t2
JOIN  (SELECT r.name region,
              sr.name sales_rep,
              SUM(o.total_amt_usd) total_sales
      FROM region r
      JOIN sales_reps sr
      ON r.id = sr.region_id
      JOIN accounts a
      ON sr.id = a.sales_rep_id
      JOIN orders o
      ON a.id = o.account_id
      GROUP BY 1,2
      ORDER BY 3 DESC) t3
ON t3.region = t3.region AND t3.total_sales = t2.total_sales;

/*
2. For the region with the largest (sum) of sales total_amt_usd, how many total (count) orders were placed?
*/

SELECT  r.name region_name,
        SUM(o.total_amt_usd) sum_sales,
        COUNT(o.total) total_orders
  FROM region r
  JOIN sales_reps sr
  ON r.id = sr.region_id
  JOIN accounts a
  ON sr.id = a.sales_rep_id
  JOIN orders o
  ON a.id = o.account_id
  GROUP BY 1
  ORDER BY 2 DESC
  LIMIT 1;

--OR

SELECT  r.name,
        COUNT(o.total) total_orders
  FROM region r
  JOIN sales_reps sr
  ON r.id = region_id
  JOIN accounts a
  ON sr.id = a.sales_rep_id
  JOIN orders o
  ON a.id = o.account_id
  GROUP BY 1
  HAVING SUM(o.total_amt_usd) = (
    SELECT MAX(total_amt)
      FROM (SELECT  r.name region_name,
                    SUM(o.total_amt_usd) total_amt
            FROM region r
            JOIN sales_reps sr
            ON r.id = region_id
            JOIN accounts a
            ON sr.id = a.sales_rep_id
            JOIN orders o
            ON a.id = o.account_id
            GROUP BY 1) sub);

/*
3. For the name of the account that purchased the most (in total over their lifetime as a customer) standard_qty paper, how many accounts still had more in total purchases?
*/

SELECT COUNT(*) count
  FROM (SELECT a.name
        FROM accounts a
        JOIN orders o
        ON a.id = o.account_id
        GROUP BY 1
        HAVING SUM(o.total) >
          (SELECT total
            FROM (SELECT a.name account_name, SUM(o.standard_qty) total_standard, SUM(o.total) total
                  FROM accounts a
                  JOIN orders o
                  ON a.id = o.account_id
                  GROUP BY 1
                  ORDER BY 2 DESC
                  LIMIT 1) inner_tab)
        ) counter_tab;

/*
4. For the customer that spent the most (in total over their lifetime as a customer) total_amt_usd, how many web_events did they have for each channel?
*/

SELECT a.name, we.channel, COUNT(*)
  FROM accounts a
  JOIN web_events we
  ON a.id = we.account_id
  AND a.id = (SELECT id
              FROM (SELECT a.id, SUM(o.total_amt_usd) tot_spent
                    FROM orders o
                    JOIN accounts a
                    ON o.account_id = a.id
                    GROUP BY 1
                    ORDER BY 2 DESC
                    LIMIT 1) t1)
  GROUP BY 1, 2
  ORDER BY 3 DESC;

/*
5. What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total spending accounts?
*/

SELECT AVG(total_spend) average_spend
  FROM (SELECT a.id, a.name, SUM(o.total_amt_usd) total_spend
          FROM accounts a
          JOIN orders o
          ON a.id = o.account_id
          GROUP BY 1, 2
          ORDER BY 3 DESC
          LIMIT 10) t1;

/*
6. What is the lifetime average amount spent in terms of total_amt_usd for only the companies that spent more than the average of all orders.
*/

SELECT AVG(avg_amount)
  FROM (SELECT o.account_id, AVG(o.total_amt_usd) avg_amount
        FROM orders o
        GROUP BY 1
        HAVING AVG(o.total_amt_usd) > (SELECT AVG(o.total_amt_usd)
                                        FROM accounts a
                                        JOIN orders o
                                        ON a.id = o.account_id)) t1;

--14. Quiz: WITH %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*
1. Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.
*/

WITH  t1 AS (
  SELECT sr.name sales_rep_name, r.name region_name, SUM(o.total_amt_usd) total_sales
    FROM sales_reps sr
    JOIN region r
    ON sr.region_id = r.id
    JOIN accounts a
    ON sr.id = a.sales_rep_id
    JOIN orders o
    ON a.id = o.account_id
    GROUP BY 1, 2
    ORDER BY 3 DESC),
  t2 AS (
    SELECT region_name, MAX(total_sales) total_sales
      FROM t1
      GROUP BY 1)
SELECT t1.sales_rep_name, t1.region_name, t1.total_sales
  FROM t1
  JOIN t2
  ON t1.region_name = t2.region_name
    AND t1.total_sales = t2.total_sales;

/*
2. For the region with the largest sales total_amt_usd, how many total orders were placed?
*/

WITH t1 AS (
  SELECT r.name region_name, SUM(o.total_amt_usd) tot_sales
    FROM region r
    JOIN sales_reps sr
    ON r.id = sr.region_id
    JOIN accounts a
    ON sr.id = a.sales_rep_id
    JOIN orders o
    ON a.id = o.account_id
    GROUP BY 1),
  t2 AS (
    SELECT MAX(tot_sales)
      FROM t1)
SELECT r.name region_name, COUNT(o.total) tot_orders
  FROM region r
  JOIN sales_reps sr
  ON r.id = sr.region_id
  JOIN accounts a
  ON sr.id = a.sales_rep_id
  JOIN orders o
  ON a.id = o.account_id
  GROUP BY 1
  HAVING SUM(o.total_amt_usd) = (SELECT * FROM t2);

/*
3. For the name of the account that purchased the most (in total over their lifetime as a customer) standard_qty paper, how many accounts still had more in total purchases?
*/

WITH t1 AS (
  SELECT a.name account_name, SUM(o.standard_qty) tot_std, SUM(o.total) tot
    FROM accounts a
    JOIN orders o
    ON a.id = o.account_id
    GROUP BY 1
    ORDER BY 2 DESC
    LIMIT 1),
  t2 AS (
    SELECT a.name
      FROM orders o
      JOIN accounts a
      ON a.id = o.account_id
      GROUP BY 1
      HAVING SUM(o.total) > (SELECT tot FROM t1))
SELECT COUNT(*)
  FROM t2;

/*
4. For the customer that spent the most (in total over their lifetime as a customer) total_amt_usd, how many web_events did they have for each channel?
*/

WITH t1 AS (
  SELECT a.id account_id, a.name account_name, SUM(o.total_amt_usd) tot_sales
    FROM accounts a
    JOIN orders o
    ON a.id = o.account_id
    GROUP BY 1, 2
    ORDER BY 2 DESC
    LIMIT 1)
SELECT a.name account_name, we.channel, COUNT(we.id) total_web_events
  FROM accounts a
  JOIN orders o
  ON a.id = o.account_id
  JOIN web_events we
  ON a.id = we.account_id
    AND a.id = (SELECT account_id FROM t1)
  GROUP BY 1, 2
  ORDER BY 3 DESC;

/*
5. What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total spending accounts?
*/

WITH t1 AS (
  SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
    FROM accounts a
    JOIN orders o
    ON a.id = o.account_id
    GROUP BY 1, 2
    ORDER BY 3 DESC
    LIMIT 10)
SELECT AVG(total_spent) avg_spent
  FROM t1;

/*
6. What is the lifetime average amount spent in terms of total_amt_usd for only the companies that spent more than the average of all accounts.
*/

/*
my initial wrong answer follows:

WITH t1 AS (
  SELECT a.id account_id, a.name account_name, SUM(o.total_amt_usd) total_spent
    FROM accounts a
    JOIN orders o
    ON a.id = o.account_id
    GROUP BY 1, 2),
  t2 AS (
    SELECT AVG(total_spent) total_avg_spent
      FROM t1),
  t3 AS (
    SELECT a.id account_id, a.name account_name, SUM(o.total_amt_usd) total_spent
      FROM t1
      JOIN t2
      GROUP BY 1, 2
      HAVING SUM(o.total_amt_usd) > (SELECT total_avg_spent FROM t2))
SELECT a.id account_id, a.name account_name, AVG(total_spent) above_avg_spent
  FROM accounts a
  JOIN orders o
  ON a.id = o.account_id
    AND t1.total_spent = t3.total_spent
  GROUP BY 1, 2
  ORDER BY 1;
*/

WITH t1 AS (
  SELECT AVG (o.total_amt_usd) avg_all
    FROM orders o
    JOIN accounts a
    ON a.id = o.account_id),
  t2 AS (
    SELECT o.account_id, AVG(o.total_amt_usd) avg_amt
      FROM orders o
      GROUP BY 1
      HAVING AVG(o.total_amt_usd) > (SELECT * FROM t1))
SELECT AVG(avg_amt)
  FROM t2;
