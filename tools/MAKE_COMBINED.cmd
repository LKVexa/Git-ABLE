@echo off
rem MAKE_COMBINED.cmd WEIGHTS_DIR - writes WEIGHTS_DIR\COMBINED-MANIFEST.cmd over the three sets.
call "%~dp0KGD_ENGINE.cmd" gen combined %*
exit /b %errorlevel%
