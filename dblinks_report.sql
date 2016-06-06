-- Drop existing database link 
drop database link SKELPROD@LOC_SKELET_PROD_NEW;
-- Create database link 
create database link SKELPROD@LOC_SKELET_PROD_NEW
  connect to SKELET
  identified by Icon7p2
  using '(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)
  (HOST=192.168.72.100)(PORT=1521)))
  (CONNECT_DATA=(SERVICE_NAME=SKELPROD))
)';
