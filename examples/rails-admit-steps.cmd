@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): rails-admit-steps.json. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to run the reasoning layer on it (tools\REASON.cmd admit); tools\DOC.cmd print shows the spec.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=rails-admit-steps.json"
set "LB_DOC_TYPE=json"
set "LB_DOC_BYTES=674"
set "LB_DOC_SHA512=99095a0761e1eb62c7d015b17b82903c80d02d55aa125a116a181ccda87873d0faf8b69dba4b3175305507a44fe5c0ea4ee5e06a1ae227a305d8bb647f1ffaa9"
set "LB_REASON=%~dp0..\tools\REASON.cmd"
call "%LB_REASON%" admit "%~f0" %1 %2
set "LB_RC=%errorlevel%"
if "%~1"=="" pause
exit /b %LB_RC%
rem ---- document ----
{
 "question": "Which of six reasoning steps add something new? (8S Theorem A: a rank-increment test)",
 "items": [
  {
   "name": "s1",
   "code": [
    1,
    0,
    0
   ],
   "gain_bits": 2.0
  },
  {
   "name": "s2",
   "code": [
    0,
    1,
    0
   ],
   "gain_bits": 1.0
  },
  {
   "name": "s3",
   "code": [
    1,
    1,
    0
   ],
   "gain_bits": 0.7
  },
  {
   "name": "s4",
   "code": [
    0,
    0,
    1
   ],
   "gain_bits": 0.0
  },
  {
   "name": "s5",
   "code": [
    1,
    1,
    0.001
   ],
   "gain_bits": 0.4
  },
  {
   "name": "s6",
   "code": [
    0,
    0,
    2
   ],
   "gain_bits": 0.3
  }
 ],
 "eps_ind": 0.01,
 "eps_gain_bits": 0.0
}