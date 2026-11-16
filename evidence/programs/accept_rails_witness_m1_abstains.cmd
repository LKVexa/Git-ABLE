@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): accept_rails_witness_m1_abstains.json. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to print the document, with /check to check its SHA-512, or with /extract FILE to write it out.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=accept_rails_witness_m1_abstains.json"
set "LB_DOC_TYPE=json"
set "LB_DOC_BYTES=9273"
set "LB_DOC_SHA512=082bf9ad50b5ffe75687ca18e3ee8eb2c95a2f2553572cbc43a242a5336c79a601437f3344c7406a373a1be3b1f9378ce061da38e04931e372f54f74cb426d02"
set "LB_SELF=%~f0"
set "LB_ARG=%~1"
set "LB_OUT=%~f2"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$n=[int]$env:LB_DOC_BYTES;$b=[IO.File]::ReadAllBytes($env:LB_SELF);$o=$b.Length-$n;$h=-join((New-Object Security.Cryptography.SHA512Managed).ComputeHash($b,$o,$n)|%%{$_.ToString('x2')});if($h -ne $env:LB_DOC_SHA512){[Console]::Error.WriteLine('LB-DOC/1: the SHA-512 of '+$env:LB_DOC+' differs from LB_DOC_SHA512');exit 1};if($env:LB_ARG -eq '/check'){'ok: '+$env:LB_DOC;exit 0};if($env:LB_ARG -eq '/extract'){$d=New-Object byte[] $n;[Array]::Copy($b,$o,$d,0,$n);[IO.File]::WriteAllBytes($env:LB_OUT,$d);'written: '+$env:LB_OUT;exit 0};[Console]::OutputEncoding=New-Object Text.UTF8Encoding $false;[Console]::Out.Write([Text.Encoding]::UTF8.GetString($b,$o,$n));exit 0"
set "LB_RC=%errorlevel%"
if "%LB_ARG%"=="" pause
exit /b %LB_RC%
rem ---- document ----
{
 "program": "kgd/accept_rails_witness_m1_abstains.cmd",
 "source_sha512": "5c2bfd204fba17262f3db264f3469055b7bcdccf2e28fe544279da2ef6b2770e3012cd8ee23c6e37b9f7cd6d78b93963330c6f84d98199f3e4e2035ddaf6907a",
 "file_sha512": "ad677525eecc0ed91b4ab23f6303c627eeffb9347f84b60c2a7d050d9b647e256c7aae4ccad4b971bc2be4f5b14eb160bd668e170e921496ee09ae00fa82a58b",
 "runner": "lcufx\\LCUFX_KGD.cmd run --twice (tools\\KGD_ENGINE.cmd host)",
 "expected": "accept",
 "observed": "accept",
 "as_expected": true,
 "exit_code": 0,
 "seconds": 1.5,
 "output": {
  "status": "host_research_pass",
  "language": "LCUF-X/0.2+lkvexa.kgd_imq/0.2",
  "source_sha512": "5c2bfd204fba17262f3db264f3469055b7bcdccf2e28fe544279da2ef6b2770e3012cd8ee23c6e37b9f7cd6d78b93963330c6f84d98199f3e4e2035ddaf6907a",
  "semantic_sha512": "b7b338f6f7396e0bc82ae9c7bebf39adbbe4ad6a922214f0c8504dcd83a38ee3f675d09cb78cc7fb602ac7e8e266db540512378b9b383aed508c14c44a55b5c9",
  "values": {
   "exp_wq": "{\"rail_III.admitted\": false, \"decision\": \"abstain\", \"answer\": null}",
   "path": "../../../weights/model1-untrained/exact/manifest.cmd",
   "pin": "2824a03df39ab370306ebf0f04f9d72afccb7a171f06997c58eddfac420e697e235b83ae32f9a89b5aa956c7aef785b0920aacbd6ea95eacb74fbb7eae3fb627",
   "spec_wq": "{\"question\": \"Which word continues the prompt?\", \"prompt\": \"Information theory and \", \"candidates\": [\"inference\", \"qzxjvkwbp\"], \"calibration\": \"ning result is claimed.\\n\\n\\u001e\\n# C005 resume\\n\\n- Last stage: W12.\\n- S\", \"lambda\": 1.0}",
   "tier": "exact",
   "report_wq": "{\"framework\": \"RAILS-8S/1\", \"op\": \"rails_witness\", \"statement\": \"abstain: the witness was not admitted, so the decision rests on the prior alone; the two most probable hypotheses are tied\", \"decision\": \"abstain\", \"answer\": null, \"posterior\": {\"inference\": 0.5, \"qzxjvkwbp\": 0.5}, \"witness\": {\"kind\": \"weights\", \"tier\": \"EXACT-BF16\", \"set_sha512\": \"2824a03df39ab370306ebf0f04f9d72afccb7a171f06997c58eddfac420e697e235b83ae32f9a89b5aa956c7aef785b0920aacbd6ea95eacb74fbb7eae3fb627\", \"vocab\": 256, \"seq_len\": 128}, \"rail_I\": {\"prompt\": \"Information theory and \", \"candidates\": [\"inference\", \"qzxjvkwbp\"], \"calibration_bytes\": 64}, \"rail_II\": {\"status\": \"exact in logs\", \"rule\": \"log P(candidate | prompt) = sum over its bytes of log p(byte | everything before it), teacher-forced (complete enumeration over the candidates)\", \"candidate_log_likelihood_nats\": {\"inference\": -54.33079006583552, \"qzxjvkwbp\": -51.85575126874746}, \"candidate_code_bits\": {\"inference\": 78.38276139556027, \"qzxjvkwbp\": 74.81203519699353}, \"calibration_bits\": 518.9117986527069, \"calibration_bits_per_byte\": 8.107996853948546}, \"rail_III\": {\"rule\": \"admit the witness iff it codes the calibration text in fewer bits than the uniform byte code by more than eps_gain_bits (evidence ratio > 1, MacKay chapter 28)\", \"baseline_bits\": 512.0, \"gain_bits\": -6.911798652706921, \"eps_gain_bits\": 0.0, \"admitted\": false, \"reason\": \"the witness predicts the calibration text no better than chance\"}, \"rail_IV\": {\"status\": \"structural analogue\", \"rule\": \"answer the most probable hypothesis only if its posterior exceeds lambda/(1+lambda); otherwise abstain\", \"lambda\": 1.0, \"threshold\": 0.5, \"posterior_max\": 0.5, \"margin_log_odds\": 0.0, \"flip_factor\": 1.0, \"threshold_margin_log_odds\": 0.0, \"reason\": \"the witness was not admitted, so the decision rests on the prior alone; the two most probable hypotheses are tied\", \"equal_lengths\": true, \"length_normalised_ranking_agrees\": true}, \"retraction\": {\"gates_off\": {\"posterior\": {\"inference\": 0.07762668460910498, \"qzxjvkwbp\": 0.9223733153908929}, \"answer\": \"qzxjvkwbp\"}, \"by_construction\": true, \"counts_as_evidence\": false, \"note\": \"witness admitted whatever its gain: the posterior an ungated system would report\"}}"
  },
  "admission": {
   "reserved_work": {
    "s": 432012861
   },
   "retained_payload_bytes": {
    "s": 54530078
   },
   "peak_modeled_scratch_bytes": {
    "s": 131072
   },
   "minimum_row_work": {
    "c_path": 1,
    "c_pin": 1,
    "c_tier": 1,
    "w": 54525494,
    "c_spec_wq": 1,
    "wq": 377487360,
    "c_exp_wq": 1,
    "chk_wq": 1,
    "out_wq": 1
   }
  },
  "row_order": [
   "c_exp_wq",
   "c_path",
   "c_pin",
   "c_spec_wq",
   "c_tier",
   "w",
   "wq",
   "chk_wq",
   "out_wq"
  ],
  "receipts": [
   {
    "scope": "LCUF_X_KGD_HOST_RESEARCH",
    "row": "w",
    "site": "s",
    "profile": "lkvexa.weights.cmd",
    "semantic_sha512": "b7b338f6f7396e0bc82ae9c7bebf39adbbe4ad6a922214f0c8504dcd83a38ee3f675d09cb78cc7fb602ac7e8e266db540512378b9b383aed508c14c44a55b5c9",
    "previous_sha512": "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
    "result_sha512": "2824a03df39ab370306ebf0f04f9d72afccb7a171f06997c58eddfac420e697e235b83ae32f9a89b5aa956c7aef785b0920aacbd6ea95eacb74fbb7eae3fb627",
    "sha512": "5440f0340b323c7dbe90e71718d03fc72dcab2d5b43ba10ddc9145139f225dc1b7e4e650f303097dcb15aef9fec745f50118942b13a8338e895c901b4e538684"
   },
   {
    "scope": "LCUF_X_KGD_HOST_RESEARCH",
    "row": "wq",
    "site": "s",
    "profile": "lkvexa.rails8s",
    "semantic_sha512": "b7b338f6f7396e0bc82ae9c7bebf39adbbe4ad6a922214f0c8504dcd83a38ee3f675d09cb78cc7fb602ac7e8e266db540512378b9b383aed508c14c44a55b5c9",
    "previous_sha512": "5440f0340b323c7dbe90e71718d03fc72dcab2d5b43ba10ddc9145139f225dc1b7e4e650f303097dcb15aef9fec745f50118942b13a8338e895c901b4e538684",
    "result_sha512": "d42b4ebe0f134ca5591e0bc4e4da641e82fe14163edb9d95dece64a2cad4f9079e5c42c91e178880956bae70cebccad6a1058da9db9be08c1c26a896f571595b",
    "sha512": "74a4ac20c3d6aa3e94186c5e5b8275da3d3f08d99c5e4a90b8cf6f540e33254a05286f4d093447c6997baacf2dc7479eb9a7a07f18d2be8755e4ddf642244976"
   },
   {
    "scope": "LCUF_X_KGD_HOST_RESEARCH",
    "row": "out_wq",
    "site": "s",
    "profile": "lcuf.evidence",
    "semantic_sha512": "b7b338f6f7396e0bc82ae9c7bebf39adbbe4ad6a922214f0c8504dcd83a38ee3f675d09cb78cc7fb602ac7e8e266db540512378b9b383aed508c14c44a55b5c9",
    "previous_sha512": "74a4ac20c3d6aa3e94186c5e5b8275da3d3f08d99c5e4a90b8cf6f540e33254a05286f4d093447c6997baacf2dc7479eb9a7a07f18d2be8755e4ddf642244976",
    "result_sha512": "d42b4ebe0f134ca5591e0bc4e4da641e82fe14163edb9d95dece64a2cad4f9079e5c42c91e178880956bae70cebccad6a1058da9db9be08c1c26a896f571595b",
    "value": "{\"framework\": \"RAILS-8S/1\", \"op\": \"rails_witness\", \"statement\": \"abstain: the witness was not admitted, so the decision rests on the prior alone; the two most probable hypotheses are tied\", \"decision\": \"abstain\", \"answer\": null, \"posterior\": {\"inference\": 0.5, \"qzxjvkwbp\": 0.5}, \"witness\": {\"kind\": \"weights\", \"tier\": \"EXACT-BF16\", \"set_sha512\": \"2824a03df39ab370306ebf0f04f9d72afccb7a171f06997c58eddfac420e697e235b83ae32f9a89b5aa956c7aef785b0920aacbd6ea95eacb74fbb7eae3fb627\", \"vocab\": 256, \"seq_len\": 128}, \"rail_I\": {\"prompt\": \"Information theory and \", \"candidates\": [\"inference\", \"qzxjvkwbp\"], \"calibration_bytes\": 64}, \"rail_II\": {\"status\": \"exact in logs\", \"rule\": \"log P(candidate | prompt) = sum over its bytes of log p(byte | everything before it), teacher-forced (complete enumeration over the candidates)\", \"candidate_log_likelihood_nats\": {\"inference\": -54.33079006583552, \"qzxjvkwbp\": -51.85575126874746}, \"candidate_code_bits\": {\"inference\": 78.38276139556027, \"qzxjvkwbp\": 74.81203519699353}, \"calibration_bits\": 518.9117986527069, \"calibration_bits_per_byte\": 8.107996853948546}, \"rail_III\": {\"rule\": \"admit the witness iff it codes the calibration text in fewer bits than the uniform byte code by more than eps_gain_bits (evidence ratio > 1, MacKay chapter 28)\", \"baseline_bits\": 512.0, \"gain_bits\": -6.911798652706921, \"eps_gain_bits\": 0.0, \"admitted\": false, \"reason\": \"the witness predicts the calibration text no better than chance\"}, \"rail_IV\": {\"status\": \"structural analogue\", \"rule\": \"answer the most probable hypothesis only if its posterior exceeds lambda/(1+lambda); otherwise abstain\", \"lambda\": 1.0, \"threshold\": 0.5, \"posterior_max\": 0.5, \"margin_log_odds\": 0.0, \"flip_factor\": 1.0, \"threshold_margin_log_odds\": 0.0, \"reason\": \"the witness was not admitted, so the decision rests on the prior alone; the two most probable hypotheses are tied\", \"equal_lengths\": true, \"length_normalised_ranking_agrees\": true}, \"retraction\": {\"gates_off\": {\"posterior\": {\"inference\": 0.07762668460910498, \"qzxjvkwbp\": 0.9223733153908929}, \"answer\": \"qzxjvkwbp\"}, \"by_construction\": true, \"counts_as_evidence\": false, \"note\": \"witness admitted whatever its gain: the posterior an ungated system would report\"}}",
    "sha512": "53f76d5b676d0e1d7b086eddbc4542e66f27223d3580ecb916f99d658991109937f62a6dc1cf823211da7f60e40d7cda2927e65a6e8d9c96136b2efb6b3f2b22"
   }
  ],
  "receipt_chain_head": "53f76d5b676d0e1d7b086eddbc4542e66f27223d3580ecb916f99d658991109937f62a6dc1cf823211da7f60e40d7cda2927e65a6e8d9c96136b2efb6b3f2b22",
  "evaluated_twice": true,
  "native_cmd_execution": false
 }
}