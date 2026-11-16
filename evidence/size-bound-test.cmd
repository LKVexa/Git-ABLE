@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): size-bound-test.json. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to print the document, with /check to check its SHA-512, or with /extract FILE to write it out.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=size-bound-test.json"
set "LB_DOC_TYPE=json"
set "LB_DOC_BYTES=333"
set "LB_DOC_SHA512=4a090c55a2e848d441cb2dddb45e9936509852fea5ada6d969eda066b8ae066ee2d282e88d4b7f090c4eaefa9d2efa7db2d7ca9d7a0076bc2ad439a19a09dc05"
set "LB_SELF=%~f0"
set "LB_ARG=%~1"
set "LB_OUT=%~f2"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$n=[int]$env:LB_DOC_BYTES;$b=[IO.File]::ReadAllBytes($env:LB_SELF);$o=$b.Length-$n;$h=-join((New-Object Security.Cryptography.SHA512Managed).ComputeHash($b,$o,$n)|%%{$_.ToString('x2')});if($h -ne $env:LB_DOC_SHA512){[Console]::Error.WriteLine('LB-DOC/1: the SHA-512 of '+$env:LB_DOC+' differs from LB_DOC_SHA512');exit 1};if($env:LB_ARG -eq '/check'){'ok: '+$env:LB_DOC;exit 0};if($env:LB_ARG -eq '/extract'){$d=New-Object byte[] $n;[Array]::Copy($b,$o,$d,0,$n);[IO.File]::WriteAllBytes($env:LB_OUT,$d);'written: '+$env:LB_OUT;exit 0};[Console]::OutputEncoding=New-Object Text.UTF8Encoding $false;[Console]::Out.Write([Text.Encoding]::UTF8.GetString($b,$o,$n));exit 0"
set "LB_RC=%errorlevel%"
if "%LB_ARG%"=="" pause
exit /b %LB_RC%
rem ---- document ----
{
 "shard": "weights/model1-untrained/tier2/shard_EMB.cmd",
 "bytes_now": 83133,
 "computed_bound": 87800,
 "worst_case_file_bytes": 87800,
 "worst_case_file_reads_back": true,
 "method": "every payload value replaced by -2147483648, LB_L1_CHECKSUM set to lines x 2^31, payload SHA-512 recomputed",
 "bound_equals_worst_case": true
}