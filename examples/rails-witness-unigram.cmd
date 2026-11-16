@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): rails-witness-unigram.json. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to run the reasoning layer on it (tools\REASON.cmd witness); tools\DOC.cmd print shows the spec.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=rails-witness-unigram.json"
set "LB_DOC_TYPE=json"
set "LB_DOC_BYTES=517"
set "LB_DOC_SHA512=7acece8b2fae6299819411f2457892cdfef71ec239c41f6216bdd69e5c1fa2131cf1ccb3c94e05cc60d8c10f178db0ada7b20631482e7aa1fea65bcf36953116"
set "LB_REASON=%~dp0..\tools\REASON.cmd"
call "%LB_REASON%" witness "%~f0" %1 %2
set "LB_RC=%errorlevel%"
if "%~1"=="" pause
exit /b %LB_RC%
rem ---- document ----
{
 "question": "Which word continues the prompt?",
 "witness": {
  "unigram": [
   "../data/train_bytes_00.cmd",
   "../data/train_bytes_01.cmd"
  ],
  "data_sha512": "c17ea34319bad060391761fa490efc01bb51cefdfb44fc200fe90015e4c76942e1be8128dd7be260f3295335c218990c56ef67321fbb41279a1782ccd1787767",
  "alpha": 1.0
 },
 "prompt": "Information theory and ",
 "candidates": [
  "inference",
  "qzxjvkwbp"
 ],
 "calibration": "ning result is claimed.\n\n\u001e\n# C005 resume\n\n- Last stage: W12.\n- S",
 "lambda": 1.0
}