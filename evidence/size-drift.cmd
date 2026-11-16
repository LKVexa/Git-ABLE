@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): size-drift.json. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to print the document, with /check to check its SHA-512, or with /extract FILE to write it out.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=size-drift.json"
set "LB_DOC_TYPE=json"
set "LB_DOC_BYTES=7132"
set "LB_DOC_SHA512=60c52de948a434f46a115b53a7c1aa13e31972ecfc522c1486c8f727164ac9ed210da2eb6585c84ba3abb1c38fd6f8434e4fd138b25d4229b443e176f3f79749"
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
  "total": 874173645,
  "largest": 16959468
 },
 "model2_bound_every_value_11_chars": {
  "total": 929758995,
  "largest": 17960298,
  "shards_over_24000000": 0
 },
 "shard_cap": 24000000,
 "mean_chars_per_value_model2_init": {
  "q16": 5.0,
  "scalar": 1.191,
  "scale": 9.0,
  "sign": 9.983
 },
 "values_per_category_model2": {
  "q16": 3607808,
  "scalar": 1248,
  "scale": 12871680,
  "sign": 8044800
 },
 "note": "training changes values, never how many words a set holds; a value is 1 to 11 characters, so the bound is the most any training can add",
 "shards": [
  {
   "file": "shard_EMB0.cmd",
   "bytes_now": 11867560,
   "bytes_bound": 12450996
  },
  {
   "file": "shard_EMB1.cmd",
   "bytes_now": 13161506,
   "bytes_bound": 14058831
  },
  {
   "file": "shard_L00_ATTN.cmd",
   "bytes_now": 8016044,
   "bytes_bound": 8605854
  },
  {
   "file": "shard_L00_FFN.cmd",
   "bytes_now": 16958859,
   "bytes_bound": 17960298
  },
  {
   "file": "shard_L01_ATTN.cmd",
   "bytes_now": 8016454,
   "bytes_bound": 8605854
  },
  {
   "file": "shard_L01_FFN.cmd",
   "bytes_now": 16958781,
   "bytes_bound": 17960298
  },
  {
   "file": "shard_L02_ATTN.cmd",
   "bytes_now": 8016058,
   "bytes_bound": 8605854
  },
  {
   "file": "shard_L02_FFN.cmd",
   "bytes_now": 16957999,
   "bytes_bound": 17960298
  },
  {
   "file": "shard_L03_ATTN.cmd",
   "bytes_now": 8016097,
   "bytes_bound": 8605854
  },
  {
   "file": "shard_L03_FFN.cmd",
   "bytes_now": 16958359,
   "bytes_bound": 17960298
  },
  {
   "file": "shard_L04_ATTN.cmd",
   "bytes_now": 8016287,
   "bytes_bound": 8605854
  },
  {
   "file": "shard_L04_FFN.cmd",
   "bytes_now": 16958212,
   "bytes_bound": 17960298
  },
  {
   "file": "shard_L05_ATTN.cmd",
   "bytes_now": 8016630,
   "bytes_bound": 8605854
  },
  {
   "file": "shard_L05_FFN.cmd",
   "bytes_now": 16958465,
   "bytes_bound": 17960298
  },
  {
   "file": "shard_L06_ATTN.cmd",
   "bytes_now": 8016263,
   "bytes_bound": 8605854
  },
  {
   "file": "shard_L06_FFN.cmd",
   "bytes_now": 16958684,
   "bytes_bound": 17960298
  },
  {
   "file": "shard_L07_ATTN.cmd",
   "bytes_now": 8016189,
   "bytes_bound": 8605854
  },
  {
   "file": "shard_L07_FFN.cmd",
   "bytes_now": 16958858,
   "bytes_bound": 17960298
  },
  {
   "file": "shard_L08_ATTN.cmd",
   "bytes_now": 8016180,
   "bytes_bound": 8605854
  },
  {
   "file": "shard_L08_FFN.cmd",
   "bytes_now": 16958371,
   "bytes_bound": 17960298
  },
  {
   "file": "shard_L09_ATTN.cmd",
   "bytes_now": 8016505,
   "bytes_bound": 8605854
  },
  {
   "file": "shard_L09_FFN.cmd",
   "bytes_now": 16958808,
   "bytes_bound": 17960298
  },
  {
   "file": "shard_L10_ATTN.cmd",
   "bytes_now": 8016421,
   "bytes_bound": 8605854
  },
  {
   "file": "shard_L10_FFN.cmd",
   "bytes_now": 16958112,
   "bytes_bound": 17960298
  },
  {
   "file": "shard_L11_ATTN.cmd",
   "bytes_now": 8016666,
   "bytes_bound": 8605854
  },
  {
   "file": "shard_L11_FFN.cmd",
   "bytes_now": 16958390,
   "bytes_bound": 17960298
  },
  {
   "file": "shard_L12_ATTN.cmd",
   "bytes_now": 8016331,
   "bytes_bound": 8605854
  },
  {
   "file": "shard_L12_FFN.cmd",
   "bytes_now": 16958748,
   "bytes_bound": 17960298
  },
  {
   "file": "shard_L13_ATTN.cmd",
   "bytes_now": 8016288,
   "bytes_bound": 8605854
  },
  {
   "file": "shard_L13_FFN.cmd",
   "bytes_now": 16958544,
   "bytes_bound": 17960298
  },
  {
   "file": "shard_L14_ATTN.cmd",
   "bytes_now": 8016109,
   "bytes_bound": 8605854
  },
  {
   "file": "shard_L14_FFN.cmd",
   "bytes_now": 16958247,
   "bytes_bound": 17960298
  },
  {
   "file": "shard_L15_ATTN.cmd",
   "bytes_now": 8016278,
   "bytes_bound": 8605854
  },
  {
   "file": "shard_L15_FFN.cmd",
   "bytes_now": 16958761,
   "bytes_bound": 17960298
  },
  {
   "file": "shard_L16_ATTN.cmd",
   "bytes_now": 8015877,
   "bytes_bound": 8605854
  },
  {
   "file": "shard_L16_FFN.cmd",
   "bytes_now": 16958788,
   "bytes_bound": 17960298
  },
  {
   "file": "shard_L17_ATTN.cmd",
   "bytes_now": 8016277,
   "bytes_bound": 8605854
  },
  {
   "file": "shard_L17_FFN.cmd",
   "bytes_now": 16958038,
   "bytes_bound": 17960298
  },
  {
   "file": "shard_L18_ATTN.cmd",
   "bytes_now": 8016688,
   "bytes_bound": 8605854
  },
  {
   "file": "shard_L18_FFN.cmd",
   "bytes_now": 16958654,
   "bytes_bound": 17960298
  },
  {
   "file": "shard_L19_ATTN.cmd",
   "bytes_now": 8016021,
   "bytes_bound": 8605854
  },
  {
   "file": "shard_L19_FFN.cmd",
   "bytes_now": 16958524,
   "bytes_bound": 17960298
  },
  {
   "file": "shard_L20_ATTN.cmd",
   "bytes_now": 8016243,
   "bytes_bound": 8605854
  },
  {
   "file": "shard_L20_FFN.cmd",
   "bytes_now": 16959136,
   "bytes_bound": 17960298
  },
  {
   "file": "shard_L21_ATTN.cmd",
   "bytes_now": 8016075,
   "bytes_bound": 8605854
  },
  {
   "file": "shard_L21_FFN.cmd",
   "bytes_now": 16959468,
   "bytes_bound": 17960298
  },
  {
   "file": "shard_L22_ATTN.cmd",
   "bytes_now": 8016252,
   "bytes_bound": 8605854
  },
  {
   "file": "shard_L22_FFN.cmd",
   "bytes_now": 16958427,
   "bytes_bound": 17960298
  },
  {
   "file": "shard_L23_ATTN.cmd",
   "bytes_now": 8016382,
   "bytes_bound": 8605854
  },
  {
   "file": "shard_L23_FFN.cmd",
   "bytes_now": 16958471,
   "bytes_bound": 17960298
  },
  {
   "file": "shard_L24_ATTN.cmd",
   "bytes_now": 8016111,
   "bytes_bound": 8605854
  },
  {
   "file": "shard_L24_FFN.cmd",
   "bytes_now": 16958502,
   "bytes_bound": 17960298
  },
  {
   "file": "shard_L25_ATTN.cmd",
   "bytes_now": 8016111,
   "bytes_bound": 8605854
  },
  {
   "file": "shard_L25_FFN.cmd",
   "bytes_now": 16958676,
   "bytes_bound": 17960298
  },
  {
   "file": "shard_L26_ATTN.cmd",
   "bytes_now": 8016264,
   "bytes_bound": 8605854
  },
  {
   "file": "shard_L26_FFN.cmd",
   "bytes_now": 16958193,
   "bytes_bound": 17960298
  },
  {
   "file": "shard_L27_ATTN.cmd",
   "bytes_now": 8016314,
   "bytes_bound": 8605854
  },
  {
   "file": "shard_L27_FFN.cmd",
   "bytes_now": 16958965,
   "bytes_bound": 17960298
  },
  {
   "file": "shard_L28_ATTN.cmd",
   "bytes_now": 8016195,
   "bytes_bound": 8605854
  },
  {
   "file": "shard_L28_FFN.cmd",
   "bytes_now": 16958677,
   "bytes_bound": 17960298
  },
  {
   "file": "shard_L29_ATTN.cmd",
   "bytes_now": 8016473,
   "bytes_bound": 8605854
  },
  {
   "file": "shard_L29_FFN.cmd",
   "bytes_now": 16957919,
   "bytes_bound": 17960298
  },
  {
   "file": "shard_L30_ATTN.cmd",
   "bytes_now": 8016114,
   "bytes_bound": 8605854
  },
  {
   "file": "shard_L30_FFN.cmd",
   "bytes_now": 16958866,
   "bytes_bound": 17960298
  },
  {
   "file": "shard_L31_ATTN.cmd",
   "bytes_now": 8016307,
   "bytes_bound": 8605854
  },
  {
   "file": "shard_L31_FFN.cmd",
   "bytes_now": 16959059,
   "bytes_bound": 17960298
  },
  {
   "file": "shard_L32_ATTN.cmd",
   "bytes_now": 8016261,
   "bytes_bound": 8605854
  },
  {
   "file": "shard_L32_FFN.cmd",
   "bytes_now": 16958542,
   "bytes_bound": 17960298
  },
  {
   "file": "shard_L33_ATTN.cmd",
   "bytes_now": 8016151,
   "bytes_bound": 8605854
  },
  {
   "file": "shard_L33_FFN.cmd",
   "bytes_now": 16958560,
   "bytes_bound": 17960298
  }
 ]
}