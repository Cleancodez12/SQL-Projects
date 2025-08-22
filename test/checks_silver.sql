/*
==========================================================================================
Quality Checks
==========================================================================================
Script Purposes:
	This script performs various quality checks for data consistency, accuracy, and 
	standardization across the 'silver' schema. It includes checks for: 
	- Null or duplicate primary keys.
	- Unwanted spaces in string fields.
	- Data standardization and consistency.
	- Invalid date ranges and orders.
	- Data consistency between related fields.

Usage Notes:
	- Run these checks after data loading Silver layer.
	- Investigate and resolve any discrepancies found during the checks.
==========================================================================================
*/

-- =======================================================================================
-- Checking: 'Silver.crm_cust_info'
-- =======================================================================================
-- Checking for NULLs or Duplicates in Primary Key
-- Expectation: No Results
SELECT
	cust_id,
	COUNT(*)
FROM silver.crm_cust_info
GROUP BY cust_id
HAVING COUNT(*) > 1 OR cust_id IS NULL;

--Check for unwanted Spaces
-- Expectation: No Results
SELECT cst_key
FROM silver.crm_cust_info
WHERE cst_key != TRIM(cst_key);


-- Data Standardization & consistency
SELECT DISTINCT cst_marital_status
FROM silver.crm_cust_info;

-- Check for Nulls or Duplicates in primary Key
-- Expectation: No Result

SELECT
prd_id,
COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL

--Check for unwanted Spaces
-- Expectation: No Results
SELECT prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm)

-- Check for NULLs or Negative Numbers
-- Expectation: No Results
SELECT prd_cost
FROM bronze.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL

-- Data Standardization & Consistency
SELECT DISTINCT prd_line
FROM bronze.crm_prd_info

-- Check for Invalid Date Orders
SELECT *
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt

SELECT
	prd_id,
	prd_key,
	prd_nm,
	prd_start_dt,
	prd_end_dt,
	LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)-1 AS prd_end_dt
	FROM silver.crm_prd_info
	WHERE prd_key IN ('AC-HE-HL-U509-R', 'AC-HE-HL-U509')

SELECT * FROM silver.crm_prd_info

-- Check for Invalid Date Orders
SELECT
*
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt

-- Check for Invalid Dates
SELECT 
NULLIF(sls_due_dt,0) sls_due_dt
FROM bronze.crm_sales_details
WHERE sls_due_dt <= 0 OR LEN(sls_due_dt) != 8
OR sls_due_dt > 20500101
OR sls_due_dt < 19000101

-- Check for Invalid Date Orders
SELECT * 
FROM bronze.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt;

-- Check Data Consistency: Between Sales, Quantity, and Price
-- Sales = Quantity * Price
-- Values must not be NULL, zero, or negative.

SELECT DISTINCT
sls_sales AS old_sls_sales,
sls_quantity,
sls_price AS old_sls_price,

CASE WHEN sls_sales IS NULL OR sls_sales <=0 OR sls_sales != sls_quantity * ABS(sls_price)
	THEN sls_quantity * ABS(sls_price)
	ELSE sls_sales
END sls_sales,

CASE WHEN sls_price IS NULL OR sls_price <= 0
	THEN sls_sales / NULLIF(sls_quantity, 0)
	ELSE sls_price
END sls_price

FROM bronze.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0  OR sls_quantity <= 0 OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price

SELECT * FROM silver.crm_sales_details

-- Identify out-of-range dates
SELECT DISTINCT
bdate
FROM bronze.erp_cust_az12
WHERE bdate < '1924-01-01' OR bdate > GETDATE()

-- Data Standardization & Consistency
SELECT 
DISTINCT gen,
CASE WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
	WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
	ELSE 'n/a'
END AS gen
FROM bronze.erp_cust_az12

SELECT 
 *
FROM silver.erp_cust_az12

-- Data Standardization & consistency
SELECT DISTINCT cntry
FROM silver.erp_loc_a101

SELECT * FROM silver.erp_loc_a101

-- Check for unwanted Spaces
SELECT * FROM bronze.erp_px_cat_g1v2
WHERE cat != TRIM(cat) OR subcat != TRIM(subcat) OR maintenance != TRIM(maintenance)

-- Data Standardizationn & Consistency
SELECT DISTINCT
maintenance
FROM bronze.erp_px_cat_g1v2
