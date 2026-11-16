@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): verify-combined.json. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to print the document, with /check to check its SHA-512, or with /extract FILE to write it out.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=verify-combined.json"
set "LB_DOC_TYPE=json"
set "LB_DOC_BYTES=1290"
set "LB_DOC_SHA512=1f00787f29e22319382e99f239e54585c7d0a52446ea9980709cdb2d554f43af91d9f5f669e8f82bdbfaab82330eb47dfa0e5ffabbe73107762e62a9bb8ce4bd"
set "LB_SELF=%~f0"
set "LB_ARG=%~1"
set "LB_OUT=%~f2"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$n=[int]$env:LB_DOC_BYTES;$b=[IO.File]::ReadAllBytes($env:LB_SELF);$o=$b.Length-$n;$h=-join((New-Object Security.Cryptography.SHA512Managed).ComputeHash($b,$o,$n)|%%{$_.ToString('x2')});if($h -ne $env:LB_DOC_SHA512){[Console]::Error.WriteLine('LB-DOC/1: the SHA-512 of '+$env:LB_DOC+' differs from LB_DOC_SHA512');exit 1};if($env:LB_ARG -eq '/check'){'ok: '+$env:LB_DOC;exit 0};if($env:LB_ARG -eq '/extract'){$d=New-Object byte[] $n;[Array]::Copy($b,$o,$d,0,$n);[IO.File]::WriteAllBytes($env:LB_OUT,$d);'written: '+$env:LB_OUT;exit 0};[Console]::OutputEncoding=New-Object Text.UTF8Encoding $false;[Console]::Out.Write([Text.Encoding]::UTF8.GetString($b,$o,$n));exit 0"
set "LB_RC=%errorlevel%"
if "%LB_ARG%"=="" pause
exit /b %LB_RC%
rem ---- document ----
{
 "combined_manifest": "COMBINED-MANIFEST.cmd",
 "sets": [
  {
   "folder": "model1-untrained/exact",
   "manifest": "manifest.cmd",
   "model": "KGD-IMQ-5DLLM-M1",
   "tier": "EXACT-BF16",
   "shards": 5,
   "total_bytes": 54525494,
   "total_bytes_bound_any_values": 55402282,
   "max_shard_bytes_bound_any_values": 13573684,
   "all_pass": true
  },
  {
   "folder": "model1-untrained/tier2",
   "manifest": "manifest.cmd",
   "model": "KGD-IMQ-5DLLM-M1",
   "tier": "TIER-2",
   "shards": 5,
   "total_bytes": 3797790,
   "total_bytes_bound_any_values": 3944956,
   "max_shard_bytes_bound_any_values": 964289,
   "all_pass": true
  },
  {
   "folder": "model2-tier1",
   "manifest": "manifest.cmd",
   "model": "KGD-IMQ-5DLLM-M2",
   "tier": "TIER-1",
   "shards": 70,
   "total_bytes": 874173645,
   "total_bytes_bound_any_values": 929758995,
   "max_shard_bytes_bound_any_values": 17960298,
   "all_pass": true
  }
 ],
 "combined_sha512_ok": true,
 "all_files_bytes_now": 932564172,
 "all_files_bytes_bound_any_values": 989174756,
 "cap": 24000000,
 "total_cap": 1000000000,
 "within_total_cap_now_and_after_any_training": true,
 "nominal_parameters": {
  "model1-untrained/exact": 2951944,
  "model1-untrained/tier2": 2951944,
  "model2-tier1": 1022597991748
 },
 "all_pass": true
}