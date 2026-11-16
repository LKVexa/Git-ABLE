@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): reject_rails_parity_no_majority.lcufx. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to run the program on this package's host, lcufx\LCUFX_KGD.cmd (run --twice); or pass check or run.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=reject_rails_parity_no_majority.lcufx"
set "LB_DOC_TYPE=lcufx"
set "LB_DOC_BYTES=4389"
set "LB_DOC_SHA512=5576312f7b4ef3e72e9124f60601e2f6aea618525d4565d54a29e314c8f6cb06820687f700976175de6035053a142792a3c37387c4c13c58dd3ed35a4f23789f"
set "LB_HOST=%~dp0..\..\LCUFX_KGD.cmd"
if "%~1"=="" call "%LB_HOST%" run "%~f0" --twice
if not "%~1"=="" call "%LB_HOST%" %1 "%~f0" %2 %3
set "LB_RC=%errorlevel%"
if "%~1"=="" pause
exit /b %LB_RC%
rem ---- document ----
LCUF-X/0.2+lkvexa.kgd_imq/0.2
module rails_parity_no_majority
site s trust=local memory=59413856 steps=3679891818
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
c_path2 | s | lcuf.scalar | const | "../../../weights/model1-untrained/tier2/manifest.cmd" | path2 | text | - | - | - | 1 | none
c_pin2 | s | lcuf.scalar | const | "555eb9eb9d0c1de18e04a22fc1517d66516c673d8116b14edba6076655883966d2ba27ca72f958c3da3bda0eb33ce9aced61128480f10f9c07881f2a2c157499" | pin2 | text | - | - | - | 1 | none
c_tier2 | s | lcuf.scalar | const | "tier2" | tier2 | text | - | - | - | 1 | none
w2 | s | lkvexa.weights.cmd | lb_load | path2,pin2,tier2 | W2 | WeightSet[model1t] | weights.read | weights.read | - | 3797790 | receipt
cl2 | s | lkvexa.rails8s | rails_codelen | W2,text | report_cl2 | text | - | - | - | 3468189696 | none
c_key | s | lcuf.scalar | const | "rail_II.ce_nats" | key | text | - | - | - | 1 | none
ce_cl2 | s | lkvexa.rails8s | json_f64 | report_cl2,key | ce_codelen2 | f64 | - | - | - | 1 | none
c_zero | s | lcuf.scalar | const | 0.0 | zero | f64 | - | - | - | 1 | none
c_ps3 | s | lcuf.scalar | const | "{\"routes\": [\"host forward (next_token_ce)\", \"arithmetic-coder route on the Tier-2 view\", \"a broken route that returns 0\"], \"tolerance\": 0.0001}" | ps3 | text | - | - | - | 1 | none
par3 | s | lkvexa.rails8s | rails_parity | ps3,loss,ce_codelen2,zero | report_par3 | text | - | - | - | 3 | receipt
c_exp_par3 | s | lcuf.scalar | const | "{\"corrected\": false}" | exp_par3 | text | - | - | - | 1 | none
chk_par3 | s | lkvexa.test | assert_json | report_par3,exp_par3 | - | unit | - | - | - | 1 | none
out_par3 | s | lcuf.evidence | emit | report_par3 | - | unit | evidence.emit | evidence.write | - | 1 | receipt
end
