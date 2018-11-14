--7. Quiz: SUM %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*
1. Find the total amount of poster_qty paper ordered in the orders table.
*/

SELECT  SUM(o.poster_qty) AS poster_total
    FROM  orders o;

/*
2. Find the total amount of standard_qty paper ordered in the orders table.
*/

SELECT  SUM(o.standard_qty) AS standard_total
    FROM  orders o;

/*
3. Find the total dollar amount of sales using the total_amt_usd in the orders table.
*/

SELECT  SUM(o.total_amt_usd) AS grand_total_amt_usd
    FROM  orders o;

/*
4. Find the total amount spent on standard_amt_usd and gloss_amt_usd paper for each order in the orders table. This should give a dollar amount for each order in the table.
*/

SELECT  o.id,
        o.standard_amt_usd + o.gloss_amt_usd AS standard_and_gloss_total_amt_usd
    FROM  orders o;

/*
5. Find the standard_amt_usd per unit of standard_qty paper. Your solution should use both an aggregation and a mathematical operator.
*/

SELECT  SUM(o.standard_amt_usd) / SUM(o.standard_qty) AS standard_amt_usd_per_unit
    FROM  orders o;

--11. Quiz: MIN, MAX, & AVG %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*
1. When was the earliest order ever placed? You only need to return the date.
*/

SELECT  MIN(o.occurred_at) AS earliest_order
    FROM  orders o;

/*
2. Try performing the same query as in question 1 without using an aggregation function.
*/

SELECT o.occurred_at AS earliest_order
    FROM  orders o
  ORDER BY  o.occurred_at
  LIMIT 1;

/*
3. When did the most recent (latest) web_event occur?
*/

SELECT  MAX(w.occurred_at) AS most_recent_web_event
    FROM  web_events w;

/*
4. Try to perform the result of the previous query without using an aggregation function.
*/

SELECT  w.occurred_at AS most_recent_web_event
    FROM  web_events w
  ORDER BY w.occurred_at DESC
  LIMIT 1;

/*
5. Find the mean (AVERAGE) amount spent per order on each paper type, as well as the mean amount of each paper type purchased per order. Your final answer should have 6 values - one for each paper type for the average number of sales, as well as the average amount.
*/

SELECT  AVG(o.standard_amt_usd) AS mean_standard_amt_usd,
        AVG(o.gloss_amt_usd) AS mean_gloss_amt_usd,
        AVG(o.poster_amt_usd) AS mean_poster_amt_usd,
        AVG(o.standard_qty) AS mean_standard_qty,
        AVG(o.gloss_qty) AS mean_gloss_qty,
        AVG(o.poster_qty) AS mean_poster_qty
    FROM  orders o;

/*
6. Via the video, you might be interested in how to calculate the MEDIAN. Though this is more advanced than what we have covered so far try finding - what is the MEDIAN total_usd spent on all orders?
*/

--1st figure out if the count is even or odd
SELECT COUNT(o.total_amt_usd) AS count
    FROM orders o;

--2nd must find the 3456th and 3457th values and divide them together
SELECT  *
    FROM  ( SELECT o.total_amt_usd
                FROM  orders o
              ORDER BY  total_amt_usd
              LIMIT 3457) AS Table1
  ORDER BY total_amt_usd DESC
  LIMIT 2;
--3rd divide the numbers to find the median
SELECT  (2483.16 + 2482.55) / 2 AS median_total_amt_usd;

--If an odd count, find the median_o
SELECT  CEILING(COUNT(o.total_amt_usd) / 2) AS median_count
    FROM  orders o;

--2nd use the median_count as the OFFSET value
SELECT  o.total_amt_usd AS median_total_amt_usd
    FROM  orders o
  ORDER BY  o.total_amt_usd
  LIMIT 1 OFFSET 3456;

--14. Quiz: GROUP BY %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*
1. Which account (by name) placed the earliest order? Your solution should have the account name and the date of the order.
*/

SELECT  a.name,
        o.occurred_at
    FROM  accounts a
      JOIN  orders o
        ON  a.id = o.account_id
  ORDER BY  occurred_at
  LIMIT 1;

/*
2. Find the total sales in usd for each account. You should include two columns - the total sales for each company's orders in usd and the company name.
*/

SELECT  a.name,
        SUM(o.total_amt_usd) total_sales
    FROM  accounts a
      JOIN  orders o
        ON  a.id = o.account_id
  GROUP BY  a.name
  ORDER BY  a.name;

/*
3. Via what channel did the most recent (latest) web_event occur, which account was associated with this web_event? Your query should return only three values - the date, channel, and account name.
*/

