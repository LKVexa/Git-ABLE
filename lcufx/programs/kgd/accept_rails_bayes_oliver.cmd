@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): accept_rails_bayes_oliver.lcufx. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to run the program on this package's host, lcufx\LCUFX_KGD.cmd (run --twice); or pass check or run.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=accept_rails_bayes_oliver.lcufx"
set "LB_DOC_TYPE=lcufx"
set "LB_DOC_BYTES=2923"
set "LB_DOC_SHA512=f5f6852894679b8651facfb0277c3903f07116b0ba4e7d8b2af93ea411761b1f7e5f4019f581e88e5a07dd9cfdbf0cf1edba2c8eb73cdd7d5a572b038433ef02"
set "LB_HOST=%~dp0..\..\LCUFX_KGD.cmd"
if "%~1"=="" call "%LB_HOST%" run "%~f0" --twice
if not "%~1"=="" call "%LB_HOST%" %1 "%~f0" %2 %3
set "LB_RC=%errorlevel%"
if "%~1"=="" pause
exit /b %LB_RC%
rem ---- document ----
LCUF-X/0.2+lkvexa.kgd_imq/0.2
module rails_bayes_oliver
site s trust=local memory=13580 steps=30
grant s caps=evidence.write
id | site | profile | op | inputs | output | type | effects | caps | after | budget | evidence
c_spec_o1 | s | lcuf.scalar | const | "{\"question\": \"Was Oliver one of the two people who left blood (types O and AB; Oliver is O)? MacKay (3.24)-(3.26)\", \"hypotheses\": [\"present\", \"absent\"], \"evidence\": [{\"name\": \"blood types at the scene\", \"tags\": [\"scene\"], \"likelihood\": [0.01, 0.012]}], \"lambda\": 1.0}" | spec_o1 | text | - | - | - | 1 | none
c_spec_o4 | s | lcuf.scalar | const | "{\"question\": \"The same question, when a wrong answer costs four times what a right one gains\", \"hypotheses\": [\"present\", \"absent\"], \"evidence\": [{\"name\": \"blood types at the scene\", \"tags\": [\"scene\"], \"likelihood\": [0.01, 0.012]}], \"lambda\": 4.0}" | spec_o4 | text | - | - | - | 1 | none
c_spec_oab | s | lcuf.scalar | const | "{\"question\": \"The same evidence for a suspect of type AB: MacKay (3.27)\", \"hypotheses\": [\"present\", \"absent\"], \"evidence\": [{\"name\": \"blood types at the scene\", \"tags\": [\"scene\"], \"likelihood\": [0.6, 0.012]}], \"lambda\": 1.0}" | spec_oab | text | - | - | - | 1 | none
o1 | s | lkvexa.rails8s | rails_bayes | spec_o1 | report_o1 | text | - | - | - | 6 | receipt
c_exp_o1 | s | lcuf.scalar | const | "{\"decision\": \"answer\", \"answer\": \"absent\", \"posterior.present\": {\"center\": 0.45454545454545453, \"tolerance\": 1e-12}, \"rail_IV.flip_factor\": {\"center\": 1.2, \"tolerance\": 1e-12}}" | exp_o1 | text | - | - | - | 1 | none
chk_o1 | s | lkvexa.test | assert_json | report_o1,exp_o1 | - | unit | - | - | - | 1 | none
out_o1 | s | lcuf.evidence | emit | report_o1 | - | unit | evidence.emit | evidence.write | - | 1 | receipt
o4 | s | lkvexa.rails8s | rails_bayes | spec_o4 | report_o4 | text | - | - | - | 6 | receipt
c_exp_o4 | s | lcuf.scalar | const | "{\"decision\": \"abstain\", \"answer\": null, \"rail_IV.threshold\": {\"center\": 0.8, \"tolerance\": 1e-15}}" | exp_o4 | text | - | - | - | 1 | none
chk_o4 | s | lkvexa.test | assert_json | report_o4,exp_o4 | - | unit | - | - | - | 1 | none
out_o4 | s | lcuf.evidence | emit | report_o4 | - | unit | evidence.emit | evidence.write | - | 1 | receipt
oab | s | lkvexa.rails8s | rails_bayes | spec_oab | report_oab | text | - | - | - | 6 | receipt
c_exp_oab | s | lcuf.scalar | const | "{\"decision\": \"answer\", \"answer\": \"present\", \"posterior.present\": {\"center\": 0.9803921568627451, \"tolerance\": 1e-12}, \"rail_IV.margin_log_odds\": {\"center\": 3.912023005428146, \"tolerance\": 1e-12}}" | exp_oab | text | - | - | - | 1 | none
chk_oab | s | lkvexa.test | assert_json | report_oab,exp_oab | - | unit | - | - | - | 1 | none
out_oab | s | lcuf.evidence | emit | report_oab | - | unit | evidence.emit | evidence.write | - | 1 | receipt
end
