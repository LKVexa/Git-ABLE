@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): accept_rails_admit_steps.lcufx. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to run the program on this package's host, lcufx\LCUFX_KGD.cmd (run --twice); or pass check or run.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=accept_rails_admit_steps.lcufx"
set "LB_DOC_TYPE=lcufx"
set "LB_DOC_BYTES=1434"
set "LB_DOC_SHA512=6c4e7bc9b6b889bb0450dc29d66fa1d5f9a628fc81a19c0df289925f4c31a835682c0a34a236c8f2034a88b2258cd02ed0984893e36bd9307f6abee413f78752"
set "LB_HOST=%~dp0..\..\LCUFX_KGD.cmd"
if "%~1"=="" call "%LB_HOST%" run "%~f0" --twice
if not "%~1"=="" call "%LB_HOST%" %1 "%~f0" %2 %3
set "LB_RC=%errorlevel%"
if "%~1"=="" pause
exit /b %LB_RC%
rem ---- document ----
LCUF-X/0.2+lkvexa.kgd_imq/0.2
module rails_admit_steps
site s trust=local memory=4876 steps=118
grant s caps=evidence.write
id | site | profile | op | inputs | output | type | effects | caps | after | budget | evidence
c_spec_steps | s | lcuf.scalar | const | "{\"question\": \"Which of six reasoning steps add something new? (8S Theorem A: a rank-increment test)\", \"items\": [{\"name\": \"s1\", \"code\": [1, 0, 0], \"gain_bits\": 2.0}, {\"name\": \"s2\", \"code\": [0, 1, 0], \"gain_bits\": 1.0}, {\"name\": \"s3\", \"code\": [1, 1, 0], \"gain_bits\": 0.7}, {\"name\": \"s4\", \"code\": [0, 0, 1], \"gain_bits\": 0.0}, {\"name\": \"s5\", \"code\": [1, 1, 0.001], \"gain_bits\": 0.4}, {\"name\": \"s6\", \"code\": [0, 0, 2], \"gain_bits\": 0.3}], \"eps_ind\": 0.01, \"eps_gain_bits\": 0.0}" | spec_steps | text | - | - | - | 1 | none
steps | s | lkvexa.rails8s | rails_admit | spec_steps | report_steps | text | - | - | - | 114 | receipt
c_exp_steps | s | lcuf.scalar | const | "{\"admitted\": [\"s1\", \"s2\", \"s6\"], \"rejected\": [\"s3\", \"s4\", \"s5\"], \"rank\": 3, \"total_gain_bits\": {\"center\": 3.3, \"tolerance\": 1e-12}, \"retraction.gates_off.rank\": 3}" | exp_steps | text | - | - | - | 1 | none
chk_steps | s | lkvexa.test | assert_json | report_steps,exp_steps | - | unit | - | - | - | 1 | none
out_steps | s | lcuf.evidence | emit | report_steps | - | unit | evidence.emit | evidence.write | - | 1 | receipt
end
