@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): verify-certutil-model1-exact.txt. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to print the document, with /check to check its SHA-512, or with /extract FILE to write it out.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=verify-certutil-model1-exact.txt"
set "LB_DOC_TYPE=text"
set "LB_DOC_BYTES=396"
set "LB_DOC_SHA512=174e1e22bdd0bbe55d819e4a9934cecb81344bfbf3179e239f35c1ea23640dc2ee8c6aa847c80fef8c2bdbacfec07cfa88b50ead3a2ec930d3e7222890c2a443"
set "LB_SELF=%~f0"
set "LB_ARG=%~1"
set "LB_OUT=%~f2"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$n=[int]$env:LB_DOC_BYTES;$b=[IO.File]::ReadAllBytes($env:LB_SELF);$o=$b.Length-$n;$h=-join((New-Object Security.Cryptography.SHA512Managed).ComputeHash($b,$o,$n)|%%{$_.ToString('x2')});if($h -ne $env:LB_DOC_SHA512){[Console]::Error.WriteLine('LB-DOC/1: the SHA-512 of '+$env:LB_DOC+' differs from LB_DOC_SHA512');exit 1};if($env:LB_ARG -eq '/check'){'ok: '+$env:LB_DOC;exit 0};if($env:LB_ARG -eq '/extract'){$d=New-Object byte[] $n;[Array]::Copy($b,$o,$d,0,$n);[IO.File]::WriteAllBytes($env:LB_OUT,$d);'written: '+$env:LB_OUT;exit 0};[Console]::OutputEncoding=New-Object Text.UTF8Encoding $false;[Console]::Out.Write([Text.Encoding]::UTF8.GetString($b,$o,$n));exit 0"
set "LB_RC=%errorlevel%"
if "%LB_ARG%"=="" pause
exit /b %LB_RC%
rem ---- document ----
tools\VERIFY_WEIGHTS.cmd weights\model1-untrained\exact 9f315674d7264f8daba1e8eb0f83d43de54f12ee559e9978d7e7ecefcaf79722c09be281f14dcf9a92f0cfea5fed11039a0434bfa260277d8bb7356dba12c54d
SHA512SUMS.cmd SHA-512: 9f315674d7264f8daba1e8eb0f83d43de54f12ee559e9978d7e7ecefcaf79722c09be281f14dcf9a92f0cfea5fed11039a0434bfa260277d8bb7356dba12c54d
shards: 5 match, 0 differ or are missing
exit code: 0
