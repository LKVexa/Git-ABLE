@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): accept_kgd_alpha_gate.lcufx. The document is the last LB_DOC_BYTES bytes of this file.
rem It runs on your LCUF-X/0.2 compiler (lcuf_x.py) through tools\RUN_CORE.cmd: see README.md.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=accept_kgd_alpha_gate.lcufx"
set "LB_DOC_TYPE=lcufx"
set "LB_DOC_BYTES=1464"
set "LB_DOC_SHA512=c5f9bc0a1d72fadc312fdc5222517beecfb886c9b47e9220fa789286e88da530e61cf068aca89a37717687df10cc24057b067a215d5d201b4daf4cdddea69d11"
set "LB_CORE=%~dp0..\..\..\tools\RUN_CORE.cmd"
if "%~1"=="" call "%LB_CORE%" run "%~f0"
if not "%~1"=="" call "%LB_CORE%" %1 "%~f0" %2 %3
set "LB_RC=%errorlevel%"
if "%~1"=="" pause
exit /b %LB_RC%
rem ---- document ----
LCUF-X/0.2
module kgd_imq_alpha_gate_0
site s trust=local memory=1000000 steps=1000000
grant s caps=evidence.write,optimizer.state
id | site | profile | op | inputs | output | type | effects | caps | after | budget | evidence
x | s | lcuf.scalar | const | [1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0] | x | Vec[f64,8] | - | - | - | 4096 | none
a_m1_l00 | s | lcuf.scalar | const | 0.0497283935546875 | alpha_m1_l00 | f64 | - | - | - | 4096 | none
d_m1_l00 | s | lcuf.diffusion.periodic | diffuse_step | x,alpha_m1_l00 | y_m1_l00 | Vec[f64,8] | - | - | - | 4096 | none
a_m1_l01 | s | lcuf.scalar | const | 0.0497283935546875 | alpha_m1_l01 | f64 | - | - | - | 4096 | none
d_m1_l01 | s | lcuf.diffusion.periodic | diffuse_step | x,alpha_m1_l01 | y_m1_l01 | Vec[f64,8] | - | - | - | 4096 | none
a_m1_l02 | s | lcuf.scalar | const | 0.0497283935546875 | alpha_m1_l02 | f64 | - | - | - | 4096 | none
d_m1_l02 | s | lcuf.diffusion.periodic | diffuse_step | x,alpha_m1_l02 | y_m1_l02 | Vec[f64,8] | - | - | - | 4096 | none
a_m1_l03 | s | lcuf.scalar | const | 0.0497283935546875 | alpha_m1_l03 | f64 | - | - | - | 4096 | none
d_m1_l03 | s | lcuf.diffusion.periodic | diffuse_step | x,alpha_m1_l03 | y_m1_l03 | Vec[f64,8] | - | - | - | 4096 | none
a_m2_all | s | lcuf.scalar | const | 0.0500030517578125 | alpha_m2_all | f64 | - | - | - | 4096 | none
d_m2_all | s | lcuf.diffusion.periodic | diffuse_step | x,alpha_m2_all | y_m2_all | Vec[f64,8] | - | - | - | 4096 | none
end
