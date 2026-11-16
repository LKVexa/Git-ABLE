@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): reject_kgd_alpha_q16_step_above_half.lcufx. The document is the last LB_DOC_BYTES bytes of this file.
rem It runs on your LCUF-X/0.2 compiler (lcuf_x.py) through tools\RUN_CORE.cmd: see README.md.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=reject_kgd_alpha_q16_step_above_half.lcufx"
set "LB_DOC_TYPE=lcufx"
set "LB_DOC_BYTES=573"
set "LB_DOC_SHA512=6a0d43935724ef165c25b8114551d6cc0117a7d8e77e3b413a2c4611814eaa78f12695985bf4192adfede5ad28ce4efcace88016875a245d997b138852806d38"
set "LB_CORE=%~dp0..\..\..\tools\RUN_CORE.cmd"
if "%~1"=="" call "%LB_CORE%" run "%~f0"
if not "%~1"=="" call "%LB_CORE%" %1 "%~f0" %2 %3
set "LB_RC=%errorlevel%"
if "%~1"=="" pause
exit /b %LB_RC%
rem ---- document ----
LCUF-X/0.2
module kgd_imq_alpha_q16_step_above_half_0
site s trust=local memory=1000000 steps=1000000
grant s caps=evidence.write,optimizer.state
id | site | profile | op | inputs | output | type | effects | caps | after | budget | evidence
x | s | lcuf.scalar | const | [1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0] | x | Vec[f64,8] | - | - | - | 4096 | none
a_over | s | lcuf.scalar | const | 0.5000152587890625 | alpha_over | f64 | - | - | - | 4096 | none
d_over | s | lcuf.diffusion.periodic | diffuse_step | x,alpha_over | y_over | Vec[f64,8] | - | - | - | 4096 | none
end
