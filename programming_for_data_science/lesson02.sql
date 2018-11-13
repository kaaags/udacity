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



/*
3. Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. Your final table should have 3 columns: region name, account name, and unit price. A few accounts have 0 for total, so I divided by (total + 0.01) to assure not dividing by zero.
*/
