/*
==========================================
Create a database and schemas
==========================================
Script Purpose:
	This  script creates a new database and its schema, After checking if it already exists.
	It is creating 3 schemas: bronze, silver, and gold under DataWarehouse
Warning:
	Running this script will drop the entire 'DataWarehouse' database, if it exists.
	All the data in the database will be permanently deleted.
	Proceed with caution and ensure you have proper backups before running this script
--
*/
use master;
GO
-- drop and recreate the database"DataWarehouse"
if  exists(select 1 from sys.databases where name='DataWarehouse')
	Begin 
		Alter database DataWarehouse Set Single_user with Rollback immediate;	
		drop database DataWarehouse;
	End;
Go
  --create DW
Create Database DataWarehouse;
GO
use DataWarehouse;
-- interview with the source system expert to understand the source system
-- data ingestion: how to load the data from the source system
-- data validation, data completeness, schema check.
-- data documentation version in git
go
  -- Create Schema
create schema bronze;
go
create schema silver;
go
create schema gold;
go
