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

SELECT *
  FROM accounts
  JOIN orders
  ON accounts.id = orders.id;

/*
2.2. Try pulling standard_qty, gloss_qty, and poster_qty from the orders table, and the website and the primary_poc from the accounts table.
*/

SELECT orders.standard_qty, orders.gloss_qty, orders.poster_qty, accounts.primary_poc
  FROM orders
  JOIN accounts
  ON orders.account_id = accounts.id;
