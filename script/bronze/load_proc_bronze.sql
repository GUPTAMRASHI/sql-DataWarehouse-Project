/*
========================================================================================================
Stored Procedure: Load Bronze Layar( from source to SQL Server bronze
========================================================================================================
Objective:
stored procedure to load the data from the external CSV file as it is into the bronze schema
    Truncate the bronze table before loading it.
    Insert the data from the external CSV file using the bulk insertion command into the bronze layer.

Parmenter:
      no input and output parameter 


-- Bulk insertion in the table
-- Mark the file should be closed before execution, and all the data types should be correctly defined

========================================================================================================
*/
create or alter procedure  bronze.load_bronze as 
Begin
		declare @start_time datetime,@end_time datetime , @batch_start_time datetime ,@batch_end_time datetime ;
		set @batch_start_time=GETDATE();
	begin try
		print '====================================================================';
		print ' loading the bronze layer';
		print '====================================================================';
		
		Print '--------------------------------------------------------------------';
		print ' loading the crm tables';
		Print '--------------------------------------------------------------------';
		set @start_time=GETDATE();
		print' Truncating the table: bronze.crm_cust_info ';
		truncate table bronze.crm_cust_info;
		print'inserting data into: bronze.crm_cust_info';
		bulk insert bronze.crm_cust_info
		from 'C:\Users\Drishti\Downloads\RASHI UPGRADES DATA\project\DataWarehouse\DataSet\crm\cust_info.csv'
		with ( 
			firstrow = 2,-- row data start from 2nd row 1st is the columnname
			fieldterminator=',',	-- csv file
			tablock --
		);
		set @end_time=GETDATE();

		print'>> Load Duration :' +cast(datediff(second,@start_time,@end_time) as nvarchar);
		Print'------------';

		set @start_time=GETDATE();

		print'truncate table : bronze.crm_prod_info';
		truncate table bronze.crm_prod_info;
		print'inserting data into : bronze.crm_prod_info';
		bulk insert bronze.crm_prod_info
		from 'C:\Users\Drishti\Downloads\RASHI UPGRADES DATA\project\DataWarehouse\DataSet\crm\prd_info.csv'
		with ( 
			firstrow = 2,-- row data start from 2nd row 1st is the columnname
			fieldterminator=',',	-- csv file
			tablock --
		);
		set @end_time=GETDATE();

		print'>> Load Duration :' +cast(datediff(second,@start_time,@end_time) as nvarchar);
		Print'------------';

		set @start_time=GETDATE();
		print ' truncating the table : bronze.crm_sales_details'; 
		truncate table  bronze.crm_sales_details;
		print'inserting data into : bronze.crm_sales_details';
		bulk insert  bronze.crm_sales_details
		from 'C:\Users\Drishti\Downloads\RASHI UPGRADES DATA\project\DataWarehouse\DataSet\crm\sales_details.csv'
		with ( 
			firstrow = 2,-- row data start from 2nd row 1st is the columnname
			fieldterminator=',',	-- csv file
			tablock --
		);
		set @end_time=GETDATE();

		print'>> Load Duration :' +cast(datediff(second,@start_time,@end_time) as nvarchar);
		Print'------------';

		set @start_time=GETDATE();

		Print '--------------------------------------------------------------------';
		print ' loading the erp tables';
		Print '--------------------------------------------------------------------';

		print'truncating the table : bronze.erp_cust_az12';
		truncate table bronze.erp_cust_az12;
		print'inserting data into : bronze.erp_cust_az12';
		bulk insert bronze.erp_cust_az12
		from 'C:\Users\Drishti\Downloads\RASHI UPGRADES DATA\project\DataWarehouse\DataSet\erp\CUST_AZ12.csv'
		with ( 
			firstrow = 2,-- row data start from 2nd row 1st is the columnname
			fieldterminator=',',	-- csv file
			tablock --
		);
		set @end_time=GETDATE();

		print'>> Load Duration :' +cast(datediff(second,@start_time,@end_time) as nvarchar);
		Print'------------';

		set @start_time=GETDATE();

		print'truncation table : bronze.erp_loc_a101';
		truncate table bronze.erp_loc_a101;
		print'inserting data into : bronze.erp_loc_a101';
		bulk insert bronze.erp_loc_a101
		from 'C:\Users\Drishti\Downloads\RASHI UPGRADES DATA\project\DataWarehouse\DataSet\erp\LOC_A101.csv'
		with ( 
			firstrow = 2,-- row data start from 2nd row 1st is the columnname
			fieldterminator=',',	-- csv file
			tablock --
		);
		set @end_time=GETDATE();

		print'>> Load Duration :' +cast(datediff(second,@start_time,@end_time) as nvarchar);
		Print'------------';

		set @start_time=GETDATE();
		print'truncation table : bronze.erp_px_cat_g1v2';
		truncate table bronze.erp_px_cat_g1v2;
		print'inserting data into : bronze.erp_px_cat_g1v2';
		bulk insert bronze.erp_px_cat_g1v2
		from 'C:\Users\Drishti\Downloads\RASHI UPGRADES DATA\project\DataWarehouse\DataSet\erp\PX_CAT_G1V2.csv'
		with ( 
			firstrow = 2,-- row data start from 2nd row 1st is the columnname
			fieldterminator=',',	-- csv file
			tablock --
		);-- 37
		set @end_time=GETDATE();

		print'>> Load Duration :' +cast(datediff(second,@start_time,@end_time) as nvarchar);
		Print'------------';
		set @start_time=GETDATE();

		set @batch_end_time=GETDATE();
		Print'------------';
		print'>> Total Loading Time: ' + cast(datediff(second,@batch_start_time,@batch_end_time)as nvarchar);
	end try 
	begin catch
		print'error occured';
		print'error message :' +error_message();
		print'error number :' + cast (error_number() as nvarchar);
		print'error message :' + cast (error_state() as nvarchar);
	end catch

End
-- doccument and draw.io
--Exec bronze.load_bronze and in gitrepo
