--3. Quiz: Window Functions 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*
1. Using Derek's previous video as an example, create another running total. This time, create a running total of standard_amt_usd (in the orders table) over order time with no date truncation. Your final table should have two columns: one with the amount being added for each new row, and a second with the running total.
*/

SELECT o.standard_amt_usd,
       SUM(o.standard_amt_usd) OVER (ORDER BY o.occurred_at) AS running_total
  FROM orders o;

--5. Quiz: Window Functions 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*
Now, modify your query from the previous quiz to include partitions. Still create a running total of standard_amt_usd (in the orders table) over order time, but this time, date truncate occurred_at by year and partition by that same year-truncated occurred_at variable. Your final table should have three columns: One with the amount being added for each row, one for the truncated date, and a final column with the running total within each year.
*/

SELECT o.standard_amt_usd,
       DATE_TRUNC('year',o.occurred_at) AS year,
       SUM(o.standard_amt_usd) OVER (PARTITION BY DATE_TRUNC('year',o.occurred_at) ORDER BY o.occurred_at) AS running_total
  FROM orders o;
