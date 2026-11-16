@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): accept_rails_witness_unigram.json. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to print the document, with /check to check its SHA-512, or with /extract FILE to write it out.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=accept_rails_witness_unigram.json"
set "LB_DOC_TYPE=json"
set "LB_DOC_BYTES=9143"
set "LB_DOC_SHA512=a3ec9eaf198298a9e1bc4727f3b4b3b57aa5426132fc5c3d6671da06f44dfcc478f6bba3408199ed54d9d22a2b69d81b816fa1dce6ffe6bebc8b722fb8a0c69f"
set "LB_SELF=%~f0"
set "LB_ARG=%~1"
set "LB_OUT=%~f2"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$n=[int]$env:LB_DOC_BYTES;$b=[IO.File]::ReadAllBytes($env:LB_SELF);$o=$b.Length-$n;$h=-join((New-Object Security.Cryptography.SHA512Managed).ComputeHash($b,$o,$n)|%%{$_.ToString('x2')});if($h -ne $env:LB_DOC_SHA512){[Console]::Error.WriteLine('LB-DOC/1: the SHA-512 of '+$env:LB_DOC+' differs from LB_DOC_SHA512');exit 1};if($env:LB_ARG -eq '/check'){'ok: '+$env:LB_DOC;exit 0};if($env:LB_ARG -eq '/extract'){$d=New-Object byte[] $n;[Array]::Copy($b,$o,$d,0,$n);[IO.File]::WriteAllBytes($env:LB_OUT,$d);'written: '+$env:LB_OUT;exit 0};[Console]::OutputEncoding=New-Object Text.UTF8Encoding $false;[Console]::Out.Write([Text.Encoding]::UTF8.GetString($b,$o,$n));exit 0"
set "LB_RC=%errorlevel%"
if "%LB_ARG%"=="" pause
exit /b %LB_RC%
rem ---- document ----
{
 "program": "kgd/accept_rails_witness_unigram.cmd",
 "source_sha512": "975e9efd448904c5ec40dc85392f7767354ebec1f2afce34fe726641afbaca65ac7ad6855cd9711cbcf3bb7f85b82093089324e547bbd1bc060f848ba42f2c81",
 "file_sha512": "81fe45dc43a6dd468e7a1435231bb5f57888710dbded73d595715aa4eaaae6cd4e7a649880a49377204d5a6ce67580fe35b2d4564ee6908bc6fa7d0d8f390c60",
 "runner": "lcufx\\LCUFX_KGD.cmd run --twice (tools\\KGD_ENGINE.cmd host)",
 "expected": "accept",
 "observed": "accept",
 "as_expected": true,
 "exit_code": 0,
 "seconds": 0.8,
 "output": {
  "status": "host_research_pass",
  "language": "LCUF-X/0.2+lkvexa.kgd_imq/0.2",
  "source_sha512": "975e9efd448904c5ec40dc85392f7767354ebec1f2afce34fe726641afbaca65ac7ad6855cd9711cbcf3bb7f85b82093089324e547bbd1bc060f848ba42f2c81",
  "semantic_sha512": "3399fceb76523bf18adeecfdd688daad81a398790f7d2746bdb9be39aa08e97cb97f4800f53d976738592e81d2f98d61a3ab3d6bd8f85b79d9a547707db455fb",
  "values": {
   "alpha": 1.0,
   "dpin": "c17ea34319bad060391761fa490efc01bb51cefdfb44fc200fe90015e4c76942e1be8128dd7be260f3295335c218990c56ef67321fbb41279a1782ccd1787767",
   "exp_wq": "{\"rail_III.admitted\": true, \"decision\": \"answer\", \"answer\": \"inference\"}",
   "shards": "[\"../../../data/train_bytes_00.cmd\", \"../../../data/train_bytes_01.cmd\"]",
   "spec_wq": "{\"question\": \"Which word continues the prompt?\", \"prompt\": \"Information theory and \", \"candidates\": [\"inference\", \"qzxjvkwbp\"], \"calibration\": \"ning result is claimed.\\n\\n\\u001e\\n# C005 resume\\n\\n- Last stage: W12.\\n- S\", \"lambda\": 1.0}",
   "report_wq": "{\"framework\": \"RAILS-8S/1\", \"op\": \"rails_witness\", \"statement\": \"the answer is 'inference'\", \"decision\": \"answer\", \"answer\": \"inference\", \"posterior\": {\"inference\": 0.9999999999475229, \"qzxjvkwbp\": 5.247718051854563e-11}, \"witness\": {\"kind\": \"unigram\", \"alpha\": 1.0, \"data_sha512\": \"c17ea34319bad060391761fa490efc01bb51cefdfb44fc200fe90015e4c76942e1be8128dd7be260f3295335c218990c56ef67321fbb41279a1782ccd1787767\", \"bytes\": 3728629}, \"rail_I\": {\"prompt\": \"Information theory and \", \"candidates\": [\"inference\", \"qzxjvkwbp\"], \"calibration_bytes\": 64}, \"rail_II\": {\"status\": \"exact in logs\", \"rule\": \"log P(candidate | prompt) = sum over its bytes of log p(byte | everything before it), teacher-forced (complete enumeration over the candidates)\", \"candidate_log_likelihood_nats\": {\"inference\": -26.72645107867926, \"qzxjvkwbp\": -50.397093776238}, \"candidate_code_bits\": {\"inference\": 38.55811843177206, \"qzxjvkwbp\": 72.70763726619461}, \"calibration_bits\": 343.5832238013789, \"calibration_bits_per_byte\": 5.368487871896545}, \"rail_III\": {\"rule\": \"admit the witness iff it codes the calibration text in fewer bits than the uniform byte code by more than eps_gain_bits (evidence ratio > 1, MacKay chapter 28)\", \"baseline_bits\": 512.0, \"gain_bits\": 168.4167761986211, \"eps_gain_bits\": 0.0, \"admitted\": true, \"reason\": \"the witness predicts the calibration text better than chance\"}, \"rail_IV\": {\"status\": \"structural analogue\", \"rule\": \"answer the most probable hypothesis only if its posterior exceeds lambda/(1+lambda); otherwise abstain\", \"lambda\": 1.0, \"threshold\": 0.5, \"posterior_max\": 0.9999999999475229, \"margin_log_odds\": 23.670642697558744, \"flip_factor\": 19055901823.72925, \"threshold_margin_log_odds\": 23.670643588784298, \"reason\": \"the posterior of the best hypothesis is above lambda/(1+lambda)\", \"equal_lengths\": true, \"length_normalised_ranking_agrees\": true}, \"retraction\": {\"gates_off\": {\"posterior\": {\"inference\": 0.9999999999475229, \"qzxjvkwbp\": 5.247718051854563e-11}, \"answer\": \"inference\"}, \"by_construction\": true, \"counts_as_evidence\": false, \"note\": \"witness admitted whatever its gain: the posterior an ungated system would report\"}}"
  },
  "admission": {
   "reserved_work": {
    "s": 33106414
   },
   "retained_payload_bytes": {
    "s": 6660
   },
   "peak_modeled_scratch_bytes": {
    "s": 3730677
   },
   "minimum_row_work": {
    "c_shards": 1,
    "c_dpin": 1,
    "c_alpha": 1,
    "u": 33106324,
    "c_spec_wq": 1,
    "wq": 83,
    "c_exp_wq": 1,
    "chk_wq": 1,
    "out_wq": 1
   }
  },
  "row_order": [
   "c_alpha",
   "c_dpin",
   "c_exp_wq",
   "c_shards",
   "c_spec_wq",
   "u",
   "wq",
   "chk_wq",
   "out_wq"
  ],
  "receipts": [
   {
    "scope": "LCUF_X_KGD_HOST_RESEARCH",
    "row": "u",
    "site": "s",
    "profile": "lkvexa.rails8s",
    "semantic_sha512": "3399fceb76523bf18adeecfdd688daad81a398790f7d2746bdb9be39aa08e97cb97f4800f53d976738592e81d2f98d61a3ab3d6bd8f85b79d9a547707db455fb",
    "previous_sha512": "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
    "result_sha512": "209ef0583820d261ee11236cd8fe6566fc1878d571b73f22033fee9fe6e71c6d4b52aa9167be2519278331d4a7c108ec5b5c2eb3178385bf91850d59de656884",
    "sha512": "443554e67af0c57af350213ba4eb462a746b7b8fabb3c57a137945dcef280948a284c65eec14e76d6e2e4b6c0c3f2cd99a73e52ef01e397d01c74439c8d45361"
   },
   {
    "scope": "LCUF_X_KGD_HOST_RESEARCH",
    "row": "wq",
    "site": "s",
    "profile": "lkvexa.rails8s",
    "semantic_sha512": "3399fceb76523bf18adeecfdd688daad81a398790f7d2746bdb9be39aa08e97cb97f4800f53d976738592e81d2f98d61a3ab3d6bd8f85b79d9a547707db455fb",
    "previous_sha512": "443554e67af0c57af350213ba4eb462a746b7b8fabb3c57a137945dcef280948a284c65eec14e76d6e2e4b6c0c3f2cd99a73e52ef01e397d01c74439c8d45361",
    "result_sha512": "ad6efd781fb4c612cf819f95785a5660d818bf1ab5063c08c7d737b2edbc1c7639170ec6ac1b78907c7c663c7501178f35e374839d08fe32aea8c72add73e3da",
    "sha512": "ffcebeb627f9379f1d30be3e88a7b7716d739907f1f057edf6ea6f72fef179e324d25143be7f4e65779aa9e06bae6881230e692bc9eaf809937a2870980a3cb0"
   },
   {
    "scope": "LCUF_X_KGD_HOST_RESEARCH",
    "row": "out_wq",
    "site": "s",
    "profile": "lcuf.evidence",
    "semantic_sha512": "3399fceb76523bf18adeecfdd688daad81a398790f7d2746bdb9be39aa08e97cb97f4800f53d976738592e81d2f98d61a3ab3d6bd8f85b79d9a547707db455fb",
    "previous_sha512": "ffcebeb627f9379f1d30be3e88a7b7716d739907f1f057edf6ea6f72fef179e324d25143be7f4e65779aa9e06bae6881230e692bc9eaf809937a2870980a3cb0",
    "result_sha512": "ad6efd781fb4c612cf819f95785a5660d818bf1ab5063c08c7d737b2edbc1c7639170ec6ac1b78907c7c663c7501178f35e374839d08fe32aea8c72add73e3da",
    "value": "{\"framework\": \"RAILS-8S/1\", \"op\": \"rails_witness\", \"statement\": \"the answer is 'inference'\", \"decision\": \"answer\", \"answer\": \"inference\", \"posterior\": {\"inference\": 0.9999999999475229, \"qzxjvkwbp\": 5.247718051854563e-11}, \"witness\": {\"kind\": \"unigram\", \"alpha\": 1.0, \"data_sha512\": \"c17ea34319bad060391761fa490efc01bb51cefdfb44fc200fe90015e4c76942e1be8128dd7be260f3295335c218990c56ef67321fbb41279a1782ccd1787767\", \"bytes\": 3728629}, \"rail_I\": {\"prompt\": \"Information theory and \", \"candidates\": [\"inference\", \"qzxjvkwbp\"], \"calibration_bytes\": 64}, \"rail_II\": {\"status\": \"exact in logs\", \"rule\": \"log P(candidate | prompt) = sum over its bytes of log p(byte | everything before it), teacher-forced (complete enumeration over the candidates)\", \"candidate_log_likelihood_nats\": {\"inference\": -26.72645107867926, \"qzxjvkwbp\": -50.397093776238}, \"candidate_code_bits\": {\"inference\": 38.55811843177206, \"qzxjvkwbp\": 72.70763726619461}, \"calibration_bits\": 343.5832238013789, \"calibration_bits_per_byte\": 5.368487871896545}, \"rail_III\": {\"rule\": \"admit the witness iff it codes the calibration text in fewer bits than the uniform byte code by more than eps_gain_bits (evidence ratio > 1, MacKay chapter 28)\", \"baseline_bits\": 512.0, \"gain_bits\": 168.4167761986211, \"eps_gain_bits\": 0.0, \"admitted\": true, \"reason\": \"the witness predicts the calibration text better than chance\"}, \"rail_IV\": {\"status\": \"structural analogue\", \"rule\": \"answer the most probable hypothesis only if its posterior exceeds lambda/(1+lambda); otherwise abstain\", \"lambda\": 1.0, \"threshold\": 0.5, \"posterior_max\": 0.9999999999475229, \"margin_log_odds\": 23.670642697558744, \"flip_factor\": 19055901823.72925, \"threshold_margin_log_odds\": 23.670643588784298, \"reason\": \"the posterior of the best hypothesis is above lambda/(1+lambda)\", \"equal_lengths\": true, \"length_normalised_ranking_agrees\": true}, \"retraction\": {\"gates_off\": {\"posterior\": {\"inference\": 0.9999999999475229, \"qzxjvkwbp\": 5.247718051854563e-11}, \"answer\": \"inference\"}, \"by_construction\": true, \"counts_as_evidence\": false, \"note\": \"witness admitted whatever its gain: the posterior an ungated system would report\"}}",
    "sha512": "2750cc9454cb1466a126621cc090a5ba8b0406f23edacfbe56ffa37803ca185c46cc1f266244d2b41ffa6a3d8f6e77283e731cdaa07dc2b94291caab764bb36c"
   }
  ],
  "receipt_chain_head": "2750cc9454cb1466a126621cc090a5ba8b0406f23edacfbe56ffa37803ca185c46cc1f266244d2b41ffa6a3d8f6e77283e731cdaa07dc2b94291caab764bb36c",
  "evaluated_twice": true,
  "native_cmd_execution": false
 }
}