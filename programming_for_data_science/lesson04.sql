--4. Video + Quiz: Write Your First Subquery %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*
1. Use the test environment below to find the number of events that occur for each day for each channel.
*/

SELECT  DATE_TRUNC('day', w.occurred_at) AS day,
        w.channel,
        COUNT(*) daily_events
    FROM  web_events w
  GROUP BY  1, 2
  ORDER BY  3 DESC;

/*
2. Now create a subquery that simply provides all of the data from your first query.
*/

SELECT  *
    FROM
      (SELECT DATE_TRUNC('day', w.occurred_at) AS day,
              w.channel,
              COUNT(*)  AS daily_events
          FROM  web_events w
        GROUP BY  1, 2
        ) sub
  ORDER BY  3 DESC;

/*
3. Now find the average number of events for each channel. Since you broke out by day earlier, this is giving you an average per day.
*/

SELECT  channel,
        AVG(daily_events) AS avg_daily_event_count
    FROM  (SELECT DATE_TRUNC('day', occurred_at) AS day,
                  channel,
                  COUNT(*) AS daily_events
              FROM  web_events
            GROUP BY  1, 2
            ) sub
  GROUP BY  1
  ORDER BY  1;

--7. Quiz: More on Subqueries %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*
1. Use DATE_TRUNC to pull month level information about the first order ever placed in the orders table.
*/

SELECT  *
  FROM  orders
  WHERE DATE_TRUNC('month',occurred_at) =
  (SELECT  DATE_TRUNC('month',MIN(occurred_at)) AS min
    FROM  orders
  )
  ORDER BY  occurred_at
  LIMIT 1;

/*
2. Use the result of the previous query to find only the orders that took place in the same month and year as the first order, and then pull the average for each type of paper qty in this month.
*/

SELECT  AVG(standard_qty) AS monthly_avg_standard,
        AVG(gloss_qty) AS monthly_avg_glossy,
        AVG(poster_qty) AS monthly_avg_poster,
        SUM(total_amt_usd) AS sum_total_amt_usd
  FROM  orders
  WHERE DATE_TRUNC('month',occurred_at) =
  (SELECT  DATE_TRUNC('month',MIN(occurred_at)) AS min
    FROM  orders
  );

--10. Quiz: Subquery Mania %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*
1. Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.
*/

SELECT  sr.name sales_rep,
        r.name region,
        MAX(total_amt_usd) max_total
  FROM  sales_reps sr
  JOIN  region r
  ON    sr.region_id = r.id
  JOIN  accounts a
  ON    sr.id = a.sales_rep_id
  JOIN  orders o
  ON    a.id = o.account_id
  GROUP BY  1,2
  ORDER BY  1;

/*
2. For the region with the largest (sum) of sales total_amt_usd, how many total (count) orders were placed?
*/



/*
3. For the name of the account that purchased the most (in total over their lifetime as a customer) standard_qty paper, how many accounts still had more in total purchases?
*/



/*
4. For the customer that spent the most (in total over their lifetime as a customer) total_amt_usd, how many web_events did they have for each channel?
*/



/*
5. What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total spending accounts?
*/



/*
6. What is the lifetime average amount spent in terms of total_amt_usd for only the companies that spent more than the average of all orders.
*/