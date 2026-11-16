@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem RUN_CORE.cmd check|compile|run PROGRAM.cmd [LCUF_X_DIR] - runs a core LCUF-X/0.2 program on your own compiler,
rem lcuf_x.py with its math_kernels.py, from LCUF_X_DIR (your LCUF_RESEARCH_CORPUS_0.2.0\extensions). That compiler is
rem a Python program, so this one step needs Python (python on PATH, or LCUF_PYTHON); nothing else in the package does.
set "RC_MODE=%~1"
set "RC_PROG=%~f2"
if not "%~3"=="" set "LCUF_X_DIR=%~f3"
if not defined LCUF_X_DIR goto :rc_nodir
if not exist "%LCUF_X_DIR%\lcuf_x.py" goto :rc_nodir
if not defined LCUF_PYTHON set "LCUF_PYTHON=python"
set "RC_TMP=%TEMP%\lkvexa-core-%RANDOM%%RANDOM%.lcufx"
call "%~dp0KGD_ENGINE.cmd" doc extract "%RC_PROG%" "%RC_TMP%"
if errorlevel 1 exit /b 2
"%LCUF_PYTHON%" -I -B -c "import sys,runpy; d=sys.argv[1]; sys.path.insert(0,d); sys.argv=[d+'\\lcuf_x.py']+sys.argv[2:]; runpy.run_path(sys.argv[0], run_name='__main__')" "%LCUF_X_DIR%" %RC_MODE% "%RC_TMP%"
set "RC_RC=%errorlevel%"
del "%RC_TMP%" >nul 2>nul
exit /b %RC_RC%
:rc_nodir
echo RUN_CORE: set LCUF_X_DIR to the folder of your lcuf_x.py, or pass it as the third argument. 1>&2
exit /b 2
