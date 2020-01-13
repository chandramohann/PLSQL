-- Drop existing database link 
drop database link SKPRPROD@LOC_PROD_NEW;
-- Create database link 
create database link SKPRPROD@LOC_PROD_NEW
  connect to SSSSSSSS
  identified by XXXXX
  using '(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)
  (HOST=192.168.72.100)(PORT=1521)))
  (CONNECT_DATA=(SERVICE_NAME=SKPRPROD))
)';
