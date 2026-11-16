@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): accept_rails_meanfield_certified.lcufx. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to run the program on this package's host, lcufx\LCUFX_KGD.cmd (run --twice); or pass check or run.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=accept_rails_meanfield_certified.lcufx"
set "LB_DOC_TYPE=lcufx"
set "LB_DOC_BYTES=1555"
set "LB_DOC_SHA512=1c46f6a789c5c6a3ca329c3fb5836f51d41057ed84c40120ee8bf58f8870ef0d732b529ab3333652f498dbf578596a689e330febed1d7d2b5613a99105baf216"
set "LB_HOST=%~dp0..\..\LCUFX_KGD.cmd"
if "%~1"=="" call "%LB_HOST%" run "%~f0" --twice
if not "%~1"=="" call "%LB_HOST%" %1 "%~f0" %2 %3
set "LB_RC=%errorlevel%"
if "%~1"=="" pause
exit /b %LB_RC%
rem ---- document ----
LCUF-X/0.2+lkvexa.kgd_imq/0.2
module rails_meanfield_certified
site s trust=local memory=5019 steps=90076
grant s caps=evidence.write
id | site | profile | op | inputs | output | type | effects | caps | after | budget | evidence
c_spec_mf | s | lcuf.scalar | const | "{\"question\": \"Three coupled claims: A supports B, B contradicts C (MacKay chapters 31 and 33)\", \"claims\": [\"A\", \"B\", \"C\"], \"h\": [1.2, -0.4, 0.3], \"J\": [[0, 0.5, 0], [0.5, 0, -0.4], [0, -0.4, 0]], \"lambda\": 1.5}" | spec_mf | text | - | - | - | 1 | none
mf | s | lkvexa.rails8s | rails_meanfield | spec_mf | report_mf | text | - | - | - | 90072 | receipt
c_exp_mf | s | lcuf.scalar | const | "{\"certified\": true, \"kappa\": {\"center\": 0.45, \"tolerance\": 1e-15}, \"marginals.A\": {\"center\": 0.7482784821861647, \"tolerance\": 1e-12}, \"marginals.B\": {\"center\": 0.45160463295708014, \"tolerance\": 1e-12}, \"marginals.C\": {\"center\": 0.5809526782572996, \"tolerance\": 1e-12}, \"rail_III.meanfield.A\": {\"center\": 0.759157110268757, \"tolerance\": 1e-09}, \"rail_III.meanfield.B\": {\"center\": 0.44806394130017624, \"tolerance\": 1e-09}, \"rail_III.meanfield.C\": {\"center\": 0.5845667072507617, \"tolerance\": 1e-09}, \"decisions.A\": \"accept\", \"decisions.B\": \"undecided\", \"decisions.C\": \"undecided\"}" | exp_mf | text | - | - | - | 1 | none
chk_mf | s | lkvexa.test | assert_json | report_mf,exp_mf | - | unit | - | - | - | 1 | none
out_mf | s | lcuf.evidence | emit | report_mf | - | unit | evidence.emit | evidence.write | - | 1 | receipt
end
