@echo off
rem RUN_ALL.cmd PKG_DIR EVIDENCE_DIR [--only A,B] [--skip A,B] [--core LCUF_X_DIR] - runs every program and records
rem each run in EVIDENCE_DIR\programs; the core programs run only with --core (your lcuf_x.py, which needs Python).
call "%~dp0KGD_ENGINE.cmd" programs run-all %*
exit /b %errorlevel%
