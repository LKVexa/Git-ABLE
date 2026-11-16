@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): rails-codelen-model1.json. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to run the reasoning layer on it (tools\REASON.cmd codelen); tools\DOC.cmd print shows the spec.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=rails-codelen-model1.json"
set "LB_DOC_TYPE=json"
set "LB_DOC_BYTES=387"
set "LB_DOC_SHA512=dd4d8cd9b519c3b0c1df41aa8544e76a990e903ca2926a659d4d6f184b43cc6cd2a675c3f9d842ae2564bb5be8fec71aeae5b8b4e99ad15250e21aa76a6737ab"
set "LB_REASON=%~dp0..\tools\REASON.cmd"
call "%LB_REASON%" codelen "%~f0" %1 %2
set "LB_RC=%errorlevel%"
if "%~1"=="" pause
exit /b %LB_RC%
rem ---- document ----
{
 "question": "How many bits does the untrained model 1 need for a held-out text?",
 "witness": {
  "manifest": "../weights/model1-untrained/exact/manifest.cmd",
  "tier": "exact",
  "pin": "2824a03df39ab370306ebf0f04f9d72afccb7a171f06997c58eddfac420e697e235b83ae32f9a89b5aa956c7aef785b0920aacbd6ea95eacb74fbb7eae3fb627"
 },
 "text": "07 | complete | See the core specification and v"
}