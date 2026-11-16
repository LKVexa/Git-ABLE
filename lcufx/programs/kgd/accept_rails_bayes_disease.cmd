@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): accept_rails_bayes_disease.lcufx. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to run the program on this package's host, lcufx\LCUFX_KGD.cmd (run --twice); or pass check or run.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=accept_rails_bayes_disease.lcufx"
set "LB_DOC_TYPE=lcufx"
set "LB_DOC_BYTES=1817"
set "LB_DOC_SHA512=84a4d4b3a669a534afab618942be0c0ce3894b2b1f7856aa13de48f6503a82ba89ce87542fca62b2c78720739aa0ee368bfeb41f43fa7a619a212bdb8124220f"
set "LB_HOST=%~dp0..\..\LCUFX_KGD.cmd"
if "%~1"=="" call "%LB_HOST%" run "%~f0" --twice
if not "%~1"=="" call "%LB_HOST%" %1 "%~f0" %2 %3
set "LB_RC=%errorlevel%"
if "%~1"=="" pause
exit /b %LB_RC%
rem ---- document ----
LCUF-X/0.2+lkvexa.kgd_imq/0.2
module rails_bayes_disease
site s trust=local memory=4867 steps=20
grant s caps=evidence.write
id | site | profile | op | inputs | output | type | effects | caps | after | budget | evidence
c_spec_jo | s | lcuf.scalar | const | "{\"question\": \"Does Jo have the disease, given a positive test? MacKay (2.12)-(2.18)\", \"hypotheses\": [\"disease\", \"healthy\"], \"prior\": [0.01, 0.99], \"evidence\": [{\"name\": \"positive test\", \"tags\": [\"test:jo-1\"], \"likelihood\": [0.95, 0.05]}, {\"name\": \"positive test, entered again\", \"tags\": [\"test:jo-1\"], \"likelihood\": [0.95, 0.05]}], \"lambda\": 1.0}" | spec_jo | text | - | - | - | 1 | none
jo | s | lkvexa.rails8s | rails_bayes | spec_jo | report_jo | text | - | - | - | 11 | receipt
c_exp_jo | s | lcuf.scalar | const | "{\"decision\": \"answer\", \"answer\": \"healthy\", \"posterior.disease\": {\"center\": 0.16101694915254236, \"tolerance\": 1e-12}, \"admitted\": [\"positive test\"], \"rejected\": [\"positive test, entered again\"], \"retraction.gates_off.posterior.disease\": {\"center\": 0.7847826086956522, \"tolerance\": 1e-12}}" | exp_jo | text | - | - | - | 1 | none
chk_jo | s | lkvexa.test | assert_json | report_jo,exp_jo | - | unit | - | - | - | 1 | none
out_jo | s | lcuf.evidence | emit | report_jo | - | unit | evidence.emit | evidence.write | - | 1 | receipt
c_key | s | lcuf.scalar | const | "posterior.disease" | key | text | - | - | - | 1 | none
p | s | lkvexa.rails8s | json_f64 | report_jo,key | p_disease | f64 | - | - | - | 1 | none
c_printed | s | lcuf.scalar | const | 0.16 | printed | f64 | - | - | - | 1 | none
c_tol | s | lcuf.scalar | const | 0.005 | tol | f64 | - | - | - | 1 | none
chk_printed | s | lkvexa.test | assert_close | p_disease,printed,tol | - | unit | - | - | - | 1 | none
end
