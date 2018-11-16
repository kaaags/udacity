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
  ORDER BY  1 DESC;
