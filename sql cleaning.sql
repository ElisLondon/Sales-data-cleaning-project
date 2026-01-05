-- Cleaning data

select *
FROM gamezone_data;

-- Creating a staging table to work on
CREATE TABLE gamezone_data_staging
LIKE gamezone_data;

INSERT gamezone_data_staging
SELECT *
FROM gamezone_data;

SELECT *
FROM gamezone_data_staging;

-- Removing duplicate rows
WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY user_id, order_id,
purchase_ts, ship_ts, product_name, product_id,
usd_price, purchase_platform, marketing_channel,
account_creation_method, country_code, region) AS row_num
FROM gamezone_data_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

SELECT *
FROM gamezone_data_staging
WHERE user_id = '099d8be7';

CREATE TABLE `gamezone_data_staging2` (
  `USER_ID` text,
  `ORDER_ID` text,
  `PURCHASE_TS` text,
  `SHIP_TS` text,
  `PRODUCT_NAME` text,
  `PRODUCT_ID` text,
  `USD_PRICE` double DEFAULT NULL,
  `PURCHASE_PLATFORM` text,
  `MARKETING_CHANNEL` text,
  `ACCOUNT_CREATION_METHOD` text,
  `COUNTRY_CODE` text,
  `REGION` text,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO gamezone_data_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY user_id, order_id,
purchase_ts, ship_ts, product_name, product_id,
usd_price, purchase_platform, marketing_channel,
account_creation_method, country_code, region) AS row_num
FROM gamezone_data_staging;

DELETE
FROM gamezone_data_staging2
WHERE row_num > 1;

-- standardizing data
SELECT DISTINCT(product_name)
FROM gamezone_data_staging2
ORDER BY 1;

-- Making product names consistent
UPDATE gamezone_data_staging2
SET product_name = '27 inch gaming monitor'
WHERE product_name LIKE '27in%';

-- fixing incorrectly formatted dates
SELECT purchase_ts
FROM gamezone_data_staging2
HAVING length(purchase_ts) > 10;

UPDATE gamezone_data_staging2
SET purchase_ts = LEFT(purchase_ts, 10);

SELECT DISTINCT substring(purchase_ts, 4, 2)
FROM gamezone_data_staging2;

UPDATE gamezone_data_staging2
SET purchase_ts = NULL
WHERE TRIM(purchase_ts) = '';

-- updating the purchase_ts column to correct date format
ALTER TABLE gamezone_data_staging2
ADD COLUMN purchase_ts_clean DATE;

UPDATE gamezone_data_staging2
SET purchase_ts_clean = CASE
    -- Format: DD/MM/YYYY
    WHEN purchase_ts REGEXP '^[0-9]{2}/[0-9]{2}/[0-9]{4}$' 
        THEN STR_TO_DATE(TRIM(purchase_ts), '%d/%m/%Y')

    -- Format: MM-DD-YYYY
    WHEN purchase_ts REGEXP '^[0-9]{2}-[0-9]{2}-[0-9]{4}$' 
        THEN STR_TO_DATE(TRIM(purchase_ts), '%m-%d-%Y')

    -- Format: YYYY-MM-DD
    WHEN purchase_ts REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$' 
        THEN STR_TO_DATE(TRIM(purchase_ts), '%Y-%m-%d')

    -- Format: YYYY/MM/DD
    WHEN purchase_ts REGEXP '^[0-9]{4}/[0-9]{2}/[0-9]{2}$' 
        THEN STR_TO_DATE(TRIM(purchase_ts), '%Y/%m/%d')

    -- Format: DD.MM.YYYY
    WHEN purchase_ts REGEXP '^[0-9]{2}\\.[0-9]{2}\\.[0-9]{4}$' 
        THEN STR_TO_DATE(TRIM(purchase_ts), '%d.%m.%Y')

    ELSE NULL
END;

-- fixing ship_ts
SELECT ship_ts
FROM gamezone_data_staging2
HAVING length(ship_ts) > 10;

SELECT DISTINCT substring(ship_ts, 4, 2)
FROM gamezone_data_staging2
ORDER BY 1;

UPDATE gamezone_data_staging2
SET ship_ts = str_to_date(ship_ts,'%d/%m/%Y');
ALTER TABLE gamezone_data_staging2
MODIFY COLUMN ship_ts DATE;

SELECT DISTINCT(USD_PRICE)
FROM gamezone_data_staging2
ORDER BY 1;

-- Changing data type of the usd_price column
ALTER TABLE gamezone_data_staging2
MODIFY COLUMN usd_price decimal(10,2);


-- Dealing with nulls and empty strings

SELECT DISTINCT(marketing_channel)
FROM gamezone_data_staging2;

UPDATE gamezone_data_staging2
SET marketing_channel = 'unknown'
WHERE marketing_channel = '';

SELECT DISTINCT(ACCOUNT_CREATION_METHOD)
FROM gamezone_data_staging2;

UPDATE gamezone_data_staging2
SET account_creation_method = 'unknown'
WHERE account_creation_method = '';

SELECT DISTINCT(country_code)
FROM gamezone_data_staging2
ORDER BY 1;

UPDATE gamezone_data_staging2
SET country_code = NULL
WHERE country_code = '';

-- Deleting unwanted rows and columns
DELETE
FROM gamezone_data_staging2
WHERE usd_price = 0;

ALTER TABLE gamezone_data_staging2
DROP COLUMN row_num;

SELECT *
FROM gamezone_data_staging2
ORDER BY usd_price ASC;

UPDATE gamezone_data_staging2
SET country_code = NULL
WHERE country_code = '' OR country_code = 'AP' or country_code = 'EU';

UPDATE gamezone_data_staging2
SET region = NULL
WHERE region = '#N/A';