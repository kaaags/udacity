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
