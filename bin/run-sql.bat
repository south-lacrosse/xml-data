@echo off
echo %DATE% %TIME% Starting SQL %1
mysql -uroot -proot local < %1
echo %DATE% %TIME% Completed