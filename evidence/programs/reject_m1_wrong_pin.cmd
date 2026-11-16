@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): reject_m1_wrong_pin.json. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to print the document, with /check to check its SHA-512, or with /extract FILE to write it out.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=reject_m1_wrong_pin.json"
set "LB_DOC_TYPE=json"
set "LB_DOC_BYTES=629"
set "LB_DOC_SHA512=3a1139145f055844a6c782ce06a1255efe22a9db59f9863a0a785fd5017e228fc44315524a3a0b17e803ace94f2a352a5a2a4de77467322537487c1160b0d90d"
set "LB_SELF=%~f0"
set "LB_ARG=%~1"
set "LB_OUT=%~f2"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$n=[int]$env:LB_DOC_BYTES;$b=[IO.File]::ReadAllBytes($env:LB_SELF);$o=$b.Length-$n;$h=-join((New-Object Security.Cryptography.SHA512Managed).ComputeHash($b,$o,$n)|%%{$_.ToString('x2')});if($h -ne $env:LB_DOC_SHA512){[Console]::Error.WriteLine('LB-DOC/1: the SHA-512 of '+$env:LB_DOC+' differs from LB_DOC_SHA512');exit 1};if($env:LB_ARG -eq '/check'){'ok: '+$env:LB_DOC;exit 0};if($env:LB_ARG -eq '/extract'){$d=New-Object byte[] $n;[Array]::Copy($b,$o,$d,0,$n);[IO.File]::WriteAllBytes($env:LB_OUT,$d);'written: '+$env:LB_OUT;exit 0};[Console]::OutputEncoding=New-Object Text.UTF8Encoding $false;[Console]::Out.Write([Text.Encoding]::UTF8.GetString($b,$o,$n));exit 0"
set "LB_RC=%errorlevel%"
if "%LB_ARG%"=="" pause
exit /b %LB_RC%
rem ---- document ----
{
 "program": "kgd/reject_m1_wrong_pin.cmd",
 "source_sha512": "e479cb60c2e05c0f5a8ef2b9fe630e65a640e7bb81c2eaccdbf596a089cfbf85d287eea7ef76bb53497e46821bcb95ef8c370f0a7b214b241fd9cf5dd9066db7",
 "file_sha512": "4c1d5dc203f87af2060624dd5568a60eb1d57ded12ee631595dc754931520b38e168ef6ca1792e9405bba157626043f17296cbb8700282d19e16b827ffd16ea4",
 "runner": "lcufx\\LCUFX_KGD.cmd run --twice (tools\\KGD_ENGINE.cmd host)",
 "expected": "reject",
 "observed": "reject",
 "as_expected": true,
 "exit_code": 2,
 "seconds": 0.0,
 "output": {
  "status": "rejected",
  "diagnostic": "line 9: weight set SHA-512 is not the pinned one"
 }
}