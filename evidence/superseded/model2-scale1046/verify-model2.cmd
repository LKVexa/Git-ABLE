@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): verify-model2.json. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to print the document, with /check to check its SHA-512, or with /extract FILE to write it out.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=verify-model2.json"
set "LB_DOC_TYPE=json"
set "LB_DOC_BYTES=5114"
set "LB_DOC_SHA512=9bd41f9184a5bb050c029ff5ada026f501074e269332b937b9b1d1df9eab82566b0cc0d65b71eb92ba547d9e3f997a4f906499f9567ca8dab33718f2219453a8"
set "LB_SELF=%~f0"
set "LB_ARG=%~1"
set "LB_OUT=%~f2"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$n=[int]$env:LB_DOC_BYTES;$b=[IO.File]::ReadAllBytes($env:LB_SELF);$o=$b.Length-$n;$h=-join((New-Object Security.Cryptography.SHA512Managed).ComputeHash($b,$o,$n)|%%{$_.ToString('x2')});if($h -ne $env:LB_DOC_SHA512){[Console]::Error.WriteLine('LB-DOC/1: the SHA-512 of '+$env:LB_DOC+' differs from LB_DOC_SHA512');exit 1};if($env:LB_ARG -eq '/check'){'ok: '+$env:LB_DOC;exit 0};if($env:LB_ARG -eq '/extract'){$d=New-Object byte[] $n;[Array]::Copy($b,$o,$d,0,$n);[IO.File]::WriteAllBytes($env:LB_OUT,$d);'written: '+$env:LB_OUT;exit 0};[Console]::OutputEncoding=New-Object Text.UTF8Encoding $false;[Console]::Out.Write([Text.Encoding]::UTF8.GetString($b,$o,$n));exit 0"
set "LB_RC=%errorlevel%"
if "%LB_ARG%"=="" pause
exit /b %LB_RC%
rem ---- document ----
{
 "manifest": "manifest.json",
 "model": "KGD-IMQ-5DLLM-M2",
 "shards": 39,
 "total_bytes": 949031240,
 "max_shard_bytes": 24976282,
 "cap": 25000000,
 "total_cap": 950000000,
 "within_caps": true,
 "set_sha512_ok": true,
 "concatenated_sha512_ok": true,
 "every_shard_ok": true,
 "rows": [
  {
   "file": "shard_EMB0.cmd",
   "bytes": 11811074,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_EMB1.cmd",
   "bytes": 13124201,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_L00.cmd",
   "bytes": 24975588,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_L01.cmd",
   "bytes": 24976032,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_L02.cmd",
   "bytes": 24974767,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_L03.cmd",
   "bytes": 24975124,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_L04.cmd",
   "bytes": 24975187,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_L05.cmd",
   "bytes": 24975832,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_L06.cmd",
   "bytes": 24975666,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_L07.cmd",
   "bytes": 24975763,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_L08.cmd",
   "bytes": 24975232,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_L09.cmd",
   "bytes": 24976045,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_L10.cmd",
   "bytes": 24975240,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_L11.cmd",
   "bytes": 24975842,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_L12.cmd",
   "bytes": 24975844,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_L13.cmd",
   "bytes": 24975596,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_L14.cmd",
   "bytes": 24975022,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_L15.cmd",
   "bytes": 24975756,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_L16.cmd",
   "bytes": 24975334,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_L17.cmd",
   "bytes": 24975096,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_L18.cmd",
   "bytes": 24976049,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_L19.cmd",
   "bytes": 24975315,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_L20.cmd",
   "bytes": 24976114,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_L21.cmd",
   "bytes": 24976282,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_L22.cmd",
   "bytes": 24975362,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_L23.cmd",
   "bytes": 24975563,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_L24.cmd",
   "bytes": 24975355,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_L25.cmd",
   "bytes": 24975536,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_L26.cmd",
   "bytes": 24975242,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_L27.cmd",
   "bytes": 24975962,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_L28.cmd",
   "bytes": 24975535,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_L29.cmd",
   "bytes": 24975079,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_L30.cmd",
   "bytes": 24975669,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_L31.cmd",
   "bytes": 24976105,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_L32.cmd",
   "bytes": 24975498,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_L33.cmd",
   "bytes": 24975366,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_L34.cmd",
   "bytes": 24975405,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_L35.cmd",
   "bytes": 24975420,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_L36.cmd",
   "bytes": 24976142,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  }
 ],
 "all_pass": true
}
