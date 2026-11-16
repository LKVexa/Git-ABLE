@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): accept_m2_tier0_forward.lcufx. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to run the program on this package's host, lcufx\LCUFX_KGD.cmd (run --twice); or pass check or run.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=accept_m2_tier0_forward.lcufx"
set "LB_DOC_TYPE=lcufx"
set "LB_DOC_BYTES=14656"
set "LB_DOC_SHA512=05f3a8a4cb2d288290e6264790aca56666cae4b4d973df47c20db0893a597f89bd549e43014354fd4c93a2d347a3ac6ab4a5e9c750e37711c4e767b3de2e879b"
set "LB_HOST=%~dp0..\..\LCUFX_KGD.cmd"
if "%~1"=="" call "%LB_HOST%" run "%~f0" --twice
if not "%~1"=="" call "%LB_HOST%" %1 "%~f0" %2 %3
set "LB_RC=%errorlevel%"
if "%~1"=="" pause
exit /b %LB_RC%
rem ---- document ----
LCUF-X/0.2+lkvexa.kgd_imq/0.2
module m2_tier0_forward
site s trust=local memory=1061246692 steps=1855493367
grant s caps=evidence.write,weights.read
id | site | profile | op | inputs | output | type | effects | caps | after | budget | evidence
c_path | s | lcuf.scalar | const | "../../../weights/model2-tier1/manifest.cmd" | path | text | - | - | - | 1 | none
c_pin | s | lcuf.scalar | const | "89485985ebb6d0b46ce5fb2cb492d897b53f073b95943cea8b73cd589a8b1f3f49c3cb917a26e7e9329fbfe777f3a094ead282445a4b7bf858f2299c64d0cb77" | pin | text | - | - | - | 1 | none
c_tier | s | lcuf.scalar | const | "tier0" | tier | text | - | - | - | 1 | none
w | s | lkvexa.weights.cmd | lb_load | path,pin,tier | W | WeightSet[model2] | weights.read | weights.read | - | 874173645 | receipt
c_text | s | lcuf.scalar | const | "KGD-IMQ " | text | text | - | - | - | 1 | none
tok | s | lkvexa.bytes | tokens_utf8 | text | ids | Tokens[8] | - | - | - | 1 | none
e | s | lkvexa.llm | embed | ids,W | h_e | Hidden[8,52224] | - | - | - | 835584 | none
c_l00 | s | lcuf.scalar | const | 0 | l00 | i64 | - | - | - | 1 | none
a00 | s | lkvexa.llm | attn_block | h_e,W,l00 | h_a00 | Hidden[8,52224] | - | - | - | 10027008 | none
k00 | s | lkvexa.kgd_imq | kgd_imq_step | h_a00,W,l00 | h_k00 | Hidden[8,52224] | - | - | - | 10027008 | none
f00 | s | lkvexa.llm | ffn_block | h_k00,W,l00 | h_f00 | Hidden[8,52224] | - | - | - | 8355840 | none
c_l01 | s | lcuf.scalar | const | 1 | l01 | i64 | - | - | - | 1 | none
a01 | s | lkvexa.llm | attn_block | h_f00,W,l01 | h_a01 | Hidden[8,52224] | - | - | - | 10027008 | none
k01 | s | lkvexa.kgd_imq | kgd_imq_step | h_a01,W,l01 | h_k01 | Hidden[8,52224] | - | - | - | 10027008 | none
f01 | s | lkvexa.llm | ffn_block | h_k01,W,l01 | h_f01 | Hidden[8,52224] | - | - | - | 8355840 | none
c_l02 | s | lcuf.scalar | const | 2 | l02 | i64 | - | - | - | 1 | none
a02 | s | lkvexa.llm | attn_block | h_f01,W,l02 | h_a02 | Hidden[8,52224] | - | - | - | 10027008 | none
k02 | s | lkvexa.kgd_imq | kgd_imq_step | h_a02,W,l02 | h_k02 | Hidden[8,52224] | - | - | - | 10027008 | none
f02 | s | lkvexa.llm | ffn_block | h_k02,W,l02 | h_f02 | Hidden[8,52224] | - | - | - | 8355840 | none
c_l03 | s | lcuf.scalar | const | 3 | l03 | i64 | - | - | - | 1 | none
a03 | s | lkvexa.llm | attn_block | h_f02,W,l03 | h_a03 | Hidden[8,52224] | - | - | - | 10027008 | none
k03 | s | lkvexa.kgd_imq | kgd_imq_step | h_a03,W,l03 | h_k03 | Hidden[8,52224] | - | - | - | 10027008 | none
f03 | s | lkvexa.llm | ffn_block | h_k03,W,l03 | h_f03 | Hidden[8,52224] | - | - | - | 8355840 | none
c_l04 | s | lcuf.scalar | const | 4 | l04 | i64 | - | - | - | 1 | none
a04 | s | lkvexa.llm | attn_block | h_f03,W,l04 | h_a04 | Hidden[8,52224] | - | - | - | 10027008 | none
k04 | s | lkvexa.kgd_imq | kgd_imq_step | h_a04,W,l04 | h_k04 | Hidden[8,52224] | - | - | - | 10027008 | none
f04 | s | lkvexa.llm | ffn_block | h_k04,W,l04 | h_f04 | Hidden[8,52224] | - | - | - | 8355840 | none
c_l05 | s | lcuf.scalar | const | 5 | l05 | i64 | - | - | - | 1 | none
a05 | s | lkvexa.llm | attn_block | h_f04,W,l05 | h_a05 | Hidden[8,52224] | - | - | - | 10027008 | none
k05 | s | lkvexa.kgd_imq | kgd_imq_step | h_a05,W,l05 | h_k05 | Hidden[8,52224] | - | - | - | 10027008 | none
f05 | s | lkvexa.llm | ffn_block | h_k05,W,l05 | h_f05 | Hidden[8,52224] | - | - | - | 8355840 | none
c_l06 | s | lcuf.scalar | const | 6 | l06 | i64 | - | - | - | 1 | none
a06 | s | lkvexa.llm | attn_block | h_f05,W,l06 | h_a06 | Hidden[8,52224] | - | - | - | 10027008 | none
k06 | s | lkvexa.kgd_imq | kgd_imq_step | h_a06,W,l06 | h_k06 | Hidden[8,52224] | - | - | - | 10027008 | none
f06 | s | lkvexa.llm | ffn_block | h_k06,W,l06 | h_f06 | Hidden[8,52224] | - | - | - | 8355840 | none
c_l07 | s | lcuf.scalar | const | 7 | l07 | i64 | - | - | - | 1 | none
a07 | s | lkvexa.llm | attn_block | h_f06,W,l07 | h_a07 | Hidden[8,52224] | - | - | - | 10027008 | none
k07 | s | lkvexa.kgd_imq | kgd_imq_step | h_a07,W,l07 | h_k07 | Hidden[8,52224] | - | - | - | 10027008 | none
f07 | s | lkvexa.llm | ffn_block | h_k07,W,l07 | h_f07 | Hidden[8,52224] | - | - | - | 8355840 | none
c_l08 | s | lcuf.scalar | const | 8 | l08 | i64 | - | - | - | 1 | none
a08 | s | lkvexa.llm | attn_block | h_f07,W,l08 | h_a08 | Hidden[8,52224] | - | - | - | 10027008 | none
k08 | s | lkvexa.kgd_imq | kgd_imq_step | h_a08,W,l08 | h_k08 | Hidden[8,52224] | - | - | - | 10027008 | none
f08 | s | lkvexa.llm | ffn_block | h_k08,W,l08 | h_f08 | Hidden[8,52224] | - | - | - | 8355840 | none
c_l09 | s | lcuf.scalar | const | 9 | l09 | i64 | - | - | - | 1 | none
a09 | s | lkvexa.llm | attn_block | h_f08,W,l09 | h_a09 | Hidden[8,52224] | - | - | - | 10027008 | none
k09 | s | lkvexa.kgd_imq | kgd_imq_step | h_a09,W,l09 | h_k09 | Hidden[8,52224] | - | - | - | 10027008 | none
f09 | s | lkvexa.llm | ffn_block | h_k09,W,l09 | h_f09 | Hidden[8,52224] | - | - | - | 8355840 | none
c_l10 | s | lcuf.scalar | const | 10 | l10 | i64 | - | - | - | 1 | none
a10 | s | lkvexa.llm | attn_block | h_f09,W,l10 | h_a10 | Hidden[8,52224] | - | - | - | 10027008 | none
k10 | s | lkvexa.kgd_imq | kgd_imq_step | h_a10,W,l10 | h_k10 | Hidden[8,52224] | - | - | - | 10027008 | none
f10 | s | lkvexa.llm | ffn_block | h_k10,W,l10 | h_f10 | Hidden[8,52224] | - | - | - | 8355840 | none
c_l11 | s | lcuf.scalar | const | 11 | l11 | i64 | - | - | - | 1 | none
a11 | s | lkvexa.llm | attn_block | h_f10,W,l11 | h_a11 | Hidden[8,52224] | - | - | - | 10027008 | none
k11 | s | lkvexa.kgd_imq | kgd_imq_step | h_a11,W,l11 | h_k11 | Hidden[8,52224] | - | - | - | 10027008 | none
f11 | s | lkvexa.llm | ffn_block | h_k11,W,l11 | h_f11 | Hidden[8,52224] | - | - | - | 8355840 | none
c_l12 | s | lcuf.scalar | const | 12 | l12 | i64 | - | - | - | 1 | none
a12 | s | lkvexa.llm | attn_block | h_f11,W,l12 | h_a12 | Hidden[8,52224] | - | - | - | 10027008 | none
k12 | s | lkvexa.kgd_imq | kgd_imq_step | h_a12,W,l12 | h_k12 | Hidden[8,52224] | - | - | - | 10027008 | none
f12 | s | lkvexa.llm | ffn_block | h_k12,W,l12 | h_f12 | Hidden[8,52224] | - | - | - | 8355840 | none
c_l13 | s | lcuf.scalar | const | 13 | l13 | i64 | - | - | - | 1 | none
a13 | s | lkvexa.llm | attn_block | h_f12,W,l13 | h_a13 | Hidden[8,52224] | - | - | - | 10027008 | none
k13 | s | lkvexa.kgd_imq | kgd_imq_step | h_a13,W,l13 | h_k13 | Hidden[8,52224] | - | - | - | 10027008 | none
f13 | s | lkvexa.llm | ffn_block | h_k13,W,l13 | h_f13 | Hidden[8,52224] | - | - | - | 8355840 | none
c_l14 | s | lcuf.scalar | const | 14 | l14 | i64 | - | - | - | 1 | none
a14 | s | lkvexa.llm | attn_block | h_f13,W,l14 | h_a14 | Hidden[8,52224] | - | - | - | 10027008 | none
k14 | s | lkvexa.kgd_imq | kgd_imq_step | h_a14,W,l14 | h_k14 | Hidden[8,52224] | - | - | - | 10027008 | none
f14 | s | lkvexa.llm | ffn_block | h_k14,W,l14 | h_f14 | Hidden[8,52224] | - | - | - | 8355840 | none
c_l15 | s | lcuf.scalar | const | 15 | l15 | i64 | - | - | - | 1 | none
a15 | s | lkvexa.llm | attn_block | h_f14,W,l15 | h_a15 | Hidden[8,52224] | - | - | - | 10027008 | none
k15 | s | lkvexa.kgd_imq | kgd_imq_step | h_a15,W,l15 | h_k15 | Hidden[8,52224] | - | - | - | 10027008 | none
f15 | s | lkvexa.llm | ffn_block | h_k15,W,l15 | h_f15 | Hidden[8,52224] | - | - | - | 8355840 | none
c_l16 | s | lcuf.scalar | const | 16 | l16 | i64 | - | - | - | 1 | none
a16 | s | lkvexa.llm | attn_block | h_f15,W,l16 | h_a16 | Hidden[8,52224] | - | - | - | 10027008 | none
k16 | s | lkvexa.kgd_imq | kgd_imq_step | h_a16,W,l16 | h_k16 | Hidden[8,52224] | - | - | - | 10027008 | none
f16 | s | lkvexa.llm | ffn_block | h_k16,W,l16 | h_f16 | Hidden[8,52224] | - | - | - | 8355840 | none
c_l17 | s | lcuf.scalar | const | 17 | l17 | i64 | - | - | - | 1 | none
a17 | s | lkvexa.llm | attn_block | h_f16,W,l17 | h_a17 | Hidden[8,52224] | - | - | - | 10027008 | none
k17 | s | lkvexa.kgd_imq | kgd_imq_step | h_a17,W,l17 | h_k17 | Hidden[8,52224] | - | - | - | 10027008 | none
f17 | s | lkvexa.llm | ffn_block | h_k17,W,l17 | h_f17 | Hidden[8,52224] | - | - | - | 8355840 | none
c_l18 | s | lcuf.scalar | const | 18 | l18 | i64 | - | - | - | 1 | none
a18 | s | lkvexa.llm | attn_block | h_f17,W,l18 | h_a18 | Hidden[8,52224] | - | - | - | 10027008 | none
k18 | s | lkvexa.kgd_imq | kgd_imq_step | h_a18,W,l18 | h_k18 | Hidden[8,52224] | - | - | - | 10027008 | none
f18 | s | lkvexa.llm | ffn_block | h_k18,W,l18 | h_f18 | Hidden[8,52224] | - | - | - | 8355840 | none
c_l19 | s | lcuf.scalar | const | 19 | l19 | i64 | - | - | - | 1 | none
a19 | s | lkvexa.llm | attn_block | h_f18,W,l19 | h_a19 | Hidden[8,52224] | - | - | - | 10027008 | none
k19 | s | lkvexa.kgd_imq | kgd_imq_step | h_a19,W,l19 | h_k19 | Hidden[8,52224] | - | - | - | 10027008 | none
f19 | s | lkvexa.llm | ffn_block | h_k19,W,l19 | h_f19 | Hidden[8,52224] | - | - | - | 8355840 | none
c_l20 | s | lcuf.scalar | const | 20 | l20 | i64 | - | - | - | 1 | none
a20 | s | lkvexa.llm | attn_block | h_f19,W,l20 | h_a20 | Hidden[8,52224] | - | - | - | 10027008 | none
k20 | s | lkvexa.kgd_imq | kgd_imq_step | h_a20,W,l20 | h_k20 | Hidden[8,52224] | - | - | - | 10027008 | none
f20 | s | lkvexa.llm | ffn_block | h_k20,W,l20 | h_f20 | Hidden[8,52224] | - | - | - | 8355840 | none
c_l21 | s | lcuf.scalar | const | 21 | l21 | i64 | - | - | - | 1 | none
a21 | s | lkvexa.llm | attn_block | h_f20,W,l21 | h_a21 | Hidden[8,52224] | - | - | - | 10027008 | none
k21 | s | lkvexa.kgd_imq | kgd_imq_step | h_a21,W,l21 | h_k21 | Hidden[8,52224] | - | - | - | 10027008 | none
f21 | s | lkvexa.llm | ffn_block | h_k21,W,l21 | h_f21 | Hidden[8,52224] | - | - | - | 8355840 | none
c_l22 | s | lcuf.scalar | const | 22 | l22 | i64 | - | - | - | 1 | none
a22 | s | lkvexa.llm | attn_block | h_f21,W,l22 | h_a22 | Hidden[8,52224] | - | - | - | 10027008 | none
k22 | s | lkvexa.kgd_imq | kgd_imq_step | h_a22,W,l22 | h_k22 | Hidden[8,52224] | - | - | - | 10027008 | none
f22 | s | lkvexa.llm | ffn_block | h_k22,W,l22 | h_f22 | Hidden[8,52224] | - | - | - | 8355840 | none
c_l23 | s | lcuf.scalar | const | 23 | l23 | i64 | - | - | - | 1 | none
a23 | s | lkvexa.llm | attn_block | h_f22,W,l23 | h_a23 | Hidden[8,52224] | - | - | - | 10027008 | none
k23 | s | lkvexa.kgd_imq | kgd_imq_step | h_a23,W,l23 | h_k23 | Hidden[8,52224] | - | - | - | 10027008 | none
f23 | s | lkvexa.llm | ffn_block | h_k23,W,l23 | h_f23 | Hidden[8,52224] | - | - | - | 8355840 | none
c_l24 | s | lcuf.scalar | const | 24 | l24 | i64 | - | - | - | 1 | none
a24 | s | lkvexa.llm | attn_block | h_f23,W,l24 | h_a24 | Hidden[8,52224] | - | - | - | 10027008 | none
k24 | s | lkvexa.kgd_imq | kgd_imq_step | h_a24,W,l24 | h_k24 | Hidden[8,52224] | - | - | - | 10027008 | none
f24 | s | lkvexa.llm | ffn_block | h_k24,W,l24 | h_f24 | Hidden[8,52224] | - | - | - | 8355840 | none
c_l25 | s | lcuf.scalar | const | 25 | l25 | i64 | - | - | - | 1 | none
a25 | s | lkvexa.llm | attn_block | h_f24,W,l25 | h_a25 | Hidden[8,52224] | - | - | - | 10027008 | none
k25 | s | lkvexa.kgd_imq | kgd_imq_step | h_a25,W,l25 | h_k25 | Hidden[8,52224] | - | - | - | 10027008 | none
f25 | s | lkvexa.llm | ffn_block | h_k25,W,l25 | h_f25 | Hidden[8,52224] | - | - | - | 8355840 | none
c_l26 | s | lcuf.scalar | const | 26 | l26 | i64 | - | - | - | 1 | none
a26 | s | lkvexa.llm | attn_block | h_f25,W,l26 | h_a26 | Hidden[8,52224] | - | - | - | 10027008 | none
k26 | s | lkvexa.kgd_imq | kgd_imq_step | h_a26,W,l26 | h_k26 | Hidden[8,52224] | - | - | - | 10027008 | none
f26 | s | lkvexa.llm | ffn_block | h_k26,W,l26 | h_f26 | Hidden[8,52224] | - | - | - | 8355840 | none
c_l27 | s | lcuf.scalar | const | 27 | l27 | i64 | - | - | - | 1 | none
a27 | s | lkvexa.llm | attn_block | h_f26,W,l27 | h_a27 | Hidden[8,52224] | - | - | - | 10027008 | none
k27 | s | lkvexa.kgd_imq | kgd_imq_step | h_a27,W,l27 | h_k27 | Hidden[8,52224] | - | - | - | 10027008 | none
f27 | s | lkvexa.llm | ffn_block | h_k27,W,l27 | h_f27 | Hidden[8,52224] | - | - | - | 8355840 | none
c_l28 | s | lcuf.scalar | const | 28 | l28 | i64 | - | - | - | 1 | none
a28 | s | lkvexa.llm | attn_block | h_f27,W,l28 | h_a28 | Hidden[8,52224] | - | - | - | 10027008 | none
k28 | s | lkvexa.kgd_imq | kgd_imq_step | h_a28,W,l28 | h_k28 | Hidden[8,52224] | - | - | - | 10027008 | none
f28 | s | lkvexa.llm | ffn_block | h_k28,W,l28 | h_f28 | Hidden[8,52224] | - | - | - | 8355840 | none
c_l29 | s | lcuf.scalar | const | 29 | l29 | i64 | - | - | - | 1 | none
a29 | s | lkvexa.llm | attn_block | h_f28,W,l29 | h_a29 | Hidden[8,52224] | - | - | - | 10027008 | none
k29 | s | lkvexa.kgd_imq | kgd_imq_step | h_a29,W,l29 | h_k29 | Hidden[8,52224] | - | - | - | 10027008 | none
f29 | s | lkvexa.llm | ffn_block | h_k29,W,l29 | h_f29 | Hidden[8,52224] | - | - | - | 8355840 | none
c_l30 | s | lcuf.scalar | const | 30 | l30 | i64 | - | - | - | 1 | none
a30 | s | lkvexa.llm | attn_block | h_f29,W,l30 | h_a30 | Hidden[8,52224] | - | - | - | 10027008 | none
k30 | s | lkvexa.kgd_imq | kgd_imq_step | h_a30,W,l30 | h_k30 | Hidden[8,52224] | - | - | - | 10027008 | none
f30 | s | lkvexa.llm | ffn_block | h_k30,W,l30 | h_f30 | Hidden[8,52224] | - | - | - | 8355840 | none
c_l31 | s | lcuf.scalar | const | 31 | l31 | i64 | - | - | - | 1 | none
a31 | s | lkvexa.llm | attn_block | h_f30,W,l31 | h_a31 | Hidden[8,52224] | - | - | - | 10027008 | none
k31 | s | lkvexa.kgd_imq | kgd_imq_step | h_a31,W,l31 | h_k31 | Hidden[8,52224] | - | - | - | 10027008 | none
f31 | s | lkvexa.llm | ffn_block | h_k31,W,l31 | h_f31 | Hidden[8,52224] | - | - | - | 8355840 | none
c_l32 | s | lcuf.scalar | const | 32 | l32 | i64 | - | - | - | 1 | none
a32 | s | lkvexa.llm | attn_block | h_f31,W,l32 | h_a32 | Hidden[8,52224] | - | - | - | 10027008 | none
k32 | s | lkvexa.kgd_imq | kgd_imq_step | h_a32,W,l32 | h_k32 | Hidden[8,52224] | - | - | - | 10027008 | none
f32 | s | lkvexa.llm | ffn_block | h_k32,W,l32 | h_f32 | Hidden[8,52224] | - | - | - | 8355840 | none
c_l33 | s | lcuf.scalar | const | 33 | l33 | i64 | - | - | - | 1 | none
a33 | s | lkvexa.llm | attn_block | h_f32,W,l33 | h_a33 | Hidden[8,52224] | - | - | - | 10027008 | none
k33 | s | lkvexa.kgd_imq | kgd_imq_step | h_a33,W,l33 | h_k33 | Hidden[8,52224] | - | - | - | 10027008 | none
f33 | s | lkvexa.llm | ffn_block | h_k33,W,l33 | h_f33 | Hidden[8,52224] | - | - | - | 8355840 | none
hd | s | lkvexa.llm | head | h_f33,W | logits | Logits[8,49152] | - | - | - | 14155776 | none
ce | s | lkvexa.llm | next_token_ce | logits,ids | loss | f64 | - | - | - | 393216 | receipt
c_cap | s | lcuf.scalar | const | 1e+300 | cap | f64 | - | - | - | 1 | none
fin | s | lkvexa.test | assert_le | loss,cap | - | unit | - | - | - | 1 | none
out | s | lcuf.evidence | emit | loss | - | unit | evidence.emit | evidence.write | - | 1 | receipt
end
