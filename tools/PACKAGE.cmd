@echo off
rem PACKAGE.cmd write PKG_DIR | verify PKG_DIR - the SHA-512 of every file (PACKAGE-MANIFEST.cmd). verify also checks
rem that every file is a .cmd file (except README.md and .gitattributes) and none is over 24,000,000 bytes.
call "%~dp0KGD_ENGINE.cmd" package %*
exit /b %errorlevel%
