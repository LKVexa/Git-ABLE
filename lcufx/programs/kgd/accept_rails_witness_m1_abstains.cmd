@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): accept_rails_witness_m1_abstains.lcufx. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to run the program on this package's host, lcufx\LCUFX_KGD.cmd (run --twice); or pass check or run.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=accept_rails_witness_m1_abstains.lcufx"
set "LB_DOC_TYPE=lcufx"
set "LB_DOC_BYTES=1597"
set "LB_DOC_SHA512=5c2bfd204fba17262f3db264f3469055b7bcdccf2e28fe544279da2ef6b2770e3012cd8ee23c6e37b9f7cd6d78b93963330c6f84d98199f3e4e2035ddaf6907a"
set "LB_HOST=%~dp0..\..\LCUFX_KGD.cmd"
if "%~1"=="" call "%LB_HOST%" run "%~f0" --twice
if not "%~1"=="" call "%LB_HOST%" %1 "%~f0" %2 %3
set "LB_RC=%errorlevel%"
if "%~1"=="" pause
exit /b %LB_RC%
rem ---- document ----
LCUF-X/0.2+lkvexa.kgd_imq/0.2
module rails_witness_m1_abstains
site s trust=local memory=54661150 steps=432012861
grant s caps=evidence.write,weights.read
id | site | profile | op | inputs | output | type | effects | caps | after | budget | evidence
c_path | s | lcuf.scalar | const | "../../../weights/model1-untrained/exact/manifest.cmd" | path | text | - | - | - | 1 | none
c_pin | s | lcuf.scalar | const | "2824a03df39ab370306ebf0f04f9d72afccb7a171f06997c58eddfac420e697e235b83ae32f9a89b5aa956c7aef785b0920aacbd6ea95eacb74fbb7eae3fb627" | pin | text | - | - | - | 1 | none
c_tier | s | lcuf.scalar | const | "exact" | tier | text | - | - | - | 1 | none
w | s | lkvexa.weights.cmd | lb_load | path,pin,tier | W | WeightSet[model1] | weights.read | weights.read | - | 54525494 | receipt
c_spec_wq | s | lcuf.scalar | const | "{\"question\": \"Which word continues the prompt?\", \"prompt\": \"Information theory and \", \"candidates\": [\"inference\", \"qzxjvkwbp\"], \"calibration\": \"ning result is claimed.\\n\\n\\u001e\\n# C005 resume\\n\\n- Last stage: W12.\\n- S\", \"lambda\": 1.0}" | spec_wq | text | - | - | - | 1 | none
wq | s | lkvexa.rails8s | rails_witness | W,spec_wq | report_wq | text | - | - | - | 377487360 | receipt
c_exp_wq | s | lcuf.scalar | const | "{\"rail_III.admitted\": false, \"decision\": \"abstain\", \"answer\": null}" | exp_wq | text | - | - | - | 1 | none
chk_wq | s | lkvexa.test | assert_json | report_wq,exp_wq | - | unit | - | - | - | 1 | none
out_wq | s | lcuf.evidence | emit | report_wq | - | unit | evidence.emit | evidence.write | - | 1 | receipt
end
