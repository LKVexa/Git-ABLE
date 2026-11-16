@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): accept_m1_tier2_forward.json. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to print the document, with /check to check its SHA-512, or with /extract FILE to write it out.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=accept_m1_tier2_forward.json"
set "LB_DOC_TYPE=json"
set "LB_DOC_BYTES=4922"
set "LB_DOC_SHA512=4fe502e3b8bc4fad5c3a0674ad477443e3e9aca9d1f959110898684ff6b7e9f54e0e632c42427ddee1d159be37ea93c2eb318e70be4d9ea3310e5fef03e6a14e"
set "LB_SELF=%~f0"
set "LB_ARG=%~1"
set "LB_OUT=%~f2"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$n=[int]$env:LB_DOC_BYTES;$b=[IO.File]::ReadAllBytes($env:LB_SELF);$o=$b.Length-$n;$h=-join((New-Object Security.Cryptography.SHA512Managed).ComputeHash($b,$o,$n)|%%{$_.ToString('x2')});if($h -ne $env:LB_DOC_SHA512){[Console]::Error.WriteLine('LB-DOC/1: the SHA-512 of '+$env:LB_DOC+' differs from LB_DOC_SHA512');exit 1};if($env:LB_ARG -eq '/check'){'ok: '+$env:LB_DOC;exit 0};if($env:LB_ARG -eq '/extract'){$d=New-Object byte[] $n;[Array]::Copy($b,$o,$d,0,$n);[IO.File]::WriteAllBytes($env:LB_OUT,$d);'written: '+$env:LB_OUT;exit 0};[Console]::OutputEncoding=New-Object Text.UTF8Encoding $false;[Console]::Out.Write([Text.Encoding]::UTF8.GetString($b,$o,$n));exit 0"
set "LB_RC=%errorlevel%"
if "%LB_ARG%"=="" pause
exit /b %LB_RC%
rem ---- document ----
{
 "program": "kgd/accept_m1_tier2_forward.cmd",
 "source_sha512": "e2228566871dab79c9a361cea73e38a50321a01f3ed78c9fa88e9c9632f4a4eeb69b60ea6d2b449787a90eb34ef359b426803997e845162cc7d2c6d5326d4138",
 "file_sha512": "b0d712fae13fe9efd05428d1bb2196eb20025be0ff1e6eec4bfa2fe8f5b05a1fa5481d6f822bdd774294beb8dccd2abf0b00bf8f2faae16c280764b2a9e6f86b",
 "runner": "lcufx\\LCUFX_KGD.cmd run --twice (tools\\KGD_ENGINE.cmd host)",
 "expected": "accept",
 "observed": "accept",
 "as_expected": true,
 "exit_code": 0,
 "seconds": 0.3,
 "output": {
  "status": "host_research_pass",
  "language": "LCUF-X/0.2+lkvexa.kgd_imq/0.2",
  "source_sha512": "e2228566871dab79c9a361cea73e38a50321a01f3ed78c9fa88e9c9632f4a4eeb69b60ea6d2b449787a90eb34ef359b426803997e845162cc7d2c6d5326d4138",
  "semantic_sha512": "74ffea15bf852c13567c9f186b1c7444ed940b552af0023aedb79e3fb4520463d3248f58dc8f2dff14e4e0deec917aacdc409f7a56570fd2c127ca2f6eb6b692",
  "values": {
   "l00": 0,
   "l01": 1,
   "l02": 2,
   "l03": 3,
   "path": "../../../weights/model1-untrained/tier2/manifest.cmd",
   "pin": "555eb9eb9d0c1de18e04a22fc1517d66516c673d8116b14edba6076655883966d2ba27ca72f958c3da3bda0eb33ce9aced61128480f10f9c07881f2a2c157499",
   "ref": 5.547993202382652,
   "text": " 88630528.\nln(49152) in millionths: 10802673, which rounds to 10.80. Step-0 plots say 10.8868. T",
   "tier": "tier2",
   "tol": 0.0001,
   "loss": 5.547993205805715
  },
  "admission": {
   "reserved_work": {
    "s": 334148395
   },
   "retained_payload_bytes": {
    "s": 5175151
   },
   "peak_modeled_scratch_bytes": {
    "s": 786432
   },
   "minimum_row_work": {
    "c_path": 1,
    "c_pin": 1,
    "c_tier": 1,
    "w": 3797790,
    "c_text": 1,
    "tok": 1,
    "e": 24576,
    "c_l00": 1,
    "a00": 23592960,
    "k00": 7077888,
    "f00": 50331648,
    "c_l01": 1,
    "a01": 23592960,
    "k01": 7077888,
    "f01": 50331648,
    "c_l02": 1,
    "a02": 23592960,
    "k02": 7077888,
    "f02": 50331648,
    "c_l03": 1,
    "a03": 23592960,
    "k03": 7077888,
    "f03": 50331648,
    "hd": 6291456,
    "ce": 24576,
    "c_ref": 1,
    "c_tol": 1,
    "chk": 1,
    "out": 1
   }
  },
  "row_order": [
   "c_l00",
   "c_l01",
   "c_l02",
   "c_l03",
   "c_path",
   "c_pin",
   "c_ref",
   "c_text",
   "c_tier",
   "c_tol",
   "tok",
   "w",
   "e",
   "a00",
   "k00",
   "f00",
   "a01",
   "k01",
   "f01",
   "a02",
   "k02",
   "f02",
   "a03",
   "k03",
   "f03",
   "hd",
   "ce",
   "chk",
   "out"
  ],
  "receipts": [
   {
    "scope": "LCUF_X_KGD_HOST_RESEARCH",
    "row": "w",
    "site": "s",
    "profile": "lkvexa.weights.cmd",
    "semantic_sha512": "74ffea15bf852c13567c9f186b1c7444ed940b552af0023aedb79e3fb4520463d3248f58dc8f2dff14e4e0deec917aacdc409f7a56570fd2c127ca2f6eb6b692",
    "previous_sha512": "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
    "result_sha512": "555eb9eb9d0c1de18e04a22fc1517d66516c673d8116b14edba6076655883966d2ba27ca72f958c3da3bda0eb33ce9aced61128480f10f9c07881f2a2c157499",
    "sha512": "b027539a15a9e1333b93db3187d975162ae127228e4966baa44e8e3a2dc2d5b2c55be7c6c64da66fece38a86a09fd667fd2b8d248aa54ada38e82a6945203da5"
   },
   {
    "scope": "LCUF_X_KGD_HOST_RESEARCH",
    "row": "ce",
    "site": "s",
    "profile": "lkvexa.llm",
    "semantic_sha512": "74ffea15bf852c13567c9f186b1c7444ed940b552af0023aedb79e3fb4520463d3248f58dc8f2dff14e4e0deec917aacdc409f7a56570fd2c127ca2f6eb6b692",
    "previous_sha512": "b027539a15a9e1333b93db3187d975162ae127228e4966baa44e8e3a2dc2d5b2c55be7c6c64da66fece38a86a09fd667fd2b8d248aa54ada38e82a6945203da5",
    "result_sha512": "31af3ead5e920e001f6db33e260ee67ef17b23859d9c682aa771001adc981ac0787a3f4de4c965cfabaf1b0cc8fced23bf46c99a22e245595a3cd8646a19e416",
    "sha512": "55e70840c3158d7160e40ab5ab0b3913a152ed224945f439b3268b457c6eeb0d1b55d4d2f55d377cea6ea97cc3610e5a6f4c34d54e59ebbeae189927c6a1714e"
   },
   {
    "scope": "LCUF_X_KGD_HOST_RESEARCH",
    "row": "out",
    "site": "s",
    "profile": "lcuf.evidence",
    "semantic_sha512": "74ffea15bf852c13567c9f186b1c7444ed940b552af0023aedb79e3fb4520463d3248f58dc8f2dff14e4e0deec917aacdc409f7a56570fd2c127ca2f6eb6b692",
    "previous_sha512": "55e70840c3158d7160e40ab5ab0b3913a152ed224945f439b3268b457c6eeb0d1b55d4d2f55d377cea6ea97cc3610e5a6f4c34d54e59ebbeae189927c6a1714e",
    "result_sha512": "31af3ead5e920e001f6db33e260ee67ef17b23859d9c682aa771001adc981ac0787a3f4de4c965cfabaf1b0cc8fced23bf46c99a22e245595a3cd8646a19e416",
    "value": 5.547993205805715,
    "sha512": "b98c4dc6bcff13ed91321ed43d48b7d4196ba714091a2b55d14b438905a0edd31a2361166bb9084dd5ea13604b31beaa281c905bb5d4fb97c90b09a35e25b4c8"
   }
  ],
  "receipt_chain_head": "b98c4dc6bcff13ed91321ed43d48b7d4196ba714091a2b55d14b438905a0edd31a2361166bb9084dd5ea13604b31beaa281c905bb5d4fb97c90b09a35e25b4c8",
  "evaluated_twice": true,
  "native_cmd_execution": false
 }
}