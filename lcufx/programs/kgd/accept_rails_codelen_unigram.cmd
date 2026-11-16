@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): accept_rails_codelen_unigram.lcufx. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to run the program on this package's host, lcufx\LCUFX_KGD.cmd (run --twice); or pass check or run.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=accept_rails_codelen_unigram.lcufx"
set "LB_DOC_TYPE=lcufx"
set "LB_DOC_BYTES=1435"
set "LB_DOC_SHA512=1fe77279f6aef8d2cfe857b216b1e25e029aaeb79c563fb1f31ddbf4987155266134e0d36cdd58239dfb5377ffabb9f439a67e0be4a76c9522aaa606f55ed64c"
set "LB_HOST=%~dp0..\..\LCUFX_KGD.cmd"
if "%~1"=="" call "%LB_HOST%" run "%~f0" --twice
if not "%~1"=="" call "%LB_HOST%" %1 "%~f0" %2 %3
set "LB_RC=%errorlevel%"
if "%~1"=="" pause
exit /b %LB_RC%
rem ---- document ----
LCUF-X/0.2+lkvexa.kgd_imq/0.2
module rails_codelen_unigram
site s trust=local memory=3737174 steps=33130908
grant s caps=evidence.write,weights.read
id | site | profile | op | inputs | output | type | effects | caps | after | budget | evidence
c_shards | s | lcuf.scalar | const | "[\"../../../data/train_bytes_00.cmd\", \"../../../data/train_bytes_01.cmd\"]" | shards | text | - | - | - | 1 | none
c_dpin | s | lcuf.scalar | const | "c17ea34319bad060391761fa490efc01bb51cefdfb44fc200fe90015e4c76942e1be8128dd7be260f3295335c218990c56ef67321fbb41279a1782ccd1787767" | dpin | text | - | - | - | 1 | none
c_alpha | s | lcuf.scalar | const | 1.0 | alpha | f64 | - | - | - | 1 | none
u | s | lkvexa.rails8s | bytes_unigram | shards,dpin,alpha | U | WeightSet[unigram] | weights.read | weights.read | - | 33106324 | receipt
c_text | s | lcuf.scalar | const | "07 \u007c complete \u007c See the core specification and v" | text | text | - | - | - | 1 | none
cl | s | lkvexa.rails8s | rails_codelen | U,text | report_cl | text | - | - | - | 24577 | receipt
c_exp_cl | s | lcuf.scalar | const | "{\"rail_I.roundtrip\": true, \"rail_IV.within_bound\": true, \"rail_III.admitted_as_compressor\": true}" | exp_cl | text | - | - | - | 1 | none
chk_cl | s | lkvexa.test | assert_json | report_cl,exp_cl | - | unit | - | - | - | 1 | none
out_cl | s | lcuf.evidence | emit | report_cl | - | unit | evidence.emit | evidence.write | - | 1 | receipt
end
