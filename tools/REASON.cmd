@echo off
rem REASON.cmd bayes|admit|meanfield|parity|witness|codelen SPEC [--out FILE.cmd] | selftest [--out FILE.cmd] - the four-rail
rem reasoning layer RAILS-8S/1 (see REASONING-RAILS-8S.cmd). SPEC is a JSON file or a .cmd document such as examples\*.cmd.
call "%~dp0KGD_ENGINE.cmd" reason %*
exit /b %errorlevel%
