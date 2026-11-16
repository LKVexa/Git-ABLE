@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): validate-factored.json. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to print the document, with /check to check its SHA-512, or with /extract FILE to write it out.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=validate-factored.json"
set "LB_DOC_TYPE=json"
set "LB_DOC_BYTES=826"
set "LB_DOC_SHA512=fc913d7927101faa9045cd82d9d24fe44493e1f11195d2b945e84a37ec035ce13ae4d6dd778b8d79512419c5c4bdfc786c309e15f55de4e1d0efa8bd73fed5f8"
set "LB_SELF=%~f0"
set "LB_ARG=%~1"
set "LB_OUT=%~f2"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$n=[int]$env:LB_DOC_BYTES;$b=[IO.File]::ReadAllBytes($env:LB_SELF);$o=$b.Length-$n;$h=-join((New-Object Security.Cryptography.SHA512Managed).ComputeHash($b,$o,$n)|%%{$_.ToString('x2')});if($h -ne $env:LB_DOC_SHA512){[Console]::Error.WriteLine('LB-DOC/1: the SHA-512 of '+$env:LB_DOC+' differs from LB_DOC_SHA512');exit 1};if($env:LB_ARG -eq '/check'){'ok: '+$env:LB_DOC;exit 0};if($env:LB_ARG -eq '/extract'){$d=New-Object byte[] $n;[Array]::Copy($b,$o,$d,0,$n);[IO.File]::WriteAllBytes($env:LB_OUT,$d);'written: '+$env:LB_OUT;exit 0};[Console]::OutputEncoding=New-Object Text.UTF8Encoding $false;[Console]::Out.Write([Text.Encoding]::UTF8.GetString($b,$o,$n));exit 0"
set "LB_RC=%errorlevel%"
if "%LB_ARG%"=="" pause
exit /b %LB_RC%
rem ---- document ----
{
 "algebra": {
  "apply": 1.8692028547206974e-07,
  "rows_10_30": 1.6891883802827579e-07,
  "row_vectors": 0.0,
  "rank_bound": 10,
  "scale_of_W": 2.049350182545382
 },
 "end_to_end_small_model2_format_set": {
  "set": {
   "d": 256,
   "n_layers": 2,
   "vocab": 49152,
   "set_sha512": "b7b0124745fb70c1f127ce8405c6d9251541762ae3316b73c257b1a240cd7d65fa20cd15119022d0662a737cc5e6f36c084bc80c4619826753dd41df0e9e7048"
  },
  "TIER-1": {
   "max_abs_diff_logits": 4.76837158203125e-07,
   "max_abs_logit": 5.458656706161534,
   "host_ce": 12.825116135299602,
   "dense_ce": 12.825116121102148,
   "tokens": 17
  },
  "TIER-0": {
   "max_abs_diff_logits": 4.76837158203125e-07,
   "max_abs_logit": 5.458656706161534,
   "host_ce": 12.825116135299602,
   "dense_ce": 12.825116121102148,
   "tokens": 17
  }
 },
 "pass": true
}