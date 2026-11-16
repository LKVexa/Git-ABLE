@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): verify-model2.json. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to print the document, with /check to check its SHA-512, or with /extract FILE to write it out.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=verify-model2.json"
set "LB_DOC_TYPE=json"
set "LB_DOC_BYTES=5114"
set "LB_DOC_SHA512=ded90c5774484ef794464817c9f1d8778b85aa87b783b873971898450cf3915d03c874296a5457efd8a90849083a4c000d2c487a8bd4026e3bb6ce943bcb1671"
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
 "total_bytes": 949070243,
 "max_shard_bytes": 24974785,
 "cap": 25000000,
 "total_cap": 950000000,
 "within_caps": true,
 "set_sha512_ok": true,
 "concatenated_sha512_ok": true,
 "every_shard_ok": true,
 "rows": [
  {
   "file": "shard_EMB0.cmd",
   "bytes": 11867558,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_EMB1.cmd",
   "bytes": 13161504,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_L00.cmd",
   "bytes": 24974145,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_L01.cmd",
   "bytes": 24974477,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_L02.cmd",
   "bytes": 24973299,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_L03.cmd",
   "bytes": 24973698,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_L04.cmd",
   "bytes": 24973741,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_L05.cmd",
   "bytes": 24974337,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_L06.cmd",
   "bytes": 24974189,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_L07.cmd",
   "bytes": 24974289,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_L08.cmd",
   "bytes": 24973793,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_L09.cmd",
   "bytes": 24974555,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_L10.cmd",
   "bytes": 24973775,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_L11.cmd",
   "bytes": 24974298,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_L12.cmd",
   "bytes": 24974321,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_L13.cmd",
   "bytes": 24974074,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_L14.cmd",
   "bytes": 24973598,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_L15.cmd",
   "bytes": 24974281,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_L16.cmd",
   "bytes": 24973907,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_L17.cmd",
   "bytes": 24973557,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_L18.cmd",
   "bytes": 24974584,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_L19.cmd",
   "bytes": 24973787,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_L20.cmd",
   "bytes": 24974621,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_L21.cmd",
   "bytes": 24974785,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_L22.cmd",
   "bytes": 24973921,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_L23.cmd",
   "bytes": 24974095,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_L24.cmd",
   "bytes": 24973855,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_L25.cmd",
   "bytes": 24974029,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_L26.cmd",
   "bytes": 24973699,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_L27.cmd",
   "bytes": 24974521,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_L28.cmd",
   "bytes": 24974114,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_L29.cmd",
   "bytes": 24973634,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_L30.cmd",
   "bytes": 24974222,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_L31.cmd",
   "bytes": 24974608,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_L32.cmd",
   "bytes": 24974045,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_L33.cmd",
   "bytes": 24973953,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_L34.cmd",
   "bytes": 24973887,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_L35.cmd",
   "bytes": 24973946,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  },
  {
   "file": "shard_L36.cmd",
   "bytes": 24974541,
   "sha512_ok": true,
   "size_ok": true,
   "payload_ok": true
  }
 ],
 "all_pass": true
}
