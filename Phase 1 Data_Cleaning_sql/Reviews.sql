/* 
==================================================
  Amazon Reviews Dataset Cleaning - SQL Script
  Author: Imran Qureshi
  Description: Cleaning messy review data step-by-step
  Uploading to GitHub for reproducibility
==================================================
*/

-- 1. Let's peak into the dataset
SELECT Top 10 *
FROM Reviews;


-- 2. Converting Time column from Unix timestamp to date
-- 2.a Adding a new column for storing only the date
ALTER TABLE Reviews
ADD Date DATE;

-- 2.b Convert Unix epoch to datetime, then cast to date (YYYY-MM-DD only)
UPDATE Reviews
SET Date = CAST(DATEADD(SECOND, Time, '1970-01-01') AS DATE);

-- 2.c Preview results
SELECT TOP 10 Time, Date
FROM Reviews;

-- 2.d Drop the original Time column after verification
ALTER TABLE Reviews
DROP COLUMN Time;


-- 3. Checking for Null or Empty Text Entries
SELECT *
FROM Reviews
WHERE Text IS NULL


-- 4. Trim extra spaces
UPDATE Reviews
SET Text = LTRIM(RTRIM(Text)),
	Summary = LTRIM(RTRIM(Summary));


-- 5. Check for Duplicate Reviews
WITH Numbered AS (
  SELECT
    *,
    COUNT(*) OVER (
      PARTITION BY UserId, ProductId, Score, Summary, Text
    ) AS TotalCount
  FROM Reviews
)
SELECT *
FROM Numbered
WHERE TotalCount > 1
ORDER BY TotalCount DESC, UserId, ProductId, Id;

-- 5.a Let's delete the duplicate Reviews
WITH CTE AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY UserId, ProductId, Score, Summary, Text
               ORDER BY Id
           ) AS RowNum
    FROM Reviews
)
DELETE FROM CTE
WHERE RowNum > 1;


-- 6.a Fix Encoding or Non-ASCII Characters
SELECT TOP 10 Id, Text
FROM Reviews
WHERE LEN(Text) <> LEN(CAST(Text AS VARCHAR(MAX)));

-- 6.b LEt's see if we have html tags in our dataset
SELECT Text
FROM Reviews
WHERE Text LIKE '%<br%/%>%';

-- 6.c Deleting html tags
UPDATE Reviews
SET Text = REPLACE(
               REPLACE(
                 REPLACE(
                   REPLACE(Text, '<br />', ' '),
                 '<BR />', ' '),
               '<br>', ' '),
             '<BR>', ' ')
WHERE Text LIKE '%<br%/%>%' OR Text LIKE '%<BR%/%>%';


-- 7. Identify potentially spammy or suspicious review patterns
-- 7.a Users with >100 total reviews
SELECT *
FROM Reviews
WHERE UserId IN (
    SELECT UserId
    FROM Reviews
    GROUP BY UserId
    HAVING COUNT(*) > 100
)
ORDER BY UserId;

-- 7.b same user posting identical text multiple times
WITH Numbered AS (
    SELECT
      *,
      COUNT(*) OVER (PARTITION BY UserId, Text) AS DupCount
    FROM Reviews
)
SELECT *
FROM Numbered
WHERE DupCount > 1
ORDER BY UserId, Text, Id;

-- 7.c Deleting identical reviews
WITH CTE AS (
    SELECT
        Id,
        UserId,
        Text,
        ROW_NUMBER() OVER (
            PARTITION BY UserId, Text 
            ORDER BY Id
        ) AS rn
    FROM Reviews
)
DELETE FROM CTE
WHERE rn > 1;

-- 7.d same user with identical helpfulness metrics 
WITH Spoof AS (
    SELECT
        *,  
        COUNT(*) OVER (
            PARTITION BY UserId, HelpfulnessNumerator, HelpfulnessDenominator
        ) AS CountRecs
    FROM Reviews
)
SELECT *
FROM Spoof
WHERE CountRecs > 3
ORDER BY CountRecs DESC, UserId, Id;

-- 7.e Let's check for short reviews
SELECT *
FROM Reviews
WHERE LEN(Text) < 10;

-- 7.f Multiple reviews of the same product by one user
SELECT r.*
FROM Reviews r
JOIN (
    SELECT UserId, ProductId
    FROM Reviews
    GROUP BY UserId, ProductId
    HAVING COUNT(*) > 1
) dup
ON r.UserId = dup.UserId AND r.ProductId = dup.ProductId
ORDER BY r.UserId, r.ProductId, r.Date;

-- 7.g Let's check what we're deleting 
SELECT *
FROM (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY UserId, ProductId 
            ORDER BY Date ASC
        ) AS RowNum
    FROM Reviews
) t
WHERE RowNum > 1;

-- 7.h delete same userid with same productid
WITH RankedReviews AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY UserId, ProductId 
            ORDER BY Date ASC
        ) AS RowNum
    FROM Reviews
)
DELETE FROM RankedReviews
WHERE RowNum > 1;


-- 8. check Unusual Scores for Quality Check
SELECT *
FROM Reviews
WHERE Score < 1 OR Score > 5;

SELECT *
FROM Reviews;
