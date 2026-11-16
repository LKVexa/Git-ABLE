@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): rails-witness-model1.json. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to run the reasoning layer on it (tools\REASON.cmd witness); tools\DOC.cmd print shows the spec.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=rails-witness-model1.json"
set "LB_DOC_TYPE=json"
set "LB_DOC_BYTES=491"
set "LB_DOC_SHA512=ae54b5d5eae0a7a99e6dd22f75a2bd817e67c4f94f801e37d2d9b52afd299796dbaddd24830145fe3b2eef03f88a6106a533aa94718d36608a94380e7aefe189"
set "LB_REASON=%~dp0..\tools\REASON.cmd"
call "%LB_REASON%" witness "%~f0" %1 %2
set "LB_RC=%errorlevel%"
if "%~1"=="" pause
exit /b %LB_RC%
rem ---- document ----
{
 "question": "Which word continues the prompt?",
 "witness": {
  "manifest": "../weights/model1-untrained/exact/manifest.cmd",
  "tier": "exact",
  "pin": "2824a03df39ab370306ebf0f04f9d72afccb7a171f06997c58eddfac420e697e235b83ae32f9a89b5aa956c7aef785b0920aacbd6ea95eacb74fbb7eae3fb627"
 },
 "prompt": "Information theory and ",
 "candidates": [
  "inference",
  "qzxjvkwbp"
 ],
 "calibration": "ning result is claimed.\n\n\u001e\n# C005 resume\n\n- Last stage: W12.\n- S",
 "lambda": 1.0
}