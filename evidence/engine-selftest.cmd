@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): selftest.json. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to print the document, with /check to check its SHA-512, or with /extract FILE to write it out.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=selftest.json"
set "LB_DOC_TYPE=json"
set "LB_DOC_BYTES=3758"
set "LB_DOC_SHA512=ddebd23ea1eb44e26bf7dc1cdfe1df5462a96dfd09577fa573063d9d76fabfd65516daf969f24346ed65b06db0aca08ec7b87fb24186958ee5e55a886c27d235"
set "LB_SELF=%~f0"
set "LB_ARG=%~1"
set "LB_OUT=%~f2"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$n=[int]$env:LB_DOC_BYTES;$b=[IO.File]::ReadAllBytes($env:LB_SELF);$o=$b.Length-$n;$h=-join((New-Object Security.Cryptography.SHA512Managed).ComputeHash($b,$o,$n)|%%{$_.ToString('x2')});if($h -ne $env:LB_DOC_SHA512){[Console]::Error.WriteLine('LB-DOC/1: the SHA-512 of '+$env:LB_DOC+' differs from LB_DOC_SHA512');exit 1};if($env:LB_ARG -eq '/check'){'ok: '+$env:LB_DOC;exit 0};if($env:LB_ARG -eq '/extract'){$d=New-Object byte[] $n;[Array]::Copy($b,$o,$d,0,$n);[IO.File]::WriteAllBytes($env:LB_OUT,$d);'written: '+$env:LB_OUT;exit 0};[Console]::OutputEncoding=New-Object Text.UTF8Encoding $false;[Console]::Out.Write([Text.Encoding]::UTF8.GetString($b,$o,$n));exit 0"
set "LB_RC=%errorlevel%"
if "%LB_ARG%"=="" pause
exit /b %LB_RC%
rem ---- document ----
{
 "pcg64_2026_next64": {
  "ok": true,
  "got": [
   "3300764713747675562",
   "11804314397344746687",
   "8619580609625321962",
   "6834528402736651379"
  ],
  "want": [
   "3300764713747675562",
   "11804314397344746687",
   "8619580609625321962",
   "6834528402736651379"
  ]
 },
 "sign_words_L00_QKVO_U1": {
  "ok": true,
  "got": [
   -1357108444,
   859180294,
   1330191283,
   -205423874,
   499803457,
   662103015
  ],
  "want": [
   -1357108444,
   859180294,
   1330191283,
   -205423874,
   499803457,
   662103015
  ]
 },
 "integers_0_256_seed5": {
  "ok": true,
  "got": [
   171,
   206,
   5,
   206,
   120,
   131,
   161,
   73,
   250,
   13,
   71,
   98
  ],
  "want": [
   171,
   206,
   5,
   206,
   120,
   131,
   161,
   73,
   250,
   13,
   71,
   98
  ]
 },
 "normal_bits_0_emb": {
  "ok": true,
  "got": [
   "bfd3634c4e9bd4c4",
   "3fed23c8946f8060",
   "bfbc5b0231230e22",
   "3fd4f17c0a3009e4",
   "3fe1341edeba606d",
   "3ff0f5a4f973feeb"
  ],
  "want": [
   "bfd3634c4e9bd4c4",
   "3fed23c8946f8060",
   "bfbc5b0231230e22",
   "3fd4f17c0a3009e4",
   "3fe1341edeba606d",
   "3ff0f5a4f973feeb"
  ]
 },
 "fdlibm_log1p_bits": {
  "ok": true,
  "got": [
   "bfe62e42fefa39ef",
   "c002957da044a298",
   "be112e0be84bbb51",
   "bfd5eb5c7907e4c8",
   "3fd588c2d9133490",
   "3ff40b512eb53d60",
   "01a56e1fc2f8f359",
   "c02ba18a998fc064"
  ],
  "want": [
   "bfe62e42fefa39ef",
   "c002957da044a298",
   "be112e0be84bbb51",
   "bfd5eb5c7907e4c8",
   "3fd588c2d9133490",
   "3ff40b512eb53d60",
   "01a56e1fc2f8f359",
   "c02ba18a998fc064"
  ]
 },
 "python_repr": {
  "ok": true,
  "got": [
   "1e-05",
   "0.0001",
   "0.1",
   "1e+16",
   "1234567890123456.0",
   "123.0",
   "2.424032688140869",
   "1e+300",
   "0.0198974609375",
   "-0.0",
   "5e-324",
   "10.957915306091309",
   "0.0500030517578125",
   "0.04973510694105353",
   "1.0010394542379546",
   "0.9999923706054688",
   "17.07",
   "0.3333333333333333"
  ],
  "want": [
   "1e-05",
   "0.0001",
   "0.1",
   "1e+16",
   "1234567890123456.0",
   "123.0",
   "2.424032688140869",
   "1e+300",
   "0.0198974609375",
   "-0.0",
   "5e-324",
   "10.957915306091309",
   "0.0500030517578125",
   "0.04973510694105353",
   "1.0010394542379546",
   "0.9999923706054688",
   "17.07",
   "0.3333333333333333"
  ]
 },
 "sha512_abc": {
  "ok": true,
  "got": "ddaf35a193617abacc417349ae20413112e6fa4e89a97ea20a9eeee64b55d39a2192992a274fc1a836ba3c23a3feebbd454d4423643ce80e2a9ac94fa54ca49f",
  "want": "ddaf35a193617abacc417349ae20413112e6fa4e89a97ea20a9eeee64b55d39a2192992a274fc1a836ba3c23a3feebbd454d4423643ce80e2a9ac94fa54ca49f"
 },
 "model1_seed0_init_sha512": {
  "ok": true,
  "got": "234e3cc523154612b292e464dff3cde4d8000f53d55fdd39f828e2a5f60c859895b723471df7b72c87ca6a7a6aea1ad1758765e2b369b29df33b39fc00b68065",
  "want": "234e3cc523154612b292e464dff3cde4d8000f53d55fdd39f828e2a5f60c859895b723471df7b72c87ca6a7a6aea1ad1758765e2b369b29df33b39fc00b68065"
 },
 "json_dump": {
  "ok": true,
  "got": "{\n \"b\": [\n  1,\n  2.5,\n  1e-05,\n  1e+16,\n  true,\n  null,\n  \"x|y \\u00e9 \\u2264\"\n ],\n \"a\": {\n  \"z\": 0.1,\n  \"y\": -3,\n  \"e\": {},\n  \"l\": []\n },\n \"s\": \"tab\\t\\\"q\\\"\"\n}",
  "want": "{\n \"b\": [\n  1,\n  2.5,\n  1e-05,\n  1e+16,\n  true,\n  null,\n  \"x|y \\u00e9 \\u2264\"\n ],\n \"a\": {\n  \"z\": 0.1,\n  \"y\": -3,\n  \"e\": {},\n  \"l\": []\n },\n \"s\": \"tab\\t\\\"q\\\"\"\n}"
 },
 "json_canonical": {
  "ok": true,
  "got": "{\"a\":{\"e\":{},\"l\":[],\"y\":-3,\"z\":0.1},\"b\":[1,2.5,1e-05,1e+16,true,null,\"x|y \u00e9 \u2264\"],\"s\":\"tab\\t\\\"q\\\"\"}",
  "want": "{\"a\":{\"e\":{},\"l\":[],\"y\":-3,\"z\":0.1},\"b\":[1,2.5,1e-05,1e+16,true,null,\"x|y \u00e9 \u2264\"],\"s\":\"tab\\t\\\"q\\\"\"}"
 },
 "all_pass": true
}