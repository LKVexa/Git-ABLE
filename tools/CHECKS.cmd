@echo off
rem CHECKS.cmd grad | factored SMALL_DIR | size-drift PKG_DIR | size-bound PKG_DIR TMP_DIR   [--out FILE.cmd]
rem the gradient check, the factored-path check and the size bounds (tools\KGD_ENGINE.cmd check).
call "%~dp0KGD_ENGINE.cmd" check %*
exit /b %errorlevel%
