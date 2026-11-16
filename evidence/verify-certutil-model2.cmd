@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): verify-certutil-model2.txt. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to print the document, with /check to check its SHA-512, or with /extract FILE to write it out.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=verify-certutil-model2.txt"
set "LB_DOC_TYPE=text"
set "LB_DOC_BYTES=387"
set "LB_DOC_SHA512=3a8a61709e6e9ade59125d1c2c57c6beebfbc996498d78caead6837bc070b81a5b5472a8c218298e674795790aa3ba56b28225fa09aec079f3b5d26a51911008"
set "LB_SELF=%~f0"
set "LB_ARG=%~1"
set "LB_OUT=%~f2"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$n=[int]$env:LB_DOC_BYTES;$b=[IO.File]::ReadAllBytes($env:LB_SELF);$o=$b.Length-$n;$h=-join((New-Object Security.Cryptography.SHA512Managed).ComputeHash($b,$o,$n)|%%{$_.ToString('x2')});if($h -ne $env:LB_DOC_SHA512){[Console]::Error.WriteLine('LB-DOC/1: the SHA-512 of '+$env:LB_DOC+' differs from LB_DOC_SHA512');exit 1};if($env:LB_ARG -eq '/check'){'ok: '+$env:LB_DOC;exit 0};if($env:LB_ARG -eq '/extract'){$d=New-Object byte[] $n;[Array]::Copy($b,$o,$d,0,$n);[IO.File]::WriteAllBytes($env:LB_OUT,$d);'written: '+$env:LB_OUT;exit 0};[Console]::OutputEncoding=New-Object Text.UTF8Encoding $false;[Console]::Out.Write([Text.Encoding]::UTF8.GetString($b,$o,$n));exit 0"
set "LB_RC=%errorlevel%"
if "%LB_ARG%"=="" pause
exit /b %LB_RC%
rem ---- document ----
tools\VERIFY_WEIGHTS.cmd weights\model2-tier1 80f9bb76ba32bb4a8a8f6652f0553e77162827e2945774da072019d37f3a18312514ae6d8487af5775342cc56e077e7bfab815ac524163fcb5898bfa60230149
SHA512SUMS.cmd SHA-512: 80f9bb76ba32bb4a8a8f6652f0553e77162827e2945774da072019d37f3a18312514ae6d8487af5775342cc56e077e7bfab815ac524163fcb5898bfa60230149
shards: 70 match, 0 differ or are missing
exit code: 0
