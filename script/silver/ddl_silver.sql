
/*
=================================================================================================
DDL Script: create Silver layer 
=================================================================================================

This script creates tables in the Silver layer, dropping the existing table, and creates.
Run this script to redefine the Silver layer  structure.

=================================================================================================
*/
if object_id ('silver.crm_cust_info','U') is not null
	drop table silver.crm_cust_info;
create table silver.crm_cust_info(
	cst_id int,
	cst_key varchar(50),
	cst_firstname varchar(50),
	cst_lastname varchar(50),
	cst_marital_status varchar(10),
	cst_gndr varchar(10),
	cst_create_date date,
	dwh_creating_date  datetime2 default getdate()
	);
GO
if object_id ('silver.crm_prod_info','U') is not null
	drop table silver.crm_prod_info
create table silver.crm_prod_info(
	prd_id int,
	cat_id varchar(50),
	prd_key	varchar(50),
	prd_nm varchar(50),
	prd_cost int,
	prd_line varchar(15),
	prd_start_dt date,	
	prd_end_dt date,
	dwh_creating_date  datetime2 default getdate()
	);
if object_id ('silver.crm_sales_details','U') is not null
	drop table silver.crm_sales_details
create table silver.crm_sales_details(
	sls_ord_num varchar(50),
	sls_prd_key	varchar(50),
	sls_cust_id	int,
	sls_order_dt date,
	sls_ship_dt date,
	sls_due_dt date,
	sls_sales float,
	sls_quantity int,
	sls_price float,
	dwh_creating_date  datetime2 default getdate()
	);

if object_id ('silver.erp_cust_az12','U') is not null
	drop table silver.erp_cust_az12
create table silver.erp_cust_az12(
	CID varchar(50),
	BDATE date,
	GEN varchar(15),
	dwh_creating_date  datetime2 default getdate()
	);

if object_id ('silver.erp_loc_a101','U') is not null
	drop table silver.erp_loc_a101
create table silver.erp_loc_a101(
	CID	varchar(50),
	CNTRY varchar(50),
	dwh_creating_date  datetime2 default getdate()
	);
if object_id ('silver.erp_px_cat_g1v2','U') is not null
	drop table silver.erp_px_cat_g1v2
create table silver.erp_px_cat_g1v2(
	ID varchar(50),
	CAT	varchar(50),
	SUBCAT	varchar(50),
	MAINTENANCE varchar(5),
	dwh_creating_date  datetime2 default getdate()
	);
