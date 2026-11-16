@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): accept_rails_parity_m1.lcufx. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to run the program on this package's host, lcufx\LCUFX_KGD.cmd (run --twice); or pass check or run.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=accept_rails_parity_m1.lcufx"
set "LB_DOC_TYPE=lcufx"
set "LB_DOC_BYTES=6103"
set "LB_DOC_SHA512=3b97311cdf35886cbf527713cc55dfb3b43dc76a5a1a4496df486fad0c0776722a64bee4f1537acca3f5f6ec4dea0ad263270b47b99dbe067a4929cff810ebba"
set "LB_HOST=%~dp0..\..\LCUFX_KGD.cmd"
if "%~1"=="" call "%LB_HOST%" run "%~f0" --twice
if not "%~1"=="" call "%LB_HOST%" %1 "%~f0" %2 %3
set "LB_RC=%errorlevel%"
if "%~1"=="" pause
exit /b %LB_RC%
rem ---- document ----
LCUF-X/0.2+lkvexa.kgd_imq/0.2
module rails_parity_m1
site s trust=local memory=59422499 steps=7148081528
grant s caps=evidence.write,weights.read
id | site | profile | op | inputs | output | type | effects | caps | after | budget | evidence
c_path | s | lcuf.scalar | const | "../../../weights/model1-untrained/exact/manifest.cmd" | path | text | - | - | - | 1 | none
c_pin | s | lcuf.scalar | const | "2824a03df39ab370306ebf0f04f9d72afccb7a171f06997c58eddfac420e697e235b83ae32f9a89b5aa956c7aef785b0920aacbd6ea95eacb74fbb7eae3fb627" | pin | text | - | - | - | 1 | none
c_tier | s | lcuf.scalar | const | "exact" | tier | text | - | - | - | 1 | none
w | s | lkvexa.weights.cmd | lb_load | path,pin,tier | W | WeightSet[model1] | weights.read | weights.read | - | 54525494 | receipt
c_text | s | lcuf.scalar | const | "07 \u007c complete \u007c See the core specification and v" | text | text | - | - | - | 1 | none
tok | s | lkvexa.bytes | tokens_utf8 | text | ids | Tokens[48] | - | - | - | 1 | none
e | s | lkvexa.llm | embed | ids,W | h_e | Hidden[48,256] | - | - | - | 12288 | none
c_l00 | s | lcuf.scalar | const | 0 | l00 | i64 | - | - | - | 1 | none
a00 | s | lkvexa.llm | attn_block | h_e,W,l00 | h_a00 | Hidden[48,256] | - | - | - | 10616832 | none
k00 | s | lkvexa.kgd_imq | kgd_imq_step | h_a00,W,l00 | h_k00 | Hidden[48,256] | - | - | - | 1769472 | none
f00 | s | lkvexa.llm | ffn_block | h_k00,W,l00 | h_f00 | Hidden[48,256] | - | - | - | 25165824 | none
c_l01 | s | lcuf.scalar | const | 1 | l01 | i64 | - | - | - | 1 | none
a01 | s | lkvexa.llm | attn_block | h_f00,W,l01 | h_a01 | Hidden[48,256] | - | - | - | 10616832 | none
k01 | s | lkvexa.kgd_imq | kgd_imq_step | h_a01,W,l01 | h_k01 | Hidden[48,256] | - | - | - | 1769472 | none
f01 | s | lkvexa.llm | ffn_block | h_k01,W,l01 | h_f01 | Hidden[48,256] | - | - | - | 25165824 | none
c_l02 | s | lcuf.scalar | const | 2 | l02 | i64 | - | - | - | 1 | none
a02 | s | lkvexa.llm | attn_block | h_f01,W,l02 | h_a02 | Hidden[48,256] | - | - | - | 10616832 | none
k02 | s | lkvexa.kgd_imq | kgd_imq_step | h_a02,W,l02 | h_k02 | Hidden[48,256] | - | - | - | 1769472 | none
f02 | s | lkvexa.llm | ffn_block | h_k02,W,l02 | h_f02 | Hidden[48,256] | - | - | - | 25165824 | none
c_l03 | s | lcuf.scalar | const | 3 | l03 | i64 | - | - | - | 1 | none
a03 | s | lkvexa.llm | attn_block | h_f02,W,l03 | h_a03 | Hidden[48,256] | - | - | - | 10616832 | none
k03 | s | lkvexa.kgd_imq | kgd_imq_step | h_a03,W,l03 | h_k03 | Hidden[48,256] | - | - | - | 1769472 | none
f03 | s | lkvexa.llm | ffn_block | h_k03,W,l03 | h_f03 | Hidden[48,256] | - | - | - | 25165824 | none
hd | s | lkvexa.llm | head | h_f03,W | logits | Logits[48,256] | - | - | - | 3145728 | none
ce | s | lkvexa.llm | next_token_ce | logits,ids | loss | f64 | - | - | - | 12288 | receipt
c_ref | s | lcuf.scalar | const | 5.566601537285965 | ref | f64 | - | - | - | 1 | none
cl | s | lkvexa.rails8s | rails_codelen | W,text | report_cl | text | - | - | - | 3468189696 | receipt
c_exp_cl | s | lcuf.scalar | const | "{\"rail_I.roundtrip\": true, \"rail_IV.within_bound\": true, \"rail_III.admitted_as_compressor\": false}" | exp_cl | text | - | - | - | 1 | none
chk_cl | s | lkvexa.test | assert_json | report_cl,exp_cl | - | unit | - | - | - | 1 | none
out_cl | s | lcuf.evidence | emit | report_cl | - | unit | evidence.emit | evidence.write | - | 1 | receipt
c_key | s | lcuf.scalar | const | "rail_II.ce_nats" | key | text | - | - | - | 1 | none
ce_cl | s | lkvexa.rails8s | json_f64 | report_cl,key | ce_codelen | f64 | - | - | - | 1 | none
c_ps | s | lcuf.scalar | const | "{\"routes\": [\"host forward (next_token_ce)\", \"dense reference (programs make)\", \"arithmetic-coder route (rails_codelen)\"], \"tolerance\": 0.0001}" | ps | text | - | - | - | 1 | none
par | s | lkvexa.rails8s | rails_parity | ps,loss,ref,ce_codelen | report_par | text | - | - | - | 3 | receipt
c_exp_par | s | lcuf.scalar | const | "{\"syndrome\": \"000\", \"corrected\": false}" | exp_par | text | - | - | - | 1 | none
chk_par | s | lkvexa.test | assert_json | report_par,exp_par | - | unit | - | - | - | 1 | none
out_par | s | lcuf.evidence | emit | report_par | - | unit | evidence.emit | evidence.write | - | 1 | receipt
c_path2 | s | lcuf.scalar | const | "../../../weights/model1-untrained/tier2/manifest.cmd" | path2 | text | - | - | - | 1 | none
c_pin2 | s | lcuf.scalar | const | "555eb9eb9d0c1de18e04a22fc1517d66516c673d8116b14edba6076655883966d2ba27ca72f958c3da3bda0eb33ce9aced61128480f10f9c07881f2a2c157499" | pin2 | text | - | - | - | 1 | none
c_tier2 | s | lcuf.scalar | const | "tier2" | tier2 | text | - | - | - | 1 | none
w2 | s | lkvexa.weights.cmd | lb_load | path2,pin2,tier2 | W2 | WeightSet[model1t] | weights.read | weights.read | - | 3797790 | receipt
cl2 | s | lkvexa.rails8s | rails_codelen | W2,text | report_cl2 | text | - | - | - | 3468189696 | receipt
c_exp_cl2 | s | lcuf.scalar | const | "{\"rail_I.roundtrip\": true, \"rail_IV.within_bound\": true}" | exp_cl2 | text | - | - | - | 1 | none
chk_cl2 | s | lkvexa.test | assert_json | report_cl2,exp_cl2 | - | unit | - | - | - | 1 | none
out_cl2 | s | lcuf.evidence | emit | report_cl2 | - | unit | evidence.emit | evidence.write | - | 1 | receipt
ce_cl2 | s | lkvexa.rails8s | json_f64 | report_cl2,key | ce_codelen2 | f64 | - | - | - | 1 | none
c_ps2 | s | lcuf.scalar | const | "{\"routes\": [\"host forward (next_token_ce)\", \"dense reference (programs make)\", \"arithmetic-coder route on the Tier-2 view (a wrong route)\"], \"tolerance\": 0.0001}" | ps2 | text | - | - | - | 1 | none
par2 | s | lkvexa.rails8s | rails_parity | ps2,loss,ref,ce_codelen2 | report_par2 | text | - | - | - | 3 | receipt
c_exp_par2 | s | lcuf.scalar | const | "{\"syndrome\": \"011\", \"corrected\": true, \"outlier\": \"arithmetic-coder route on the Tier-2 view (a wrong route)\"}" | exp_par2 | text | - | - | - | 1 | none
chk_par2 | s | lkvexa.test | assert_json | report_par2,exp_par2 | - | unit | - | - | - | 1 | none
out_par2 | s | lcuf.evidence | emit | report_par2 | - | unit | evidence.emit | evidence.write | - | 1 | receipt
end
