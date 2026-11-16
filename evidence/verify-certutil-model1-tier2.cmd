@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): verify-certutil-model1-tier2.txt. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to print the document, with /check to check its SHA-512, or with /extract FILE to write it out.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=verify-certutil-model1-tier2.txt"
set "LB_DOC_TYPE=text"
set "LB_DOC_BYTES=396"
set "LB_DOC_SHA512=e7b5c4e530f5462857ddc942fb138f3cbdcc1d651a98cb12a83fd54f915897320a604027690f64512ccdecc9d08d1766103a775f8d77e283ae721dde9f3285b1"
set "LB_SELF=%~f0"
set "LB_ARG=%~1"
set "LB_OUT=%~f2"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$n=[int]$env:LB_DOC_BYTES;$b=[IO.File]::ReadAllBytes($env:LB_SELF);$o=$b.Length-$n;$h=-join((New-Object Security.Cryptography.SHA512Managed).ComputeHash($b,$o,$n)|%%{$_.ToString('x2')});if($h -ne $env:LB_DOC_SHA512){[Console]::Error.WriteLine('LB-DOC/1: the SHA-512 of '+$env:LB_DOC+' differs from LB_DOC_SHA512');exit 1};if($env:LB_ARG -eq '/check'){'ok: '+$env:LB_DOC;exit 0};if($env:LB_ARG -eq '/extract'){$d=New-Object byte[] $n;[Array]::Copy($b,$o,$d,0,$n);[IO.File]::WriteAllBytes($env:LB_OUT,$d);'written: '+$env:LB_OUT;exit 0};[Console]::OutputEncoding=New-Object Text.UTF8Encoding $false;[Console]::Out.Write([Text.Encoding]::UTF8.GetString($b,$o,$n));exit 0"
set "LB_RC=%errorlevel%"
if "%LB_ARG%"=="" pause
exit /b %LB_RC%
rem ---- document ----
tools\VERIFY_WEIGHTS.cmd weights\model1-untrained\tier2 dd58bb438a1c15d413ac798287d2f09c5bef01f0b1f8c8d613410d7aa1d796135bf2b59940b598015f9d6e771aa7532c7532e235d300a097b2d5785ccdf16ed4
SHA512SUMS.cmd SHA-512: dd58bb438a1c15d413ac798287d2f09c5bef01f0b1f8c8d613410d7aa1d796135bf2b59940b598015f9d6e771aa7532c7532e235d300a097b2d5785ccdf16ed4
shards: 5 match, 0 differ or are missing
exit code: 0
