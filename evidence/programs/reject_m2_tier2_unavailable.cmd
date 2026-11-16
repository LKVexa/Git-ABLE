@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): reject_m2_tier2_unavailable.json. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to print the document, with /check to check its SHA-512, or with /extract FILE to write it out.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=reject_m2_tier2_unavailable.json"
set "LB_DOC_TYPE=json"
set "LB_DOC_BYTES=641"
set "LB_DOC_SHA512=2db6d9b65f8bedb82eada0f25b4c323a208099d8b7471d01538b1b0a1758cab1006e5c13ba3d692a908749ddacf29317fa64fe21b03eba9424bd1016b7c6b92e"
set "LB_SELF=%~f0"
set "LB_ARG=%~1"
set "LB_OUT=%~f2"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$n=[int]$env:LB_DOC_BYTES;$b=[IO.File]::ReadAllBytes($env:LB_SELF);$o=$b.Length-$n;$h=-join((New-Object Security.Cryptography.SHA512Managed).ComputeHash($b,$o,$n)|%%{$_.ToString('x2')});if($h -ne $env:LB_DOC_SHA512){[Console]::Error.WriteLine('LB-DOC/1: the SHA-512 of '+$env:LB_DOC+' differs from LB_DOC_SHA512');exit 1};if($env:LB_ARG -eq '/check'){'ok: '+$env:LB_DOC;exit 0};if($env:LB_ARG -eq '/extract'){$d=New-Object byte[] $n;[Array]::Copy($b,$o,$d,0,$n);[IO.File]::WriteAllBytes($env:LB_OUT,$d);'written: '+$env:LB_OUT;exit 0};[Console]::OutputEncoding=New-Object Text.UTF8Encoding $false;[Console]::Out.Write([Text.Encoding]::UTF8.GetString($b,$o,$n));exit 0"
set "LB_RC=%errorlevel%"
if "%LB_ARG%"=="" pause
exit /b %LB_RC%
rem ---- document ----
{
 "program": "kgd/reject_m2_tier2_unavailable.cmd",
 "source_sha512": "fd1282fd49ce32350d7d65cf7a39329d407282b53bcb1525394ce85b781b43e0bd513d4f806b8790a5b54dcb2d187e3c642f3310a03186bb255322514b8638e5",
 "file_sha512": "d7bc5446af2ed5224160ba4d0bd6868575843bedfdbb6f5510aee60ee60561bbddac8b29a96f41f24590f551bffc15c9615343c48a8ec5636fd7336ae9a92239",
 "runner": "lcufx\\LCUFX_KGD.cmd run --twice (tools\\KGD_ENGINE.cmd host)",
 "expected": "reject",
 "observed": "reject",
 "as_expected": true,
 "exit_code": 2,
 "seconds": 0.0,
 "output": {
  "status": "rejected",
  "diagnostic": "line 9: tier TIER-2 is not available in a TIER-1 set"
 }
}