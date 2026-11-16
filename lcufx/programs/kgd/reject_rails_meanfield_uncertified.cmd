@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): reject_rails_meanfield_uncertified.lcufx. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to run the program on this package's host, lcufx\LCUFX_KGD.cmd (run --twice); or pass check or run.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=reject_rails_meanfield_uncertified.lcufx"
set "LB_DOC_TYPE=lcufx"
set "LB_DOC_BYTES=841"
set "LB_DOC_SHA512=18c1e92c602fee84c872ee59afbec5ad84e1fc1fe5ea9634db03a42c71b90643e83610c9794c4999d383d19afb38afdd88a9c5561a521e8a284cb0dc6f6f6b14"
set "LB_HOST=%~dp0..\..\LCUFX_KGD.cmd"
if "%~1"=="" call "%LB_HOST%" run "%~f0" --twice
if not "%~1"=="" call "%LB_HOST%" %1 "%~f0" %2 %3
set "LB_RC=%errorlevel%"
if "%~1"=="" pause
exit /b %LB_RC%
rem ---- document ----
LCUF-X/0.2+lkvexa.kgd_imq/0.2
module rails_meanfield_uncertified
site s trust=local memory=4289 steps=40020
grant s caps=evidence.write
id | site | profile | op | inputs | output | type | effects | caps | after | budget | evidence
c_spec_mf | s | lcuf.scalar | const | "{\"question\": \"Two strongly coupled claims\", \"claims\": [\"A\", \"B\"], \"h\": [0.1, -0.1], \"J\": [[0, 2.5], [2.5, 0]]}" | spec_mf | text | - | - | - | 1 | none
mf | s | lkvexa.rails8s | rails_meanfield | spec_mf | report_mf | text | - | - | - | 40016 | receipt
c_exp_mf | s | lcuf.scalar | const | "{\"certified\": true}" | exp_mf | text | - | - | - | 1 | none
chk_mf | s | lkvexa.test | assert_json | report_mf,exp_mf | - | unit | - | - | - | 1 | none
out_mf | s | lcuf.evidence | emit | report_mf | - | unit | evidence.emit | evidence.write | - | 1 | receipt
end
