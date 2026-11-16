@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): accept_rails_bayes_disease.json. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to print the document, with /check to check its SHA-512, or with /extract FILE to write it out.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=accept_rails_bayes_disease.json"
set "LB_DOC_TYPE=json"
set "LB_DOC_BYTES=8967"
set "LB_DOC_SHA512=7a75d66483e48a605be2ae1ac4ca19ae5cd79985b2781179f55bd687e29365f1802db9d49fe98fe17efc402b01e6b02b14173c3bb7450a331e2ede39a3d6a649"
set "LB_SELF=%~f0"
set "LB_ARG=%~1"
set "LB_OUT=%~f2"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$n=[int]$env:LB_DOC_BYTES;$b=[IO.File]::ReadAllBytes($env:LB_SELF);$o=$b.Length-$n;$h=-join((New-Object Security.Cryptography.SHA512Managed).ComputeHash($b,$o,$n)|%%{$_.ToString('x2')});if($h -ne $env:LB_DOC_SHA512){[Console]::Error.WriteLine('LB-DOC/1: the SHA-512 of '+$env:LB_DOC+' differs from LB_DOC_SHA512');exit 1};if($env:LB_ARG -eq '/check'){'ok: '+$env:LB_DOC;exit 0};if($env:LB_ARG -eq '/extract'){$d=New-Object byte[] $n;[Array]::Copy($b,$o,$d,0,$n);[IO.File]::WriteAllBytes($env:LB_OUT,$d);'written: '+$env:LB_OUT;exit 0};[Console]::OutputEncoding=New-Object Text.UTF8Encoding $false;[Console]::Out.Write([Text.Encoding]::UTF8.GetString($b,$o,$n));exit 0"
set "LB_RC=%errorlevel%"
if "%LB_ARG%"=="" pause
exit /b %LB_RC%
rem ---- document ----
{
 "program": "kgd/accept_rails_bayes_disease.cmd",
 "source_sha512": "84a4d4b3a669a534afab618942be0c0ce3894b2b1f7856aa13de48f6503a82ba89ce87542fca62b2c78720739aa0ee368bfeb41f43fa7a619a212bdb8124220f",
 "file_sha512": "c18ecf115314b69863409689579d634a69f2f8edce023e08e4755db0ebd4950421feb77a72ea87101901b8516dd405b861dbec752565713e7671e04c256f8104",
 "runner": "lcufx\\LCUFX_KGD.cmd run --twice (tools\\KGD_ENGINE.cmd host)",
 "expected": "accept",
 "observed": "accept",
 "as_expected": true,
 "exit_code": 0,
 "seconds": 0.0,
 "output": {
  "status": "host_research_pass",
  "language": "LCUF-X/0.2+lkvexa.kgd_imq/0.2",
  "source_sha512": "84a4d4b3a669a534afab618942be0c0ce3894b2b1f7856aa13de48f6503a82ba89ce87542fca62b2c78720739aa0ee368bfeb41f43fa7a619a212bdb8124220f",
  "semantic_sha512": "be6e26c79c29f6232f07879d0bb0fbb4a3c4971be95be071c605e60a88ec78b1cafcca5f3991557aeed0645e85551dc38cdc2cbc942fa87a1fbe721c8f3e3909",
  "values": {
   "exp_jo": "{\"decision\": \"answer\", \"answer\": \"healthy\", \"posterior.disease\": {\"center\": 0.16101694915254236, \"tolerance\": 1e-12}, \"admitted\": [\"positive test\"], \"rejected\": [\"positive test, entered again\"], \"retraction.gates_off.posterior.disease\": {\"center\": 0.7847826086956522, \"tolerance\": 1e-12}}",
   "key": "posterior.disease",
   "printed": 0.16,
   "spec_jo": "{\"question\": \"Does Jo have the disease, given a positive test? MacKay (2.12)-(2.18)\", \"hypotheses\": [\"disease\", \"healthy\"], \"prior\": [0.01, 0.99], \"evidence\": [{\"name\": \"positive test\", \"tags\": [\"test:jo-1\"], \"likelihood\": [0.95, 0.05]}, {\"name\": \"positive test, entered again\", \"tags\": [\"test:jo-1\"], \"likelihood\": [0.95, 0.05]}], \"lambda\": 1.0}",
   "tol": 0.005,
   "report_jo": "{\"framework\": \"RAILS-8S/1\", \"op\": \"rails_bayes\", \"statement\": \"the most probable hypothesis is healthy, with posterior 0.8389830508474576\", \"decision\": \"answer\", \"answer\": \"healthy\", \"posterior\": {\"disease\": 0.1610169491525425, \"healthy\": 0.8389830508474576}, \"admitted\": [\"positive test\"], \"rejected\": [\"positive test, entered again\"], \"rail_I\": {\"question\": \"Does Jo have the disease, given a positive test? MacKay (2.12)-(2.18)\", \"hypotheses\": [\"disease\", \"healthy\"], \"evidence_items\": 2}, \"rail_II\": {\"status\": \"exact in logs\", \"rule\": \"log posterior = log prior + sum of the admitted log likelihoods - log Z\", \"log_prior\": [-4.605170185988091, -0.01005033585350145], \"log_posterior\": [-1.8262456452992235, -0.17556477433107487], \"log_evidence_nats\": -2.8302178350764176, \"entropy_prior_bits\": 0.08079313589591121, \"entropy_posterior_bits\": 0.636736878655829}, \"rail_III\": {\"rule\": \"admit evidence e iff eta_ind(e) >= eps_ind and gain_bits(e) > eps_gain_bits; eta_ind is computed on the provenance tags; gain_bits = KL(posterior with e || posterior without e)\", \"eps_ind\": 0.5, \"eps_gain_bits\": 0.0, \"rank\": 1, \"items\": [{\"name\": \"positive test\", \"tags\": [\"test:jo-1\"], \"eta_ind\": 0.9999999999989999, \"gain_bits\": 0.44520146884871564, \"admitted\": true, \"reason\": \"admitted\", \"log_evidence_nats\": -2.8302178350764176}, {\"name\": \"positive test, entered again\", \"tags\": [\"test:jo-1\"], \"eta_ind\": 0.0, \"gain_bits\": 1.3708526339677578, \"admitted\": false, \"reason\": \"not independent: its provenance lies in the span of admitted evidence\", \"log_evidence_nats\": -1.6351904085365145}]}, \"rail_IV\": {\"status\": \"structural analogue\", \"rule\": \"answer the most probable hypothesis only if its posterior exceeds lambda/(1+lambda); otherwise abstain\", \"lambda\": 1.0, \"threshold\": 0.5, \"posterior_max\": 0.8389830508474576, \"margin_log_odds\": 1.6506808709681486, \"flip_factor\": 5.210526315789469, \"threshold_margin_log_odds\": 1.6506808709681493, \"reason\": \"the posterior of the best hypothesis is above lambda/(1+lambda)\"}, \"retraction\": {\"gates_off\": {\"posterior\": {\"disease\": 0.7847826086956523, \"healthy\": 0.21521739130434756}, \"answer\": \"disease\"}, \"by_construction\": true, \"counts_as_evidence\": false, \"note\": \"every item admitted, whatever its provenance or gain: the plain product of all likelihoods\"}}",
   "p_disease": 0.1610169491525425
  },
  "admission": {
   "reserved_work": {
    "s": 20
   },
   "retained_payload_bytes": {
    "s": 4771
   },
   "peak_modeled_scratch_bytes": {
    "s": 96
   },
   "minimum_row_work": {
    "c_spec_jo": 1,
    "jo": 11,
    "c_exp_jo": 1,
    "chk_jo": 1,
    "out_jo": 1,
    "c_key": 1,
    "p": 1,
    "c_printed": 1,
    "c_tol": 1,
    "chk_printed": 1
   }
  },
  "row_order": [
   "c_exp_jo",
   "c_key",
   "c_printed",
   "c_spec_jo",
   "c_tol",
   "jo",
   "chk_jo",
   "out_jo",
   "p",
   "chk_printed"
  ],
  "receipts": [
   {
    "scope": "LCUF_X_KGD_HOST_RESEARCH",
    "row": "jo",
    "site": "s",
    "profile": "lkvexa.rails8s",
    "semantic_sha512": "be6e26c79c29f6232f07879d0bb0fbb4a3c4971be95be071c605e60a88ec78b1cafcca5f3991557aeed0645e85551dc38cdc2cbc942fa87a1fbe721c8f3e3909",
    "previous_sha512": "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
    "result_sha512": "e3c1e0d799fbdda9c6e5f7f44057714cc2201be942fe2e7adb21613d4689b83e8bd1c0fb069c892c3e4ad8782c9b9c8ec15e6c012da887c9f0ecada1651e1edc",
    "sha512": "c39f8c34c3f1bf3e5a1ff335cb43681c5ccbf76af76e9df36582dbe28913cbd3be960bdeddbede40477b3a0e605eab7ba791b89bc40ce8379346af3025b32ee9"
   },
   {
    "scope": "LCUF_X_KGD_HOST_RESEARCH",
    "row": "out_jo",
    "site": "s",
    "profile": "lcuf.evidence",
    "semantic_sha512": "be6e26c79c29f6232f07879d0bb0fbb4a3c4971be95be071c605e60a88ec78b1cafcca5f3991557aeed0645e85551dc38cdc2cbc942fa87a1fbe721c8f3e3909",
    "previous_sha512": "c39f8c34c3f1bf3e5a1ff335cb43681c5ccbf76af76e9df36582dbe28913cbd3be960bdeddbede40477b3a0e605eab7ba791b89bc40ce8379346af3025b32ee9",
    "result_sha512": "e3c1e0d799fbdda9c6e5f7f44057714cc2201be942fe2e7adb21613d4689b83e8bd1c0fb069c892c3e4ad8782c9b9c8ec15e6c012da887c9f0ecada1651e1edc",
    "value": "{\"framework\": \"RAILS-8S/1\", \"op\": \"rails_bayes\", \"statement\": \"the most probable hypothesis is healthy, with posterior 0.8389830508474576\", \"decision\": \"answer\", \"answer\": \"healthy\", \"posterior\": {\"disease\": 0.1610169491525425, \"healthy\": 0.8389830508474576}, \"admitted\": [\"positive test\"], \"rejected\": [\"positive test, entered again\"], \"rail_I\": {\"question\": \"Does Jo have the disease, given a positive test? MacKay (2.12)-(2.18)\", \"hypotheses\": [\"disease\", \"healthy\"], \"evidence_items\": 2}, \"rail_II\": {\"status\": \"exact in logs\", \"rule\": \"log posterior = log prior + sum of the admitted log likelihoods - log Z\", \"log_prior\": [-4.605170185988091, -0.01005033585350145], \"log_posterior\": [-1.8262456452992235, -0.17556477433107487], \"log_evidence_nats\": -2.8302178350764176, \"entropy_prior_bits\": 0.08079313589591121, \"entropy_posterior_bits\": 0.636736878655829}, \"rail_III\": {\"rule\": \"admit evidence e iff eta_ind(e) >= eps_ind and gain_bits(e) > eps_gain_bits; eta_ind is computed on the provenance tags; gain_bits = KL(posterior with e || posterior without e)\", \"eps_ind\": 0.5, \"eps_gain_bits\": 0.0, \"rank\": 1, \"items\": [{\"name\": \"positive test\", \"tags\": [\"test:jo-1\"], \"eta_ind\": 0.9999999999989999, \"gain_bits\": 0.44520146884871564, \"admitted\": true, \"reason\": \"admitted\", \"log_evidence_nats\": -2.8302178350764176}, {\"name\": \"positive test, entered again\", \"tags\": [\"test:jo-1\"], \"eta_ind\": 0.0, \"gain_bits\": 1.3708526339677578, \"admitted\": false, \"reason\": \"not independent: its provenance lies in the span of admitted evidence\", \"log_evidence_nats\": -1.6351904085365145}]}, \"rail_IV\": {\"status\": \"structural analogue\", \"rule\": \"answer the most probable hypothesis only if its posterior exceeds lambda/(1+lambda); otherwise abstain\", \"lambda\": 1.0, \"threshold\": 0.5, \"posterior_max\": 0.8389830508474576, \"margin_log_odds\": 1.6506808709681486, \"flip_factor\": 5.210526315789469, \"threshold_margin_log_odds\": 1.6506808709681493, \"reason\": \"the posterior of the best hypothesis is above lambda/(1+lambda)\"}, \"retraction\": {\"gates_off\": {\"posterior\": {\"disease\": 0.7847826086956523, \"healthy\": 0.21521739130434756}, \"answer\": \"disease\"}, \"by_construction\": true, \"counts_as_evidence\": false, \"note\": \"every item admitted, whatever its provenance or gain: the plain product of all likelihoods\"}}",
    "sha512": "a9af4f901eee26a48029cfbcfeb31ec4ad84abf1fb0fad41983f2e467c9283724d0b36b9ae93e86dc45ac75a131d98d02d21446cab434da553a6f2f910d382c3"
   }
  ],
  "receipt_chain_head": "a9af4f901eee26a48029cfbcfeb31ec4ad84abf1fb0fad41983f2e467c9283724d0b36b9ae93e86dc45ac75a131d98d02d21446cab434da553a6f2f910d382c3",
  "evaluated_twice": true,
  "native_cmd_execution": false
 }
}