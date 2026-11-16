@echo off
rem DOC.cmd print FILE.cmd | extract FILE.cmd OUT | check FILE.cmd... | pack IN OUT.cmd NAME TYPE - LB-DOC/1 files,
rem documents stored in .cmd files (each one also prints itself when run).
call "%~dp0KGD_ENGINE.cmd" doc %*
exit /b %errorlevel%
