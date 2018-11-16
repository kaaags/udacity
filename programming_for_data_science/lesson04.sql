--4. Video + Quiz: Write Your First Subquery %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*
1. Use the test environment below to find the number of events that occur for each day for each channel.
*/

SELECT  DATE_TRUNC('day', w.occurred_at) AS day,
        w.channel,
        COUNT(*) daily_events
    FROM  web_events w
  GROUP BY  1,
            2
  ORDER BY  1;

/*
2. Now create a subquery that simply provides all of the data from your first query.
*/



/*
3. Now find the average number of events for each channel. Since you broke out by day earlier, this is giving you an average per day.
*/
