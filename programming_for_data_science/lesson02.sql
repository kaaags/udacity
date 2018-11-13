--4. JOIN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*
1. Try it yourself below by writing a query that limits the response to only the first 15 rows and includes the occurred_at, account_id, and channel fields in the web_events table.
*/

SELECT orders.*
  FROM orders
  JOIN accounts
  ON orders.account_id = accounts.id;

/*
2.1. Try pulling all the data from the accounts table, and all the data from the orders table.
*/

SELECT orders.*, accounts.*
  FROM accounts
  JOIN orders
  ON accounts.id = orders.account_id;

/*
2.2. Try pulling standard_qty, gloss_qty, and poster_qty from the orders table, and the website and the primary_poc from the accounts table.
*/

SELECT orders.standard_qty, orders.gloss_qty, orders.poster_qty, accounts.website, accounts.primary_poc
  FROM orders
  JOIN accounts
  ON orders.account_id = accounts.id;

--9. Text + Quiz: JOIN Revisited %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*
1. Use the image above to assist you. If we wanted to join the sales_reps and region tables together, how would you do it?
*/

SELECT sales_reps.*, region.*
  FROM sales_reps
  JOIN region
  ON sales_reps.region_id = region.id;

--11. Quiz: JOIN Quesions Part I %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*
1. Provide a table for all web_events associated with account name of Walmart. There should be three columns. Be sure to include the primary_poc, time of the event, and the channel for each event. Additionally, you might choose to add a fourth column to assure only Walmart events were chosen.
*/

SELECT a.primary_poc, w.occurred_at, w.channel, a.name
  FROM web_events w
    JOIN accounts a
      ON w.account_id = a.id
    WHERE a.id = 1001;

/*
2. Provide a table that provides the region for each sales_rep along with their associated accounts. Your final table should include three columns: the region name, the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) according to account name.
*/

SELECT  r.name AS region_name,
        s.name AS sales_rep_name,
        a.name AS account_name
    FROM sales_reps s
      JOIN region r
        ON s.region_id = r.id
      JOIN accounts a
        ON s.id = a.sales_rep_id
  ORDER BY a.name;

/*
3. Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. Your final table should have 3 columns: region name, account name, and unit price. A few accounts have 0 for total, so I divided by (total + 0.01) to assure not dividing by zero.
*/

SELECT r.name AS region_name,
        a.name AS account_name,
        o.total_amt_usd / (o.total + 0.0001) AS unit_price
    FROM accounts AS a
      JOIN sales_reps s
        ON a.sales_rep_id = s.id
      JOIN region r
        ON s.region_id = r.id
      JOIN orders o
        ON a.id = o.account_id

--19. Quiz: Last Check %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*
1. Provide a table that provides the region for each sales_rep along with their associated accounts. This time only for the Midwest region. Your final table should include three columns: the region name, the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) according to account name.
*/

SELECT  r.name region_name,
        s.name sales_rep_name,
        a.name account_name
    FROM region r
      JOIN sales_reps s
        ON r.id = s.region_id
      JOIN accounts a
        ON s.id = a.sales_rep_id
  WHERE r.name = 'Midwest'
  ORDER BY a.name;

/*
2. Provide a table that provides the region for each sales_rep along with their associated accounts. This time only for accounts where the sales rep has a first name starting with S and in the Midwest region. Your final table should include three columns: the region name, the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) according to account name.
*/

SELECT  r.name region_name,
        s.name sales_rep_name,
        a.name account_name
    FROM region r
      JOIN sales_reps s
        ON r.id = s.region_id
      JOIN accounts a
        ON s.id = a.sales_rep_id
  WHERE s.name LIKE 'S%'
    AND r.name IN ('Midwest')
  ORDER BY a.name;

/*
3. Provide a table that provides the region for each sales_rep along with their associated accounts. This time only for accounts where the sales rep has a last name starting with K and in the Midwest region. Your final table should include three columns: the region name, the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) according to account name.
*/

SELECT  r.name region_name,
        s.name sales_rep_name,
        a.name account_name
    FROM  region r
      JOIN  sales_reps s
        ON  r.id = s.region_id
      JOIN  accounts a
        ON  s.id = a.sales_rep_id
  WHERE s.name LIKE '% K%'
    AND r.name IN ('Midwest')
  ORDER BY a.name;

/*
4. Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. However, you should only provide the results if the standard order quantity exceeds 100. Your final table should have 3 columns: region name, account name, and unit price. In order to avoid a division by zero error, adding .01 to the denominator here is helpful total_amt_usd/(total+0.01).
*/

/*
5. Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. However, you should only provide the results if the standard order quantity exceeds 100 and the poster order quantity exceeds 50. Your final table should have 3 columns: region name, account name, and unit price. Sort for the smallest unit price first. In order to avoid a division by zero error, adding .01 to the denominator here is helpful (total_amt_usd/(total+0.01).
*/

/*
6. Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. However, you should only provide the results if the standard order quantity exceeds 100 and the poster order quantity exceeds 50. Your final table should have 3 columns: region name, account name, and unit price. Sort for the largest unit price first. In order to avoid a division by zero error, adding .01 to the denominator here is helpful (total_amt_usd/(total+0.01).
*/

/*
7. What are the different channels used by account id 1001? Your final table should have only 2 columns: account name and the different channels. You can try SELECT DISTINCT to narrow down the results to only the unique values.
*/

/*
8. Find all the orders that occurred in 2015. Your final table should have 4 columns: occurred_at, account name, order total, and order total_amt_usd.
*/
