@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): programs-made.json. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to print the document, with /check to check its SHA-512, or with /extract FILE to write it out.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=programs-made.json"
set "LB_DOC_TYPE=json"
set "LB_DOC_BYTES=5217"
set "LB_DOC_SHA512=3344f4ad2e08abfb0b13a3119b08063a25f83da3f1afbda04a4de06b5a58fa33acac16580925d8f797b2b6417ef68f3d83c55e93757602ebffaab2e5f133ec44"
set "LB_SELF=%~f0"
set "LB_ARG=%~1"
set "LB_OUT=%~f2"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$n=[int]$env:LB_DOC_BYTES;$b=[IO.File]::ReadAllBytes($env:LB_SELF);$o=$b.Length-$n;$h=-join((New-Object Security.Cryptography.SHA512Managed).ComputeHash($b,$o,$n)|%%{$_.ToString('x2')});if($h -ne $env:LB_DOC_SHA512){[Console]::Error.WriteLine('LB-DOC/1: the SHA-512 of '+$env:LB_DOC+' differs from LB_DOC_SHA512');exit 1};if($env:LB_ARG -eq '/check'){'ok: '+$env:LB_DOC;exit 0};if($env:LB_ARG -eq '/extract'){$d=New-Object byte[] $n;[Array]::Copy($b,$o,$d,0,$n);[IO.File]::WriteAllBytes($env:LB_OUT,$d);'written: '+$env:LB_OUT;exit 0};[Console]::OutputEncoding=New-Object Text.UTF8Encoding $false;[Console]::Out.Write([Text.Encoding]::UTF8.GetString($b,$o,$n));exit 0"
set "LB_RC=%errorlevel%"
if "%LB_ARG%"=="" pause
exit /b %LB_RC%
rem ---- document ----
{
 "accept_kgd_alpha_gate": {
  "alphas_q16": {
   "m1_l00": 3259,
   "m1_l01": 3259,
   "m1_l02": 3259,
   "m1_l03": 3259,
   "m2_all": 3277
  }
 },
 "reject_kgd_alpha_q16_step_above_half": {
  "alpha_q16": 32769
 },
 "accept_littlebit_block_sign": {
  "source": "model 1 exact set, L00.qkvo row 0, columns 0-255 (one g = 256 block)"
 },
 "accept_m1_exact_forward": {
  "reference_ce_engine_dense_forward": 5.59829033138504,
  "tolerance": 0.0001,
  "tokens": 96,
  "memory": 56689287,
  "steps": 384876099
 },
 "accept_m1_tier2_forward": {
  "reference_ce_engine_dense_forward": 5.547993202382652,
  "tolerance": 0.0001,
  "tokens": 96,
  "memory": 5961583,
  "steps": 334148395
 },
 "accept_m1_exact_decode": {
  "prompt": "LCUF-X/0.2 admits ",
  "new_bytes": 64
 },
 "accept_m2_tier1_forward": {
  "tokens": 8,
  "memory": 1061246692,
  "steps": 3506410743,
  "rows": 148
 },
 "accept_m2_tier0_forward": {
  "tokens": 8,
  "memory": 1061246692,
  "steps": 1855493367,
  "rows": 148
 },
 "accept_port_source_checks": {
  "expected": {
   "C2": [
    88630528,
    63438848,
    25191680
   ],
   "C3": {
    "logits_shape": [
     2,
     16,
     49152
    ],
    "scored_positions": 30,
    "loss": {
     "center": 10.905,
     "tolerance": 0.25
    },
    "finite": true
   },
   "C4": "max_abs_change 0.0"
  }
 },
 "accept_port_loop": {
  "expected_loop": {
   "steps_run": 151,
   "tokens_seen": 19328,
   "est_total_steps": 150,
   "loop_completed": true,
   "nonfinite_loss_steps": 101,
   "weights_finite_at_end": false
  }
 },
 "accept_rails_bayes_disease": {
  "source": "MacKay (2.12)-(2.18): P(disease | positive) = 0.95 x 0.01 / (0.95 x 0.01 + 0.05 x 0.99) = 19/118, printed as 0.16",
  "expected_independent_of_the_engine": true,
  "spec": {
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
 },
 "accept_rails_bayes_r3": {
  "source": "MacKay (1.18)-(1.23): the likelihood ratio of r = 011 is ((1-f)/f)^(2-1) = 9, so P(s = 1 | r) = 0.9",
  "expected_independent_of_the_engine": true,
  "spec": {
   "question": "Which source bit was sent, given r = 011 over a binary symmetric channel with f = 0.1? MacKay (1.18)-(1.23)",
   "hypotheses": [
    "s=0",
    "s=1"
   ],
   "prior": [
    0.5,
    0.5
   ],
   "evidence": [
    {
     "name": "r1=0",
     "tags": [
      "bit:1"
     ],
     "likelihood": [
      0.9,
      0.1
     ]
    },
    {
     "name": "r2=1",
     "tags": [
      "bit:2"
     ],
     "likelihood": [
      0.1,
      0.9
     ]
    },
    {
     "name": "r3=1",
     "tags": [
      "bit:3"
     ],
     "likelihood": [
      0.1,
      0.9
     ]
    }
   ]
  }
 },
 "accept_rails_bayes_oliver": {
  "source": "MacKay (3.24)-(3.27): likelihood ratios 1/(2 x 0.6) = 0.83 and 1/(2 x 0.01) = 50, with even prior odds",
  "expected_independent_of_the_engine": true
 },
 "accept_rails_admit_steps": {
  "source": "s3 = s1 + s2 and s5 differs from s3 by 0.001 in a new direction: both fail the independence gate; s4 fails the gain gate",
  "expected_independent_of_the_engine": true
 },
 "accept_rails_meanfield_certified": {
  "source": "exact and mean-field marginals computed independently at build time (Python enumeration of the 8 states)",
  "expected_independent_of_the_engine": true
 },
 "reject_rails_meanfield_uncertified": {
  "kappa": 1.25,
  "expected": "refused: no contraction certificate"
 },
 "accept_rails_witness_m1_abstains": {
  "expected": "the untrained model codes held-out text no better than 8 bits per byte, so it is not admitted and the layer abstains",
  "spec": {
   "question": "Which word continues the prompt?",
   "prompt": "Information theory and ",
   "candidates": [
    "inference",
    "qzxjvkwbp"
   ],
   "calibration": "ning result is claimed.\n\n\u001e\n# C005 resume\n\n- Last stage: W12.\n- S",
   "lambda": 1.0
  }
 },
 "accept_rails_witness_unigram": {
  "expected": "the unigram of the training text is admitted (it codes held-out text below 8 bits per byte) and prefers the English word; it ignores the prompt, so it is a positive control for the gate, not a reasoner",
  "data_sha512": "c17ea34319bad060391761fa490efc01bb51cefdfb44fc200fe90015e4c76942e1be8128dd7be260f3295335c218990c56ef67321fbb41279a1782ccd1787767"
 },
 "accept_rails_parity_m1": {
  "text_bytes": 48,
  "reference_ce_engine_dense_forward": 5.566601537285965,
  "expected": "three routes to the same cross-entropy agree within 1e-4; the Tier-2 route is a different model and is outvoted"
 },
 "reject_rails_parity_no_majority": {
  "expected": "refused: no two of the three routes agree"
 },
 "accept_rails_codelen_unigram": {
  "text_bytes": 48,
  "data_sha512": "c17ea34319bad060391761fa490efc01bb51cefdfb44fc200fe90015e4c76942e1be8128dd7be260f3295335c218990c56ef67321fbb41279a1782ccd1787767"
 }
}