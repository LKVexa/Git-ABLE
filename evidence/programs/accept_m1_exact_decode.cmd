@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): accept_m1_exact_decode.json. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to print the document, with /check to check its SHA-512, or with /extract FILE to write it out.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=accept_m1_exact_decode.json"
set "LB_DOC_TYPE=json"
set "LB_DOC_BYTES=4293"
set "LB_DOC_SHA512=34698e34a59e8bb1681d1a642f36a6bedc5175e3e197fcbb12e98daaa4ce1912877f988610172f1961f860803cefd6330105322e6d8f307cb683c0dbcc620cc4"
set "LB_SELF=%~f0"
set "LB_ARG=%~1"
set "LB_OUT=%~f2"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$n=[int]$env:LB_DOC_BYTES;$b=[IO.File]::ReadAllBytes($env:LB_SELF);$o=$b.Length-$n;$h=-join((New-Object Security.Cryptography.SHA512Managed).ComputeHash($b,$o,$n)|%%{$_.ToString('x2')});if($h -ne $env:LB_DOC_SHA512){[Console]::Error.WriteLine('LB-DOC/1: the SHA-512 of '+$env:LB_DOC+' differs from LB_DOC_SHA512');exit 1};if($env:LB_ARG -eq '/check'){'ok: '+$env:LB_DOC;exit 0};if($env:LB_ARG -eq '/extract'){$d=New-Object byte[] $n;[Array]::Copy($b,$o,$d,0,$n);[IO.File]::WriteAllBytes($env:LB_OUT,$d);'written: '+$env:LB_OUT;exit 0};[Console]::OutputEncoding=New-Object Text.UTF8Encoding $false;[Console]::Out.Write([Text.Encoding]::UTF8.GetString($b,$o,$n));exit 0"
set "LB_RC=%errorlevel%"
if "%LB_ARG%"=="" pause
exit /b %LB_RC%
rem ---- document ----
{
 "program": "kgd/accept_m1_exact_decode.cmd",
 "source_sha512": "3c1d185ffaa755f209bfef667447b6f8aa72cab44bcbfd728ccc12f2d54c702be4f122e443282c996a491f5afa2dc3711943d3eb356435d8e627b5edcedbe4f0",
 "file_sha512": "7247c51c0a56580aecc049e9f21aa622e333e3574177c5133d3ad38fcf36f2bfc55470316a9ede82c76bf43ae06eb333f2719ee21bf32e1d14164216c5aa098e",
 "runner": "lcufx\\LCUFX_KGD.cmd run --twice (tools\\KGD_ENGINE.cmd host)",
 "expected": "accept",
 "observed": "accept",
 "as_expected": true,
 "exit_code": 0,
 "seconds": 5.2,
 "output": {
  "status": "host_research_pass",
  "language": "LCUF-X/0.2+lkvexa.kgd_imq/0.2",
  "source_sha512": "3c1d185ffaa755f209bfef667447b6f8aa72cab44bcbfd728ccc12f2d54c702be4f122e443282c996a491f5afa2dc3711943d3eb356435d8e627b5edcedbe4f0",
  "semantic_sha512": "bc129be286943aa6907cbb31378e58c34a0630dc81eb90ea7d215a28530c28f2a38ca9e1ffc40be5f71301a02de2e38d7040be91f870a2692e1f63c58adc9d0c",
  "values": {
   "n": 64,
   "path": "../../../weights/model1-untrained/exact/manifest.cmd",
   "pin": "2824a03df39ab370306ebf0f04f9d72afccb7a171f06997c58eddfac420e697e235b83ae32f9a89b5aa956c7aef785b0920aacbd6ea95eacb74fbb7eae3fb627",
   "text": "LCUF-X/0.2 admits ",
   "tier": "exact",
   "continuation": "                                                                "
  },
  "admission": {
   "reserved_work": {
    "s": 15531507261
   },
   "retained_payload_bytes": {
    "s": 54526105
   },
   "peak_modeled_scratch_bytes": {
    "s": 191552
   },
   "minimum_row_work": {
    "c_path": 1,
    "c_pin": 1,
    "c_tier": 1,
    "w": 54525494,
    "c_text": 1,
    "tok": 1,
    "c_n": 1,
    "gen": 15476981760,
    "out": 1
   }
  },
  "row_order": [
   "c_n",
   "c_path",
   "c_pin",
   "c_text",
   "c_tier",
   "tok",
   "w",
   "gen",
   "out"
  ],
  "receipts": [
   {
    "scope": "LCUF_X_KGD_HOST_RESEARCH",
    "row": "w",
    "site": "s",
    "profile": "lkvexa.weights.cmd",
    "semantic_sha512": "bc129be286943aa6907cbb31378e58c34a0630dc81eb90ea7d215a28530c28f2a38ca9e1ffc40be5f71301a02de2e38d7040be91f870a2692e1f63c58adc9d0c",
    "previous_sha512": "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
    "result_sha512": "2824a03df39ab370306ebf0f04f9d72afccb7a171f06997c58eddfac420e697e235b83ae32f9a89b5aa956c7aef785b0920aacbd6ea95eacb74fbb7eae3fb627",
    "sha512": "be5c30c8a5d37523a58ef6f7ed3ed16380a5b466e1de46f11d8fbe2fec1556492b9e22e9c593b8cf3f66a1740b13a90b794afd1deacac27c9bd2f9bf87f9445e"
   },
   {
    "scope": "LCUF_X_KGD_HOST_RESEARCH",
    "row": "gen",
    "site": "s",
    "profile": "lkvexa.llm.decode",
    "semantic_sha512": "bc129be286943aa6907cbb31378e58c34a0630dc81eb90ea7d215a28530c28f2a38ca9e1ffc40be5f71301a02de2e38d7040be91f870a2692e1f63c58adc9d0c",
    "previous_sha512": "be5c30c8a5d37523a58ef6f7ed3ed16380a5b466e1de46f11d8fbe2fec1556492b9e22e9c593b8cf3f66a1740b13a90b794afd1deacac27c9bd2f9bf87f9445e",
    "result_sha512": "f8fd31f8676a52d8f18396161149e1a6362e623e278866203531df3e3cc20b8d42c9e41ce9af318b85ce8efff2fee6c476b3f57193d2471928994f540f26ecaa",
    "sha512": "46ed696dabe8799a5ce8b00dc51c093b6ba8c150aab8119e831bf4203919ebc297e43c54c0d574cb015eccf4fe93963dfb0aa9418d2805a674d175152c7b5fd0"
   },
   {
    "scope": "LCUF_X_KGD_HOST_RESEARCH",
    "row": "out",
    "site": "s",
    "profile": "lcuf.evidence",
    "semantic_sha512": "bc129be286943aa6907cbb31378e58c34a0630dc81eb90ea7d215a28530c28f2a38ca9e1ffc40be5f71301a02de2e38d7040be91f870a2692e1f63c58adc9d0c",
    "previous_sha512": "46ed696dabe8799a5ce8b00dc51c093b6ba8c150aab8119e831bf4203919ebc297e43c54c0d574cb015eccf4fe93963dfb0aa9418d2805a674d175152c7b5fd0",
    "result_sha512": "f8fd31f8676a52d8f18396161149e1a6362e623e278866203531df3e3cc20b8d42c9e41ce9af318b85ce8efff2fee6c476b3f57193d2471928994f540f26ecaa",
    "value": "                                                                ",
    "sha512": "47f791922f450df4a9ec709581a3528b66f1a1c0064ad0c2d20c4223d83b2397fed2c34f4e0e92ce4f881daa3a3da61783bf75274b19625577a1e52715a957e8"
   }
  ],
  "receipt_chain_head": "47f791922f450df4a9ec709581a3528b66f1a1c0064ad0c2d20c4223d83b2397fed2c34f4e0e92ce4f881daa3a3da61783bf75274b19625577a1e52715a957e8",
  "evaluated_twice": true,
  "native_cmd_execution": false
 }
}