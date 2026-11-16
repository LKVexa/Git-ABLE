@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): accept_port_loop.lcufx. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to run the program on this package's host, lcufx\LCUFX_KGD.cmd (run --twice); or pass check or run.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=accept_port_loop.lcufx"
set "LB_DOC_TYPE=lcufx"
set "LB_DOC_BYTES=3823"
set "LB_DOC_SHA512=740b7a59fdf0a82b6ab46cde8dfbfcbd8628308ac7725fe889977abaff2b41930d2d355ba641c86ab09c58fadc446fce779e09fce64e29d44a8206754680272a"
set "LB_HOST=%~dp0..\..\LCUFX_KGD.cmd"
if "%~1"=="" call "%LB_HOST%" run "%~f0" --twice
if not "%~1"=="" call "%LB_HOST%" %1 "%~f0" %2 %3
set "LB_RC=%errorlevel%"
if "%~1"=="" pause
exit /b %LB_RC%
rem ---- document ----
LCUF-X/0.2+lkvexa.kgd_imq/0.2
module port_loop
site s trust=local memory=21382 steps=12402150666
grant s caps=evidence.write
id | site | profile | op | inputs | output | type | effects | caps | after | budget | evidence
c_tiny | s | lcuf.scalar | const | "{\"vocab\": 256, \"d\": 64, \"n_layers\": 2, \"n_heads\": 2, \"n_kv\": 1, \"d_ff\": 256, \"seq_len\": 32}" | tiny | text | - | - | - | 1 | none
c_tt | s | lcuf.scalar | const | 19201 | tt | i64 | - | - | - | 1 | none
c_ns | s | lcuf.scalar | const | 50 | ns | i64 | - | - | - | 1 | none
lp | s | lkvexa.port | port_loop_probe | tiny,tt,ns | report_loop | text | - | - | - | 12402081792 | none
c_explp | s | lcuf.scalar | const | "{\"steps_run\": 151, \"tokens_seen\": 19328, \"est_total_steps\": 150, \"loop_completed\": true, \"nonfinite_loss_steps\": 101, \"weights_finite_at_end\": false}" | exp_loop | text | - | - | - | 1 | none
chk_loop | s | lkvexa.test | assert_json | report_loop,exp_loop | - | unit | - | - | - | 1 | none
out_loop | s | lcuf.evidence | emit | report_loop | - | unit | evidence.emit | evidence.write | - | 1 | receipt
c_b8 | s | lcuf.scalar | const | 8 | b8 | i64 | - | - | - | 1 | none
c_s2048 | s | lcuf.scalar | const | 2048 | s2048 | i64 | - | - | - | 1 | none
c_t8m | s | lcuf.scalar | const | 8000000 | t8m | i64 | - | - | - | 1 | none
acct_t8m | s | lkvexa.port | port_step_account | t8m,b8,s2048 | report_t8m | text | - | - | - | 489 | none
c_exp_t8m | s | lcuf.scalar | const | "{\"steps_run\": 489, \"tokens_seen\": 8011776, \"est_total_steps\": 488, \"schedule_total_steps\": 488, \"warmup_steps\": 1, \"lr_factor_first_update\": 0.0}" | exp_t8m | text | - | - | - | 1 | none
chk_t8m | s | lkvexa.test | assert_json | report_t8m,exp_t8m | - | unit | - | - | - | 1 | none
out_t8m | s | lcuf.evidence | emit | report_t8m | - | unit | evidence.emit | evidence.write | - | 1 | receipt
c_t20m | s | lcuf.scalar | const | 20000000 | t20m | i64 | - | - | - | 1 | none
acct_t20m | s | lkvexa.port | port_step_account | t20m,b8,s2048 | report_t20m | text | - | - | - | 1221 | none
c_exp_t20m | s | lcuf.scalar | const | "{\"steps_run\": 1221, \"tokens_seen\": 20004864, \"est_total_steps\": 1220, \"schedule_total_steps\": 1220, \"warmup_steps\": 1, \"lr_factor_first_update\": 0.0}" | exp_t20m | text | - | - | - | 1 | none
chk_t20m | s | lkvexa.test | assert_json | report_t20m,exp_t20m | - | unit | - | - | - | 1 | none
out_t20m | s | lcuf.evidence | emit | report_t20m | - | unit | evidence.emit | evidence.write | - | 1 | receipt
c_t100m | s | lcuf.scalar | const | 100000000 | t100m | i64 | - | - | - | 1 | none
acct_t100m | s | lkvexa.port | port_step_account | t100m,b8,s2048 | report_t100m | text | - | - | - | 6104 | none
c_exp_t100m | s | lcuf.scalar | const | "{\"steps_run\": 6104, \"tokens_seen\": 100007936, \"est_total_steps\": 6103, \"schedule_total_steps\": 6103, \"warmup_steps\": 1, \"lr_factor_first_update\": 0.0}" | exp_t100m | text | - | - | - | 1 | none
chk_t100m | s | lkvexa.test | assert_json | report_t100m,exp_t100m | - | unit | - | - | - | 1 | none
out_t100m | s | lcuf.evidence | emit | report_t100m | - | unit | evidence.emit | evidence.write | - | 1 | receipt
c_t1b | s | lcuf.scalar | const | 1000000000 | t1b | i64 | - | - | - | 1 | none
acct_t1b | s | lkvexa.port | port_step_account | t1b,b8,s2048 | report_t1b | text | - | - | - | 61036 | none
c_exp_t1b | s | lcuf.scalar | const | "{\"steps_run\": 61036, \"tokens_seen\": 1000013824, \"est_total_steps\": 61035, \"schedule_total_steps\": 61035, \"warmup_steps\": 1, \"lr_factor_first_update\": 0.0}" | exp_t1b | text | - | - | - | 1 | none
chk_t1b | s | lkvexa.test | assert_json | report_t1b,exp_t1b | - | unit | - | - | - | 1 | none
out_t1b | s | lcuf.evidence | emit | report_t1b | - | unit | evidence.emit | evidence.write | - | 1 | receipt
end
