@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): reject_kgd_imq_profile_at_core_compiler.json. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to print the document, with /check to check its SHA-512, or with /extract FILE to write it out.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=reject_kgd_imq_profile_at_core_compiler.json"
set "LB_DOC_TYPE=json"
set "LB_DOC_BYTES=637"
set "LB_DOC_SHA512=14c755b876f7c6a3cf91f001a9fe198c54f82244449af1313f3197619f636d86d8d35143a2caef20337a3133e839e0ed11a70da3dbd6d16fee9576589e4ad550"
set "LB_SELF=%~f0"
set "LB_ARG=%~1"
set "LB_OUT=%~f2"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$n=[int]$env:LB_DOC_BYTES;$b=[IO.File]::ReadAllBytes($env:LB_SELF);$o=$b.Length-$n;$h=-join((New-Object Security.Cryptography.SHA512Managed).ComputeHash($b,$o,$n)|%%{$_.ToString('x2')});if($h -ne $env:LB_DOC_SHA512){[Console]::Error.WriteLine('LB-DOC/1: the SHA-512 of '+$env:LB_DOC+' differs from LB_DOC_SHA512');exit 1};if($env:LB_ARG -eq '/check'){'ok: '+$env:LB_DOC;exit 0};if($env:LB_ARG -eq '/extract'){$d=New-Object byte[] $n;[Array]::Copy($b,$o,$d,0,$n);[IO.File]::WriteAllBytes($env:LB_OUT,$d);'written: '+$env:LB_OUT;exit 0};[Console]::OutputEncoding=New-Object Text.UTF8Encoding $false;[Console]::Out.Write([Text.Encoding]::UTF8.GetString($b,$o,$n));exit 0"
set "LB_RC=%errorlevel%"
if "%LB_ARG%"=="" pause
exit /b %LB_RC%
rem ---- document ----
{
 "program": "core/reject_kgd_imq_profile_at_core_compiler.cmd",
 "source_sha512": "6ed9691650e8acadc2139d36a8dbab7440933413aba2836a9ff3b064fff2434b1c2c15d603f6f3b03f2fd5596e58f5eacd7bf2b26a3cc3475a9751eb237006b7",
 "file_sha512": "849b2bcdbc9858fb986aa43c9f6723d77ac8dfc19343789c880bc97b7f72a6e3062edf036736527761e95abde698b95dbde92c7c1b835715e55b84119bab4046",
 "runner": "lcuf_x.py (the user's LCUF-X/0.2 compiler)",
 "expected": "reject",
 "observed": "not_run",
 "as_expected": false,
 "exit_code": -1,
 "seconds": 0.0,
 "output": {
  "status": "not_run",
  "note": "pass --core LCUF_X_DIR (the folder of lcuf_x.py) to run it"
 }
}