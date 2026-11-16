@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): reject_m2_tier2_unavailable.json. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to print the document, with /check to check its SHA-512, or with /extract FILE to write it out.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=reject_m2_tier2_unavailable.json"
set "LB_DOC_TYPE=json"
set "LB_DOC_BYTES=458"
set "LB_DOC_SHA512=bb6f5dcbd4cad5993a45e35b915d77973d8a4b4741dd4804e5db21172c346f515f3a5144ffb60211d19001bcc18024043d9db20c75015b447edcb0f93e2b13a6"
set "LB_SELF=%~f0"
set "LB_ARG=%~1"
set "LB_OUT=%~f2"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$n=[int]$env:LB_DOC_BYTES;$b=[IO.File]::ReadAllBytes($env:LB_SELF);$o=$b.Length-$n;$h=-join((New-Object Security.Cryptography.SHA512Managed).ComputeHash($b,$o,$n)|%%{$_.ToString('x2')});if($h -ne $env:LB_DOC_SHA512){[Console]::Error.WriteLine('LB-DOC/1: the SHA-512 of '+$env:LB_DOC+' differs from LB_DOC_SHA512');exit 1};if($env:LB_ARG -eq '/check'){'ok: '+$env:LB_DOC;exit 0};if($env:LB_ARG -eq '/extract'){$d=New-Object byte[] $n;[Array]::Copy($b,$o,$d,0,$n);[IO.File]::WriteAllBytes($env:LB_OUT,$d);'written: '+$env:LB_OUT;exit 0};[Console]::OutputEncoding=New-Object Text.UTF8Encoding $false;[Console]::Out.Write([Text.Encoding]::UTF8.GetString($b,$o,$n));exit 0"
set "LB_RC=%errorlevel%"
if "%LB_ARG%"=="" pause
exit /b %LB_RC%
rem ---- document ----
{
 "program": "kgd/reject_m2_tier2_unavailable.lcufx",
 "source_sha512": "61289a52669d6aa338898e1c915545f53b52fd0aac2a53b4cb495bec9889053a5c95bcba77c252aa4d5969584aa332b1708ea013e121dc924c22d9ecad4bdebe",
 "runner": "lcufx_kgd.py run --twice",
 "expected": "reject",
 "observed": "reject",
 "as_expected": true,
 "exit_code": 2,
 "seconds": 0.1,
 "output": {
  "status": "rejected",
  "diagnostic": "line 9: tier TIER-2 is not available in a TIER-1 set"
 }
}