SELECT  w.occurred_at,
        w.channel,
        a.name
    FROM  web_events w
      JOIN  accounts a
        ON  w.account_id = a.id
  ORDER BY  occurred_at DESC
  LIMIT 1;

/*
4. Find the total number of times each type of channel from the web_events was used. Your final table should have two columns - the channel and the number of times the channel was used.
*/

SELECT  w.channel,
        COUNT(*)
    FROM  web_events w
  GROUP BY  w.channel
  ORDER BY  w.channel;

/*
5. Who was the primary contact associated with the earliest web_event?
*/

SELECT  a.primary_poc
    FROM  accounts a
      JOIN  web_events w
        ON  a.id = w.account_id
  ORDER BY w.occurred_at
  LIMIT 1;

/*
6. What was the smallest order placed by each account in terms of total usd. Provide only two columns - the account name and the total usd. Order from smallest dollar amounts to largest.
*/

SELECT  a.name,
        MIN(o.total_amt_usd) AS smallest_order
    FROM  accounts a
      JOIN  orders o
        ON  a.id = o.account_id
  GROUP BY  a.name
  ORDER BY  smallest_order;

/*
7. Find the number of sales reps in each region. Your final table should have two columns - the region and the number of sales_reps. Order from fewest reps to most reps.
*/

SELECT  r.name,
        COUNT(s.name) AS num_reps
    FROM  region r
      JOIN  sales_reps s
        ON  r.id = s.region_id
  GROUP BY  r.name
  ORDER BY  sales_reps;

--17. Quiz: GROUP BY Part II %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*
1. For each account, determine the average amount of each type of paper they purchased across their orders. Your result should have four columns - one for the account name and one for the average quantity purchased for each of the paper types for each account.
*/

SELECT  a.name,
        AVG(o.standard_qty) average_standard,
        AVG(o.poster_qty) average_poster,
        AVG(o.gloss_qty) average_glossy
    FROM  accounts a
      JOIN  orders o
        ON  a.id = o.account_id
  GROUP BY a.name;

/*
2. For each account, determine the average amount spent per order on each paper type. Your result should have four columns - one for the account name and one for the average amount spent on each paper type.
*/

SELECT  a.name,
        AVG(o.standard_amt_usd) average_standard,
        AVG(o.gloss_amt_usd) average_glossy,
        AVG(o.poster_amt_usd) average_poster
    FROM  accounts a
      JOIN  orders o
        ON  a.id = o.account_id
  GROUP BY  a.name;

/*
3. Determine the number of times a particular channel was used in the web_events table for each sales rep. Your final table should have three columns - the name of the sales rep, the channel, and the number of occurrences. Order your table with the highest number of occurrences first.
*/

SELECT  s.name,
        w.channel,
        COUNT(w.channel) AS channel_occurrences
    FROM  sales_reps s
      JOIN  accounts a
        ON  s.id = a.sales_rep_id
      JOIN  web_events w
        ON  a.id = w.account_id
  GROUP BY  s.name, w.channel
  ORDER BY  channel_occurrences DESC;

/*
4. Determine the number of times a particular channel was used in the web_events table for each region. Your final table should have three columns - the region name, the channel, and the number of occurrences. Order your table with the highest number of occurrences first.
*/

SELECT  r.name,
        w.channel,
        COUNT(w.channel) AS channel_occurrences
    FROM  region r
      JOIN  sales_reps s
        ON  r.id = s.region_id
      JOIN  accounts a
        ON  s.id = a.sales_rep_id
      JOIN  web_events w
        ON  a.id = w.account_id
  GROUP BY  r.name,
            w.channel
  ORDER BY  channel_occurrences DESC;

--20. Quiz: DISTINCT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*
1. Use DISTINCT to test if there are any accounts associated with more than one region.
*/

SELECT  a.id AS "account id",
        r.id AS "region id",
        a.name AS "account name",
        r.name AS "region name"
    FROM  accounts a
      JOIN  sales_reps s
        ON  a.sales_rep_id = s.id
      JOIN  region r
        ON  s.region_id = r.id;

SELECT  DISTINCT  id,
                  name
    FROM  accounts;

/*
2. Have any sales reps worked on more than one account?
*/

SELECT  s.id AS "sales rep id",
        s.name AS "sales rep name",
        COUNT(*) AS num_accounts
    FROM sales_reps s
      JOIN  accounts a
        ON  s.id = sales_rep_id
  GROUP BY  s.id,
            s.name
  ORDER BY  num_accounts;

SELECT  DISTINCT  id,
                  name
    FROM  sales_reps;

