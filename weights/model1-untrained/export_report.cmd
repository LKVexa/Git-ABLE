@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): export_report.json. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to print the document, with /check to check its SHA-512, or with /extract FILE to write it out.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=export_report.json"
set "LB_DOC_TYPE=json"
set "LB_DOC_BYTES=3290"
set "LB_DOC_SHA512=adfa2f33ffe01a804fa898fea4448dd4e06fb5ca3e3ad1ee2d86a307b33d7ac374f54e2ec8a1d5c18a654c2e235a4c7dcbae359f3d99a30aefd247b786e821eb"
set "LB_SELF=%~f0"
set "LB_ARG=%~1"
set "LB_OUT=%~f2"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$n=[int]$env:LB_DOC_BYTES;$b=[IO.File]::ReadAllBytes($env:LB_SELF);$o=$b.Length-$n;$h=-join((New-Object Security.Cryptography.SHA512Managed).ComputeHash($b,$o,$n)|%%{$_.ToString('x2')});if($h -ne $env:LB_DOC_SHA512){[Console]::Error.WriteLine('LB-DOC/1: the SHA-512 of '+$env:LB_DOC+' differs from LB_DOC_SHA512');exit 1};if($env:LB_ARG -eq '/check'){'ok: '+$env:LB_DOC;exit 0};if($env:LB_ARG -eq '/extract'){$d=New-Object byte[] $n;[Array]::Copy($b,$o,$d,0,$n);[IO.File]::WriteAllBytes($env:LB_OUT,$d);'written: '+$env:LB_OUT;exit 0};[Console]::OutputEncoding=New-Object Text.UTF8Encoding $false;[Console]::Out.Write([Text.Encoding]::UTF8.GetString($b,$o,$n));exit 0"
set "LB_RC=%errorlevel%"
if "%LB_ARG%"=="" pause
exit /b %LB_RC%
rem ---- document ----
{
 "model": "KGD-IMQ-5DLLM-M1",
 "trained": false,
 "exact": {
  "set_sha512": "2824a03df39ab370306ebf0f04f9d72afccb7a171f06997c58eddfac420e697e235b83ae32f9a89b5aa956c7aef785b0920aacbd6ea95eacb74fbb7eae3fb627",
  "total_bytes": 54525494
 },
 "tier2": {
  "set_sha512": "555eb9eb9d0c1de18e04a22fc1517d66516c673d8116b14edba6076655883966d2ba27ca72f958c3da3bda0eb33ce9aced61128480f10f9c07881f2a2c157499",
  "total_bytes": 3797790
 },
 "kgd": [
  {
   "block": 0,
   "alpha": 0.04973510694105353,
   "c": 1.0010394542379546,
   "alpha_q16": 3259,
   "c_q16": 65604
  },
  {
   "block": 1,
   "alpha": 0.04973510694105353,
   "c": 1.0010394542379546,
   "alpha_q16": 3259,
   "c_q16": 65604
  },
  {
   "block": 2,
   "alpha": 0.04973510694105353,
   "c": 1.0010394542379546,
   "alpha_q16": 3259,
   "c_q16": 65604
  },
  {
   "block": 3,
   "alpha": 0.04973510694105353,
   "c": 1.0010394542379546,
   "alpha_q16": 3259,
   "c_q16": 65604
  }
 ],
 "matrix_errors": {
  "L00.qkvo": {
   "shape": [
    768,
    256
   ],
   "tier2_rel_err": 0.6017198701467981,
   "tier0_rank2_rel_err": 0.9940056803352052,
   "max_scale": 0.3933694596401619
  },
  "L00.up": {
   "shape": [
    1024,
    256
   ],
   "tier2_rel_err": 0.6006875843586281,
   "tier0_rank2_rel_err": 0.9945272679306014,
   "max_scale": 0.3392736570153121
  },
  "L00.down": {
   "shape": [
    256,
    1024
   ],
   "tier2_rel_err": 0.6017203389827378,
   "tier0_rank2_rel_err": 0.9948945142447685,
   "max_scale": 0.7106162445608062
  },
  "L01.qkvo": {
   "shape": [
    768,
    256
   ],
   "tier2_rel_err": 0.6008173333661575,
   "tier0_rank2_rel_err": 0.9941084883764586,
   "max_scale": 0.43497128245329997
  },
  "L01.up": {
   "shape": [
    1024,
    256
   ],
   "tier2_rel_err": 0.6019043033261307,
   "tier0_rank2_rel_err": 0.9945423568070775,
   "max_scale": 0.38469472044945163
  },
  "L01.down": {
   "shape": [
    256,
    1024
   ],
   "tier2_rel_err": 0.602072589967866,
   "tier0_rank2_rel_err": 0.994546079727761,
   "max_scale": 0.7748013536547225
  },
  "L02.qkvo": {
   "shape": [
    768,
    256
   ],
   "tier2_rel_err": 0.6017365454465351,
   "tier0_rank2_rel_err": 0.9939222965236242,
   "max_scale": 0.3910738945666683
  },
  "L02.up": {
   "shape": [
    1024,
    256
   ],
   "tier2_rel_err": 0.6017751569725264,
   "tier0_rank2_rel_err": 0.9943880895029928,
   "max_scale": 0.49732711128684176
  },
  "L02.down": {
   "shape": [
    256,
    1024
   ],
   "tier2_rel_err": 0.6016218933908551,
   "tier0_rank2_rel_err": 0.9943900554131168,
   "max_scale": 0.7578783119647427
  },
  "L03.qkvo": {
   "shape": [
    768,
    256
   ],
   "tier2_rel_err": 0.6017519777767292,
   "tier0_rank2_rel_err": 0.9937946212201164,
   "max_scale": 0.37428329177294406
  },
  "L03.up": {
   "shape": [
    1024,
    256
   ],
   "tier2_rel_err": 0.6016488005759931,
   "tier0_rank2_rel_err": 0.9946673707277016,
   "max_scale": 0.33602530682677656
  },
  "L03.down": {
   "shape": [
    256,
    1024
   ],
   "tier2_rel_err": 0.601699595021377,
   "tier0_rank2_rel_err": 0.9946630073177287,
   "max_scale": 0.7737620949408102
  },
  "emb": {
   "shape": [
    256,
    256
   ],
   "tier2_rel_err": 0.6010225815702535,
   "tier0_rank2_rel_err": 0.9904337636935719,
   "max_scale": 0.5228730888333564
  }
 }
}