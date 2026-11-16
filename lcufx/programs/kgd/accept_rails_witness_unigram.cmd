@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): accept_rails_witness_unigram.lcufx. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to run the program on this package's host, lcufx\LCUFX_KGD.cmd (run --twice); or pass check or run.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=accept_rails_witness_unigram.lcufx"
set "LB_DOC_TYPE=lcufx"
set "LB_DOC_BYTES=1625"
set "LB_DOC_SHA512=975e9efd448904c5ec40dc85392f7767354ebec1f2afce34fe726641afbaca65ac7ad6855cd9711cbcf3bb7f85b82093089324e547bbd1bc060f848ba42f2c81"
set "LB_HOST=%~dp0..\..\LCUFX_KGD.cmd"
if "%~1"=="" call "%LB_HOST%" run "%~f0" --twice
if not "%~1"=="" call "%LB_HOST%" %1 "%~f0" %2 %3
set "LB_RC=%errorlevel%"
if "%~1"=="" pause
exit /b %LB_RC%
rem ---- document ----
LCUF-X/0.2+lkvexa.kgd_imq/0.2
module rails_witness_unigram
site s trust=local memory=3737337 steps=33106414
grant s caps=evidence.write,weights.read
id | site | profile | op | inputs | output | type | effects | caps | after | budget | evidence
c_shards | s | lcuf.scalar | const | "[\"../../../data/train_bytes_00.cmd\", \"../../../data/train_bytes_01.cmd\"]" | shards | text | - | - | - | 1 | none
c_dpin | s | lcuf.scalar | const | "c17ea34319bad060391761fa490efc01bb51cefdfb44fc200fe90015e4c76942e1be8128dd7be260f3295335c218990c56ef67321fbb41279a1782ccd1787767" | dpin | text | - | - | - | 1 | none
c_alpha | s | lcuf.scalar | const | 1.0 | alpha | f64 | - | - | - | 1 | none
u | s | lkvexa.rails8s | bytes_unigram | shards,dpin,alpha | U | WeightSet[unigram] | weights.read | weights.read | - | 33106324 | receipt
c_spec_wq | s | lcuf.scalar | const | "{\"question\": \"Which word continues the prompt?\", \"prompt\": \"Information theory and \", \"candidates\": [\"inference\", \"qzxjvkwbp\"], \"calibration\": \"ning result is claimed.\\n\\n\\u001e\\n# C005 resume\\n\\n- Last stage: W12.\\n- S\", \"lambda\": 1.0}" | spec_wq | text | - | - | - | 1 | none
wq | s | lkvexa.rails8s | rails_witness | U,spec_wq | report_wq | text | - | - | - | 83 | receipt
c_exp_wq | s | lcuf.scalar | const | "{\"rail_III.admitted\": true, \"decision\": \"answer\", \"answer\": \"inference\"}" | exp_wq | text | - | - | - | 1 | none
chk_wq | s | lkvexa.test | assert_json | report_wq,exp_wq | - | unit | - | - | - | 1 | none
out_wq | s | lcuf.evidence | emit | report_wq | - | unit | evidence.emit | evidence.write | - | 1 | receipt
end
