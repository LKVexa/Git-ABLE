@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): accept_rails_bayes_r3.json. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to print the document, with /check to check its SHA-512, or with /extract FILE to write it out.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=accept_rails_bayes_r3.json"
set "LB_DOC_TYPE=json"
set "LB_DOC_BYTES=8684"
set "LB_DOC_SHA512=37c47a94df40ba64a13214c6c87127edf2329aa3a33f45a160af9867b8cf2f2ce6dc74dc22c93b02d532e2ed62f0ef1baf97494c603268435f7597817ae46be4"
set "LB_SELF=%~f0"
set "LB_ARG=%~1"
set "LB_OUT=%~f2"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$n=[int]$env:LB_DOC_BYTES;$b=[IO.File]::ReadAllBytes($env:LB_SELF);$o=$b.Length-$n;$h=-join((New-Object Security.Cryptography.SHA512Managed).ComputeHash($b,$o,$n)|%%{$_.ToString('x2')});if($h -ne $env:LB_DOC_SHA512){[Console]::Error.WriteLine('LB-DOC/1: the SHA-512 of '+$env:LB_DOC+' differs from LB_DOC_SHA512');exit 1};if($env:LB_ARG -eq '/check'){'ok: '+$env:LB_DOC;exit 0};if($env:LB_ARG -eq '/extract'){$d=New-Object byte[] $n;[Array]::Copy($b,$o,$d,0,$n);[IO.File]::WriteAllBytes($env:LB_OUT,$d);'written: '+$env:LB_OUT;exit 0};[Console]::OutputEncoding=New-Object Text.UTF8Encoding $false;[Console]::Out.Write([Text.Encoding]::UTF8.GetString($b,$o,$n));exit 0"
set "LB_RC=%errorlevel%"
if "%LB_ARG%"=="" pause
exit /b %LB_RC%
rem ---- document ----
{
 "program": "kgd/accept_rails_bayes_r3.cmd",
 "source_sha512": "d9ef0998c12fa093219204f8c3385967703fffbaea54f00effaf1b911e42c41120ebab9161d63e67903a4ef494e6557cd484b6b71d23245eab85587f96976670",
 "file_sha512": "623d3e1ae8e71dd4f3acb49432c950c1b1291b32917624d4ab1647c4ed4e0692e71fc8647d4e76b29736d9980c24f9cc633a74215f0862a9c07461eb793c7948",
 "runner": "lcufx\\LCUFX_KGD.cmd run --twice (tools\\KGD_ENGINE.cmd host)",
 "expected": "accept",
 "observed": "accept",
 "as_expected": true,
 "exit_code": 0,
 "seconds": 0.0,
 "output": {
  "status": "host_research_pass",
  "language": "LCUF-X/0.2+lkvexa.kgd_imq/0.2",
  "source_sha512": "d9ef0998c12fa093219204f8c3385967703fffbaea54f00effaf1b911e42c41120ebab9161d63e67903a4ef494e6557cd484b6b71d23245eab85587f96976670",
  "semantic_sha512": "89b0c3ac948f4f4f1f655a9709abefc3f67170e71a88f4a19dc9874957733769b904298c287fecbe497c853b3cecf28e5ddcb2bdd0ce76db8d04ee70c3ee3d6b",
  "values": {
   "exp_r3": "{\"decision\": \"answer\", \"answer\": \"s=1\", \"posterior.s=1\": {\"center\": 0.9, \"tolerance\": 1e-12}, \"rail_IV.margin_log_odds\": {\"center\": 2.1972245773362196, \"tolerance\": 1e-12}, \"rail_III.rank\": 3}",
   "spec_r3": "{\"question\": \"Which source bit was sent, given r = 011 over a binary symmetric channel with f = 0.1? MacKay (1.18)-(1.23)\", \"hypotheses\": [\"s=0\", \"s=1\"], \"prior\": [0.5, 0.5], \"evidence\": [{\"name\": \"r1=0\", \"tags\": [\"bit:1\"], \"likelihood\": [0.9, 0.1]}, {\"name\": \"r2=1\", \"tags\": [\"bit:2\"], \"likelihood\": [0.1, 0.9]}, {\"name\": \"r3=1\", \"tags\": [\"bit:3\"], \"likelihood\": [0.1, 0.9]}]}",
   "report_r3": "{\"framework\": \"RAILS-8S/1\", \"op\": \"rails_bayes\", \"statement\": \"the most probable hypothesis is s=1, with posterior 0.9\", \"decision\": \"answer\", \"answer\": \"s=1\", \"posterior\": {\"s=0\": 0.10000000000000006, \"s=1\": 0.9}, \"admitted\": [\"r1=0\", \"r2=1\", \"r3=1\"], \"rejected\": [], \"rail_I\": {\"question\": \"Which source bit was sent, given r = 011 over a binary symmetric channel with f = 0.1? MacKay (1.18)-(1.23)\", \"hypotheses\": [\"s=0\", \"s=1\"], \"evidence_items\": 3}, \"rail_II\": {\"status\": \"exact in logs\", \"rule\": \"log posterior = log prior + sum of the admitted log likelihoods - log Z\", \"log_prior\": [-0.6931471805599453, -0.6931471805599453], \"log_posterior\": [-2.302585092994045, -0.10536051565782634], \"log_evidence_nats\": -3.101092789211817, \"entropy_prior_bits\": 1.0, \"entropy_posterior_bits\": 0.46899559358928133}, \"rail_III\": {\"rule\": \"admit evidence e iff eta_ind(e) >= eps_ind and gain_bits(e) > eps_gain_bits; eta_ind is computed on the provenance tags; gain_bits = KL(posterior with e || posterior without e)\", \"eps_ind\": 0.5, \"eps_gain_bits\": 0.0, \"rank\": 3, \"items\": [{\"name\": \"r1=0\", \"tags\": [\"bit:1\"], \"eta_ind\": 0.9999999999989999, \"gain_bits\": 0.5310044064107189, \"admitted\": true, \"reason\": \"admitted\", \"log_evidence_nats\": -0.6931471805599452}, {\"name\": \"r2=1\", \"tags\": [\"bit:2\"], \"eta_ind\": 0.9999999999989999, \"gain_bits\": 0.7369655941662062, \"admitted\": true, \"reason\": \"admitted\", \"log_evidence_nats\": -1.7147984280919268}, {\"name\": \"r3=1\", \"tags\": [\"bit:3\"], \"eta_ind\": 0.9999999999989999, \"gain_bits\": 0.5310044064107188, \"admitted\": true, \"reason\": \"admitted\", \"log_evidence_nats\": -0.6931471805599454}]}, \"rail_IV\": {\"status\": \"structural analogue\", \"rule\": \"answer the most probable hypothesis only if its posterior exceeds lambda/(1+lambda); otherwise abstain\", \"lambda\": 1.0, \"threshold\": 0.5, \"posterior_max\": 0.9, \"margin_log_odds\": 2.1972245773362187, \"flip_factor\": 8.999999999999993, \"threshold_margin_log_odds\": 2.1972245773362196, \"reason\": \"the posterior of the best hypothesis is above lambda/(1+lambda)\"}, \"retraction\": {\"gates_off\": {\"posterior\": {\"s=0\": 0.10000000000000006, \"s=1\": 0.9}, \"answer\": \"s=1\"}, \"by_construction\": true, \"counts_as_evidence\": false, \"note\": \"every item admitted, whatever its provenance or gain: the plain product of all likelihoods\"}}"
  },
  "admission": {
   "reserved_work": {
    "s": 40
   },
   "retained_payload_bytes": {
    "s": 4665
   },
   "peak_modeled_scratch_bytes": {
    "s": 152
   },
   "minimum_row_work": {
    "c_spec_r3": 1,
    "r3": 36,
    "c_exp_r3": 1,
    "chk_r3": 1,
    "out_r3": 1
   }
  },
  "row_order": [
   "c_exp_r3",
   "c_spec_r3",
   "r3",
   "chk_r3",
   "out_r3"
  ],
  "receipts": [
   {
    "scope": "LCUF_X_KGD_HOST_RESEARCH",
    "row": "r3",
    "site": "s",
    "profile": "lkvexa.rails8s",
    "semantic_sha512": "89b0c3ac948f4f4f1f655a9709abefc3f67170e71a88f4a19dc9874957733769b904298c287fecbe497c853b3cecf28e5ddcb2bdd0ce76db8d04ee70c3ee3d6b",
    "previous_sha512": "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
    "result_sha512": "7127e3ad57b0b6f8154129496f8864e3300f0bbc8fdf013f2388b5d60f3b7db3d1eb351e66138b638a7cd21667094b7651ccf659a23e02814615ebd9357b8b85",
    "sha512": "21d292e271b7f921d5f96ccdd245ca2e434451d06ee7476cdd256d3c01e9118ffd29ef800a2299b942bea9ad4775b5c87baabae96ea7ac3f6b7deea97fddc6de"
   },
   {
    "scope": "LCUF_X_KGD_HOST_RESEARCH",
    "row": "out_r3",
    "site": "s",
    "profile": "lcuf.evidence",
    "semantic_sha512": "89b0c3ac948f4f4f1f655a9709abefc3f67170e71a88f4a19dc9874957733769b904298c287fecbe497c853b3cecf28e5ddcb2bdd0ce76db8d04ee70c3ee3d6b",
    "previous_sha512": "21d292e271b7f921d5f96ccdd245ca2e434451d06ee7476cdd256d3c01e9118ffd29ef800a2299b942bea9ad4775b5c87baabae96ea7ac3f6b7deea97fddc6de",
    "result_sha512": "7127e3ad57b0b6f8154129496f8864e3300f0bbc8fdf013f2388b5d60f3b7db3d1eb351e66138b638a7cd21667094b7651ccf659a23e02814615ebd9357b8b85",
    "value": "{\"framework\": \"RAILS-8S/1\", \"op\": \"rails_bayes\", \"statement\": \"the most probable hypothesis is s=1, with posterior 0.9\", \"decision\": \"answer\", \"answer\": \"s=1\", \"posterior\": {\"s=0\": 0.10000000000000006, \"s=1\": 0.9}, \"admitted\": [\"r1=0\", \"r2=1\", \"r3=1\"], \"rejected\": [], \"rail_I\": {\"question\": \"Which source bit was sent, given r = 011 over a binary symmetric channel with f = 0.1? MacKay (1.18)-(1.23)\", \"hypotheses\": [\"s=0\", \"s=1\"], \"evidence_items\": 3}, \"rail_II\": {\"status\": \"exact in logs\", \"rule\": \"log posterior = log prior + sum of the admitted log likelihoods - log Z\", \"log_prior\": [-0.6931471805599453, -0.6931471805599453], \"log_posterior\": [-2.302585092994045, -0.10536051565782634], \"log_evidence_nats\": -3.101092789211817, \"entropy_prior_bits\": 1.0, \"entropy_posterior_bits\": 0.46899559358928133}, \"rail_III\": {\"rule\": \"admit evidence e iff eta_ind(e) >= eps_ind and gain_bits(e) > eps_gain_bits; eta_ind is computed on the provenance tags; gain_bits = KL(posterior with e || posterior without e)\", \"eps_ind\": 0.5, \"eps_gain_bits\": 0.0, \"rank\": 3, \"items\": [{\"name\": \"r1=0\", \"tags\": [\"bit:1\"], \"eta_ind\": 0.9999999999989999, \"gain_bits\": 0.5310044064107189, \"admitted\": true, \"reason\": \"admitted\", \"log_evidence_nats\": -0.6931471805599452}, {\"name\": \"r2=1\", \"tags\": [\"bit:2\"], \"eta_ind\": 0.9999999999989999, \"gain_bits\": 0.7369655941662062, \"admitted\": true, \"reason\": \"admitted\", \"log_evidence_nats\": -1.7147984280919268}, {\"name\": \"r3=1\", \"tags\": [\"bit:3\"], \"eta_ind\": 0.9999999999989999, \"gain_bits\": 0.5310044064107188, \"admitted\": true, \"reason\": \"admitted\", \"log_evidence_nats\": -0.6931471805599454}]}, \"rail_IV\": {\"status\": \"structural analogue\", \"rule\": \"answer the most probable hypothesis only if its posterior exceeds lambda/(1+lambda); otherwise abstain\", \"lambda\": 1.0, \"threshold\": 0.5, \"posterior_max\": 0.9, \"margin_log_odds\": 2.1972245773362187, \"flip_factor\": 8.999999999999993, \"threshold_margin_log_odds\": 2.1972245773362196, \"reason\": \"the posterior of the best hypothesis is above lambda/(1+lambda)\"}, \"retraction\": {\"gates_off\": {\"posterior\": {\"s=0\": 0.10000000000000006, \"s=1\": 0.9}, \"answer\": \"s=1\"}, \"by_construction\": true, \"counts_as_evidence\": false, \"note\": \"every item admitted, whatever its provenance or gain: the plain product of all likelihoods\"}}",
    "sha512": "3d476bd4c0806fed97389801189575f1acc52024c9231278fc8f7979e63086fab91a87abc4f4a18e13b779c78de1bea89b581856867c4c40fa1640d5aacd7972"
   }
  ],
  "receipt_chain_head": "3d476bd4c0806fed97389801189575f1acc52024c9231278fc8f7979e63086fab91a87abc4f4a18e13b779c78de1bea89b581856867c4c40fa1640d5aacd7972",
  "evaluated_twice": true,
  "native_cmd_execution": false
 }
}