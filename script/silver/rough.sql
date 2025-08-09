Rough Work
GO
Select	cst_id,
		cst_key,
		cst_firstname,
		cst_lastname,
		cst_marital_status,
		cst_gndr,
		cst_create_date
from silver.crm_cust_info;
GO

--  chk for duplicates id in it
-- expectating no result
Select	cst_id,count(*)			
from silver.crm_cust_info
group by cst_id
having count(*)>1;
Select	cst_key,count(*)			
from silver.crm_cust_info
group by cst_key
having count(*)>1;

select * from(
Select  *, row_number() over(partition by cst_id order by cst_create_date) as flag_last 
from silver.crm_cust_info
where cst_id is not null) a
--group by cst_id,cst_create_date
where flag_last > 1
	-- in (29449,29473,29433,NULL,29483,29466)
;
-- firstname and last name trim the space rename the column to proper
Select trim (cst_firstname),trim(cst_lastname)
from silver.crm_cust_info
where trim (cst_firstname)!=cst_firstname or trim(cst_lastname)!=cst_lastname

-- In Marital_status M to Married,Single
Select  distinct /*case when upper(Trim(cst_marital_status) ) ='M' then 'Maried'
		when upper(Trim(cst_marital_status) ) ='S' then 'Single'
		else 'n/a'
		end,*/
		cst_gndr
from silver.crm_cust_info


select Distinct  prd_id,
	prd_key,
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt
from bronze.crm_prod_info;

select prd_id, count(*)
from bronze.crm_prod_info
	group by prd_id
	having count(*) >1 or prd_id is null;

select prd_id,
	prd_key,-- split it into to
	replace(substring (prd_key,1,5),'-','_') as cat_id,-- to connect with the cat table
	substring(prd_key,7,len(prd_key)) as prd_key-- to connect with the sales table
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt
from bronze.crm_prod_info
where replace(substring (prd_key,1,5),'-','_')not in (select id from bronze.erp_PX_CAT_G1V2)
;
-- to be able to connect with the erp_PX_CAT_G1V2 need to transfor its id column accordingly
select prd_id,
	prd_key,-- split it into to
	replace(substring (prd_key,1,5),'-','_') as cat_id,--7 product cat no order to connect with the cat table
	substring(prd_key,7,len(prd_key)) as prd_key,-- to connect with the sales table
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt
from bronze.crm_prod_info
where substring(prd_key,7,len(prd_key))not in (select sls_prd_key from bronze.crm_sales_details)
--220 many product do not have anyorder;

-- check for unwanted space
-- expectaion no value
select 	prd_nm
	from bronze.crm_prod_info
	where trim(prd_nm) != prd_nm;
-- check for negative and null value
-- expectaion no result
select 	prd_cost
	from bronze.crm_prod_info
	where prd_cost<=0 and prd_cost is null;
-- data standarization and consitency
select distinct prd_line
from bronze.crm_prod_info;

--Mountain,Road,Other Sales,Touring	
select *,case when upper(trim(prd_line)) ='M' then 'Mountain'
			when upper(trim(prd_line)) ='R' then 'Road'
			when upper(trim(prd_line)) ='S' then 'Other Sales'
			when upper(trim(prd_line)) ='T' then 'Touring'
			Else 'n/a'
		end
from bronze.crm_prod_info;
-- where end date is should be less then the start date
-- chk  any invalid date order
select	prd_start_dt,prd_end_dt
from bronze.crm_prod_info-- 397
where prd_start_dt>prd_end_dt -- 200 such cases
		or	prd_start_dt is null --  confirming any product without start date
		or	prd_end_dt is null;-- activate product 
-- kepping the start date as it is and generating the end date for the start dates lead
select  *
from bronze.crm_prod_info --397
where prd_start_dt>prd_end_dt ;--120/ other are null dates
-- changes made to 
select  prd_key,prd_start_dt,prd_end_dt,
		dateadd(day,-1,lead(prd_start_dt) over (partition by prd_key order by prd_start_dt) )as new_prd_end_dt
from bronze.crm_prod_info where  prd_start_dt>prd_end_dt or prd_end_dt is null 

