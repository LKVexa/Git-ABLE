@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): reject_rails_meanfield_uncertified.json. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to print the document, with /check to check its SHA-512, or with /extract FILE to write it out.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=reject_rails_meanfield_uncertified.json"
set "LB_DOC_TYPE=json"
set "LB_DOC_BYTES=730"
set "LB_DOC_SHA512=d614f5a71341603363dbd6f1d692c0a2dcd85dc2a5dc29870bc534105465cdcdcdfcad0a5c0f96cfe1740df42ac609d4d91fdc5567e36ff61146bafb412078a9"
set "LB_SELF=%~f0"
set "LB_ARG=%~1"
set "LB_OUT=%~f2"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$n=[int]$env:LB_DOC_BYTES;$b=[IO.File]::ReadAllBytes($env:LB_SELF);$o=$b.Length-$n;$h=-join((New-Object Security.Cryptography.SHA512Managed).ComputeHash($b,$o,$n)|%%{$_.ToString('x2')});if($h -ne $env:LB_DOC_SHA512){[Console]::Error.WriteLine('LB-DOC/1: the SHA-512 of '+$env:LB_DOC+' differs from LB_DOC_SHA512');exit 1};if($env:LB_ARG -eq '/check'){'ok: '+$env:LB_DOC;exit 0};if($env:LB_ARG -eq '/extract'){$d=New-Object byte[] $n;[Array]::Copy($b,$o,$d,0,$n);[IO.File]::WriteAllBytes($env:LB_OUT,$d);'written: '+$env:LB_OUT;exit 0};[Console]::OutputEncoding=New-Object Text.UTF8Encoding $false;[Console]::Out.Write([Text.Encoding]::UTF8.GetString($b,$o,$n));exit 0"
set "LB_RC=%errorlevel%"
if "%LB_ARG%"=="" pause
exit /b %LB_RC%
rem ---- document ----
{
 "program": "kgd/reject_rails_meanfield_uncertified.cmd",
 "source_sha512": "18c1e92c602fee84c872ee59afbec5ad84e1fc1fe5ea9634db03a42c71b90643e83610c9794c4999d383d19afb38afdd88a9c5561a521e8a284cb0dc6f6f6b14",
 "file_sha512": "48ab0027b57a7dbf7ad2d9ca2b5124efac8716f2ea0d017a3d77fe6a592723822b713af4d825aa0c3481513ac727962f340d253d8a59f4070501ee3e95b20ee4",
 "runner": "lcufx\\LCUFX_KGD.cmd run --twice (tools\\KGD_ENGINE.cmd host)",
 "expected": "reject",
 "observed": "reject",
 "as_expected": true,
 "exit_code": 2,
 "seconds": 0.0,
 "output": {
  "status": "rejected",
  "diagnostic": "rails_meanfield: no contraction certificate: kappa = 1.25 >= 1, so the gate may have several fixed points and its answer is not unique"
 }
}