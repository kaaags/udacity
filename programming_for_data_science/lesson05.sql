--3. Quiz: LEFT & RIGHT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*
1. In the accounts table, there is a column holding the website for each company. The last three digits specify what type of web address they are using. A list of extensions (and pricing) is provided here. Pull these extensions and provide how many of each website type exist in the accounts table.
*/

SELECT  RIGHT(a.website, 3) AS domain,
        COUNT(*) num_companies
  FROM accounts a
  GROUP BY 1
  ORDER BY 2 DESC;

/*
2. There is much debate about how much the name (or even the first letter of a company name) matters. Use the accounts table to pull the first letter of each company name to see the distribution of company names that begin with each letter (or number).
*/

SELECT  LEFT(UPPER(a.name), 1) AS first_letter,
        COUNT(*) num_companies
  FROM accounts a
  GROUP BY 1
  ORDER BY 2 DESC;

/*
3. Use the accounts table and a CASE statement to create two groups: one group of company names that start with a number and a second group of those company names that start with a letter. What proportion of company names start with a letter?
*/

SELECT SUM(num) nums, SUM(letter) letters
  FROM (SELECT name,
          CASE WHEN LEFT(UPPER(a.name), 1)
            IN ('0','1','2','3','4','5','6','7','8','9')
            THEN 1
            ELSE 0
            END AS num,
          CASE WHEN LEFT(UPPER(a.name), 1)
            IN ('0','1','2','3','4','5','6','7','8','9')
            THEN 0
            ELSE 1
            END AS letter
          FROM accounts a) t1;

--Answer: 350/351 (or 99.7% of) company names start with a letter.

/*
4. Consider vowels as a, e, i, o, and u. What proportion of company names start with a vowel, and what percent start with anything else?
*/

SELECT  SUM(vowel) vowels,
        SUM(other) others
  FROM (SELECT name,
          CASE WHEN LEFT(UPPER(a.name), 1)
            IN ('A','E','I','O','U')
            THEN 1
            ELSE 0
            END AS vowel,
          CASE WHEN LEFT(UPPER(a.name), 1)
            IN ('A','E','I','O','U')
            THEN 0
            ELSE 1
            END AS other
          FROM accounts a) t1;

-- 80/351 (or 22.8% of) company names start with a vowel. 77.2% (or 271) of company names start with any other character.

--6. Quiz: POSITION, STRPOS, & SUBSTR - AME DATA AS QUIZ 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*
1. Use the accounts table to create first and last name columns that hold the first and last names for the primary_poc.
*/

SELECT  LEFT(a.primary_poc, STRPOS(a.primary_poc, ' ') -1) first_name,
        RIGHT(a.primary_poc, LENGTH(a.primary_poc) - STRPOS(a.primary_poc, ' ')) last_name
  FROM  accounts a;

/*
2. Now see if you can do the same thing for every rep name in the sales_reps table. Again provide first and last name columns.
*/

SELECT  LEFT(sr.name, STRPOS(sr.name, ' ') -1) first_name,
        RIGHT(sr.name, LENGTH(sr.name) - STRPOS(sr.name, ' ')) last_name
  FROM  sales_reps sr;
