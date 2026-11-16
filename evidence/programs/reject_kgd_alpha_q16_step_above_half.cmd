@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): reject_kgd_alpha_q16_step_above_half.json. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to print the document, with /check to check its SHA-512, or with /extract FILE to write it out.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=reject_kgd_alpha_q16_step_above_half.json"
set "LB_DOC_TYPE=json"
set "LB_DOC_BYTES=634"
set "LB_DOC_SHA512=19e688fead8919a499345a24222883546361e62cd4f3e3b8b779814281d2c121026c394145269caf8480dfc1313542c81ca052a0966efc8528d961e0c5b65ebb"
set "LB_SELF=%~f0"
set "LB_ARG=%~1"
set "LB_OUT=%~f2"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$n=[int]$env:LB_DOC_BYTES;$b=[IO.File]::ReadAllBytes($env:LB_SELF);$o=$b.Length-$n;$h=-join((New-Object Security.Cryptography.SHA512Managed).ComputeHash($b,$o,$n)|%%{$_.ToString('x2')});if($h -ne $env:LB_DOC_SHA512){[Console]::Error.WriteLine('LB-DOC/1: the SHA-512 of '+$env:LB_DOC+' differs from LB_DOC_SHA512');exit 1};if($env:LB_ARG -eq '/check'){'ok: '+$env:LB_DOC;exit 0};if($env:LB_ARG -eq '/extract'){$d=New-Object byte[] $n;[Array]::Copy($b,$o,$d,0,$n);[IO.File]::WriteAllBytes($env:LB_OUT,$d);'written: '+$env:LB_OUT;exit 0};[Console]::OutputEncoding=New-Object Text.UTF8Encoding $false;[Console]::Out.Write([Text.Encoding]::UTF8.GetString($b,$o,$n));exit 0"
set "LB_RC=%errorlevel%"
if "%LB_ARG%"=="" pause
exit /b %LB_RC%
rem ---- document ----
{
 "program": "core/reject_kgd_alpha_q16_step_above_half.cmd",
 "source_sha512": "6a0d43935724ef165c25b8114551d6cc0117a7d8e77e3b413a2c4611814eaa78f12695985bf4192adfede5ad28ce4efcace88016875a245d997b138852806d38",
 "file_sha512": "43b0d4f5d5b988cfa18a6d35f673801a17fda57b559e8523b5f5420254bac9cd582c06700ede18a9a2c01612ff8f1a5c968a5da3fa26fb9d8f0aacbface25677",
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