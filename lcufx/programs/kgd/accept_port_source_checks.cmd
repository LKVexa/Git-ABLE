@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): accept_port_source_checks.lcufx. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to run the program on this package's host, lcufx\LCUFX_KGD.cmd (run --twice); or pass check or run.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=accept_port_source_checks.lcufx"
set "LB_DOC_TYPE=lcufx"
set "LB_DOC_BYTES=3079"
set "LB_DOC_SHA512=e7ad1280b6abb380e823a75e8a97c2cbe7c58271498eff52181ad35b1387b48369b0a4d1cecb616fb2be8d789f5661f3fee9a59aa7f8567d145967c9c098df8d"
set "LB_HOST=%~dp0..\..\LCUFX_KGD.cmd"
if "%~1"=="" call "%LB_HOST%" run "%~f0" --twice
if not "%~1"=="" call "%LB_HOST%" %1 "%~f0" %2 %3
set "LB_RC=%errorlevel%"
if "%~1"=="" pause
exit /b %LB_RC%
rem ---- document ----
LCUF-X/0.2+lkvexa.kgd_imq/0.2
module port_source_checks
site s trust=local memory=1772619147 steps=22778045720
grant s caps=evidence.write
id | site | profile | op | inputs | output | type | effects | caps | after | budget | evidence
c_cfg | s | lcuf.scalar | const | "default" | cfgname | text | - | - | - | 1 | none
c_seed | s | lcuf.scalar | const | 0 | seed | i64 | - | - | - | 1 | none
b | s | lkvexa.port | port_build | cfgname,seed | P | Port[minimal_llm] | - | - | - | 88630528 | none
c_all | s | lcuf.scalar | const | "all" | group_all | text | - | - | - | 1 | none
n_all | s | lkvexa.port | port_count | P,group_all | count_all | i64 | - | - | - | 1 | none
c_exp_all | s | lcuf.scalar | const | 88630528 | exp_all | i64 | - | - | - | 1 | none
chk_all | s | lcuf.test | assert_eq | count_all,exp_all | - | unit | - | - | - | 1 | none
out_all | s | lcuf.evidence | emit | count_all | - | unit | evidence.emit | evidence.write | - | 1 | receipt
c_muon | s | lcuf.scalar | const | "muon" | group_muon | text | - | - | - | 1 | none
n_muon | s | lkvexa.port | port_count | P,group_muon | count_muon | i64 | - | - | - | 1 | none
c_exp_muon | s | lcuf.scalar | const | 63438848 | exp_muon | i64 | - | - | - | 1 | none
chk_muon | s | lcuf.test | assert_eq | count_muon,exp_muon | - | unit | - | - | - | 1 | none
out_muon | s | lcuf.evidence | emit | count_muon | - | unit | evidence.emit | evidence.write | - | 1 | receipt
c_adamw | s | lcuf.scalar | const | "adamw" | group_adamw | text | - | - | - | 1 | none
n_adamw | s | lkvexa.port | port_count | P,group_adamw | count_adamw | i64 | - | - | - | 1 | none
c_exp_adamw | s | lcuf.scalar | const | 25191680 | exp_adamw | i64 | - | - | - | 1 | none
chk_adamw | s | lcuf.test | assert_eq | count_adamw,exp_adamw | - | unit | - | - | - | 1 | none
out_adamw | s | lcuf.evidence | emit | count_adamw | - | unit | evidence.emit | evidence.write | - | 1 | receipt
c_fx | s | lcuf.scalar | const | "{\"ids\": [[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16], [17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32]]}" | fx | text | - | - | - | 1 | none
fwd | s | lkvexa.port | port_forward_report | P,fx | report_c3 | text | - | - | - | 5672353792 | none
c_exp3 | s | lcuf.scalar | const | "{\"logits_shape\": [2, 16, 49152], \"scored_positions\": 30, \"loss\": {\"center\": 10.905, \"tolerance\": 0.25}, \"finite\": true}" | exp_c3 | text | - | - | - | 1 | none
chk_c3 | s | lkvexa.test | assert_json | report_c3,exp_c3 | - | unit | - | - | - | 1 | none
out_c3 | s | lcuf.evidence | emit | report_c3 | - | unit | evidence.emit | evidence.write | - | 1 | receipt
upd | s | lkvexa.port | port_first_update | P,fx | report_c4 | text | - | - | - | 17017061376 | none
c_exp4 | s | lcuf.scalar | const | "{\"weights_unchanged_after_first_update\": true, \"max_abs_change\": 0.0}" | exp_c4 | text | - | - | - | 1 | none
chk_c4 | s | lkvexa.test | assert_json | report_c4,exp_c4 | - | unit | - | - | - | 1 | none
out_c4 | s | lcuf.evidence | emit | report_c4 | - | unit | evidence.emit | evidence.write | - | 1 | receipt
end
