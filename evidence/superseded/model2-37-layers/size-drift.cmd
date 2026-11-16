@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): size-drift.json. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to print the document, with /check to check its SHA-512, or with /extract FILE to write it out.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=size-drift.json"
set "LB_DOC_TYPE=json"
set "LB_DOC_BYTES=5544"
set "LB_DOC_SHA512=a5cd74d3b8e8473ca1db54e435de355de10ed2c5f372075a2479af59d4f8c5f8d801465157eebe16befde723aca4cad0039fd8d8d16f5ffcc5836801a2c0a156"
set "LB_SELF=%~f0"
set "LB_ARG=%~1"
set "LB_OUT=%~f2"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$n=[int]$env:LB_DOC_BYTES;$b=[IO.File]::ReadAllBytes($env:LB_SELF);$o=$b.Length-$n;$h=-join((New-Object Security.Cryptography.SHA512Managed).ComputeHash($b,$o,$n)|%%{$_.ToString('x2')});if($h -ne $env:LB_DOC_SHA512){[Console]::Error.WriteLine('LB-DOC/1: the SHA-512 of '+$env:LB_DOC+' differs from LB_DOC_SHA512');exit 1};if($env:LB_ARG -eq '/check'){'ok: '+$env:LB_DOC;exit 0};if($env:LB_ARG -eq '/extract'){$d=New-Object byte[] $n;[Array]::Copy($b,$o,$d,0,$n);[IO.File]::WriteAllBytes($env:LB_OUT,$d);'written: '+$env:LB_OUT;exit 0};[Console]::OutputEncoding=New-Object Text.UTF8Encoding $false;[Console]::Out.Write([Text.Encoding]::UTF8.GetString($b,$o,$n));exit 0"
set "LB_RC=%errorlevel%"
if "%LB_ARG%"=="" pause
exit /b %LB_RC%
rem ---- document ----
{
 "model2_now": {
  "total": 949070243,
  "largest": 24974785
 },
 "model2_bound_every_value_11_chars": {
  "total": 1009429364,
  "largest": 26565393,
  "shards_over_25000000": 37
 },
 "model2_illustration_model1_trained_lengths": {
  "total": 947210675,
  "largest": 24926107,
  "shards_over_25000000": 0
 },
 "mean_chars_per_value": {
  "model2_init": {
   "sign": 9.983,
   "scale": 9.0,
   "scalar": 1.193,
   "q16": 5.0
  },
  "model1_trained_tier2": {
   "sign": 9.98,
   "scale": 8.87,
   "q16": 4.994,
   "scalar": 1.553
  }
 },
 "values_per_category_model2": {
  "sign": 8730240,
  "scale": 13968384,
  "scalar": 1344,
  "q16": 3921536
 },
 "shards": [
  {
   "file": "shard_EMB0.cmd",
   "bytes_now": 11867558,
   "bytes_bound": 12450994,
   "bytes_illustration": 11838465
  },
  {
   "file": "shard_EMB1.cmd",
   "bytes_now": 13161504,
   "bytes_bound": 14058829,
   "bytes_illustration": 13132115
  },
  {
   "file": "shard_L00.cmd",
   "bytes_now": 24974145,
   "bytes_bound": 26565393,
   "bytes_illustration": 24925467
  },
  {
   "file": "shard_L01.cmd",
   "bytes_now": 24974477,
   "bytes_bound": 26565393,
   "bytes_illustration": 24925799
  },
  {
   "file": "shard_L02.cmd",
   "bytes_now": 24973299,
   "bytes_bound": 26565393,
   "bytes_illustration": 24924621
  },
  {
   "file": "shard_L03.cmd",
   "bytes_now": 24973698,
   "bytes_bound": 26565393,
   "bytes_illustration": 24925020
  },
  {
   "file": "shard_L04.cmd",
   "bytes_now": 24973741,
   "bytes_bound": 26565393,
   "bytes_illustration": 24925063
  },
  {
   "file": "shard_L05.cmd",
   "bytes_now": 24974337,
   "bytes_bound": 26565393,
   "bytes_illustration": 24925659
  },
  {
   "file": "shard_L06.cmd",
   "bytes_now": 24974189,
   "bytes_bound": 26565393,
   "bytes_illustration": 24925511
  },
  {
   "file": "shard_L07.cmd",
   "bytes_now": 24974289,
   "bytes_bound": 26565393,
   "bytes_illustration": 24925611
  },
  {
   "file": "shard_L08.cmd",
   "bytes_now": 24973793,
   "bytes_bound": 26565393,
   "bytes_illustration": 24925115
  },
  {
   "file": "shard_L09.cmd",
   "bytes_now": 24974555,
   "bytes_bound": 26565393,
   "bytes_illustration": 24925877
  },
  {
   "file": "shard_L10.cmd",
   "bytes_now": 24973775,
   "bytes_bound": 26565393,
   "bytes_illustration": 24925097
  },
  {
   "file": "shard_L11.cmd",
   "bytes_now": 24974298,
   "bytes_bound": 26565393,
   "bytes_illustration": 24925620
  },
  {
   "file": "shard_L12.cmd",
   "bytes_now": 24974321,
   "bytes_bound": 26565393,
   "bytes_illustration": 24925643
  },
  {
   "file": "shard_L13.cmd",
   "bytes_now": 24974074,
   "bytes_bound": 26565393,
   "bytes_illustration": 24925396
  },
  {
   "file": "shard_L14.cmd",
   "bytes_now": 24973598,
   "bytes_bound": 26565393,
   "bytes_illustration": 24924920
  },
  {
   "file": "shard_L15.cmd",
   "bytes_now": 24974281,
   "bytes_bound": 26565393,
   "bytes_illustration": 24925603
  },
  {
   "file": "shard_L16.cmd",
   "bytes_now": 24973907,
   "bytes_bound": 26565393,
   "bytes_illustration": 24925229
  },
  {
   "file": "shard_L17.cmd",
   "bytes_now": 24973557,
   "bytes_bound": 26565393,
   "bytes_illustration": 24924879
  },
  {
   "file": "shard_L18.cmd",
   "bytes_now": 24974584,
   "bytes_bound": 26565393,
   "bytes_illustration": 24925906
  },
  {
   "file": "shard_L19.cmd",
   "bytes_now": 24973787,
   "bytes_bound": 26565393,
   "bytes_illustration": 24925109
  },
  {
   "file": "shard_L20.cmd",
   "bytes_now": 24974621,
   "bytes_bound": 26565393,
   "bytes_illustration": 24925943
  },
  {
   "file": "shard_L21.cmd",
   "bytes_now": 24974785,
   "bytes_bound": 26565393,
   "bytes_illustration": 24926107
  },
  {
   "file": "shard_L22.cmd",
   "bytes_now": 24973921,
   "bytes_bound": 26565393,
   "bytes_illustration": 24925243
  },
  {
   "file": "shard_L23.cmd",
   "bytes_now": 24974095,
   "bytes_bound": 26565393,
   "bytes_illustration": 24925417
  },
  {
   "file": "shard_L24.cmd",
   "bytes_now": 24973855,
   "bytes_bound": 26565393,
   "bytes_illustration": 24925177
  },
  {
   "file": "shard_L25.cmd",
   "bytes_now": 24974029,
   "bytes_bound": 26565393,
   "bytes_illustration": 24925351
  },
  {
   "file": "shard_L26.cmd",
   "bytes_now": 24973699,
   "bytes_bound": 26565393,
   "bytes_illustration": 24925021
  },
  {
   "file": "shard_L27.cmd",
   "bytes_now": 24974521,
   "bytes_bound": 26565393,
   "bytes_illustration": 24925843
  },
  {
   "file": "shard_L28.cmd",
   "bytes_now": 24974114,
   "bytes_bound": 26565393,
   "bytes_illustration": 24925436
  },
  {
   "file": "shard_L29.cmd",
   "bytes_now": 24973634,
   "bytes_bound": 26565393,
   "bytes_illustration": 24924956
  },
  {
   "file": "shard_L30.cmd",
   "bytes_now": 24974222,
   "bytes_bound": 26565393,
   "bytes_illustration": 24925544
  },
  {
   "file": "shard_L31.cmd",
   "bytes_now": 24974608,
   "bytes_bound": 26565393,
   "bytes_illustration": 24925930
  },
  {
   "file": "shard_L32.cmd",
   "bytes_now": 24974045,
   "bytes_bound": 26565393,
   "bytes_illustration": 24925367
  },
  {
   "file": "shard_L33.cmd",
   "bytes_now": 24973953,
   "bytes_bound": 26565393,
   "bytes_illustration": 24925275
  },
  {
   "file": "shard_L34.cmd",
   "bytes_now": 24973887,
   "bytes_bound": 26565393,
   "bytes_illustration": 24925209
  },
  {
   "file": "shard_L35.cmd",
   "bytes_now": 24973946,
   "bytes_bound": 26565393,
   "bytes_illustration": 24925268
  },
  {
   "file": "shard_L36.cmd",
   "bytes_now": 24974541,
   "bytes_bound": 26565393,
   "bytes_illustration": 24925863
  }
 ]
}