@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): accept_littlebit_block_sign.json. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to print the document, with /check to check its SHA-512, or with /extract FILE to write it out.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=accept_littlebit_block_sign.json"
set "LB_DOC_TYPE=json"
set "LB_DOC_BYTES=625"
set "LB_DOC_SHA512=848b2cf500fc94ae28cb3d509634789f0cafd821a425d46d360f66f1a3f1d731e5e3729474572bd286dcc3dd40d9115f4ce9e46adf693f99e5b262faf790146e"
set "LB_SELF=%~f0"
set "LB_ARG=%~1"
set "LB_OUT=%~f2"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$n=[int]$env:LB_DOC_BYTES;$b=[IO.File]::ReadAllBytes($env:LB_SELF);$o=$b.Length-$n;$h=-join((New-Object Security.Cryptography.SHA512Managed).ComputeHash($b,$o,$n)|%%{$_.ToString('x2')});if($h -ne $env:LB_DOC_SHA512){[Console]::Error.WriteLine('LB-DOC/1: the SHA-512 of '+$env:LB_DOC+' differs from LB_DOC_SHA512');exit 1};if($env:LB_ARG -eq '/check'){'ok: '+$env:LB_DOC;exit 0};if($env:LB_ARG -eq '/extract'){$d=New-Object byte[] $n;[Array]::Copy($b,$o,$d,0,$n);[IO.File]::WriteAllBytes($env:LB_OUT,$d);'written: '+$env:LB_OUT;exit 0};[Console]::OutputEncoding=New-Object Text.UTF8Encoding $false;[Console]::Out.Write([Text.Encoding]::UTF8.GetString($b,$o,$n));exit 0"
set "LB_RC=%errorlevel%"
if "%LB_ARG%"=="" pause
exit /b %LB_RC%
rem ---- document ----
{
 "program": "core/accept_littlebit_block_sign.cmd",
 "source_sha512": "7ac62e02042a6f05c7a4c8244f25daff0714434fa3d982b5b209a7826e7d0b5d1c0a81dbe6b0a0312795abfb4034cc8b646398b20c72c9666d3868d84d160a89",
 "file_sha512": "8bd36507461b58e432911db06f263d0bb890491028a64d5d06de47006c8bc457f2e962fcc1f011b9ec69c44170a152e0045bb40b24806a7af773ebab26fa8a65",
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