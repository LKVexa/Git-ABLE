@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): verify.json. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to print the document, with /check to check its SHA-512, or with /extract FILE to write it out.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=verify.json"
set "LB_DOC_TYPE=json"
set "LB_DOC_BYTES=2240"
set "LB_DOC_SHA512=2ebdad0749c8eccbc674f8eddf7abdf0142b68a0752d72528c967730b47e509ab6a4a3c603d9e1663fa86aa861fa893b6e4e36a2fb8b2b0c8fe77a2991d40c46"
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
 "tier": "EXACT-BF16",
 "shards": 5,
 "total_bytes": 54525494,
 "max_shard_bytes": 13359681,
 "every_shard_ok": true,
 "total_bytes_bound_any_values": 55402282,
 "max_shard_bytes_bound_any_values": 13573684,
 "sums_file_lists_exactly_the_shards": true,
 "set_sha512": "2824a03df39ab370306ebf0f04f9d72afccb7a171f06997c58eddfac420e697e235b83ae32f9a89b5aa956c7aef785b0920aacbd6ea95eacb74fbb7eae3fb627",
 "set_sha512_ok": true,
 "concatenated_sha512_ok": true,
 "cap": 24000000,
 "total_cap": null,
 "total_ok": true,
 "pinned_set_ok": null,
 "rows": [
  {
   "file": "shard_L00.cmd",
   "bytes": 13359052,
   "sha512_ok": true,
   "sums_ok": true,
   "size_ok": true,
   "bytes_bound_any_values": 13573684,
   "payload_sha512_ok": true,
   "payload_lines_ok": true,
   "l1_ok": true,
   "format": "LB-CMD/1",
   "tier": "EXACT-BF16",
   "bound_ok": true,
   "ok": true
  },
  {
   "file": "shard_L01.cmd",
   "bytes": 13359528,
   "sha512_ok": true,
   "sums_ok": true,
   "size_ok": true,
   "bytes_bound_any_values": 13573684,
   "payload_sha512_ok": true,
   "payload_lines_ok": true,
   "l1_ok": true,
   "format": "LB-CMD/1",
   "tier": "EXACT-BF16",
   "bound_ok": true,
   "ok": true
  },
  {
   "file": "shard_L02.cmd",
   "bytes": 13359154,
   "sha512_ok": true,
   "sums_ok": true,
   "size_ok": true,
   "bytes_bound_any_values": 13573684,
   "payload_sha512_ok": true,
   "payload_lines_ok": true,
   "l1_ok": true,
   "format": "LB-CMD/1",
   "tier": "EXACT-BF16",
   "bound_ok": true,
   "ok": true
  },
  {
   "file": "shard_L03.cmd",
   "bytes": 13359681,
   "sha512_ok": true,
   "sums_ok": true,
   "size_ok": true,
   "bytes_bound_any_values": 13573684,
   "payload_sha512_ok": true,
   "payload_lines_ok": true,
   "l1_ok": true,
   "format": "LB-CMD/1",
   "tier": "EXACT-BF16",
   "bound_ok": true,
   "ok": true
  },
  {
   "file": "shard_EMB.cmd",
   "bytes": 1088079,
   "sha512_ok": true,
   "sums_ok": true,
   "size_ok": true,
   "bytes_bound_any_values": 1107546,
   "payload_sha512_ok": true,
   "payload_lines_ok": true,
   "l1_ok": true,
   "format": "LB-CMD/1",
   "tier": "EXACT-BF16",
   "bound_ok": true,
   "ok": true
  }
 ],
 "all_pass": true
}