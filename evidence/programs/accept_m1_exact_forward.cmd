@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): accept_m1_exact_forward.json. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to print the document, with /check to check its SHA-512, or with /extract FILE to write it out.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=accept_m1_exact_forward.json"
set "LB_DOC_TYPE=json"
set "LB_DOC_BYTES=4923"
set "LB_DOC_SHA512=310928e1baf71c8fd6134913256af440094313ee5c4d142f89810911576fc71f6a194f5ed514dece9101258ed8feef7f440569eaec828d53571577326867892b"
set "LB_SELF=%~f0"
set "LB_ARG=%~1"
set "LB_OUT=%~f2"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$n=[int]$env:LB_DOC_BYTES;$b=[IO.File]::ReadAllBytes($env:LB_SELF);$o=$b.Length-$n;$h=-join((New-Object Security.Cryptography.SHA512Managed).ComputeHash($b,$o,$n)|%%{$_.ToString('x2')});if($h -ne $env:LB_DOC_SHA512){[Console]::Error.WriteLine('LB-DOC/1: the SHA-512 of '+$env:LB_DOC+' differs from LB_DOC_SHA512');exit 1};if($env:LB_ARG -eq '/check'){'ok: '+$env:LB_DOC;exit 0};if($env:LB_ARG -eq '/extract'){$d=New-Object byte[] $n;[Array]::Copy($b,$o,$d,0,$n);[IO.File]::WriteAllBytes($env:LB_OUT,$d);'written: '+$env:LB_OUT;exit 0};[Console]::OutputEncoding=New-Object Text.UTF8Encoding $false;[Console]::Out.Write([Text.Encoding]::UTF8.GetString($b,$o,$n));exit 0"
set "LB_RC=%errorlevel%"
if "%LB_ARG%"=="" pause
exit /b %LB_RC%
rem ---- document ----
{
 "program": "kgd/accept_m1_exact_forward.cmd",
 "source_sha512": "6ed9691650e8acadc2139d36a8dbab7440933413aba2836a9ff3b064fff2434b1c2c15d603f6f3b03f2fd5596e58f5eacd7bf2b26a3cc3475a9751eb237006b7",
 "file_sha512": "db1a7ac20777f1ee9d919bc8087951694d676f739b5e679ad3592cf7f61dcd341fa7a52de08cff6bb9101e4120cdf9e271e1883450daeb7024278f6a59ff89db",
 "runner": "lcufx\\LCUFX_KGD.cmd run --twice (tools\\KGD_ENGINE.cmd host)",
 "expected": "accept",
 "observed": "accept",
 "as_expected": true,
 "exit_code": 0,
 "seconds": 1.4,
 "output": {
  "status": "host_research_pass",
  "language": "LCUF-X/0.2+lkvexa.kgd_imq/0.2",
  "source_sha512": "6ed9691650e8acadc2139d36a8dbab7440933413aba2836a9ff3b064fff2434b1c2c15d603f6f3b03f2fd5596e58f5eacd7bf2b26a3cc3475a9751eb237006b7",
  "semantic_sha512": "ea0bf0ac49ec97cb014d2892e68a3e7463470dc888b3165fa5a8fc4633f6483143cb1ce53784b7081e40d0a8146203488730728a681ff7f05841ce6c9c36cd0b",
  "values": {
   "l00": 0,
   "l01": 1,
   "l02": 2,
   "l03": 3,
   "path": "../../../weights/model1-untrained/exact/manifest.cmd",
   "pin": "2824a03df39ab370306ebf0f04f9d72afccb7a171f06997c58eddfac420e697e235b83ae32f9a89b5aa956c7aef785b0920aacbd6ea95eacb74fbb7eae3fb627",
   "ref": 5.59829033138504,
   "text": " 88630528.\nln(49152) in millionths: 10802673, which rounds to 10.80. Step-0 plots say 10.8868. T",
   "tier": "exact",
   "tol": 0.0001,
   "loss": 5.598290324140858
  },
  "admission": {
   "reserved_work": {
    "s": 384876099
   },
   "retained_payload_bytes": {
    "s": 55902855
   },
   "peak_modeled_scratch_bytes": {
    "s": 786432
   },
   "minimum_row_work": {
    "c_path": 1,
    "c_pin": 1,
    "c_tier": 1,
    "w": 54525494,
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
    "semantic_sha512": "ea0bf0ac49ec97cb014d2892e68a3e7463470dc888b3165fa5a8fc4633f6483143cb1ce53784b7081e40d0a8146203488730728a681ff7f05841ce6c9c36cd0b",
    "previous_sha512": "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
    "result_sha512": "2824a03df39ab370306ebf0f04f9d72afccb7a171f06997c58eddfac420e697e235b83ae32f9a89b5aa956c7aef785b0920aacbd6ea95eacb74fbb7eae3fb627",
    "sha512": "45ddc8c98d6724543e71f6ef2c09a813976395ffc3e97859f3c780c267ce3281a5c728eec3a0e2a809b8bc88802bd479d8a8a5d99dee9cbcff4fa4f5fe06ad25"
   },
   {
    "scope": "LCUF_X_KGD_HOST_RESEARCH",
    "row": "ce",
    "site": "s",
    "profile": "lkvexa.llm",
    "semantic_sha512": "ea0bf0ac49ec97cb014d2892e68a3e7463470dc888b3165fa5a8fc4633f6483143cb1ce53784b7081e40d0a8146203488730728a681ff7f05841ce6c9c36cd0b",
    "previous_sha512": "45ddc8c98d6724543e71f6ef2c09a813976395ffc3e97859f3c780c267ce3281a5c728eec3a0e2a809b8bc88802bd479d8a8a5d99dee9cbcff4fa4f5fe06ad25",
    "result_sha512": "bb530dee6c169d6774d5a973c0fc8b92a2d90f408794b6ef22b2f1bed6868b7c5830182ef562a7bab0b122121028e16336370ce6b9cffdaca2a1ec0c47ca0242",
    "sha512": "fcd2499895084c1438daa3d5dbcf3ec6ada76f51fc06b30a7b5e48604a2931024e3dfbf010908287ec2edbf61e468fefbae91e3e0bfdd154d0a10efbb228055d"
   },
   {
    "scope": "LCUF_X_KGD_HOST_RESEARCH",
    "row": "out",
    "site": "s",
    "profile": "lcuf.evidence",
    "semantic_sha512": "ea0bf0ac49ec97cb014d2892e68a3e7463470dc888b3165fa5a8fc4633f6483143cb1ce53784b7081e40d0a8146203488730728a681ff7f05841ce6c9c36cd0b",
    "previous_sha512": "fcd2499895084c1438daa3d5dbcf3ec6ada76f51fc06b30a7b5e48604a2931024e3dfbf010908287ec2edbf61e468fefbae91e3e0bfdd154d0a10efbb228055d",
    "result_sha512": "bb530dee6c169d6774d5a973c0fc8b92a2d90f408794b6ef22b2f1bed6868b7c5830182ef562a7bab0b122121028e16336370ce6b9cffdaca2a1ec0c47ca0242",
    "value": 5.598290324140858,
    "sha512": "56a5d22d71e7192979e9bab97cd0ec1a8ebc62eb8842936303d71a83adf73734ec26dc7075f2481189ecdfa6d9f9c8eaf9d2149564cffc80e4e195a9e858b20e"
   }
  ],
  "receipt_chain_head": "56a5d22d71e7192979e9bab97cd0ec1a8ebc62eb8842936303d71a83adf73734ec26dc7075f2481189ecdfa6d9f9c8eaf9d2149564cffc80e4e195a9e858b20e",
  "evaluated_twice": true,
  "native_cmd_execution": false
 }
}