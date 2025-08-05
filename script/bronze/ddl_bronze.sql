/*
=================================================================================================
DDL Script: create bronze layer
=================================================================================================

This script creates tables in the bronze layer, dropping the existing table, and creates.
Run this script to redefine the bronze layer structure.

=================================================================================================
*/
if object_id ('bronze.crm_cust_info','U') is not null
	drop table bronze.crm_cust_info;
create table bronze.crm_cust_info(
	cst_id int,
	cst_key varchar(50),
	cst_firstname varchar(50),
	cst_lastname varchar(50),
	cst_marital_status varchar(10),
	cst_gndr varchar(10),
	cst_create_date date
	);
GO
if object_id ('bronze.crm_prod_info','U') is not null
	drop table bronze.crm_prod_info
create table bronze.crm_prod_info(
	prd_id int,
	prd_key	varchar(50),
	prd_nm varchar(50),
	prd_cost int,
	prd_line varchar(15),
	prd_start_dt date,	
	prd_end_dt date
	);
if object_id ('bronze.crm_sales_details','U') is not null
	drop table bronze.crm_sales_details
create table bronze.crm_sales_details(
	sls_ord_num varchar(50),
	sls_prd_key	varchar(50),
	sls_cust_id	int,
	sls_order_dt int,
	sls_ship_dt int,
	sls_due_dt int,
	sls_sales float,
	sls_quantity int,
	sls_price float
	);

if object_id ('bronze.erp_cust_az12','U') is not null
	drop table bronze.erp_cust_az12
create table bronze.erp_cust_az12(
	CID varchar(50),
	BDATE date,
	GEN varchar(15)
	);

if object_id ('bronze.erp_loc_a101','U') is not null
	drop table bronze.erp_loc_a101
create table bronze.erp_loc_a101(
	CID	varchar(50),
	CNTRY varchar(50)
	);
if object_id ('bronze.erp_px_cat_g1v2','U') is not null
	drop table bronze.erp_px_cat_g1v2
create table bronze.erp_px_cat_g1v2(
	ID varchar(50),
	CAT	varchar(50),
	SUBCAT	varchar(50),
	MAINTENANCE varchar(5)
	);