--23. Quiz: HAVING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*
1. How many of the sales reps have more than 5 accounts that they manage?
*/

SELECT  s.id,
        s.name,
        COUNT(*) num_accounts
    FROM  accounts a
      JOIN  sales_reps s
        ON  s.id = a.sales_rep_id
  GROUP BY  s.id,
            s.name
  HAVING  COUNT(*) > 5
  ORDER BY num_accounts;

--or

SELECT  COUNT(*) num_reps_above5
    FROM( SELECT  s.id,
                  s.name,
                  COUNT(*) num_accounts
              FROM  accounts a
                JOIN  sales_reps s
                  ON  s.id = a.sales_rep_id
            GROUP BY  s.id,
                      s.name
            HAVING  COUNT(*) > 5
            ORDER BY  num_accounts) AS Table1;

/*
2. How many accounts have more than 20 orders?
*/

SELECT  COUNT(*) num_accounts_above20
    FROM( SELECT  a.id,
                  a.name,
                  COUNT(*) num_orders
              FROM  accounts a
                JOIN  orders o
                  ON  a.id = account_id
            GROUP BY  a.id,
                      a.name
            HAVING  COUNT(*) > 20
            ORDER BY  num_orders) AS Table1;

/*
3. Which account has the most orders?
*/

SELECT  a.id,
        a.name,
        COUNT(*)  num_orders
    FROM  orders o
      JOIN  accounts a
        ON  o.account_id = a.id
  GROUP BY  a.id, a.name
  ORDER BY  num_orders DESC
  LIMIT 1;

/*
4. How many accounts spent more than 30,000 usd total across all orders?
*/

SELECT  COUNT(*)  num_accounts_above30k_usd
    FROM( SELECT  a.id,
                  a.name,
                  COUNT(*) total_spent
              FROM  accounts a
                JOIN  orders o
                  ON  a.id = o.account_id
            GROUP BY  a.id,
                      a.name
            HAVING  SUM(o.total_amt_usd) > 30000
            ORDER BY total_spent) AS Table1;

/*
5. How many accounts spent less than 1,000 usd total across all orders?
*/

SELECT  COUNT(*)  num_accounts_below1k_usd
    FROM( SELECT  a.id,
                  a.name,
                  COUNT(*) total_spent
              FROM  accounts a
                JOIN  orders o
                  ON  a.id = o.account_id
            GROUP BY  a.id,
                      a.name
            HAVING  SUM(o.total_amt_usd) < 1000
            ORDER BY  total_spent) AS Table1;

/*
6. Which account has spent the most with us?
*/

SELECT  a.id,
        a.name,
        SUM(o.total_amt_usd) total_spent
    FROM  orders o
      JOIN  accounts a
        ON  a.id = o.account_id
  GROUP BY  a.id,
            a.name
  ORDER BY  total_spent DESC
  LIMIT 1;

/*
7. Which account has spent the least with us?
*/

SELECT  a.id,
        a.name,
        SUM(o.total_amt_usd) amt_spent
    FROM  accounts a
      JOIN  orders o
        ON  o.account_id = a.id
  GROUP BY  a.id,
            a.name
  ORDER BY  amt_spent
  LIMIT 1;

/*
8. Which accounts used facebook as a channel to contact customers more than 6 times?
*/

SELECT  a.id,
        a.name,
        w.channel,
        COUNT(*) use_of_channel
    FROM  accounts a
      JOIN  web_events w
        ON  a.id = w.account_id
  GROUP BY  a.id,
            a.name,
            w.channel
  HAVING  COUNT(*) > 6
    AND   w.channel = 'facebook'
  ORDER BY  use_of_channel;

/*
9. Which account used facebook most as a channel?
*/

SELECT  a.id,
        a.name,
        COUNT(*) use_of_facebook
    FROM  accounts a
      JOIN  web_events w
        ON  a.id = w.account_id
  GROUP BY  a.id,
            a.name,
            w.channel
  HAVING    w.channel = 'facebook'
  ORDER BY  use_of_facebook DESC
  LIMIT 1;

/*
10. Which channel was most frequently used by most accounts?
*/

SELECT  w.channel,
        COUNT(*) use_by_accounts
    FROM  web_events w
      JOIN  accounts a
        ON  a.id = w.account_id
  GROUP BY  w.channel,
            a.id,
            a.name
  ORDER BY  use_by_accounts DESC
  LIMIT 1;

--27. Quiz: DATE Functions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*
1. Find the sales in terms of total dollars for all orders in each year, ordered from greatest to least. Do you notice any trends in the yearly sales totals?
*/

