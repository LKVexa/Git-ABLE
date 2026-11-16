@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): accept_kgd_alpha_gate.json. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to print the document, with /check to check its SHA-512, or with /extract FILE to write it out.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=accept_kgd_alpha_gate.json"
set "LB_DOC_TYPE=json"
set "LB_DOC_BYTES=619"
set "LB_DOC_SHA512=3c3c28e2eadd202a83cc7b5756f88c9c96b385d9a3b7108db3d0811a01da994be45fd9357ea57a062d1cdecb489800445a67767fa3a9d6bb0a4465e2df7ff203"
set "LB_SELF=%~f0"
set "LB_ARG=%~1"
set "LB_OUT=%~f2"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$n=[int]$env:LB_DOC_BYTES;$b=[IO.File]::ReadAllBytes($env:LB_SELF);$o=$b.Length-$n;$h=-join((New-Object Security.Cryptography.SHA512Managed).ComputeHash($b,$o,$n)|%%{$_.ToString('x2')});if($h -ne $env:LB_DOC_SHA512){[Console]::Error.WriteLine('LB-DOC/1: the SHA-512 of '+$env:LB_DOC+' differs from LB_DOC_SHA512');exit 1};if($env:LB_ARG -eq '/check'){'ok: '+$env:LB_DOC;exit 0};if($env:LB_ARG -eq '/extract'){$d=New-Object byte[] $n;[Array]::Copy($b,$o,$d,0,$n);[IO.File]::WriteAllBytes($env:LB_OUT,$d);'written: '+$env:LB_OUT;exit 0};[Console]::OutputEncoding=New-Object Text.UTF8Encoding $false;[Console]::Out.Write([Text.Encoding]::UTF8.GetString($b,$o,$n));exit 0"
set "LB_RC=%errorlevel%"
if "%LB_ARG%"=="" pause
exit /b %LB_RC%
rem ---- document ----
{
 "program": "core/accept_kgd_alpha_gate.cmd",
 "source_sha512": "c5f9bc0a1d72fadc312fdc5222517beecfb886c9b47e9220fa789286e88da530e61cf068aca89a37717687df10cc24057b067a215d5d201b4daf4cdddea69d11",
 "file_sha512": "7570db0e7ce1ca91d92997de6191f61b33a18e05a06a6523c6c7ac7b8c7ddd56923c66fd47a8a4886372aae4b9f9302dfa013d17c231a8daaaa6e44cdff5223b",
 "runner": "lcuf_x.py (the user's LCUF-X/0.2 compiler)",
 "expected": "accept",
 "observed": "not_run",
 "as_expected": false,
 "exit_code": -1,
 "seconds": 0.0,
 "output": {
  "status": "not_run",
  "note": "pass --core LCUF_X_DIR (the folder of lcuf_x.py) to run it"
 }
}