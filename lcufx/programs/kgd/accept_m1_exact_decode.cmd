@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): accept_m1_exact_decode.lcufx. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to run the program on this package's host, lcufx\LCUFX_KGD.cmd (run --twice); or pass check or run.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=accept_m1_exact_decode.lcufx"
set "LB_DOC_TYPE=lcufx"
set "LB_DOC_BYTES=1252"
set "LB_DOC_SHA512=3c1d185ffaa755f209bfef667447b6f8aa72cab44bcbfd728ccc12f2d54c702be4f122e443282c996a491f5afa2dc3711943d3eb356435d8e627b5edcedbe4f0"
set "LB_HOST=%~dp0..\..\LCUFX_KGD.cmd"
if "%~1"=="" call "%LB_HOST%" run "%~f0" --twice
if not "%~1"=="" call "%LB_HOST%" %1 "%~f0" %2 %3
set "LB_RC=%errorlevel%"
if "%~1"=="" pause
exit /b %LB_RC%
rem ---- document ----
LCUF-X/0.2+lkvexa.kgd_imq/0.2
module m1_exact_decode
site s trust=local memory=54717657 steps=15531507261
grant s caps=evidence.write,weights.read
id | site | profile | op | inputs | output | type | effects | caps | after | budget | evidence
c_path | s | lcuf.scalar | const | "../../../weights/model1-untrained/exact/manifest.cmd" | path | text | - | - | - | 1 | none
c_pin | s | lcuf.scalar | const | "2824a03df39ab370306ebf0f04f9d72afccb7a171f06997c58eddfac420e697e235b83ae32f9a89b5aa956c7aef785b0920aacbd6ea95eacb74fbb7eae3fb627" | pin | text | - | - | - | 1 | none
c_tier | s | lcuf.scalar | const | "exact" | tier | text | - | - | - | 1 | none
w | s | lkvexa.weights.cmd | lb_load | path,pin,tier | W | WeightSet[model1] | weights.read | weights.read | - | 54525494 | receipt
c_text | s | lcuf.scalar | const | "LCUF-X/0.2 admits " | text | text | - | - | - | 1 | none
tok | s | lkvexa.bytes | tokens_utf8 | text | ids | Tokens[18] | - | - | - | 1 | none
c_n | s | lcuf.scalar | const | 64 | n | i64 | - | - | - | 1 | none
gen | s | lkvexa.llm.decode | greedy_bytes | ids,W,n | continuation | text | - | - | - | 15476981760 | receipt
out | s | lcuf.evidence | emit | continuation | - | unit | evidence.emit | evidence.write | - | 1 | receipt
end
