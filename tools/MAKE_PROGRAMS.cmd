@echo off
rem MAKE_PROGRAMS.cmd PKG_DIR - writes the LCUF-X programs in lcufx\programs from the weight sets, with exact
rem work reservations (tools\KGD_ENGINE.cmd programs make).
call "%~dp0KGD_ENGINE.cmd" programs make %*
exit /b %errorlevel%
