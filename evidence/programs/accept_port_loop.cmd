@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): accept_port_loop.json. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to print the document, with /check to check its SHA-512, or with /extract FILE to write it out.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=accept_port_loop.json"
set "LB_DOC_TYPE=json"
set "LB_DOC_BYTES=9420"
set "LB_DOC_SHA512=14b0bcda1870b5fb3b7d532246a705b4b94a550da65e53b01e3aab5dd094b7514361378aad8da5887ac7c731da587c8c7ebb2520075c057864162fb53477e3c4"
set "LB_SELF=%~f0"
set "LB_ARG=%~1"
set "LB_OUT=%~f2"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$n=[int]$env:LB_DOC_BYTES;$b=[IO.File]::ReadAllBytes($env:LB_SELF);$o=$b.Length-$n;$h=-join((New-Object Security.Cryptography.SHA512Managed).ComputeHash($b,$o,$n)|%%{$_.ToString('x2')});if($h -ne $env:LB_DOC_SHA512){[Console]::Error.WriteLine('LB-DOC/1: the SHA-512 of '+$env:LB_DOC+' differs from LB_DOC_SHA512');exit 1};if($env:LB_ARG -eq '/check'){'ok: '+$env:LB_DOC;exit 0};if($env:LB_ARG -eq '/extract'){$d=New-Object byte[] $n;[Array]::Copy($b,$o,$d,0,$n);[IO.File]::WriteAllBytes($env:LB_OUT,$d);'written: '+$env:LB_OUT;exit 0};[Console]::OutputEncoding=New-Object Text.UTF8Encoding $false;[Console]::Out.Write([Text.Encoding]::UTF8.GetString($b,$o,$n));exit 0"
set "LB_RC=%errorlevel%"
if "%LB_ARG%"=="" pause
exit /b %LB_RC%
rem ---- document ----
{
 "program": "kgd/accept_port_loop.cmd",
 "source_sha512": "740b7a59fdf0a82b6ab46cde8dfbfcbd8628308ac7725fe889977abaff2b41930d2d355ba641c86ab09c58fadc446fce779e09fce64e29d44a8206754680272a",
 "file_sha512": "c6c5c1c296c33a6e9ec1e78a90c9c09fab90bf311797ba9a1d1c0e6c9fa44b93a86ce60d257612fe53fe0bc748a81fbc0c61e31579890ef921a7bb302115ead7",
 "runner": "lcufx\\LCUFX_KGD.cmd run --twice (tools\\KGD_ENGINE.cmd host)",
 "expected": "accept",
 "observed": "accept",
 "as_expected": true,
 "exit_code": 0,
 "seconds": 7.6,
 "output": {
  "status": "host_research_pass",
  "language": "LCUF-X/0.2+lkvexa.kgd_imq/0.2",
  "source_sha512": "740b7a59fdf0a82b6ab46cde8dfbfcbd8628308ac7725fe889977abaff2b41930d2d355ba641c86ab09c58fadc446fce779e09fce64e29d44a8206754680272a",
  "semantic_sha512": "53c9c207e118d50bbd6c43a1bf8183319cb4e9b4f40788adea2cb6129a87516a679024008fa17ef551fcda769211fd88d47027a6a4337937fb056f68d0dc02d6",
  "values": {
   "b8": 8,
   "exp_t100m": "{\"steps_run\": 6104, \"tokens_seen\": 100007936, \"est_total_steps\": 6103, \"schedule_total_steps\": 6103, \"warmup_steps\": 1, \"lr_factor_first_update\": 0.0}",
   "exp_t1b": "{\"steps_run\": 61036, \"tokens_seen\": 1000013824, \"est_total_steps\": 61035, \"schedule_total_steps\": 61035, \"warmup_steps\": 1, \"lr_factor_first_update\": 0.0}",
   "exp_t20m": "{\"steps_run\": 1221, \"tokens_seen\": 20004864, \"est_total_steps\": 1220, \"schedule_total_steps\": 1220, \"warmup_steps\": 1, \"lr_factor_first_update\": 0.0}",
   "exp_t8m": "{\"steps_run\": 489, \"tokens_seen\": 8011776, \"est_total_steps\": 488, \"schedule_total_steps\": 488, \"warmup_steps\": 1, \"lr_factor_first_update\": 0.0}",
   "exp_loop": "{\"steps_run\": 151, \"tokens_seen\": 19328, \"est_total_steps\": 150, \"loop_completed\": true, \"nonfinite_loss_steps\": 101, \"weights_finite_at_end\": false}",
   "ns": 50,
   "s2048": 2048,
   "t100m": 100000000,
   "report_t100m": "{\"steps_run\": 6104, \"tokens_seen\": 100007936, \"est_total_steps\": 6103, \"schedule_total_steps\": 6103, \"warmup_steps\": 1, \"lr_factor_first_update\": 0.0, \"optimizer_updates\": 6104}",
   "t1b": 1000000000,
   "report_t1b": "{\"steps_run\": 61036, \"tokens_seen\": 1000013824, \"est_total_steps\": 61035, \"schedule_total_steps\": 61035, \"warmup_steps\": 1, \"lr_factor_first_update\": 0.0, \"optimizer_updates\": 61036}",
   "t20m": 20000000,
   "report_t20m": "{\"steps_run\": 1221, \"tokens_seen\": 20004864, \"est_total_steps\": 1220, \"schedule_total_steps\": 1220, \"warmup_steps\": 1, \"lr_factor_first_update\": 0.0, \"optimizer_updates\": 1221}",
   "t8m": 8000000,
   "report_t8m": "{\"steps_run\": 489, \"tokens_seen\": 8011776, \"est_total_steps\": 488, \"schedule_total_steps\": 488, \"warmup_steps\": 1, \"lr_factor_first_update\": 0.0, \"optimizer_updates\": 489}",
   "tiny": "{\"vocab\": 256, \"d\": 64, \"n_layers\": 2, \"n_heads\": 2, \"n_kv\": 1, \"d_ff\": 256, \"seq_len\": 32}",
   "tt": 19201,
   "report_loop": "{\"steps_run\": 151, \"tokens_seen\": 19328, \"tokens_per_step\": 128, \"est_total_steps\": 150, \"loop_completed\": true, \"nonfinite_loss_steps\": 101, \"losses_read_at_steps\": {\"0\": 5.584117493913947, \"100\": \"nan\"}, \"weights_finite_at_end\": false}"
  },
  "admission": {
   "reserved_work": {
    "s": 12402150666
   },
   "retained_payload_bytes": {
    "s": 21382
   },
   "peak_modeled_scratch_bytes": {
    "s": 0
   },
   "minimum_row_work": {
    "c_tiny": 1,
    "c_tt": 1,
    "c_ns": 1,
    "lp": 12402081792,
    "c_explp": 1,
    "chk_loop": 1,
    "out_loop": 1,
    "c_b8": 1,
    "c_s2048": 1,
    "c_t8m": 1,
    "acct_t8m": 489,
    "c_exp_t8m": 1,
    "chk_t8m": 1,
    "out_t8m": 1,
    "c_t20m": 1,
    "acct_t20m": 1221,
    "c_exp_t20m": 1,
    "chk_t20m": 1,
    "out_t20m": 1,
    "c_t100m": 1,
    "acct_t100m": 6104,
    "c_exp_t100m": 1,
    "chk_t100m": 1,
    "out_t100m": 1,
    "c_t1b": 1,
    "acct_t1b": 61036,
    "c_exp_t1b": 1,
    "chk_t1b": 1,
    "out_t1b": 1
   }
  },
  "row_order": [
   "c_b8",
   "c_exp_t100m",
   "c_exp_t1b",
   "c_exp_t20m",
   "c_exp_t8m",
   "c_explp",
   "c_ns",
   "c_s2048",
   "c_t100m",
   "acct_t100m",
   "c_t1b",
   "acct_t1b",
   "c_t20m",
   "acct_t20m",
   "c_t8m",
   "acct_t8m",
   "c_tiny",
   "c_tt",
   "chk_t100m",
   "chk_t1b",
   "chk_t20m",
   "chk_t8m",
   "lp",
   "chk_loop",
   "out_loop",
   "out_t100m",
   "out_t1b",
   "out_t20m",
   "out_t8m"
  ],
  "receipts": [
   {
    "scope": "LCUF_X_KGD_HOST_RESEARCH",
    "row": "out_loop",
    "site": "s",
    "profile": "lcuf.evidence",
    "semantic_sha512": "53c9c207e118d50bbd6c43a1bf8183319cb4e9b4f40788adea2cb6129a87516a679024008fa17ef551fcda769211fd88d47027a6a4337937fb056f68d0dc02d6",
    "previous_sha512": "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
    "result_sha512": "d6bce046e3275961d0598da72db8171ae1c7c3d0876ec1c7c2d07d90443bb3b3589b0d42547da2d1862b48420c367e2748f5f9ba54382755d2821d528bf01bb3",
    "value": "{\"steps_run\": 151, \"tokens_seen\": 19328, \"tokens_per_step\": 128, \"est_total_steps\": 150, \"loop_completed\": true, \"nonfinite_loss_steps\": 101, \"losses_read_at_steps\": {\"0\": 5.584117493913947, \"100\": \"nan\"}, \"weights_finite_at_end\": false}",
    "sha512": "e0e85b10fcf689104505beeb6cec44589321774e17e81c7e542f85e1fcd47c65888b97329888667fc227c51ca708c0e97a0d3eb28437ec6864afcff502982fef"
   },
   {
    "scope": "LCUF_X_KGD_HOST_RESEARCH",
    "row": "out_t100m",
    "site": "s",
    "profile": "lcuf.evidence",
    "semantic_sha512": "53c9c207e118d50bbd6c43a1bf8183319cb4e9b4f40788adea2cb6129a87516a679024008fa17ef551fcda769211fd88d47027a6a4337937fb056f68d0dc02d6",
    "previous_sha512": "e0e85b10fcf689104505beeb6cec44589321774e17e81c7e542f85e1fcd47c65888b97329888667fc227c51ca708c0e97a0d3eb28437ec6864afcff502982fef",
    "result_sha512": "7ea82ed37ca719293fa68fecec07e04d5dddac8412d4eb9f1c6e744c6faf964321de9becbdeb202d23534308025b812e03247f3be4f3d31e6dc925ad43ec0f2b",
    "value": "{\"steps_run\": 6104, \"tokens_seen\": 100007936, \"est_total_steps\": 6103, \"schedule_total_steps\": 6103, \"warmup_steps\": 1, \"lr_factor_first_update\": 0.0, \"optimizer_updates\": 6104}",
    "sha512": "a8aef35e88ad64474c4a979bb0a7dae68da612c8765174356295e8cbd142a4a3ff8feb475955e2fba20388c0fb70b97980063f8233104319555bc826253c763d"
   },
   {
    "scope": "LCUF_X_KGD_HOST_RESEARCH",
    "row": "out_t1b",
    "site": "s",
    "profile": "lcuf.evidence",
    "semantic_sha512": "53c9c207e118d50bbd6c43a1bf8183319cb4e9b4f40788adea2cb6129a87516a679024008fa17ef551fcda769211fd88d47027a6a4337937fb056f68d0dc02d6",
    "previous_sha512": "a8aef35e88ad64474c4a979bb0a7dae68da612c8765174356295e8cbd142a4a3ff8feb475955e2fba20388c0fb70b97980063f8233104319555bc826253c763d",
    "result_sha512": "8f9cb1bb306b277c9424b69821062d540a6aa4ea15a14167539d75108708ec1bc7dcf48d960c28dfc04a943af17a40df62f15df50c062b3f3d94fbb91c43dd78",
    "value": "{\"steps_run\": 61036, \"tokens_seen\": 1000013824, \"est_total_steps\": 61035, \"schedule_total_steps\": 61035, \"warmup_steps\": 1, \"lr_factor_first_update\": 0.0, \"optimizer_updates\": 61036}",
    "sha512": "8c9bfb5744a66c304dfd4a66640630c10881cf5b93e92b780adf9ba0c387a98707830ed6d9c24c49c2907924ee6350ff9e4ca86a65c7c5a775213a7583f29635"
   },
   {
    "scope": "LCUF_X_KGD_HOST_RESEARCH",
    "row": "out_t20m",
    "site": "s",
    "profile": "lcuf.evidence",
    "semantic_sha512": "53c9c207e118d50bbd6c43a1bf8183319cb4e9b4f40788adea2cb6129a87516a679024008fa17ef551fcda769211fd88d47027a6a4337937fb056f68d0dc02d6",
    "previous_sha512": "8c9bfb5744a66c304dfd4a66640630c10881cf5b93e92b780adf9ba0c387a98707830ed6d9c24c49c2907924ee6350ff9e4ca86a65c7c5a775213a7583f29635",
    "result_sha512": "b61fbd5b9cde26c8ab4d740315bb72cbec536d54d61ffa28fba62ca0347394333fdfa7d9a817a603f02af6b96cd059a920bf6cc559d1697c54cfc47d6b319e64",
    "value": "{\"steps_run\": 1221, \"tokens_seen\": 20004864, \"est_total_steps\": 1220, \"schedule_total_steps\": 1220, \"warmup_steps\": 1, \"lr_factor_first_update\": 0.0, \"optimizer_updates\": 1221}",
    "sha512": "482cd1bcb76a82b86727d298cf7ebc8a065e75df4da2f87a8b8e9c5d8df6151839b228d2738df4a90f61e37361f6866099c08d578836a0fb3eb36589b7c37ca4"
   },
   {
    "scope": "LCUF_X_KGD_HOST_RESEARCH",
    "row": "out_t8m",
    "site": "s",
    "profile": "lcuf.evidence",
    "semantic_sha512": "53c9c207e118d50bbd6c43a1bf8183319cb4e9b4f40788adea2cb6129a87516a679024008fa17ef551fcda769211fd88d47027a6a4337937fb056f68d0dc02d6",
    "previous_sha512": "482cd1bcb76a82b86727d298cf7ebc8a065e75df4da2f87a8b8e9c5d8df6151839b228d2738df4a90f61e37361f6866099c08d578836a0fb3eb36589b7c37ca4",
    "result_sha512": "815659ee0654d7aeeb9560f2f9ea149f143ec31e8da070adfaa438f3d5058fb659c0312d76bb4f99e9ce4e96de407bf1570081f62d91b01d82f3474910d5779d",
    "value": "{\"steps_run\": 489, \"tokens_seen\": 8011776, \"est_total_steps\": 488, \"schedule_total_steps\": 488, \"warmup_steps\": 1, \"lr_factor_first_update\": 0.0, \"optimizer_updates\": 489}",
    "sha512": "487688c20339ce471b2ae94e2c3b66365c239070eb5264312abe8d1846f3c2bd103b481b28b62cc972d18d253b9f361bad3a32997e2015b4d14bf677d5e055d0"
   }
  ],
  "receipt_chain_head": "487688c20339ce471b2ae94e2c3b66365c239070eb5264312abe8d1846f3c2bd103b481b28b62cc972d18d253b9f361bad3a32997e2015b4d14bf677d5e055d0",
  "evaluated_twice": true,
  "native_cmd_execution": false
 }
}