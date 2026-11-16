@echo off
rem LB_CMD.cmd - checks LB-CMD/1 weight sets as text, never running a shard (tools\KGD_ENGINE.cmd lb).
rem   tools\LB_CMD.cmd verify weights\model2-tier1\manifest.cmd --cap 24000000 --bound
rem   tools\LB_CMD.cmd combined weights\COMBINED-MANIFEST.cmd --cap 24000000 --total-cap 1000000000
rem   tools\LB_CMD.cmd bound SHARD.cmd     tools\LB_CMD.cmd decode SHARD.cmd
call "%~dp0KGD_ENGINE.cmd" lb %*
exit /b %errorlevel%
