@echo off
rem Create MySQL tables from the history XML
cd %~dp0
call run-sql.bat ..\database\create-history.sql
perl %~dp0import-history.pl
call run-sql.bat ..\database\create-history-extras.sql
