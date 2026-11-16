@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): accept_rails_bayes_oliver.json. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to print the document, with /check to check its SHA-512, or with /extract FILE to write it out.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=accept_rails_bayes_oliver.json"
set "LB_DOC_TYPE=json"
set "LB_DOC_BYTES=20761"
set "LB_DOC_SHA512=c6004eb7ed9b7f0c6e888e3cc64b60fad7d76b7a3ce179e894cf50b730678ff9013b3a392dc3595e3fbad563c3f582e18c279849fb9a20f8863b77dc369aee38"
set "LB_SELF=%~f0"
set "LB_ARG=%~1"
set "LB_OUT=%~f2"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$n=[int]$env:LB_DOC_BYTES;$b=[IO.File]::ReadAllBytes($env:LB_SELF);$o=$b.Length-$n;$h=-join((New-Object Security.Cryptography.SHA512Managed).ComputeHash($b,$o,$n)|%%{$_.ToString('x2')});if($h -ne $env:LB_DOC_SHA512){[Console]::Error.WriteLine('LB-DOC/1: the SHA-512 of '+$env:LB_DOC+' differs from LB_DOC_SHA512');exit 1};if($env:LB_ARG -eq '/check'){'ok: '+$env:LB_DOC;exit 0};if($env:LB_ARG -eq '/extract'){$d=New-Object byte[] $n;[Array]::Copy($b,$o,$d,0,$n);[IO.File]::WriteAllBytes($env:LB_OUT,$d);'written: '+$env:LB_OUT;exit 0};[Console]::OutputEncoding=New-Object Text.UTF8Encoding $false;[Console]::Out.Write([Text.Encoding]::UTF8.GetString($b,$o,$n));exit 0"
set "LB_RC=%errorlevel%"
if "%LB_ARG%"=="" pause
exit /b %LB_RC%
rem ---- document ----
{
 "program": "kgd/accept_rails_bayes_oliver.cmd",
 "source_sha512": "f5f6852894679b8651facfb0277c3903f07116b0ba4e7d8b2af93ea411761b1f7e5f4019f581e88e5a07dd9cfdbf0cf1edba2c8eb73cdd7d5a572b038433ef02",
 "file_sha512": "1a7dfb3b94850244fe1e4f0df85e56383d3785904518ecadc144008600696d56f52e90b0b3323f48f3df1b853db0e78a9464ad2bf8e8b567560d3c437cc8e8a9",
 "runner": "lcufx\\LCUFX_KGD.cmd run --twice (tools\\KGD_ENGINE.cmd host)",
 "expected": "accept",
 "observed": "accept",
 "as_expected": true,
 "exit_code": 0,
 "seconds": 0.0,
 "output": {
  "status": "host_research_pass",
  "language": "LCUF-X/0.2+lkvexa.kgd_imq/0.2",
  "source_sha512": "f5f6852894679b8651facfb0277c3903f07116b0ba4e7d8b2af93ea411761b1f7e5f4019f581e88e5a07dd9cfdbf0cf1edba2c8eb73cdd7d5a572b038433ef02",
  "semantic_sha512": "6bd3ffcb34ec2b31fbdb9b14bb3657b061e80e55b6d70b00cff0c59880fffdc9c96c6932fa5f8a3462d44e5cb918ecbfcba3b415edd7fdffe4422b0c60ec50f4",
  "values": {
   "exp_o1": "{\"decision\": \"answer\", \"answer\": \"absent\", \"posterior.present\": {\"center\": 0.45454545454545453, \"tolerance\": 1e-12}, \"rail_IV.flip_factor\": {\"center\": 1.2, \"tolerance\": 1e-12}}",
   "exp_o4": "{\"decision\": \"abstain\", \"answer\": null, \"rail_IV.threshold\": {\"center\": 0.8, \"tolerance\": 1e-15}}",
   "exp_oab": "{\"decision\": \"answer\", \"answer\": \"present\", \"posterior.present\": {\"center\": 0.9803921568627451, \"tolerance\": 1e-12}, \"rail_IV.margin_log_odds\": {\"center\": 3.912023005428146, \"tolerance\": 1e-12}}",
   "spec_o1": "{\"question\": \"Was Oliver one of the two people who left blood (types O and AB; Oliver is O)? MacKay (3.24)-(3.26)\", \"hypotheses\": [\"present\", \"absent\"], \"evidence\": [{\"name\": \"blood types at the scene\", \"tags\": [\"scene\"], \"likelihood\": [0.01, 0.012]}], \"lambda\": 1.0}",
   "spec_o4": "{\"question\": \"The same question, when a wrong answer costs four times what a right one gains\", \"hypotheses\": [\"present\", \"absent\"], \"evidence\": [{\"name\": \"blood types at the scene\", \"tags\": [\"scene\"], \"likelihood\": [0.01, 0.012]}], \"lambda\": 4.0}",
   "spec_oab": "{\"question\": \"The same evidence for a suspect of type AB: MacKay (3.27)\", \"hypotheses\": [\"present\", \"absent\"], \"evidence\": [{\"name\": \"blood types at the scene\", \"tags\": [\"scene\"], \"likelihood\": [0.6, 0.012]}], \"lambda\": 1.0}",
   "report_o1": "{\"framework\": \"RAILS-8S/1\", \"op\": \"rails_bayes\", \"statement\": \"the most probable hypothesis is absent, with posterior 0.5454545454545451\", \"decision\": \"answer\", \"answer\": \"absent\", \"posterior\": {\"present\": 0.45454545454545453, \"absent\": 0.5454545454545451}, \"admitted\": [\"blood types at the scene\"], \"rejected\": [], \"rail_I\": {\"question\": \"Was Oliver one of the two people who left blood (types O and AB; Oliver is O)? MacKay (3.24)-(3.26)\", \"hypotheses\": [\"present\", \"absent\"], \"evidence_items\": 1}, \"rail_II\": {\"status\": \"exact in logs\", \"rule\": \"log posterior = log prior + sum of the admitted log likelihoods - log Z\", \"log_prior\": [-0.6931471805599453, -0.6931471805599453], \"log_posterior\": [-0.7884573603642702, -0.6061358035703162], \"log_evidence_nats\": -4.509860006183766, \"entropy_prior_bits\": 1.0, \"entropy_posterior_bits\": 0.9940302114769567}, \"rail_III\": {\"rule\": \"admit evidence e iff eta_ind(e) >= eps_ind and gain_bits(e) > eps_gain_bits; eta_ind is computed on the provenance tags; gain_bits = KL(posterior with e || posterior without e)\", \"eps_ind\": 0.5, \"eps_gain_bits\": 0.0, \"rank\": 1, \"items\": [{\"name\": \"blood types at the scene\", \"tags\": [\"scene\"], \"eta_ind\": 0.9999999999989999, \"gain_bits\": 0.005969788523042902, \"admitted\": true, \"reason\": \"admitted\", \"log_evidence_nats\": -4.509860006183766}]}, \"rail_IV\": {\"status\": \"structural analogue\", \"rule\": \"answer the most probable hypothesis only if its posterior exceeds lambda/(1+lambda); otherwise abstain\", \"lambda\": 1.0, \"threshold\": 0.5, \"posterior_max\": 0.5454545454545451, \"margin_log_odds\": 0.182321556793954, \"flip_factor\": 1.1999999999999993, \"threshold_margin_log_odds\": 0.18232155679395312, \"reason\": \"the posterior of the best hypothesis is above lambda/(1+lambda)\"}, \"retraction\": {\"gates_off\": {\"posterior\": {\"present\": 0.45454545454545453, \"absent\": 0.5454545454545451}, \"answer\": \"absent\"}, \"by_construction\": true, \"counts_as_evidence\": false, \"note\": \"every item admitted, whatever its provenance or gain: the plain product of all likelihoods\"}}",
   "report_o4": "{\"framework\": \"RAILS-8S/1\", \"op\": \"rails_bayes\", \"statement\": \"abstain: the posterior of the best hypothesis is not above lambda/(1+lambda)\", \"decision\": \"abstain\", \"answer\": null, \"posterior\": {\"present\": 0.45454545454545453, \"absent\": 0.5454545454545451}, \"admitted\": [\"blood types at the scene\"], \"rejected\": [], \"rail_I\": {\"question\": \"The same question, when a wrong answer costs four times what a right one gains\", \"hypotheses\": [\"present\", \"absent\"], \"evidence_items\": 1}, \"rail_II\": {\"status\": \"exact in logs\", \"rule\": \"log posterior = log prior + sum of the admitted log likelihoods - log Z\", \"log_prior\": [-0.6931471805599453, -0.6931471805599453], \"log_posterior\": [-0.7884573603642702, -0.6061358035703162], \"log_evidence_nats\": -4.509860006183766, \"entropy_prior_bits\": 1.0, \"entropy_posterior_bits\": 0.9940302114769567}, \"rail_III\": {\"rule\": \"admit evidence e iff eta_ind(e) >= eps_ind and gain_bits(e) > eps_gain_bits; eta_ind is computed on the provenance tags; gain_bits = KL(posterior with e || posterior without e)\", \"eps_ind\": 0.5, \"eps_gain_bits\": 0.0, \"rank\": 1, \"items\": [{\"name\": \"blood types at the scene\", \"tags\": [\"scene\"], \"eta_ind\": 0.9999999999989999, \"gain_bits\": 0.005969788523042902, \"admitted\": true, \"reason\": \"admitted\", \"log_evidence_nats\": -4.509860006183766}]}, \"rail_IV\": {\"status\": \"structural analogue\", \"rule\": \"answer the most probable hypothesis only if its posterior exceeds lambda/(1+lambda); otherwise abstain\", \"lambda\": 4.0, \"threshold\": 0.8, \"posterior_max\": 0.5454545454545451, \"margin_log_odds\": 0.182321556793954, \"flip_factor\": 1.1999999999999993, \"threshold_margin_log_odds\": -1.2039728043259377, \"reason\": \"the posterior of the best hypothesis is not above lambda/(1+lambda)\"}, \"retraction\": {\"gates_off\": {\"posterior\": {\"present\": 0.45454545454545453, \"absent\": 0.5454545454545451}, \"answer\": null}, \"by_construction\": true, \"counts_as_evidence\": false, \"note\": \"every item admitted, whatever its provenance or gain: the plain product of all likelihoods\"}}",
   "report_oab": "{\"framework\": \"RAILS-8S/1\", \"op\": \"rails_bayes\", \"statement\": \"the most probable hypothesis is present, with posterior 0.9803921568627451\", \"decision\": \"answer\", \"answer\": \"present\", \"posterior\": {\"present\": 0.9803921568627451, \"absent\": 0.019607843137254895}, \"admitted\": [\"blood types at the scene\"], \"rejected\": [], \"rail_I\": {\"question\": \"The same evidence for a suspect of type AB: MacKay (3.27)\", \"hypotheses\": [\"present\", \"absent\"], \"evidence_items\": 1}, \"rail_II\": {\"status\": \"exact in logs\", \"rule\": \"log posterior = log prior + sum of the admitted log likelihoods - log Z\", \"log_prior\": [-0.6931471805599453, -0.6931471805599453], \"log_posterior\": [-0.019802627296179764, -3.931825632724326], \"log_evidence_nats\": -1.1841701770297561, \"entropy_prior_bits\": 1.0, \"entropy_posterior_bits\": 0.13923299905509887}, \"rail_III\": {\"rule\": \"admit evidence e iff eta_ind(e) >= eps_ind and gain_bits(e) > eps_gain_bits; eta_ind is computed on the provenance tags; gain_bits = KL(posterior with e || posterior without e)\", \"eps_ind\": 0.5, \"eps_gain_bits\": 0.0, \"rank\": 1, \"items\": [{\"name\": \"blood types at the scene\", \"tags\": [\"scene\"], \"eta_ind\": 0.9999999999989999, \"gain_bits\": 0.860767000944901, \"admitted\": true, \"reason\": \"admitted\", \"log_evidence_nats\": -1.1841701770297561}]}, \"rail_IV\": {\"status\": \"structural analogue\", \"rule\": \"answer the most probable hypothesis only if its posterior exceeds lambda/(1+lambda); otherwise abstain\", \"lambda\": 1.0, \"threshold\": 0.5, \"posterior_max\": 0.9803921568627451, \"margin_log_odds\": 3.9120230054281464, \"flip_factor\": 50.000000000000014, \"threshold_margin_log_odds\": 3.9120230054281437, \"reason\": \"the posterior of the best hypothesis is above lambda/(1+lambda)\"}, \"retraction\": {\"gates_off\": {\"posterior\": {\"present\": 0.9803921568627451, \"absent\": 0.019607843137254895}, \"answer\": \"present\"}, \"by_construction\": true, \"counts_as_evidence\": false, \"note\": \"every item admitted, whatever its provenance or gain: the plain product of all likelihoods\"}}"
  },
  "admission": {
   "reserved_work": {
    "s": 30
   },
   "retained_payload_bytes": {
    "s": 13492
   },
   "peak_modeled_scratch_bytes": {
    "s": 88
   },
   "minimum_row_work": {
    "c_spec_o1": 1,
    "c_spec_o4": 1,
    "c_spec_oab": 1,
    "o1": 6,
    "c_exp_o1": 1,
    "chk_o1": 1,
    "out_o1": 1,
    "o4": 6,
    "c_exp_o4": 1,
    "chk_o4": 1,
    "out_o4": 1,
    "oab": 6,
    "c_exp_oab": 1,
    "chk_oab": 1,
    "out_oab": 1
   }
  },
  "row_order": [
   "c_exp_o1",
   "c_exp_o4",
   "c_exp_oab",
   "c_spec_o1",
   "c_spec_o4",
   "c_spec_oab",
   "o1",
   "chk_o1",
   "o4",
   "chk_o4",
   "oab",
   "chk_oab",
   "out_o1",
   "out_o4",
   "out_oab"
  ],
  "receipts": [
   {
    "scope": "LCUF_X_KGD_HOST_RESEARCH",
    "row": "o1",
    "site": "s",
    "profile": "lkvexa.rails8s",
    "semantic_sha512": "6bd3ffcb34ec2b31fbdb9b14bb3657b061e80e55b6d70b00cff0c59880fffdc9c96c6932fa5f8a3462d44e5cb918ecbfcba3b415edd7fdffe4422b0c60ec50f4",
    "previous_sha512": "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
    "result_sha512": "c35b7905abc006842011ee6ca638be9d0d3bc27d571810b5d03aceec4b95f909448219cae9bdc1b48078ae076009d0a32faff8fbd2d43649083ec40ef33a7a4a",
    "sha512": "976edee65225172f881c1ebcd98ed119022b2e4d0d353de54684ebe54c0b478e845922f73c2efcf97c090028a0f6f7e622425d0a5b030816c9ae803f884bd7ec"
   },
   {
    "scope": "LCUF_X_KGD_HOST_RESEARCH",
    "row": "o4",
    "site": "s",
    "profile": "lkvexa.rails8s",
    "semantic_sha512": "6bd3ffcb34ec2b31fbdb9b14bb3657b061e80e55b6d70b00cff0c59880fffdc9c96c6932fa5f8a3462d44e5cb918ecbfcba3b415edd7fdffe4422b0c60ec50f4",
    "previous_sha512": "976edee65225172f881c1ebcd98ed119022b2e4d0d353de54684ebe54c0b478e845922f73c2efcf97c090028a0f6f7e622425d0a5b030816c9ae803f884bd7ec",
    "result_sha512": "aaf0f3989353b61b7efd0dca6f25b4051503c40a77cd27a832315702de70e5e3e94d91627c9b4abd076528aace0b8d3dcf4d93447ce9980f3064614d2553d8e8",
    "sha512": "d5a4365705043b6ff3d8ea3d7a8389adc48b6ff5df6315eecb28ec0a6b01cf8233639586f83240b4e065e3d33f3a5479f86d7e6642b67156f98087932b62d526"
   },
   {
    "scope": "LCUF_X_KGD_HOST_RESEARCH",
    "row": "oab",
    "site": "s",
    "profile": "lkvexa.rails8s",
    "semantic_sha512": "6bd3ffcb34ec2b31fbdb9b14bb3657b061e80e55b6d70b00cff0c59880fffdc9c96c6932fa5f8a3462d44e5cb918ecbfcba3b415edd7fdffe4422b0c60ec50f4",
    "previous_sha512": "d5a4365705043b6ff3d8ea3d7a8389adc48b6ff5df6315eecb28ec0a6b01cf8233639586f83240b4e065e3d33f3a5479f86d7e6642b67156f98087932b62d526",
    "result_sha512": "7415ccb38d0727b8e908c31ff02b20a7ae93de1f18ac817e053ccdf5072afeeadb4c8e873dd585c092af9e540e7054abcd635c6e940d51dfa9b6ab4c643c8fda",
    "sha512": "0d7a597b210d15d540766ce4d5b2adb3593bf84156f74a30a6ff5af356b205c43567b5adbf92c1785067a9d1b42a2a29f016907f13366a4ee9b67c640713cdc9"
   },
   {
    "scope": "LCUF_X_KGD_HOST_RESEARCH",
    "row": "out_o1",
    "site": "s",
    "profile": "lcuf.evidence",
    "semantic_sha512": "6bd3ffcb34ec2b31fbdb9b14bb3657b061e80e55b6d70b00cff0c59880fffdc9c96c6932fa5f8a3462d44e5cb918ecbfcba3b415edd7fdffe4422b0c60ec50f4",
    "previous_sha512": "0d7a597b210d15d540766ce4d5b2adb3593bf84156f74a30a6ff5af356b205c43567b5adbf92c1785067a9d1b42a2a29f016907f13366a4ee9b67c640713cdc9",
    "result_sha512": "c35b7905abc006842011ee6ca638be9d0d3bc27d571810b5d03aceec4b95f909448219cae9bdc1b48078ae076009d0a32faff8fbd2d43649083ec40ef33a7a4a",
    "value": "{\"framework\": \"RAILS-8S/1\", \"op\": \"rails_bayes\", \"statement\": \"the most probable hypothesis is absent, with posterior 0.5454545454545451\", \"decision\": \"answer\", \"answer\": \"absent\", \"posterior\": {\"present\": 0.45454545454545453, \"absent\": 0.5454545454545451}, \"admitted\": [\"blood types at the scene\"], \"rejected\": [], \"rail_I\": {\"question\": \"Was Oliver one of the two people who left blood (types O and AB; Oliver is O)? MacKay (3.24)-(3.26)\", \"hypotheses\": [\"present\", \"absent\"], \"evidence_items\": 1}, \"rail_II\": {\"status\": \"exact in logs\", \"rule\": \"log posterior = log prior + sum of the admitted log likelihoods - log Z\", \"log_prior\": [-0.6931471805599453, -0.6931471805599453], \"log_posterior\": [-0.7884573603642702, -0.6061358035703162], \"log_evidence_nats\": -4.509860006183766, \"entropy_prior_bits\": 1.0, \"entropy_posterior_bits\": 0.9940302114769567}, \"rail_III\": {\"rule\": \"admit evidence e iff eta_ind(e) >= eps_ind and gain_bits(e) > eps_gain_bits; eta_ind is computed on the provenance tags; gain_bits = KL(posterior with e || posterior without e)\", \"eps_ind\": 0.5, \"eps_gain_bits\": 0.0, \"rank\": 1, \"items\": [{\"name\": \"blood types at the scene\", \"tags\": [\"scene\"], \"eta_ind\": 0.9999999999989999, \"gain_bits\": 0.005969788523042902, \"admitted\": true, \"reason\": \"admitted\", \"log_evidence_nats\": -4.509860006183766}]}, \"rail_IV\": {\"status\": \"structural analogue\", \"rule\": \"answer the most probable hypothesis only if its posterior exceeds lambda/(1+lambda); otherwise abstain\", \"lambda\": 1.0, \"threshold\": 0.5, \"posterior_max\": 0.5454545454545451, \"margin_log_odds\": 0.182321556793954, \"flip_factor\": 1.1999999999999993, \"threshold_margin_log_odds\": 0.18232155679395312, \"reason\": \"the posterior of the best hypothesis is above lambda/(1+lambda)\"}, \"retraction\": {\"gates_off\": {\"posterior\": {\"present\": 0.45454545454545453, \"absent\": 0.5454545454545451}, \"answer\": \"absent\"}, \"by_construction\": true, \"counts_as_evidence\": false, \"note\": \"every item admitted, whatever its provenance or gain: the plain product of all likelihoods\"}}",
    "sha512": "ac8a123364589be1c65eac644d80d9ced07acbc0074e8c62aa5f076f440b40a0b64a5b3217fbd547e2e81cd7f3b9cc90eca503a870ed4de3097bb9944ff3dafb"
   },
   {
    "scope": "LCUF_X_KGD_HOST_RESEARCH",
    "row": "out_o4",
    "site": "s",
    "profile": "lcuf.evidence",
    "semantic_sha512": "6bd3ffcb34ec2b31fbdb9b14bb3657b061e80e55b6d70b00cff0c59880fffdc9c96c6932fa5f8a3462d44e5cb918ecbfcba3b415edd7fdffe4422b0c60ec50f4",
    "previous_sha512": "ac8a123364589be1c65eac644d80d9ced07acbc0074e8c62aa5f076f440b40a0b64a5b3217fbd547e2e81cd7f3b9cc90eca503a870ed4de3097bb9944ff3dafb",
    "result_sha512": "aaf0f3989353b61b7efd0dca6f25b4051503c40a77cd27a832315702de70e5e3e94d91627c9b4abd076528aace0b8d3dcf4d93447ce9980f3064614d2553d8e8",
    "value": "{\"framework\": \"RAILS-8S/1\", \"op\": \"rails_bayes\", \"statement\": \"abstain: the posterior of the best hypothesis is not above lambda/(1+lambda)\", \"decision\": \"abstain\", \"answer\": null, \"posterior\": {\"present\": 0.45454545454545453, \"absent\": 0.5454545454545451}, \"admitted\": [\"blood types at the scene\"], \"rejected\": [], \"rail_I\": {\"question\": \"The same question, when a wrong answer costs four times what a right one gains\", \"hypotheses\": [\"present\", \"absent\"], \"evidence_items\": 1}, \"rail_II\": {\"status\": \"exact in logs\", \"rule\": \"log posterior = log prior + sum of the admitted log likelihoods - log Z\", \"log_prior\": [-0.6931471805599453, -0.6931471805599453], \"log_posterior\": [-0.7884573603642702, -0.6061358035703162], \"log_evidence_nats\": -4.509860006183766, \"entropy_prior_bits\": 1.0, \"entropy_posterior_bits\": 0.9940302114769567}, \"rail_III\": {\"rule\": \"admit evidence e iff eta_ind(e) >= eps_ind and gain_bits(e) > eps_gain_bits; eta_ind is computed on the provenance tags; gain_bits = KL(posterior with e || posterior without e)\", \"eps_ind\": 0.5, \"eps_gain_bits\": 0.0, \"rank\": 1, \"items\": [{\"name\": \"blood types at the scene\", \"tags\": [\"scene\"], \"eta_ind\": 0.9999999999989999, \"gain_bits\": 0.005969788523042902, \"admitted\": true, \"reason\": \"admitted\", \"log_evidence_nats\": -4.509860006183766}]}, \"rail_IV\": {\"status\": \"structural analogue\", \"rule\": \"answer the most probable hypothesis only if its posterior exceeds lambda/(1+lambda); otherwise abstain\", \"lambda\": 4.0, \"threshold\": 0.8, \"posterior_max\": 0.5454545454545451, \"margin_log_odds\": 0.182321556793954, \"flip_factor\": 1.1999999999999993, \"threshold_margin_log_odds\": -1.2039728043259377, \"reason\": \"the posterior of the best hypothesis is not above lambda/(1+lambda)\"}, \"retraction\": {\"gates_off\": {\"posterior\": {\"present\": 0.45454545454545453, \"absent\": 0.5454545454545451}, \"answer\": null}, \"by_construction\": true, \"counts_as_evidence\": false, \"note\": \"every item admitted, whatever its provenance or gain: the plain product of all likelihoods\"}}",
    "sha512": "3b7c5c3368cff3b1a28a26901f9da31f0eedbbe0d1c80dfb08235f33b3ec2d5610ca4765061beaedf4cea9db37aa0399a7d13e688d8f7f6e75ca198856d16ef3"
   },
   {
    "scope": "LCUF_X_KGD_HOST_RESEARCH",
    "row": "out_oab",
    "site": "s",
    "profile": "lcuf.evidence",
    "semantic_sha512": "6bd3ffcb34ec2b31fbdb9b14bb3657b061e80e55b6d70b00cff0c59880fffdc9c96c6932fa5f8a3462d44e5cb918ecbfcba3b415edd7fdffe4422b0c60ec50f4",
    "previous_sha512": "3b7c5c3368cff3b1a28a26901f9da31f0eedbbe0d1c80dfb08235f33b3ec2d5610ca4765061beaedf4cea9db37aa0399a7d13e688d8f7f6e75ca198856d16ef3",
    "result_sha512": "7415ccb38d0727b8e908c31ff02b20a7ae93de1f18ac817e053ccdf5072afeeadb4c8e873dd585c092af9e540e7054abcd635c6e940d51dfa9b6ab4c643c8fda",
    "value": "{\"framework\": \"RAILS-8S/1\", \"op\": \"rails_bayes\", \"statement\": \"the most probable hypothesis is present, with posterior 0.9803921568627451\", \"decision\": \"answer\", \"answer\": \"present\", \"posterior\": {\"present\": 0.9803921568627451, \"absent\": 0.019607843137254895}, \"admitted\": [\"blood types at the scene\"], \"rejected\": [], \"rail_I\": {\"question\": \"The same evidence for a suspect of type AB: MacKay (3.27)\", \"hypotheses\": [\"present\", \"absent\"], \"evidence_items\": 1}, \"rail_II\": {\"status\": \"exact in logs\", \"rule\": \"log posterior = log prior + sum of the admitted log likelihoods - log Z\", \"log_prior\": [-0.6931471805599453, -0.6931471805599453], \"log_posterior\": [-0.019802627296179764, -3.931825632724326], \"log_evidence_nats\": -1.1841701770297561, \"entropy_prior_bits\": 1.0, \"entropy_posterior_bits\": 0.13923299905509887}, \"rail_III\": {\"rule\": \"admit evidence e iff eta_ind(e) >= eps_ind and gain_bits(e) > eps_gain_bits; eta_ind is computed on the provenance tags; gain_bits = KL(posterior with e || posterior without e)\", \"eps_ind\": 0.5, \"eps_gain_bits\": 0.0, \"rank\": 1, \"items\": [{\"name\": \"blood types at the scene\", \"tags\": [\"scene\"], \"eta_ind\": 0.9999999999989999, \"gain_bits\": 0.860767000944901, \"admitted\": true, \"reason\": \"admitted\", \"log_evidence_nats\": -1.1841701770297561}]}, \"rail_IV\": {\"status\": \"structural analogue\", \"rule\": \"answer the most probable hypothesis only if its posterior exceeds lambda/(1+lambda); otherwise abstain\", \"lambda\": 1.0, \"threshold\": 0.5, \"posterior_max\": 0.9803921568627451, \"margin_log_odds\": 3.9120230054281464, \"flip_factor\": 50.000000000000014, \"threshold_margin_log_odds\": 3.9120230054281437, \"reason\": \"the posterior of the best hypothesis is above lambda/(1+lambda)\"}, \"retraction\": {\"gates_off\": {\"posterior\": {\"present\": 0.9803921568627451, \"absent\": 0.019607843137254895}, \"answer\": \"present\"}, \"by_construction\": true, \"counts_as_evidence\": false, \"note\": \"every item admitted, whatever its provenance or gain: the plain product of all likelihoods\"}}",
    "sha512": "46ce656c673cc185c91d22c9aeb797074cdb1d472804c124aa1c2b15802460c4842b10caefac4ae4a2354f63ca9466f1780163085a5ab6f6abd3aa4a165e3be1"
   }
  ],
  "receipt_chain_head": "46ce656c673cc185c91d22c9aeb797074cdb1d472804c124aa1c2b15802460c4842b10caefac4ae4a2354f63ca9466f1780163085a5ab6f6abd3aa4a165e3be1",
  "evaluated_twice": true,
  "native_cmd_execution": false
 }
}