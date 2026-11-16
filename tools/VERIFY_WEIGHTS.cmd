@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem VERIFY_WEIGHTS.cmd SET_FOLDER [EXPECTED_SHA512_OF_SHA512SUMS.cmd]
rem Checks every shard listed in SET_FOLDER\SHA512SUMS.cmd with certutil -hashfile ... SHA512, without the engine.
rem It reads the shards as files and never runs them. It also prints the SHA-512 of SHA512SUMS.cmd itself:
rem pass the value from README.md as the second argument to have it compared.
rem Exit 0: every listed shard matches; 1: a shard differs or is missing, or SHA512SUMS.cmd differs; 2: usage.
if "%~1"=="" goto :vw_usage
set "VW_DIR=%~f1"
set "VW_SUMS=%~f1\SHA512SUMS.cmd"
if not exist "%VW_SUMS%" goto :vw_nosums
set "VW_OK=0"
set "VW_BAD=0"
for /f "tokens=1,2" %%A in ('findstr /r /b /c:"[0-9a-f]*  shard_" "%VW_SUMS%"') do call :vw_one "%%A" "%%B"
call :vw_hash "%VW_SUMS%"
echo SHA512SUMS.cmd SHA-512: %VW_HASH%
echo shards: %VW_OK% match, %VW_BAD% differ or are missing
if not "%~2"=="" if /i not "%VW_HASH%"=="%~2" goto :vw_sums_differ
if not "%VW_BAD%"=="0" exit /b 1
if "%VW_OK%"=="0" goto :vw_empty
exit /b 0
:vw_one
if not exist "%VW_DIR%\%~2" goto :vw_missing
call :vw_hash "%VW_DIR%\%~2"
if /i "%VW_HASH%"=="%~1" (set /a VW_OK+=1) else (set /a VW_BAD+=1 & echo MISMATCH %~2)
exit /b 0
:vw_missing
set /a VW_BAD+=1
echo MISSING %~2
exit /b 0
:vw_hash
set "VW_HASH="
for /f "skip=1 delims=" %%H in ('certutil -hashfile "%~1" SHA512 ^| findstr /v /c:"CertUtil"') do if not defined VW_HASH set "VW_HASH=%%H"
if defined VW_HASH set "VW_HASH=%VW_HASH: =%"
exit /b 0
:vw_usage
echo usage: VERIFY_WEIGHTS.cmd SET_FOLDER [EXPECTED_SHA512_OF_SHA512SUMS.cmd]
exit /b 2
:vw_nosums
echo SHA512SUMS.cmd not found in "%VW_DIR%"
exit /b 2
:vw_sums_differ
echo SHA512SUMS.cmd differs from the expected value
exit /b 1
:vw_empty
echo no shard lines found in SHA512SUMS.cmd
exit /b 1
