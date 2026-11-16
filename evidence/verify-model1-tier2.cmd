@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): verify.json. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to print the document, with /check to check its SHA-512, or with /extract FILE to write it out.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=verify.json"
set "LB_DOC_TYPE=json"
set "LB_DOC_BYTES=2190"
set "LB_DOC_SHA512=475b42564f068128c0193bea0a63dcc4919e3b45fbc7a286ef0365d721359cf861cda639059b231c2b3c2bf45f6916e52c212a9fb4909d2df87efd62519b347d"
set "LB_SELF=%~f0"
set "LB_ARG=%~1"
set "LB_OUT=%~f2"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$n=[int]$env:LB_DOC_BYTES;$b=[IO.File]::ReadAllBytes($env:LB_SELF);$o=$b.Length-$n;$h=-join((New-Object Security.Cryptography.SHA512Managed).ComputeHash($b,$o,$n)|%%{$_.ToString('x2')});if($h -ne $env:LB_DOC_SHA512){[Console]::Error.WriteLine('LB-DOC/1: the SHA-512 of '+$env:LB_DOC+' differs from LB_DOC_SHA512');exit 1};if($env:LB_ARG -eq '/check'){'ok: '+$env:LB_DOC;exit 0};if($env:LB_ARG -eq '/extract'){$d=New-Object byte[] $n;[Array]::Copy($b,$o,$d,0,$n);[IO.File]::WriteAllBytes($env:LB_OUT,$d);'written: '+$env:LB_OUT;exit 0};[Console]::OutputEncoding=New-Object Text.UTF8Encoding $false;[Console]::Out.Write([Text.Encoding]::UTF8.GetString($b,$o,$n));exit 0"
set "LB_RC=%errorlevel%"
if "%LB_ARG%"=="" pause
exit /b %LB_RC%
rem ---- document ----
{
 "manifest": "manifest.cmd",
 "model": "KGD-IMQ-5DLLM-M1",
 "tier": "TIER-2",
 "shards": 5,
 "total_bytes": 3797790,
 "max_shard_bytes": 928832,
 "every_shard_ok": true,
 "total_bytes_bound_any_values": 3944956,
 "max_shard_bytes_bound_any_values": 964289,
 "sums_file_lists_exactly_the_shards": true,
 "set_sha512": "555eb9eb9d0c1de18e04a22fc1517d66516c673d8116b14edba6076655883966d2ba27ca72f958c3da3bda0eb33ce9aced61128480f10f9c07881f2a2c157499",
 "set_sha512_ok": true,
 "concatenated_sha512_ok": true,
 "cap": 24000000,
 "total_cap": null,
 "total_ok": true,
 "pinned_set_ok": null,
 "rows": [
  {
   "file": "shard_L00.cmd",
   "bytes": 928273,
   "sha512_ok": true,
   "sums_ok": true,
   "size_ok": true,
   "bytes_bound_any_values": 964289,
   "payload_sha512_ok": true,
   "payload_lines_ok": true,
   "l1_ok": true,
   "format": "LB-CMD/1",
   "tier": "TIER-2",
   "bound_ok": true,
   "ok": true
  },
  {
   "file": "shard_L01.cmd",
   "bytes": 928792,
   "sha512_ok": true,
   "sums_ok": true,
   "size_ok": true,
   "bytes_bound_any_values": 964289,
   "payload_sha512_ok": true,
   "payload_lines_ok": true,
   "l1_ok": true,
   "format": "LB-CMD/1",
   "tier": "TIER-2",
   "bound_ok": true,
   "ok": true
  },
  {
   "file": "shard_L02.cmd",
   "bytes": 928760,
   "sha512_ok": true,
   "sums_ok": true,
   "size_ok": true,
   "bytes_bound_any_values": 964289,
   "payload_sha512_ok": true,
   "payload_lines_ok": true,
   "l1_ok": true,
   "format": "LB-CMD/1",
   "tier": "TIER-2",
   "bound_ok": true,
   "ok": true
  },
  {
   "file": "shard_L03.cmd",
   "bytes": 928832,
   "sha512_ok": true,
   "sums_ok": true,
   "size_ok": true,
   "bytes_bound_any_values": 964289,
   "payload_sha512_ok": true,
   "payload_lines_ok": true,
   "l1_ok": true,
   "format": "LB-CMD/1",
   "tier": "TIER-2",
   "bound_ok": true,
   "ok": true
  },
  {
   "file": "shard_EMB.cmd",
   "bytes": 83133,
   "sha512_ok": true,
   "sums_ok": true,
   "size_ok": true,
   "bytes_bound_any_values": 87800,
   "payload_sha512_ok": true,
   "payload_lines_ok": true,
   "l1_ok": true,
   "format": "LB-CMD/1",
   "tier": "TIER-2",
   "bound_ok": true,
   "ok": true
  }
 ],
 "all_pass": true
}