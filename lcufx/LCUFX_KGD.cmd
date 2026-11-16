@echo off
rem LCUFX_KGD.cmd check|run PROGRAM.cmd [--twice] - the host of the LCUF-X/0.2 profile lkvexa.kgd_imq/0.1
rem (tools\KGD_ENGINE.cmd host). Exit 0: admitted and every assertion passed; 2: refused.
call "%~dp0..\tools\KGD_ENGINE.cmd" host %*
exit /b %errorlevel%
