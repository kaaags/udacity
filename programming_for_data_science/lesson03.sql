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
When was the earliest order ever placed? You only need to return the date.
*/

SELECT  MIN(o.occurred_at) AS earliest_order
    FROM  orders o;

/*
Try performing the same query as in question 1 without using an aggregation function.
*/



/*
When did the most recent (latest) web_event occur?
*/



/*
Try to perform the result of the previous query without using an aggregation function.
*/



/*
Find the mean (AVERAGE) amount spent per order on each paper type, as well as the mean amount of each paper type purchased per order. Your final answer should have 6 values - one for each paper type for the average number of sales, as well as the average amount.
*/



/*
Via the video, you might be interested in how to calculate the MEDIAN. Though this is more advanced than what we have covered so far try finding - what is the MEDIAN total_usd spent on all orders?
*/
