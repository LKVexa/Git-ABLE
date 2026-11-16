@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): reject_m1_work_underreserve.lcufx. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to run the program on this package's host, lcufx\LCUFX_KGD.cmd (run --twice); or pass check or run.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=reject_m1_work_underreserve.lcufx"
set "LB_DOC_TYPE=lcufx"
set "LB_DOC_BYTES=3198"
set "LB_DOC_SHA512=be3896ca00225697a1748aff33535191c1c3479d30fdd90650b0f19c7f3e12e8747e3d73ec0fa6e2f07e31255483881f948ac47ca1265c91cb926a24c6d5b168"
set "LB_HOST=%~dp0..\..\LCUFX_KGD.cmd"
if "%~1"=="" call "%LB_HOST%" run "%~f0" --twice
if not "%~1"=="" call "%LB_HOST%" %1 "%~f0" %2 %3
set "LB_RC=%errorlevel%"
if "%~1"=="" pause
exit /b %LB_RC%
rem ---- document ----
LCUF-X/0.2+lkvexa.kgd_imq/0.2
module m1_work_underreserve
site s trust=local memory=56689287 steps=384876099
grant s caps=evidence.write,weights.read
id | site | profile | op | inputs | output | type | effects | caps | after | budget | evidence
c_path | s | lcuf.scalar | const | "../../../weights/model1-untrained/exact/manifest.cmd" | path | text | - | - | - | 1 | none
c_pin | s | lcuf.scalar | const | "2824a03df39ab370306ebf0f04f9d72afccb7a171f06997c58eddfac420e697e235b83ae32f9a89b5aa956c7aef785b0920aacbd6ea95eacb74fbb7eae3fb627" | pin | text | - | - | - | 1 | none
c_tier | s | lcuf.scalar | const | "exact" | tier | text | - | - | - | 1 | none
w | s | lkvexa.weights.cmd | lb_load | path,pin,tier | W | WeightSet[model1] | weights.read | weights.read | - | 54525494 | receipt
c_text | s | lcuf.scalar | const | " 88630528.\nln(49152) in millionths: 10802673, which rounds to 10.80. Step-0 plots say 10.8868. T" | text | text | - | - | - | 1 | none
tok | s | lkvexa.bytes | tokens_utf8 | text | ids | Tokens[96] | - | - | - | 1 | none
e | s | lkvexa.llm | embed | ids,W | h_e | Hidden[96,256] | - | - | - | 24576 | none
c_l00 | s | lcuf.scalar | const | 0 | l00 | i64 | - | - | - | 1 | none
a00 | s | lkvexa.llm | attn_block | h_e,W,l00 | h_a00 | Hidden[96,256] | - | - | - | 23592959 | none
k00 | s | lkvexa.kgd_imq | kgd_imq_step | h_a00,W,l00 | h_k00 | Hidden[96,256] | - | - | - | 7077888 | none
f00 | s | lkvexa.llm | ffn_block | h_k00,W,l00 | h_f00 | Hidden[96,256] | - | - | - | 50331648 | none
c_l01 | s | lcuf.scalar | const | 1 | l01 | i64 | - | - | - | 1 | none
a01 | s | lkvexa.llm | attn_block | h_f00,W,l01 | h_a01 | Hidden[96,256] | - | - | - | 23592960 | none
k01 | s | lkvexa.kgd_imq | kgd_imq_step | h_a01,W,l01 | h_k01 | Hidden[96,256] | - | - | - | 7077888 | none
f01 | s | lkvexa.llm | ffn_block | h_k01,W,l01 | h_f01 | Hidden[96,256] | - | - | - | 50331648 | none
c_l02 | s | lcuf.scalar | const | 2 | l02 | i64 | - | - | - | 1 | none
a02 | s | lkvexa.llm | attn_block | h_f01,W,l02 | h_a02 | Hidden[96,256] | - | - | - | 23592960 | none
k02 | s | lkvexa.kgd_imq | kgd_imq_step | h_a02,W,l02 | h_k02 | Hidden[96,256] | - | - | - | 7077888 | none
f02 | s | lkvexa.llm | ffn_block | h_k02,W,l02 | h_f02 | Hidden[96,256] | - | - | - | 50331648 | none
c_l03 | s | lcuf.scalar | const | 3 | l03 | i64 | - | - | - | 1 | none
a03 | s | lkvexa.llm | attn_block | h_f02,W,l03 | h_a03 | Hidden[96,256] | - | - | - | 23592960 | none
k03 | s | lkvexa.kgd_imq | kgd_imq_step | h_a03,W,l03 | h_k03 | Hidden[96,256] | - | - | - | 7077888 | none
f03 | s | lkvexa.llm | ffn_block | h_k03,W,l03 | h_f03 | Hidden[96,256] | - | - | - | 50331648 | none
hd | s | lkvexa.llm | head | h_f03,W | logits | Logits[96,256] | - | - | - | 6291456 | none
ce | s | lkvexa.llm | next_token_ce | logits,ids | loss | f64 | - | - | - | 24576 | receipt
c_ref | s | lcuf.scalar | const | 5.59829033138504 | ref | f64 | - | - | - | 1 | none
c_tol | s | lcuf.scalar | const | 0.0001 | tol | f64 | - | - | - | 1 | none
chk | s | lkvexa.test | assert_close | loss,ref,tol | - | unit | - | - | - | 1 | none
out | s | lcuf.evidence | emit | loss | - | unit | evidence.emit | evidence.write | - | 1 | receipt
end
