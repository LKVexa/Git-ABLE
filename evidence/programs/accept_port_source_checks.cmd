@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): accept_port_source_checks.json. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to print the document, with /check to check its SHA-512, or with /extract FILE to write it out.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=accept_port_source_checks.json"
set "LB_DOC_TYPE=json"
set "LB_DOC_BYTES=7320"
set "LB_DOC_SHA512=c8ba5a238e54c4af90fb262e539928b0836bee71cfe8e8a79afca981218d7f30f632d502ba3a4e7a2e4b52a39154d3297b1331dd02a55996d927e929c8cf5af7"
set "LB_SELF=%~f0"
set "LB_ARG=%~1"
set "LB_OUT=%~f2"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$n=[int]$env:LB_DOC_BYTES;$b=[IO.File]::ReadAllBytes($env:LB_SELF);$o=$b.Length-$n;$h=-join((New-Object Security.Cryptography.SHA512Managed).ComputeHash($b,$o,$n)|%%{$_.ToString('x2')});if($h -ne $env:LB_DOC_SHA512){[Console]::Error.WriteLine('LB-DOC/1: the SHA-512 of '+$env:LB_DOC+' differs from LB_DOC_SHA512');exit 1};if($env:LB_ARG -eq '/check'){'ok: '+$env:LB_DOC;exit 0};if($env:LB_ARG -eq '/extract'){$d=New-Object byte[] $n;[Array]::Copy($b,$o,$d,0,$n);[IO.File]::WriteAllBytes($env:LB_OUT,$d);'written: '+$env:LB_OUT;exit 0};[Console]::OutputEncoding=New-Object Text.UTF8Encoding $false;[Console]::Out.Write([Text.Encoding]::UTF8.GetString($b,$o,$n));exit 0"
set "LB_RC=%errorlevel%"
if "%LB_ARG%"=="" pause
exit /b %LB_RC%
rem ---- document ----
{
 "program": "kgd/accept_port_source_checks.cmd",
 "source_sha512": "e7ad1280b6abb380e823a75e8a97c2cbe7c58271498eff52181ad35b1387b48369b0a4d1cecb616fb2be8d789f5661f3fee9a59aa7f8567d145967c9c098df8d",
 "file_sha512": "24bac8aa8564846e7bf6d593dfc140c2bb229c68d969af760b5c250cef71bdcd39dd2fb010cd1a8410ca132f73a3cf5699aaaed2d8f9363ff5cf4a789f4f3e67",
 "runner": "lcufx\\LCUFX_KGD.cmd run --twice (tools\\KGD_ENGINE.cmd host)",
 "expected": "accept",
 "observed": "accept",
 "as_expected": true,
 "exit_code": 0,
 "seconds": 108.8,
 "output": {
  "status": "host_research_pass",
  "language": "LCUF-X/0.2+lkvexa.kgd_imq/0.2",
  "source_sha512": "e7ad1280b6abb380e823a75e8a97c2cbe7c58271498eff52181ad35b1387b48369b0a4d1cecb616fb2be8d789f5661f3fee9a59aa7f8567d145967c9c098df8d",
  "semantic_sha512": "9189e1ad9935d29c6c48373854c754165a8d987c0f84e29327afab345f1f5261d104dd32008d13e0cbd681d40baf375373e34a2ad914638ffed4909157f5ccc4",
  "values": {
   "group_adamw": "adamw",
   "group_all": "all",
   "cfgname": "default",
   "exp_c3": "{\"logits_shape\": [2, 16, 49152], \"scored_positions\": 30, \"loss\": {\"center\": 10.905, \"tolerance\": 0.25}, \"finite\": true}",
   "exp_c4": "{\"weights_unchanged_after_first_update\": true, \"max_abs_change\": 0.0}",
   "exp_adamw": 25191680,
   "exp_all": 88630528,
   "exp_muon": 63438848,
   "fx": "{\"ids\": [[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16], [17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32]]}",
   "group_muon": "muon",
   "seed": 0,
   "report_c3": "{\"logits_shape\": [2, 16, 49152], \"scored_positions\": 30, \"loss\": 10.957893340777588, \"finite\": true}",
   "count_adamw": 25191680,
   "count_all": 88630528,
   "count_muon": 63438848,
   "report_c4": "{\"weights_unchanged_after_first_update\": true, \"max_abs_change\": 0.0, \"grad_norm\": 12.668168243901702, \"lr_factor_first_update\": 0.0, \"muon_tensors\": 66, \"adamw_tensors\": 90}"
  },
  "admission": {
   "reserved_work": {
    "s": 22778045720
   },
   "retained_payload_bytes": {
    "s": 354530699
   },
   "peak_modeled_scratch_bytes": {
    "s": 1418088448
   },
   "minimum_row_work": {
    "c_cfg": 1,
    "c_seed": 1,
    "b": 88630528,
    "c_all": 1,
    "n_all": 1,
    "c_exp_all": 1,
    "chk_all": 1,
    "out_all": 1,
    "c_muon": 1,
    "n_muon": 1,
    "c_exp_muon": 1,
    "chk_muon": 1,
    "out_muon": 1,
    "c_adamw": 1,
    "n_adamw": 1,
    "c_exp_adamw": 1,
    "chk_adamw": 1,
    "out_adamw": 1,
    "c_fx": 1,
    "fwd": 5672353792,
    "c_exp3": 1,
    "chk_c3": 1,
    "out_c3": 1,
    "upd": 17017061376,
    "c_exp4": 1,
    "chk_c4": 1,
    "out_c4": 1
   }
  },
  "row_order": [
   "c_adamw",
   "c_all",
   "c_cfg",
   "c_exp3",
   "c_exp4",
   "c_exp_adamw",
   "c_exp_all",
   "c_exp_muon",
   "c_fx",
   "c_muon",
   "c_seed",
   "b",
   "fwd",
   "chk_c3",
   "n_adamw",
   "chk_adamw",
   "n_all",
   "chk_all",
   "n_muon",
   "chk_muon",
   "out_adamw",
   "out_all",
   "out_c3",
   "out_muon",
   "upd",
   "chk_c4",
   "out_c4"
  ],
  "receipts": [
   {
    "scope": "LCUF_X_KGD_HOST_RESEARCH",
    "row": "out_adamw",
    "site": "s",
    "profile": "lcuf.evidence",
    "semantic_sha512": "9189e1ad9935d29c6c48373854c754165a8d987c0f84e29327afab345f1f5261d104dd32008d13e0cbd681d40baf375373e34a2ad914638ffed4909157f5ccc4",
    "previous_sha512": "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
    "result_sha512": "b268d541b03144b244d11416a9c8170d7f743a558493771826da2d39f565c720b6bdf7569803227dbd40e86bdec422f2329fab19a05fc02550545db879dd7b6c",
    "value": 25191680,
    "sha512": "b6b6c5c0faad6fef9ac01d451926d4a4d783d8d8d31afebacfb7d6197e40c71eaeecbbfd0bbeb36ddc23fe12207ec6d2bc89d379b30b31c2ff521e5b523f5f8e"
   },
   {
    "scope": "LCUF_X_KGD_HOST_RESEARCH",
    "row": "out_all",
    "site": "s",
    "profile": "lcuf.evidence",
    "semantic_sha512": "9189e1ad9935d29c6c48373854c754165a8d987c0f84e29327afab345f1f5261d104dd32008d13e0cbd681d40baf375373e34a2ad914638ffed4909157f5ccc4",
    "previous_sha512": "b6b6c5c0faad6fef9ac01d451926d4a4d783d8d8d31afebacfb7d6197e40c71eaeecbbfd0bbeb36ddc23fe12207ec6d2bc89d379b30b31c2ff521e5b523f5f8e",
    "result_sha512": "b761b0e2693f6761addf97d71647405fea3e51370d572c3f5a5b3bc40a648501292ee94239c01c28e8d79ff3f1e9de885c4f6e7a42893a1b652f4322e3ddcc93",
    "value": 88630528,
    "sha512": "3985ec6c9f1a0560118a8bcf8a05b0ca47465b3b6863c95580e8d4b2f10bf447b67c7b5f1ca5a7efebbe2b683c1c8b42ec6b1745494f6e578912d72a1a4af461"
   },
   {
    "scope": "LCUF_X_KGD_HOST_RESEARCH",
    "row": "out_c3",
    "site": "s",
    "profile": "lcuf.evidence",
    "semantic_sha512": "9189e1ad9935d29c6c48373854c754165a8d987c0f84e29327afab345f1f5261d104dd32008d13e0cbd681d40baf375373e34a2ad914638ffed4909157f5ccc4",
    "previous_sha512": "3985ec6c9f1a0560118a8bcf8a05b0ca47465b3b6863c95580e8d4b2f10bf447b67c7b5f1ca5a7efebbe2b683c1c8b42ec6b1745494f6e578912d72a1a4af461",
    "result_sha512": "d592d7d4aba3fb5675eb21c1ccc3fdf6a006dbe92b6ddf97210abdbcc7a74331a4be71c3547351e044f0496d185fc53a8c42efdcf6b239061ff82dc8152e2130",
    "value": "{\"logits_shape\": [2, 16, 49152], \"scored_positions\": 30, \"loss\": 10.957893340777588, \"finite\": true}",
    "sha512": "8f072b52adcf6b15dccc65ed951f4b107ffdf910524d0a6491f5e9e384d80d9fd65c849f1f450db4c5d3274ec58f7b4b0cdb4749473a6823d88bcb197e8216ac"
   },
   {
    "scope": "LCUF_X_KGD_HOST_RESEARCH",
    "row": "out_muon",
    "site": "s",
    "profile": "lcuf.evidence",
    "semantic_sha512": "9189e1ad9935d29c6c48373854c754165a8d987c0f84e29327afab345f1f5261d104dd32008d13e0cbd681d40baf375373e34a2ad914638ffed4909157f5ccc4",
    "previous_sha512": "8f072b52adcf6b15dccc65ed951f4b107ffdf910524d0a6491f5e9e384d80d9fd65c849f1f450db4c5d3274ec58f7b4b0cdb4749473a6823d88bcb197e8216ac",
    "result_sha512": "05518b7a2c35fb38ea4e1d66473c923b690f68b087083649186d493936532e382f995abbaca49b47082cfa558af7232bb4e01287f2ffdcf2fa988cbcf8e7f5ae",
    "value": 63438848,
    "sha512": "12577c103d3ce099191646a56945cc52746299d23b38d972b67646f9e11b873567a0769cfe6b9a208af3964614c33daa4f02f26ad60407ac4a45cd222b192b80"
   },
   {
    "scope": "LCUF_X_KGD_HOST_RESEARCH",
    "row": "out_c4",
    "site": "s",
    "profile": "lcuf.evidence",
    "semantic_sha512": "9189e1ad9935d29c6c48373854c754165a8d987c0f84e29327afab345f1f5261d104dd32008d13e0cbd681d40baf375373e34a2ad914638ffed4909157f5ccc4",
    "previous_sha512": "12577c103d3ce099191646a56945cc52746299d23b38d972b67646f9e11b873567a0769cfe6b9a208af3964614c33daa4f02f26ad60407ac4a45cd222b192b80",
    "result_sha512": "1e99124f2698c94287204d0d7811e6dd57b6b5aea0676cdd99302fe699e20869ac10c404190a4576375112f7529b997819b64a2bdc82b8c050ef25b0d9b6152c",
    "value": "{\"weights_unchanged_after_first_update\": true, \"max_abs_change\": 0.0, \"grad_norm\": 12.668168243901702, \"lr_factor_first_update\": 0.0, \"muon_tensors\": 66, \"adamw_tensors\": 90}",
    "sha512": "2c3ec7ea4a345733106655e7adf17b23df4a668ab53fcbd667651038ab34b0dc0490cc34708885f58f110ad46597b5ad8ed500d45b503a0b4a4739f3da2a2f6d"
   }
  ],
  "receipt_chain_head": "2c3ec7ea4a345733106655e7adf17b23df4a668ab53fcbd667651038ab34b0dc0490cc34708885f58f110ad46597b5ad8ed500d45b503a0b4a4739f3da2a2f6d",
  "evaluated_twice": true,
  "native_cmd_execution": false
 }
}