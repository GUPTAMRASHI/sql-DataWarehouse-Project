--test cases

--  chk for duplicates id in it
-- expectating no result
Select	cst_id,count(*)			
from silver.crm_cust_info
group by cst_id
having count(*)>1;

-- firstname and last name trim the space rename the column to proper
Select (cst_firstname),
		(cst_lastname)
from silver.crm_cust_info
where trim (cst_firstname)!=cst_firstname 
	or trim(cst_lastname)!=cst_lastname
--
Select  distinct
		cst_gndr
from silver.crm_cust_info

--
select prd_id, count(*)
from bronze.crm_prod_info
	group by prd_id
	having count(*) >1 or prd_id is null;

-- check for unwanted space
-- expectaion no value
select 	prd_nm
from silver.crm_prod_info
where trim(prd_nm) != prd_nm;

-- check for negative and null value
-- expectaion no result
select 	prd_cost
from silver.crm_prod_info
where prd_cost<=0 and prd_cost is null;

-- data standarization and consitency
-- expectaion all the cat with Mountain,n/a,Other Sales,Road,Touring no short abrevation
select distinct prd_line
from silver.crm_prod_info;

-- where end date is should be less then the start date
-- chk  any invalid date order
select	prd_start_dt,prd_end_dt
from silver.crm_prod_info-- 397
where prd_start_dt>prd_end_dt 

-- chk  any invalid date order
--expecting no result
select 
	sls_order_dt
from silver.crm_sales_details
where sls_order_dt<=0 -- found no negative, but 17 0 date
	or sls_order_dt is null-- no null dates
	or sls_order_dt >20250101
	or sls_order_dt < 19900101;-- 32154,5489 found two abnomilies
-- chk  any invalid date order
--expecting no result
select 
	sls_due_dt
from silver.crm_sales_details
where sls_due_dt<=0 -- found no negative, no 0 date
	or sls_due_dt is null-- no null dates
	or sls_due_dt >20250101 -- no such abnomilies found
	or sls_due_dt< 19900101-- found no abnomilies
	or sls_order_dt < 19900101;-- found  no abnomilies
-- chk  any invalid date order
--expecting no result
select 
	sls_ship_dt
from bronze.crm_sales_details
where sls_ship_dt<=0 -- found no negative, no 0 date
	or sls_ship_dt is null-- no null dates
	or sls_ship_dt>20250101 -- no such abnomilies found
	or sls_ship_dt< 19900101;-- found no abnomilies

--check duplicate
--expecting no result
select cid,count(*)from bronze.erp_CUST_AZ12 group by cid having count(*)>1;

-- Test case: fetch all customer IDs not starting with 'AW' - inorder t match with the custinfo table cst_key
-- expecting no result
select 	cid
from bronze.erp_CUST_AZ12
where upper(trim(cid))  not like 'AW%';
-- test case: checking the distinct valuse in gender
-- expecting result male,female,n/a
Select distinct gen
from bronze.erp_CUST_AZ12;

-- testing any anomilies customer age
--expecting no result
select bdate 
from bronze.erp_CUST_AZ12 
where year(bdate) < 1970 and year(bdate)>2025
-- test case : 
-- expecting no result
Select cid
from bronze.erp_LOC_A101
where cid not in(select cst_key from bronze.crm_cust_info);
--test case:check if teh cntry lies in the specified cuntry only id 
-- expecting no output
select cntry 
from  bronze.erp_LOC_A101
where cntry  not in('n/a','United States','United kingdom','Germany','Australia','Canada','France');;

-- test case 
select distinct SubCat from bronze.erp_PX_CAT_G1V2
select distinct Cat from bronze.erp_PX_CAT_G1V2
select distinct Maintenance from bronze.erp_PX_CAT_G1V2
Select id from bronze.erp_PX_CAT_G1V2 where id  not in (select cat_id from silver.crm_prod_info);
select  distinct cat_id from silver.crm_prod_info where cat_id not in (Select id from bronze.erp_PX_CAT_G1V2);

