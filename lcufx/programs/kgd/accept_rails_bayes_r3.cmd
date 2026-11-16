@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): accept_rails_bayes_r3.lcufx. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to run the program on this package's host, lcufx\LCUFX_KGD.cmd (run --twice); or pass check or run.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=accept_rails_bayes_r3.lcufx"
set "LB_DOC_TYPE=lcufx"
set "LB_DOC_BYTES=1308"
set "LB_DOC_SHA512=d9ef0998c12fa093219204f8c3385967703fffbaea54f00effaf1b911e42c41120ebab9161d63e67903a4ef494e6557cd484b6b71d23245eab85587f96976670"
set "LB_HOST=%~dp0..\..\LCUFX_KGD.cmd"
if "%~1"=="" call "%LB_HOST%" run "%~f0" --twice
if not "%~1"=="" call "%LB_HOST%" %1 "%~f0" %2 %3
set "LB_RC=%errorlevel%"
if "%~1"=="" pause
exit /b %LB_RC%
rem ---- document ----
LCUF-X/0.2+lkvexa.kgd_imq/0.2
module rails_bayes_r3
site s trust=local memory=4817 steps=40
grant s caps=evidence.write
id | site | profile | op | inputs | output | type | effects | caps | after | budget | evidence
c_spec_r3 | s | lcuf.scalar | const | "{\"question\": \"Which source bit was sent, given r = 011 over a binary symmetric channel with f = 0.1? MacKay (1.18)-(1.23)\", \"hypotheses\": [\"s=0\", \"s=1\"], \"prior\": [0.5, 0.5], \"evidence\": [{\"name\": \"r1=0\", \"tags\": [\"bit:1\"], \"likelihood\": [0.9, 0.1]}, {\"name\": \"r2=1\", \"tags\": [\"bit:2\"], \"likelihood\": [0.1, 0.9]}, {\"name\": \"r3=1\", \"tags\": [\"bit:3\"], \"likelihood\": [0.1, 0.9]}]}" | spec_r3 | text | - | - | - | 1 | none
r3 | s | lkvexa.rails8s | rails_bayes | spec_r3 | report_r3 | text | - | - | - | 36 | receipt
c_exp_r3 | s | lcuf.scalar | const | "{\"decision\": \"answer\", \"answer\": \"s=1\", \"posterior.s=1\": {\"center\": 0.9, \"tolerance\": 1e-12}, \"rail_IV.margin_log_odds\": {\"center\": 2.1972245773362196, \"tolerance\": 1e-12}, \"rail_III.rank\": 3}" | exp_r3 | text | - | - | - | 1 | none
chk_r3 | s | lkvexa.test | assert_json | report_r3,exp_r3 | - | unit | - | - | - | 1 | none
out_r3 | s | lcuf.evidence | emit | report_r3 | - | unit | evidence.emit | evidence.write | - | 1 | receipt
end
