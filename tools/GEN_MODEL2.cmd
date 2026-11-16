@echo off
rem GEN_MODEL2.cmd OUT_DIR --d 52224 --layers 34 --seed 2026 --split - writes model 2's Tier-1 set (untrained),
rem bit for bit the files in weights\model2-tier1 (tools\KGD_ENGINE.cmd gen model2). --probe writes one layer only.
call "%~dp0KGD_ENGINE.cmd" gen model2 %*
exit /b %errorlevel%
