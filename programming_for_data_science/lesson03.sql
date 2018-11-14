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



/*
4. Find the total amount spent on standard_amt_usd and gloss_amt_usd paper for each order in the orders table. This should give a dollar amount for each order in the table.
*/



/*
5. Find the standard_amt_usd per unit of standard_qty paper. Your solution should use both an aggregation and a mathematical operator.
*/
