@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): reject_core_header_at_kgd_host.json. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to print the document, with /check to check its SHA-512, or with /extract FILE to write it out.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=reject_core_header_at_kgd_host.json"
set "LB_DOC_TYPE=json"
set "LB_DOC_BYTES=637"
set "LB_DOC_SHA512=78d7d5079127308aaa05b403bde630562ce64c0d104b5f40e9268c9fd92533a2bb2387ba821c1c3fe792dcbf72795a4afa93e30e0127b7c4933210c1ff8feda1"
set "LB_SELF=%~f0"
set "LB_ARG=%~1"
set "LB_OUT=%~f2"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$n=[int]$env:LB_DOC_BYTES;$b=[IO.File]::ReadAllBytes($env:LB_SELF);$o=$b.Length-$n;$h=-join((New-Object Security.Cryptography.SHA512Managed).ComputeHash($b,$o,$n)|%%{$_.ToString('x2')});if($h -ne $env:LB_DOC_SHA512){[Console]::Error.WriteLine('LB-DOC/1: the SHA-512 of '+$env:LB_DOC+' differs from LB_DOC_SHA512');exit 1};if($env:LB_ARG -eq '/check'){'ok: '+$env:LB_DOC;exit 0};if($env:LB_ARG -eq '/extract'){$d=New-Object byte[] $n;[Array]::Copy($b,$o,$d,0,$n);[IO.File]::WriteAllBytes($env:LB_OUT,$d);'written: '+$env:LB_OUT;exit 0};[Console]::OutputEncoding=New-Object Text.UTF8Encoding $false;[Console]::Out.Write([Text.Encoding]::UTF8.GetString($b,$o,$n));exit 0"
set "LB_RC=%errorlevel%"
if "%LB_ARG%"=="" pause
exit /b %LB_RC%
rem ---- document ----
{
 "program": "kgd/reject_core_header_at_kgd_host.cmd",
 "source_sha512": "7088c6b41de01d36e1b0696124af236573305e22d1a4eb12f9010b742d550869b3890c77550291ef69b064852d74c43dd6ff0859100263d5c92f6cc788d7f9ba",
 "file_sha512": "165f461b1d1152ccdce207f2205d97d28c7ee163037463d2482bd25e69e032ed42a501f42d4e7be7b4cdae4d22a0fd796a0dd833209e14b9e7ad93841dc53a6c",
 "runner": "lcufx\\LCUFX_KGD.cmd run --twice (tools\\KGD_ENGINE.cmd host)",
 "expected": "reject",
 "observed": "reject",
 "as_expected": true,
 "exit_code": 2,
 "seconds": 0.0,
 "output": {
  "status": "rejected",
  "diagnostic": "required header LCUF-X/0.2+lkvexa.kgd_imq/0.2"
 }
}