@echo off
rem MAKE_DATA.cmd pack FILE OUT_DIR STEM LABEL - stores a file as LB-CMD/1 BYTES shards (4 bytes per word).
rem MAKE_DATA.cmd unpack OUT_FILE SHARD.cmd... - writes the original file back and checks its SHA-512.
call "%~dp0KGD_ENGINE.cmd" data %*
exit /b %errorlevel%
