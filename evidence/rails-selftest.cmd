@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): rails-selftest.json. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to print the document, with /check to check its SHA-512, or with /extract FILE to write it out.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=rails-selftest.json"
set "LB_DOC_TYPE=json"
set "LB_DOC_BYTES=4448"
set "LB_DOC_SHA512=13c07e34b6a1289194ea088404a59fd9c6e24e73e8de7aad531b50274120e9c28e8965cd4e2ba21f16935182c8d0349d7ef585b7fa21a20c9715f3d63478fa63"
set "LB_SELF=%~f0"
set "LB_ARG=%~1"
set "LB_OUT=%~f2"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$n=[int]$env:LB_DOC_BYTES;$b=[IO.File]::ReadAllBytes($env:LB_SELF);$o=$b.Length-$n;$h=-join((New-Object Security.Cryptography.SHA512Managed).ComputeHash($b,$o,$n)|%%{$_.ToString('x2')});if($h -ne $env:LB_DOC_SHA512){[Console]::Error.WriteLine('LB-DOC/1: the SHA-512 of '+$env:LB_DOC+' differs from LB_DOC_SHA512');exit 1};if($env:LB_ARG -eq '/check'){'ok: '+$env:LB_DOC;exit 0};if($env:LB_ARG -eq '/extract'){$d=New-Object byte[] $n;[Array]::Copy($b,$o,$d,0,$n);[IO.File]::WriteAllBytes($env:LB_OUT,$d);'written: '+$env:LB_OUT;exit 0};[Console]::OutputEncoding=New-Object Text.UTF8Encoding $false;[Console]::Out.Write([Text.Encoding]::UTF8.GetString($b,$o,$n));exit 0"
set "LB_RC=%errorlevel%"
if "%LB_ARG%"=="" pause
exit /b %LB_RC%
rem ---- document ----
{
 "framework": "RAILS-8S/1",
 "checks": [
  {
   "check": "P(disease | positive test)",
   "source": "MacKay (2.16)-(2.18)",
   "printed": "0.16",
   "expected": 0.16101694915254236,
   "computed": 0.1610169491525425,
   "tolerance": 1e-12,
   "ok": true
  },
  {
   "check": "the same test entered twice is not admitted (posterior unchanged)",
   "source": "8S independence gate on provenance",
   "printed": null,
   "expected": 1.0,
   "computed": 1.0,
   "tolerance": 0.0,
   "ok": true
  },
  {
   "check": "gates off: the duplicate is double-counted",
   "source": "retraction (by construction, not evidence)",
   "printed": null,
   "expected": 0.7847826086956522,
   "computed": 0.7847826086956523,
   "tolerance": 1e-12,
   "ok": true
  },
  {
   "check": "P(s = 1 | r = 011), f = 0.1",
   "source": "MacKay (1.18)-(1.23)",
   "printed": null,
   "expected": 0.9,
   "computed": 0.9,
   "tolerance": 1e-12,
   "ok": true
  },
  {
   "check": "likelihood ratio of r = 011",
   "source": "MacKay (1.23): ((1-f)/f)^(2-1) = 9",
   "printed": null,
   "expected": 9.0,
   "computed": 8.999999999999993,
   "tolerance": 1e-09,
   "ok": true
  },
  {
   "check": "bit error of R3 at f = 0.1 (Bayes risk of the MAP decoder)",
   "source": "MacKay (1.36): 3f^2 - 2f^3",
   "printed": null,
   "expected": 0.028000000000000004,
   "computed": 0.028000000000000004,
   "tolerance": 1e-12,
   "ok": true
  },
  {
   "check": "capacity of the BSC at f = 0.1",
   "source": "MacKay (1.35): 1 - H2(f)",
   "printed": null,
   "expected": 0.5310044064107188,
   "computed": 0.5310044064107189,
   "tolerance": 1e-12,
   "ok": true
  },
  {
   "check": "likelihood ratio for Oliver",
   "source": "MacKay (3.26)",
   "printed": "0.83",
   "expected": 0.8333333333333334,
   "computed": 0.8333333333333339,
   "tolerance": 1e-12,
   "ok": true
  },
  {
   "check": "likelihood ratio for a suspect of type AB",
   "source": "MacKay (3.27)",
   "printed": "50",
   "expected": 50.0,
   "computed": 50.000000000000014,
   "tolerance": 1e-09,
   "ok": true
  },
  {
   "check": "Laplace's rule with F_a = 3, F_b = 1",
   "source": "MacKay (3.16): (F_a + 1)/(F_a + F_b + 2)",
   "printed": null,
   "expected": 0.6666666666666666,
   "computed": 0.6666666666666666,
   "tolerance": 1e-15,
   "ok": true
  },
  {
   "check": "H G^T = 0 over F2",
   "source": "MacKay (1.26), (1.30)",
   "printed": null,
   "expected": 0.0,
   "computed": 0.0,
   "tolerance": 0.0,
   "ok": true
  },
  {
   "check": "single-bit errors corrected by syndrome decoding (16 codewords x 7 positions)",
   "source": "MacKay (1.25)-(1.34)",
   "printed": null,
   "expected": 112.0,
   "computed": 112.0,
   "tolerance": 0.0,
   "ok": true
  },
  {
   "check": "rank after the 8S admission of six steps",
   "source": "8S Theorem A: rank(C5) = rank(C4) + [eta_ind > 0]",
   "printed": null,
   "expected": 3.0,
   "computed": 3.0,
   "tolerance": 0.0,
   "ok": true
  },
  {
   "check": "eta_ind of a step in the span of admitted steps",
   "source": "8S independence gate",
   "printed": null,
   "expected": 0.0,
   "computed": 0.0,
   "tolerance": 1e-12,
   "ok": true
  },
  {
   "check": "arithmetic coding round trip (400 symbols)",
   "source": "MacKay chapter 6",
   "printed": null,
   "expected": 1.0,
   "computed": 1.0,
   "tolerance": 0.0,
   "ok": true
  },
  {
   "check": "coded length minus the quantised ideal length is at most 2 bits",
   "source": "MacKay chapter 6",
   "printed": null,
   "expected": 1.0,
   "computed": 1.0,
   "tolerance": 0.0,
   "ok": true
  },
  {
   "check": "exact marginal of claim A",
   "source": "complete enumeration (MacKay chapter 21)",
   "printed": null,
   "expected": 0.7482784821861647,
   "computed": 0.7482784821861646,
   "tolerance": 1e-12,
   "ok": true
  },
  {
   "check": "mean-field marginal of claim A",
   "source": "mean field (MacKay chapter 33), 8S gate layer",
   "printed": null,
   "expected": 0.759157110268757,
   "computed": 0.7591571102686129,
   "tolerance": 1e-09,
   "ok": true
  },
  {
   "check": "one deviating route is outvoted",
   "source": "R3 majority decoding, MacKay (1.18)-(1.23)",
   "printed": null,
   "expected": 1.0,
   "computed": 1.0,
   "tolerance": 0.0,
   "ok": true
  },
  {
   "check": "three disagreeing routes are refused",
   "source": "R3: no majority",
   "printed": null,
   "expected": 1.0,
   "computed": 1.0,
   "tolerance": 0.0,
   "ok": true
  }
 ],
 "all_pass": true
}