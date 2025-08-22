# Data Dictionary for Gold Layer
## Overview
### The Gold Layer is the business-level data representation, structured to support analytical and reporting use cases. It consists of dimension tables and fact tables for specific business metrics

1.gold.dim_customers
-	Purpose: Stores customer details enriched with demographic and geographic data
-	Columns:

| Column Name	| Data Type |	Description |
|-------------|-----------|-------------|
| customer_key |	INT	| Surrogate key uniquely identifying each customer record in the dimension table |
| Customer_id	| INT	| Unique numerical identifier assigned to each customer |
| Customer_number	| NVARCHAR(50)	| Alphanumeric identifier representing the customer used for tracking and referencing |
| First_name | NVARCHAR(50) |	The customer’s first name, as recorded in the systems |
| Last_name	| NVARCHAR(50)	| The customer’s last name or family name |
| Country	| NVARCHAR(50) | The county of residence of the customer (e.g ‘Australia’) |
|Marital_status |	NVARCHAR(50)	| The marital status of the customer (e.g ‘Single’, ‘Married’,) |
|Gender |	NVARCHAR(50) | The customer’s gender (e.g ‘Male’, ‘ Female’, ‘n/a’) |
|Birthdate |	DATE |	The date of birth of the customer formatted as YYYY-MM-DD (e.g 1971-10-06). |
|Create_date |	DATE	| The date and time when the customer record was created in the system. |



2.gold.dim_products
-	Purpose: Provides information about the products and their attributes.
-	Columns:

| Column Name	| Data Type |	Description |
|-------------|-----------|-------------|
|Product_key|	INT|	Surrogate key uniquely identifying each customer record in the dimension table|
|Product_id|	INT|	A unique identifier assigned to the product for internal tracking and referencing|
|Product_number|	NVARCHAR(50)|	A structured alphanumeric code representing the product, often used for categorizing inventory.|
|Product_name|	NVARCHAR(50)|	Descriptive name of the product, including key details such as type, color, and size|
|Category_id|	NVARCHAR(50)|	A unique identifier for the product’s category, linking to its high-level classification.|
|category|	NVARCHAR(50)|	The broader classification of the product (e.g., Bikes, Components) to group related items|
|Maintenance_required|	NVARCHAR(50)|	Indicated whether the product requires maintenance (e.g ‘Yes’, ‘No’).|
|subcategory|	NVARCHAR(50)|	A more detailed classification of the product within the category, such as product type|
|cost|	INT|	The cost of base price of the product, measured in monetary units.|
|Product_line|	NVARCHAR(50)|	The specific product line or series to which the product belongs (e.g, Road, Mountain)|
|Start_date	|DATE|	The date te product became available for sale or use, stored in|

3.gold.fact_sales
-	Purpose: Provides information about the products and their attributes.
-	Columns:

| Column Name	| Data Type |	Description |
|-------------|-----------|-------------|
|Order_number	|NVARCHAR(50)|	A unique alphanumeric identifier for each sales order (e.g., ‘SO54496’).|
|Product_key|	INT|	Surrogate key linking the order to the product dimension table.|
|Customer_key|	INT	|Surrogate key linking the order to the customer dimension table.|
|Order_date|	DATE	|The date when the order was placed.|
|Ship_date|	DATE	|The date when the order was shipped to the customer.|
|Due_date|	DATE|	The date when the order payment was due.|
|sales|	INT	|The total monetary value of the sale for the line item, in whole currency units (e.g., 25).|
|Quantity	|INT|	The number of units of the product ordered for the line item (e.g., 1)|
|price|	INT	|The price unit of the product for the line item, in whole currency units (e.g., 25).|
		