SELECT  DATE_TRUNC('year', o.occurred_at) AS year,
        SUM(total_amt_usd) AS yearly_total
    FROM  orders o
  GROUP BY  DATE_TRUNC('year', o.occurred_at)
  ORDER BY  yearly_total DESC;

/*
Yes. Aside from they year 2017, sales have increased year over year. If sales figures for 2017 are incomplete, 2017 may continue the trend and eclipse 2016's sales figures.
*/

/*
2. Which month did Parch & Posey have the greatest sales in terms of total dollars? Are all months evenly represented by the dataset?
*/

SELECT  DATE_PART('month', o.occurred_at) AS month,
        SUM(o.total_amt_usd) AS monthly_total
    FROM  orders o
  GROUP BY  DATE_PART('month', o.occurred_at)
  ORDER BY  monthly_total DESC;

/*
December has significantly greater sales than the rest of the year. However, the first and last years in the database are incomplete; resulting in incomplete representation of the months.

/*
3. Which year did Parch & Posey have the greatest sales in terms of total number of orders? Are all years evenly represented by the dataset?
*/

SELECT  DATE_TRUNC('year', o.occurred_at) ord_year,
        COUNT(*) total_orders
    FROM  orders o
  GROUP BY  1
  ORDER BY  2 DESC;

/*
2016 was the year with the greatest total number of orders. No, all years were not evenly represented.
*/

/*
4. Which month did Parch & Posey have the greatest sales in terms of total number of orders? Are all months evenly represented by the dataset?
*/

SELECT  DATE_PART('month', o.occurred_at) ord_month,
        COUNT(*) total_orders
    FROM  orders o
  GROUP BY  1
  ORDER BY  2 DESC;

/*
December was again the month with the greatest number; this time of orders. No, all months were not equally represented by the dataset.
*/

/*
5. In which month of which year did Walmart spend the most on gloss paper in terms of dollars?
*/

SELECT  DATE_TRUNC('month', o.occurred_at) ord_date,
        SUM(o.gloss_amt_usd) month_gloss_amt_usd
    FROM  orders o
      JOIN  accounts a
        ON  o.account_id = a.id
  GROUP BY  1,
            a.name
  HAVING  a.name IN('Walmart')
  ORDER BY 2 DESC
  LIMIT 1;

--31. Quiz: CASE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*
1. Write a query to display for each order, the account ID, total amount of the order, and the level of the order - ‘Large’ or ’Small’ - depending on if the order is $3000 or more, or smaller than $3000.
*/

SELECT  o.account_id,
        o.total,
        CASE WHEN o.total_amt_usd >= 3000
            THEN  'Large'
          ELSE  'Small'
          END AS order_level
    FROM  orders o;

/*
2. Write a query to display the number of orders in each of three categories, based on the 'total' amount of each order. The three categories are: 'At Least 2000', 'Between 1000 and 2000' and 'Less than 1000'.
*/

SELECT  CASE
          WHEN o.total >= 2000
            THEN  'At Least 2000'
          WHEN  o.total >= 1000
            AND o.total < 2000
            THEN  'Between 1000 and 2000'
          ELSE  'Less than 1000'
          END AS  order_category,
        COUNT(*) AS num_orders
    FROM  orders o
    GROUP BY 1;

/*
3. We would like to understand 3 different levels of customers based on the amount associated with their purchases. The top level includes anyone with a Lifetime Value (total sales of all orders) greater than 200,000 usd. The second level is between 200,000 and 100,000 usd. The lowest level is anyone under 100,000 usd. Provide a table that includes the level associated with each account. You should provide the account name, the total sales of all orders for the customer, and the level. Order with the top spending customers listed first.
*/



/*
4. We would now like to perform a similar calculation to the first, but we want to obtain the total amount spent by customers only in 2016 and 2017. Keep the same levels as in the previous question. Order with the top spending customers listed first.
*/



/*
5. We would like to identify top performing sales reps, which are sales reps associated with more than 200 orders. Create a table with the sales rep name, the total number of orders, and a column with top or not depending on if they have more than 200 orders. Place the top sales people first in your final table.
*/



/*
6. The previous didn't account for the middle, nor the dollar amount associated with the sales. Management decides they want to see these characteristics represented as well. We would like to identify top performing sales reps, which are sales reps associated with more than 200 orders or more than 750000 in total sales. The middle group has any rep with more than 150 orders or 500000 in sales. Create a table with the sales rep name, the total number of orders, total sales across all orders, and a column with top, middle, or low depending on this criteria. Place the top sales people based on dollar amount of sales first in your final table. You might see a few upset sales people by this criteria!
*/
