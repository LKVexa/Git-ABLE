@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): rails-meanfield.json. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to run the reasoning layer on it (tools\REASON.cmd meanfield); tools\DOC.cmd print shows the spec.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=rails-meanfield.json"
set "LB_DOC_TYPE=json"
set "LB_DOC_BYTES=283"
set "LB_DOC_SHA512=b404cd2dc5f3817d036c49c05179f20a0ae9e100bd6777020a30137224e035df304ecfa5e27a915849f09b8bf79881b67ee0ec89cd0512f303659130e92a3691"
set "LB_REASON=%~dp0..\tools\REASON.cmd"
call "%LB_REASON%" meanfield "%~f0" %1 %2
set "LB_RC=%errorlevel%"
if "%~1"=="" pause
exit /b %LB_RC%
rem ---- document ----
{
 "question": "Three coupled claims: A supports B, B contradicts C (MacKay chapters 31 and 33)",
 "claims": [
  "A",
  "B",
  "C"
 ],
 "h": [
  1.2,
  -0.4,
  0.3
 ],
 "J": [
  [
   0,
   0.5,
   0
  ],
  [
   0.5,
   0,
   -0.4
  ],
  [
   0,
   -0.4,
   0
  ]
 ],
 "lambda": 1.5
}