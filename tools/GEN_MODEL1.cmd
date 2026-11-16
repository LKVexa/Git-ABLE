@echo off
rem GEN_MODEL1.cmd OUT_DIR [--seed 0] - writes model 1's seed-0 initialization (untrained) as its exact and Tier-2
rem sets, bit for bit the files in weights\model1-untrained (tools\KGD_ENGINE.cmd gen model1).
call "%~dp0KGD_ENGINE.cmd" gen model1 %*
exit /b %errorlevel%
