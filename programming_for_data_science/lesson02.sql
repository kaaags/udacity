--4. JOIN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*
1. Try it yourself below by writing a query that limits the response to only the first 15 rows and includes the occurred_at, account_id, and channel fields in the web_events table.
*/

SELECT orders.*
  FROM orders
  JOIN accounts
  ON orders.account_id = accounts.id;
