@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): reject_rails_parity_no_majority.json. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to print the document, with /check to check its SHA-512, or with /extract FILE to write it out.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=reject_rails_parity_no_majority.json"
set "LB_DOC_TYPE=json"
set "LB_DOC_BYTES=676"
set "LB_DOC_SHA512=cb74fe7c3842a9bc0514ff4ddcd89a31b83b4752b6aa076952aac6b805ee2a40106a9cd674e4ef4b9b5a9dd75acdefe6460176d72e86bd4496439c2f200080a6"
set "LB_SELF=%~f0"
set "LB_ARG=%~1"
set "LB_OUT=%~f2"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$n=[int]$env:LB_DOC_BYTES;$b=[IO.File]::ReadAllBytes($env:LB_SELF);$o=$b.Length-$n;$h=-join((New-Object Security.Cryptography.SHA512Managed).ComputeHash($b,$o,$n)|%%{$_.ToString('x2')});if($h -ne $env:LB_DOC_SHA512){[Console]::Error.WriteLine('LB-DOC/1: the SHA-512 of '+$env:LB_DOC+' differs from LB_DOC_SHA512');exit 1};if($env:LB_ARG -eq '/check'){'ok: '+$env:LB_DOC;exit 0};if($env:LB_ARG -eq '/extract'){$d=New-Object byte[] $n;[Array]::Copy($b,$o,$d,0,$n);[IO.File]::WriteAllBytes($env:LB_OUT,$d);'written: '+$env:LB_OUT;exit 0};[Console]::OutputEncoding=New-Object Text.UTF8Encoding $false;[Console]::Out.Write([Text.Encoding]::UTF8.GetString($b,$o,$n));exit 0"
set "LB_RC=%errorlevel%"
if "%LB_ARG%"=="" pause
exit /b %LB_RC%
rem ---- document ----
{
 "program": "kgd/reject_rails_parity_no_majority.cmd",
 "source_sha512": "5576312f7b4ef3e72e9124f60601e2f6aea618525d4565d54a29e314c8f6cb06820687f700976175de6035053a142792a3c37387c4c13c58dd3ed35a4f23789f",
 "file_sha512": "436fefadef366e6d80e4ce30a06f11f69be4a4dfea2f4cb19eeed6fd7e02d00b23f25581f97b7d912cba8d4878812f46192b2db03afc26f1d084414d2457bd3a",
 "runner": "lcufx\\LCUFX_KGD.cmd run --twice (tools\\KGD_ENGINE.cmd host)",
 "expected": "reject",
 "observed": "reject",
 "as_expected": true,
 "exit_code": 2,
 "seconds": 1.4,
 "output": {
  "status": "rejected",
  "diagnostic": "rails_parity: no majority among the three routes (pairwise checks ab, bc, ac = 111)"
 }
}