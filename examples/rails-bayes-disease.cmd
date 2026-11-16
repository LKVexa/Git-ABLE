@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): rails-bayes-disease.json. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to run the reasoning layer on it (tools\REASON.cmd bayes); tools\DOC.cmd print shows the spec.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=rails-bayes-disease.json"
set "LB_DOC_TYPE=json"
set "LB_DOC_BYTES=444"
set "LB_DOC_SHA512=525594ce1800e8ca9e75d6f05038dc963b3c621f3889f7eae2c4f19c9fdc7fe4ba790d25fddadb4c9503cb21e5b5a98c82ae98baf7403ba9f64bf63e8d80e635"
set "LB_REASON=%~dp0..\tools\REASON.cmd"
call "%LB_REASON%" bayes "%~f0" %1 %2
set "LB_RC=%errorlevel%"
if "%~1"=="" pause
exit /b %LB_RC%
rem ---- document ----
{
 "question": "Does Jo have the disease, given a positive test? MacKay (2.12)-(2.18)",
 "hypotheses": [
  "disease",
  "healthy"
 ],
 "prior": [
  0.01,
  0.99
 ],
 "evidence": [
  {
   "name": "positive test",
   "tags": [
    "test:jo-1"
   ],
   "likelihood": [
    0.95,
    0.05
   ]
  },
  {
   "name": "positive test, entered again",
   "tags": [
    "test:jo-1"
   ],
   "likelihood": [
    0.95,
    0.05
   ]
  }
 ],
 "lambda": 1.0
}