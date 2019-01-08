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

--8. Quiz: ROW_NUMBER & RANK %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*
1. Select the id, account_id, and total variable from the orders table, then create a column called total_rank that ranks this total amount of paper ordered (from highest to lowest) for each account using a partition. Your final table should have these four columns.
*/

SELECT o.id,
       o.account_id,
       o.total,
       RANK() OVER (PARTITION BY o.account_id ORDER BY o.total DESC) AS total_rank
  FROM orders o;

--11. Quiz: Aggregates in Window Functions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*
1. Run the query that Derek wrote in the previous video in the first SQL Explorer below. Keep the query results in mind; you'll be comparing them to the results of another query next.
*/

SELECT o.id,
       o.account_id,
       o.standard_qty,
       DATE_TRUNC('month',o.occurred_at) AS month,
       DENSE_RANK() OVER (PARTITION BY o.account_id ORDER BY DATE_TRUNC('month',o.occurred_at)) AS dense_rank,
       SUM(o.standard_qty) OVER (PARTITION BY o.account_id ORDER BY DATE_TRUNC('month',o.occurred_at)) AS sum_std_qty,
       COUNT(o.standard_qty) OVER (PARTITION BY o.account_id ORDER BY DATE_TRUNC('month',o.occurred_at)) AS count_std_qty,
       AVG(o.standard_qty) OVER (PARTITION BY o.account_id ORDER BY DATE_TRUNC('month',o.occurred_at)) AS avg_std_qty,
       MIN(o.standard_qty) OVER (PARTITION BY o.account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS min_std_qty,
       MAX(o.standard_qty) OVER (PARTITION BY o.account_id ORDER BY DATE_TRUNC('month',o.occurred_at)) AS max_std_qty
  FROM orders o;


/*
2. Now remove ORDER BY DATE_TRUNC('month',occurred_at) in each line of the query that contains it in the SQL Explorer below. Evaluate your new query, compare it to the results in the SQL Explorer above, and answer the subsequent quiz questions.
*/

SELECT o.id,
       o.account_id,
       o.standard_qty,
       DATE_TRUNC('month',o.occurred_at) AS month,
       DENSE_RANK() OVER (PARTITION BY o.account_id ) AS dense_rank,
       SUM(o.standard_qty) OVER (PARTITION BY o.account_id) AS sum_std_qty,
       COUNT(o.standard_qty) OVER (PARTITION BY o.account_id) AS count_std_qty,
       AVG(o.standard_qty) OVER (PARTITION BY o.account_id) AS avg_std_qty,
       MIN(o.standard_qty) OVER (PARTITION BY o.account_id) AS min_std_qty,
       MAX(o.standard_qty) OVER (PARTITION BY o.account_id) AS max_std_qty
  FROM orders o;

--14. Quiz: Aliases for Multiple Windows Functions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*
1. Now, create and use an alias to shorten the following query (which is different than the one in Derek's previous video) that has multiple window functions. Name the alias account_year_window, which is more descriptive than main_window in the example above.

SELECT id,
       account_id,
       DATE_TRUNC('year',occurred_at) AS year,
       DENSE_RANK() OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at)) AS dense_rank,
       total_amt_usd,
       SUM(total_amt_usd) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at)) AS sum_total_amt_usd,
       COUNT(total_amt_usd) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at)) AS count_total_amt_usd,
       AVG(total_amt_usd) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at)) AS avg_total_amt_usd,
       MIN(total_amt_usd) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at)) AS min_total_amt_usd,
       MAX(total_amt_usd) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at)) AS max_total_amt_usd
FROM orders
*/

SELECT id,
       account_id,
       DATE_TRUNC('year',occurred_at) AS year,
       DENSE_RANK() OVER account_year_window AS dense_rank,
       total_amt_usd,
       SUM(total_amt_usd) OVER account_year_window AS sum_total_amt_usd,
       COUNT(total_amt_usd) OVER account_year_window AS count_total_amt_usd,
       AVG(total_amt_usd) OVER account_year_window AS avg_total_amt_usd,
       MIN(total_amt_usd) OVER account_year_window AS min_total_amt_usd,
       MAX(total_amt_usd) OVER account_year_window AS max_total_amt_usd
FROM orders
WINDOW account_year_window AS (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at))