select sls_ord_num,
		sls_prd_key,
		sls_cust_id,
		sls_order_dt,-- change to date
		sls_ship_dt,-- change to date
		sls_due_dt,--change to date cast not working
		sls_sales,
		sls_quantity,
		sls_price from bronze.crm_sales_details;
select 
	sls_ship_dt
from bronze.crm_sales_details
where sls_ship_dt<=0 -- found no negative, no 0 date
	or sls_ship_dt is null-- no null dates
	or sls_ship_dt>20250101 -- no such abnomilies found
	or sls_ship_dt< 19900101-- found no abnomilies
	
select case when sls_ship_dt<=0 or len(sls_due_dt) != 8 then Null
			else cast (cast(sls_due_dt as varchar) as date)
		end
			sls_ship_dt
from bronze.crm_sales_details



Select cid,bdate,gen from bronze.erp_CUST_AZ12 where cid like 'AW%';-- details of the customer date of birth and gender
-- testing: the duplicate 
-- expectation: no result
select cid,count(*)from bronze.erp_CUST_AZ12 group by cid having count(*)>1;-- no duplicate id exist 
-- cehcking to connect with the customer table
select * from [silver].[crm_cust_info] where cst_id=11000;--where cst_key like 'NA*%';-- no id in cst table sttarts with NA
-- removing NAS from the cid -- forming cst_key
select case when len(cid)>10 then substring(cid,4,len(cid))
			when len(cid)<=10 then cid
			end,
			cid
from bronze.erp_CUST_AZ12-- 18483
where substring(cid,4,len(cid))not in(select cst_key from [silver].[crm_cust_info] )
order by cid --11042 all
--0022042 checking for this in [silver].[crm_cust_info]

select cst_key from [silver].[crm_cust_info] where cst_key like '%0022042'

Select distinct gen
from bronze.erp_CUST_AZ12

select gen , case when (upper(trim(gen)) in('M','MALE')) then 'Male'
				when (upper(trim(gen)) in ('F','FEMALE')) then 'Female'
				else 'n/a'
				end
				gen
from bronze.erp_CUST_AZ12;

select bdate from bronze.erp_CUST_AZ12 where year(bdate) < 1970 and year(bdate)>2025;

Select replace(trim(upper(cid)),'-','') from bronze.erp_LOC_A101 where replace(trim(upper(cid)),'-','') not in(select cst_key from bronze.crm_cust_info);
select distinct upper(trim(cntry)) from bronze.erp_LOC_A101;
-- Step 1: Create the temp table first
CREATE TABLE ##temp_chk (
    cntry VARCHAR(100)  -- Define appropriate datatype
);


insert into ##temp_chk 
NULL 

DE,GERMANY  Then Germany
USA,US,UNITED STATES then United States
AUSTRALIA  then Australia
UNITED KINGDOM United Kingdom
CANADA then Canada
FRANCE then France
select distinct case when upper(trim(cntry)) in ('US','USA','UNITED STATES') THEN 'United States'
			when upper(trim(cntry)) in ('UK','UNITED KINGDOM') THEN 'United Kingdom'
			When upper(trim(cntry)) in ('GERMANY', 'GER','DE') THEN 'Germany'
			When upper(trim(cntry)) in ('AUSTRALIA','AUS') THEN 'Australia'
			When upper(trim(cntry)) in ('CANADA','CAN') THEN 'Canada'
			When upper(trim(cntry)) in ('FRANCE','FRA') THEN 'France'
			else 'n/a'
			end  cntry 
from  bronze.erp_LOC_A101
select cntry from ##temp_chk  where cntry  not in('n/a','United States','United kingdom','Germany','Australia','Canada','France');
Select * from bronze.erp_LOC_A101;
Select * from bronze.erp_PX_CAT_G1V2;
select distinct Cat from bronze.erp_PX_CAT_G1V2

--id=cat_id in product info which is already convert into _ format 
Select id from bronze.erp_PX_CAT_G1V2 where id  not in (select cat_id from silver.crm_prod_info);
select  distinct cat_id from silver.crm_prod_info where cat_id not in (Select id from bronze.erp_PX_CAT_G1V2);

