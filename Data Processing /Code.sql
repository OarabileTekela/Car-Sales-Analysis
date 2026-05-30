-- select * from `workspace`.`default`.`car_sales_dataset` limit 100;

-- CHECKING THE YEAR RANGE

SELECT MIN(year) AS earliest_year
FROM workspace.default.car_sales_dataset;

SELECT MAX(year) AS latest_year
FROM workspace.default.car_sales_dataset;

-- CHECKING DIFFERENT REGIONS (STATES)

SELECT DISTINCT state
FROM workspace.default.car_sales_dataset;

SELECT COUNT(DISTINCT state) AS number_of_states
FROM workspace.default.car_sales_dataset;

-- CHECKING CAR MAKES AND YEARS

SELECT DISTINCT make
FROM workspace.default.car_sales_dataset;

SELECT DISTINCT model
FROM workspace.default.car_sales_dataset;

SELECT DISTINCT body
FROM workspace.default.car_sales_dataset;

SELECT DISTINCT transmission
FROM workspace.default.car_sales_dataset;

-- CHECKING PRICE RANGE AND COST PRICE 

SELECT 
    MIN(CAST(sellingprice AS DOUBLE)) AS cheapest_price
FROM workspace.default.car_sales_dataset;

SELECT 
    MAX(CAST(sellingprice AS DOUBLE)) AS highest_price
FROM workspace.default.car_sales_dataset;

-- DATASET OVERVIEW ----

SELECT
    COUNT(*) AS number_of_rows,
    COUNT(DISTINCT make) AS number_of_makes,
    COUNT(DISTINCT model) AS number_of_models,
    COUNT(DISTINCT state) AS number_of_states
FROM workspace.default.car_sales_dataset;

-- DATASET PREVIEW ---

SELECT *
FROM workspace.default.car_sales_dataset
LIMIT 100;

--- REVENUE PER SALE---
SELECT
    make,
    model,
    year,

    CAST(sellingprice AS DOUBLE) AS selling_price,

    CAST(mmr AS DOUBLE) AS market_price

FROM workspace.default.car_sales_dataset;

--- REVENUE ---
SELECT
    make,
    model,
    year,

    CAST(sellingprice AS DOUBLE) AS selling_price,

    CAST(sellingprice AS DOUBLE) * 1 AS total_revenue

FROM workspace.default.car_sales_dataset;

-- Profit Margin + Performance Tier
SELECT

    make,
    model,
    year,
    state,

    CAST(sellingprice AS DOUBLE) AS selling_price,

    CAST(mmr AS DOUBLE) AS cost_price,

    ROUND(
        (
            CAST(sellingprice AS DOUBLE)
            - CAST(mmr AS DOUBLE)
        )
        / CAST(sellingprice AS DOUBLE) * 100,
    2) AS profit_margin,

    CASE
        WHEN (
            (
                CAST(sellingprice AS DOUBLE)
                - CAST(mmr AS DOUBLE)
            )
            / CAST(sellingprice AS DOUBLE) * 100
        ) >= 20 THEN 'High Margin'

        WHEN (
            (
                CAST(sellingprice AS DOUBLE)
                - CAST(mmr AS DOUBLE)
            )
            / CAST(sellingprice AS DOUBLE) * 100
        ) BETWEEN 10 AND 20 THEN 'Medium Margin'

        ELSE 'Low Margin'
    END AS performance_tier

FROM workspace.default.car_sales_dataset;

--- PERFORMANCE CLASSIFICATION AND FILTERING NULL VALUES ---
SELECT
    make,
    model,
    year,
    state,
    CAST(sellingprice AS DOUBLE) AS selling_price,
    CAST(mmr AS DOUBLE) AS cost_price,
    ROUND(
        (
            CAST(sellingprice AS DOUBLE)
            - CAST(mmr AS DOUBLE)
        )
        / CAST(sellingprice AS DOUBLE) * 100,
    2) AS profit_margin,
    CASE
        WHEN (
            (CAST(sellingprice AS DOUBLE) - CAST(mmr AS DOUBLE))
            / CAST(sellingprice AS DOUBLE) * 100
        ) >= 20 THEN 'High Margin'
        WHEN (
            (CAST(sellingprice AS DOUBLE) - CAST(mmr AS DOUBLE))
            / CAST(sellingprice AS DOUBLE) * 100
        ) BETWEEN 10 AND 20 THEN 'Medium Margin'
        ELSE 'Low Margin'
    END AS performance_tier
FROM workspace.default.car_sales_dataset
WHERE sellingprice IS NOT NULL
AND mmr IS NOT NULL;

--- SALES TRENDS BY YEAR ---

SELECT

    year,

    COUNT(*) AS cars_sold,

    SUM(CAST(sellingprice AS DOUBLE)) AS total_revenue,

    ROUND(
        AVG(CAST(sellingprice AS DOUBLE)),
    2) AS avg_selling_price

FROM workspace.default.car_sales_dataset

GROUP BY year

ORDER BY year;

--- REVENUE BY MAKE AND CAR MODEL ---

SELECT

    make,
    model,

    COUNT(*) AS units_sold,

    SUM(CAST(sellingprice AS DOUBLE)) AS total_revenue

FROM workspace.default.car_sales_dataset

GROUP BY make, model

ORDER BY total_revenue DESC;

---PERFORMANECE BY REGIONS ---
SELECT

    state,

    COUNT(*) AS cars_sold,

    SUM(CAST(sellingprice AS DOUBLE)) AS total_revenue,

    ROUND(
        AVG(CAST(sellingprice AS DOUBLE)),
    2) AS avg_price

FROM workspace.default.car_sales_dataset

GROUP BY state

ORDER BY total_revenue DESC;
