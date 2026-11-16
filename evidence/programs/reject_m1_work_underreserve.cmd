@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): reject_m1_work_underreserve.json. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to print the document, with /check to check its SHA-512, or with /extract FILE to write it out.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=reject_m1_work_underreserve.json"
set "LB_DOC_TYPE=json"
set "LB_DOC_BYTES=665"
set "LB_DOC_SHA512=c0d7e4dd02bc91e4a6d1718fdff191dbd45fbfdfd79edbad573a4435dd04b190d57359b7a402341771c0492969ba8958354408b52ff5ea8dd9829448ae9f8c02"
set "LB_SELF=%~f0"
set "LB_ARG=%~1"
set "LB_OUT=%~f2"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$n=[int]$env:LB_DOC_BYTES;$b=[IO.File]::ReadAllBytes($env:LB_SELF);$o=$b.Length-$n;$h=-join((New-Object Security.Cryptography.SHA512Managed).ComputeHash($b,$o,$n)|%%{$_.ToString('x2')});if($h -ne $env:LB_DOC_SHA512){[Console]::Error.WriteLine('LB-DOC/1: the SHA-512 of '+$env:LB_DOC+' differs from LB_DOC_SHA512');exit 1};if($env:LB_ARG -eq '/check'){'ok: '+$env:LB_DOC;exit 0};if($env:LB_ARG -eq '/extract'){$d=New-Object byte[] $n;[Array]::Copy($b,$o,$d,0,$n);[IO.File]::WriteAllBytes($env:LB_OUT,$d);'written: '+$env:LB_OUT;exit 0};[Console]::OutputEncoding=New-Object Text.UTF8Encoding $false;[Console]::Out.Write([Text.Encoding]::UTF8.GetString($b,$o,$n));exit 0"
set "LB_RC=%errorlevel%"
if "%LB_ARG%"=="" pause
exit /b %LB_RC%
rem ---- document ----
{
 "program": "kgd/reject_m1_work_underreserve.cmd",
 "source_sha512": "be3896ca00225697a1748aff33535191c1c3479d30fdd90650b0f19c7f3e12e8747e3d73ec0fa6e2f07e31255483881f948ac47ca1265c91cb926a24c6d5b168",
 "file_sha512": "0fd49d9155419ef969dd0d38c145eb30655854a3786038bf24742213b2013baec7d6f115b49723edfc46abcc363f1958e76885d68f099acd7b5b5e9906ab8a72",
 "runner": "lcufx\\LCUFX_KGD.cmd run --twice (tools\\KGD_ENGINE.cmd host)",
 "expected": "reject",
 "observed": "reject",
 "as_expected": true,
 "exit_code": 2,
 "seconds": 0.0,
 "output": {
  "status": "rejected",
  "diagnostic": "line 14: kernel work reservation below modeled minimum (23592959 < 23592960)"
 }
}