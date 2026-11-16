@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): programs-summary.json. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to print the document, with /check to check its SHA-512, or with /extract FILE to write it out.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=programs-summary.json"
set "LB_DOC_TYPE=json"
set "LB_DOC_BYTES=44992"
set "LB_DOC_SHA512=6e18894872cfbeae6fdb047208050bb60ac33c1a7c092507e58399177b836ec4d42fc19b6e39acc7ac5d3b30f22b0bc5f7775316648a89e1d99394bb09402a89"
set "LB_SELF=%~f0"
set "LB_ARG=%~1"
set "LB_OUT=%~f2"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$n=[int]$env:LB_DOC_BYTES;$b=[IO.File]::ReadAllBytes($env:LB_SELF);$o=$b.Length-$n;$h=-join((New-Object Security.Cryptography.SHA512Managed).ComputeHash($b,$o,$n)|%%{$_.ToString('x2')});if($h -ne $env:LB_DOC_SHA512){[Console]::Error.WriteLine('LB-DOC/1: the SHA-512 of '+$env:LB_DOC+' differs from LB_DOC_SHA512');exit 1};if($env:LB_ARG -eq '/check'){'ok: '+$env:LB_DOC;exit 0};if($env:LB_ARG -eq '/extract'){$d=New-Object byte[] $n;[Array]::Copy($b,$o,$d,0,$n);[IO.File]::WriteAllBytes($env:LB_OUT,$d);'written: '+$env:LB_OUT;exit 0};[Console]::OutputEncoding=New-Object Text.UTF8Encoding $false;[Console]::Out.Write([Text.Encoding]::UTF8.GetString($b,$o,$n));exit 0"
set "LB_RC=%errorlevel%"
if "%LB_ARG%"=="" pause
exit /b %LB_RC%
rem ---- document ----
{
 "runs": {
  "accept_kgd_alpha_gate": {
   "program": "core/accept_kgd_alpha_gate.cmd",
   "source_sha512": "c5f9bc0a1d72fadc312fdc5222517beecfb886c9b47e9220fa789286e88da530e61cf068aca89a37717687df10cc24057b067a215d5d201b4daf4cdddea69d11",
   "runner": "lcuf_x.py (the user's LCUF-X/0.2 compiler)",
   "expected": "accept",
   "observed": "not_run",
   "as_expected": false,
   "exit_code": -1,
   "seconds": 0.0
  },
  "accept_littlebit_block_sign": {
   "program": "core/accept_littlebit_block_sign.cmd",
   "source_sha512": "7ac62e02042a6f05c7a4c8244f25daff0714434fa3d982b5b209a7826e7d0b5d1c0a81dbe6b0a0312795abfb4034cc8b646398b20c72c9666d3868d84d160a89",
   "runner": "lcuf_x.py (the user's LCUF-X/0.2 compiler)",
   "expected": "accept",
   "observed": "not_run",
   "as_expected": false,
   "exit_code": -1,
   "seconds": 0.0
  },
  "accept_m1_exact_decode": {
   "program": "kgd/accept_m1_exact_decode.cmd",
   "source_sha512": "3c1d185ffaa755f209bfef667447b6f8aa72cab44bcbfd728ccc12f2d54c702be4f122e443282c996a491f5afa2dc3711943d3eb356435d8e627b5edcedbe4f0",
   "runner": "lcufx\\LCUFX_KGD.cmd run --twice (tools\\KGD_ENGINE.cmd host)",
   "expected": "accept",
   "observed": "accept",
   "as_expected": true,
   "exit_code": 0,
   "seconds": 5.2,
   "receipt_chain_head": "47f791922f450df4a9ec709581a3528b66f1a1c0064ad0c2d20c4223d83b2397fed2c34f4e0e92ce4f881daa3a3da61783bf75274b19625577a1e52715a957e8",
   "values": {
    "continuation": "                                                                "
   }
  },
  "accept_m1_exact_forward": {
   "program": "kgd/accept_m1_exact_forward.cmd",
   "source_sha512": "6ed9691650e8acadc2139d36a8dbab7440933413aba2836a9ff3b064fff2434b1c2c15d603f6f3b03f2fd5596e58f5eacd7bf2b26a3cc3475a9751eb237006b7",
   "runner": "lcufx\\LCUFX_KGD.cmd run --twice (tools\\KGD_ENGINE.cmd host)",
   "expected": "accept",
   "observed": "accept",
   "as_expected": true,
   "exit_code": 0,
   "seconds": 1.4,
   "receipt_chain_head": "56a5d22d71e7192979e9bab97cd0ec1a8ebc62eb8842936303d71a83adf73734ec26dc7075f2481189ecdfa6d9f9c8eaf9d2149564cffc80e4e195a9e858b20e",
   "values": {
    "loss": 5.598290324140858
   }
  },
  "accept_m1_tier2_forward": {
   "program": "kgd/accept_m1_tier2_forward.cmd",
   "source_sha512": "e2228566871dab79c9a361cea73e38a50321a01f3ed78c9fa88e9c9632f4a4eeb69b60ea6d2b449787a90eb34ef359b426803997e845162cc7d2c6d5326d4138",
   "runner": "lcufx\\LCUFX_KGD.cmd run --twice (tools\\KGD_ENGINE.cmd host)",
   "expected": "accept",
   "observed": "accept",
   "as_expected": true,
   "exit_code": 0,
   "seconds": 0.3,
   "receipt_chain_head": "b98c4dc6bcff13ed91321ed43d48b7d4196ba714091a2b55d14b438905a0edd31a2361166bb9084dd5ea13604b31beaa281c905bb5d4fb97c90b09a35e25b4c8",
   "values": {
    "loss": 5.547993205805715
   }
  },
  "accept_m2_tier0_forward": {
   "program": "kgd/accept_m2_tier0_forward.cmd",
   "source_sha512": "05f3a8a4cb2d288290e6264790aca56666cae4b4d973df47c20db0893a597f89bd549e43014354fd4c93a2d347a3ac6ab4a5e9c750e37711c4e767b3de2e879b",
   "runner": "lcufx\\LCUFX_KGD.cmd run --twice (tools\\KGD_ENGINE.cmd host)",
   "expected": "accept",
   "observed": "accept",
   "as_expected": true,
   "exit_code": 0,
   "seconds": 23.1,
   "receipt_chain_head": "9e69c0fdc8e6f3669241a7c7684d820ead30bf6dd61e69eca231df695c8084eadb0e2cdb6fc23e38a39f3c34981b64c97ab365cecc55c18db38c654be41e39c2",
   "values": {
    "loss": 17.07025582016117
   }
  },
  "accept_m2_tier1_forward": {
   "program": "kgd/accept_m2_tier1_forward.cmd",
   "source_sha512": "4c996a7c7a59ef3f73ad3a028d2f24647fb3bd846da6ad1c92c0cc314a03f86c0b8703b0693c49d19e983740e73fbe0403324446d9335987e1be759be34363a8",
   "runner": "lcufx\\LCUFX_KGD.cmd run --twice (tools\\KGD_ENGINE.cmd host)",
   "expected": "accept",
   "observed": "accept",
   "as_expected": true,
   "exit_code": 0,
   "seconds": 23.0,
   "receipt_chain_head": "7d1233469ef2a5325576cbc9281622d2e78e3b202fd587105c13592a9f7efee51721c2fed9632febeaeff09b33a9d00986ef650c4a1c978bb836661e0f4ac2e8",
   "values": {
    "loss": 17.07025582016117
   }
  },
  "accept_port_loop": {
   "program": "kgd/accept_port_loop.cmd",
   "source_sha512": "740b7a59fdf0a82b6ab46cde8dfbfcbd8628308ac7725fe889977abaff2b41930d2d355ba641c86ab09c58fadc446fce779e09fce64e29d44a8206754680272a",
   "runner": "lcufx\\LCUFX_KGD.cmd run --twice (tools\\KGD_ENGINE.cmd host)",
   "expected": "accept",
   "observed": "accept",
   "as_expected": true,
   "exit_code": 0,
   "seconds": 7.6,
   "receipt_chain_head": "487688c20339ce471b2ae94e2c3b66365c239070eb5264312abe8d1846f3c2bd103b481b28b62cc972d18d253b9f361bad3a32997e2015b4d14bf677d5e055d0",
   "values": {
    "report_t100m": "{\"steps_run\": 6104, \"tokens_seen\": 100007936, \"est_total_steps\": 6103, \"schedule_total_steps\": 6103, \"warmup_steps\": 1, \"lr_factor_first_update\": 0.0, \"optimizer_updates\": 6104}",
    "report_t1b": "{\"steps_run\": 61036, \"tokens_seen\": 1000013824, \"est_total_steps\": 61035, \"schedule_total_steps\": 61035, \"warmup_steps\": 1, \"lr_factor_first_update\": 0.0, \"optimizer_updates\": 61036}",
    "report_t20m": "{\"steps_run\": 1221, \"tokens_seen\": 20004864, \"est_total_steps\": 1220, \"schedule_total_steps\": 1220, \"warmup_steps\": 1, \"lr_factor_first_update\": 0.0, \"optimizer_updates\": 1221}",
    "report_t8m": "{\"steps_run\": 489, \"tokens_seen\": 8011776, \"est_total_steps\": 488, \"schedule_total_steps\": 488, \"warmup_steps\": 1, \"lr_factor_first_update\": 0.0, \"optimizer_updates\": 489}",
    "report_loop": "{\"steps_run\": 151, \"tokens_seen\": 19328, \"tokens_per_step\": 128, \"est_total_steps\": 150, \"loop_completed\": true, \"nonfinite_loss_steps\": 101, \"losses_read_at_steps\": {\"0\": 5.584117493913947, \"100\": \"nan\"}, \"weights_finite_at_end\": false}"
   }
  },
  "accept_port_source_checks": {
   "program": "kgd/accept_port_source_checks.cmd",
   "source_sha512": "e7ad1280b6abb380e823a75e8a97c2cbe7c58271498eff52181ad35b1387b48369b0a4d1cecb616fb2be8d789f5661f3fee9a59aa7f8567d145967c9c098df8d",
   "runner": "lcufx\\LCUFX_KGD.cmd run --twice (tools\\KGD_ENGINE.cmd host)",
   "expected": "accept",
   "observed": "accept",
   "as_expected": true,
   "exit_code": 0,
   "seconds": 108.8,
   "receipt_chain_head": "2c3ec7ea4a345733106655e7adf17b23df4a668ab53fcbd667651038ab34b0dc0490cc34708885f58f110ad46597b5ad8ed500d45b503a0b4a4739f3da2a2f6d",
   "values": {
    "report_c3": "{\"logits_shape\": [2, 16, 49152], \"scored_positions\": 30, \"loss\": 10.957893340777588, \"finite\": true}",
    "count_adamw": 25191680,
    "count_all": 88630528,
    "count_muon": 63438848,
    "report_c4": "{\"weights_unchanged_after_first_update\": true, \"max_abs_change\": 0.0, \"grad_norm\": 12.668168243901702, \"lr_factor_first_update\": 0.0, \"muon_tensors\": 66, \"adamw_tensors\": 90}"
   }
  },
  "accept_rails_admit_steps": {
   "program": "kgd/accept_rails_admit_steps.cmd",
   "source_sha512": "6c4e7bc9b6b889bb0450dc29d66fa1d5f9a628fc81a19c0df289925f4c31a835682c0a34a236c8f2034a88b2258cd02ed0984893e36bd9307f6abee413f78752",
   "runner": "lcufx\\LCUFX_KGD.cmd run --twice (tools\\KGD_ENGINE.cmd host)",
   "expected": "accept",
   "observed": "accept",
   "as_expected": true,
   "exit_code": 0,
   "seconds": 0.0,
   "receipt_chain_head": "186d09a82a4abff42e530c7d5133552d6620f1981556fbcfff45540c0ae48b40c2ef2d267aba876bfebab20db8ac4c141326a3fbede1dd76816d9f1cfe10c11d",
   "values": {
    "report_steps": "{\"framework\": \"RAILS-8S/1\", \"op\": \"rails_admit\", \"statement\": \"admitted 3 of 6 steps; rank 3\", \"decision\": \"admit\", \"answer\": null, \"admitted\": [\"s1\", \"s2\", \"s6\"], \"rejected\": [\"s3\", \"s4\", \"s5\"], \"rank\": 3, \"total_gain_bits\": 3.3, \"rail_I\": {\"steps\": 6, \"code_dimension\": 3, \"codes\": \"numbers\"}, \"rail_II\": {\"status\": \"exact linear\", \"rule\": \"eta_ind = ||(I - C C+) e||^2 / (||e||^2 + 1e-12): the residual of e after projection on the span C of the admitted codes\"}, \"rail_III\": {\"rule\": \"Admit(8S) iff eta_ind >= eps_ind and gain_bits > eps_gain_bits; rank(C) grows by one per admitted step (Theorem A)\", \"eps_ind\": 0.01, \"eps_gain_bits\": 0.0, \"items\": [{\"name\": \"s1\", \"eta_ind\": 0.9999999999989999, \"gain_bits\": 2.0, \"admitted\": true, \"reason\": \"admitted\"}, {\"name\": \"s2\", \"eta_ind\": 0.9999999999989999, \"gain_bits\": 1.0, \"admitted\": true, \"reason\": \"admitted\"}, {\"name\": \"s3\", \"eta_ind\": 0.0, \"gain_bits\": 0.7, \"admitted\": false, \"reason\": \"not independent: in the span of the admitted codes\"}, {\"name\": \"s4\", \"eta_ind\": 0.9999999999989999, \"gain_bits\": 0.0, \"admitted\": false, \"reason\": \"no gain\"}, {\"name\": \"s5\", \"eta_ind\": 4.999997499998749e-07, \"gain_bits\": 0.4, \"admitted\": false, \"reason\": \"not independent: in the span of the admitted codes\"}, {\"name\": \"s6\", \"eta_ind\": 0.99999999999975, \"gain_bits\": 0.3, \"admitted\": true, \"reason\": \"admitted\"}]}, \"rail_IV\": {\"redundant_steps_rejected\": 2}, \"retraction\": {\"gates_off\": {\"rank\": 3, \"total_gain_bits\": 4.4}, \"by_construction\": true, \"counts_as_evidence\": false, \"note\": \"every step admitted: the gains of redundant steps are counted again\"}}"
   }
  },
  "accept_rails_bayes_disease": {
   "program": "kgd/accept_rails_bayes_disease.cmd",
   "source_sha512": "84a4d4b3a669a534afab618942be0c0ce3894b2b1f7856aa13de48f6503a82ba89ce87542fca62b2c78720739aa0ee368bfeb41f43fa7a619a212bdb8124220f",
   "runner": "lcufx\\LCUFX_KGD.cmd run --twice (tools\\KGD_ENGINE.cmd host)",
   "expected": "accept",
   "observed": "accept",
   "as_expected": true,
   "exit_code": 0,
   "seconds": 0.0,
   "receipt_chain_head": "a9af4f901eee26a48029cfbcfeb31ec4ad84abf1fb0fad41983f2e467c9283724d0b36b9ae93e86dc45ac75a131d98d02d21446cab434da553a6f2f910d382c3",
   "values": {
    "report_jo": "{\"framework\": \"RAILS-8S/1\", \"op\": \"rails_bayes\", \"statement\": \"the most probable hypothesis is healthy, with posterior 0.8389830508474576\", \"decision\": \"answer\", \"answer\": \"healthy\", \"posterior\": {\"disease\": 0.1610169491525425, \"healthy\": 0.8389830508474576}, \"admitted\": [\"positive test\"], \"rejected\": [\"positive test, entered again\"], \"rail_I\": {\"question\": \"Does Jo have the disease, given a positive test? MacKay (2.12)-(2.18)\", \"hypotheses\": [\"disease\", \"healthy\"], \"evidence_items\": 2}, \"rail_II\": {\"status\": \"exact in logs\", \"rule\": \"log posterior = log prior + sum of the admitted log likelihoods - log Z\", \"log_prior\": [-4.605170185988091, -0.01005033585350145], \"log_posterior\": [-1.8262456452992235, -0.17556477433107487], \"log_evidence_nats\": -2.8302178350764176, \"entropy_prior_bits\": 0.08079313589591121, \"entropy_posterior_bits\": 0.636736878655829}, \"rail_III\": {\"rule\": \"admit evidence e iff eta_ind(e) >= eps_ind and gain_bits(e) > eps_gain_bits; eta_ind is computed on the provenance tags; gain_bits = KL(posterior with e || posterior without e)\", \"eps_ind\": 0.5, \"eps_gain_bits\": 0.0, \"rank\": 1, \"items\": [{\"name\": \"positive test\", \"tags\": [\"test:jo-1\"], \"eta_ind\": 0.9999999999989999, \"gain_bits\": 0.44520146884871564, \"admitted\": true, \"reason\": \"admitted\", \"log_evidence_nats\": -2.8302178350764176}, {\"name\": \"positive test, entered again\", \"tags\": [\"test:jo-1\"], \"eta_ind\": 0.0, \"gain_bits\": 1.3708526339677578, \"admitted\": false, \"reason\": \"not independent: its provenance lies in the span of admitted evidence\", \"log_evidence_nats\": -1.6351904085365145}]}, \"rail_IV\": {\"status\": \"structural analogue\", \"rule\": \"answer the most probable hypothesis only if its posterior exceeds lambda/(1+lambda); otherwise abstain\", \"lambda\": 1.0, \"threshold\": 0.5, \"posterior_max\": 0.8389830508474576, \"margin_log_odds\": 1.6506808709681486, \"flip_factor\": 5.210526315789469, \"threshold_margin_log_odds\": 1.6506808709681493, \"reason\": \"the posterior of the best hypothesis is above lambda/(1+lambda)\"}, \"retraction\": {\"gates_off\": {\"posterior\": {\"disease\": 0.7847826086956523, \"healthy\": 0.21521739130434756}, \"answer\": \"disease\"}, \"by_construction\": true, \"counts_as_evidence\": false, \"note\": \"every item admitted, whatever its provenance or gain: the plain product of all likelihoods\"}}"
   }
  },
  "accept_rails_bayes_oliver": {
   "program": "kgd/accept_rails_bayes_oliver.cmd",
   "source_sha512": "f5f6852894679b8651facfb0277c3903f07116b0ba4e7d8b2af93ea411761b1f7e5f4019f581e88e5a07dd9cfdbf0cf1edba2c8eb73cdd7d5a572b038433ef02",
   "runner": "lcufx\\LCUFX_KGD.cmd run --twice (tools\\KGD_ENGINE.cmd host)",
   "expected": "accept",
   "observed": "accept",
   "as_expected": true,
   "exit_code": 0,
   "seconds": 0.0,
   "receipt_chain_head": "46ce656c673cc185c91d22c9aeb797074cdb1d472804c124aa1c2b15802460c4842b10caefac4ae4a2354f63ca9466f1780163085a5ab6f6abd3aa4a165e3be1",
   "values": {
    "report_o1": "{\"framework\": \"RAILS-8S/1\", \"op\": \"rails_bayes\", \"statement\": \"the most probable hypothesis is absent, with posterior 0.5454545454545451\", \"decision\": \"answer\", \"answer\": \"absent\", \"posterior\": {\"present\": 0.45454545454545453, \"absent\": 0.5454545454545451}, \"admitted\": [\"blood types at the scene\"], \"rejected\": [], \"rail_I\": {\"question\": \"Was Oliver one of the two people who left blood (types O and AB; Oliver is O)? MacKay (3.24)-(3.26)\", \"hypotheses\": [\"present\", \"absent\"], \"evidence_items\": 1}, \"rail_II\": {\"status\": \"exact in logs\", \"rule\": \"log posterior = log prior + sum of the admitted log likelihoods - log Z\", \"log_prior\": [-0.6931471805599453, -0.6931471805599453], \"log_posterior\": [-0.7884573603642702, -0.6061358035703162], \"log_evidence_nats\": -4.509860006183766, \"entropy_prior_bits\": 1.0, \"entropy_posterior_bits\": 0.9940302114769567}, \"rail_III\": {\"rule\": \"admit evidence e iff eta_ind(e) >= eps_ind and gain_bits(e) > eps_gain_bits; eta_ind is computed on the provenance tags; gain_bits = KL(posterior with e || posterior without e)\", \"eps_ind\": 0.5, \"eps_gain_bits\": 0.0, \"rank\": 1, \"items\": [{\"name\": \"blood types at the scene\", \"tags\": [\"scene\"], \"eta_ind\": 0.9999999999989999, \"gain_bits\": 0.005969788523042902, \"admitted\": true, \"reason\": \"admitted\", \"log_evidence_nats\": -4.509860006183766}]}, \"rail_IV\": {\"status\": \"structural analogue\", \"rule\": \"answer the most probable hypothesis only if its posterior exceeds lambda/(1+lambda); otherwise abstain\", \"lambda\": 1.0, \"threshold\": 0.5, \"posterior_max\": 0.5454545454545451, \"margin_log_odds\": 0.182321556793954, \"flip_factor\": 1.1999999999999993, \"threshold_margin_log_odds\": 0.18232155679395312, \"reason\": \"the posterior of the best hypothesis is above lambda/(1+lambda)\"}, \"retraction\": {\"gates_off\": {\"posterior\": {\"present\": 0.45454545454545453, \"absent\": 0.5454545454545451}, \"answer\": \"absent\"}, \"by_construction\": true, \"counts_as_evidence\": false, \"note\": \"every item admitted, whatever its provenance or gain: the plain product of all likelihoods\"}}",
    "report_o4": "{\"framework\": \"RAILS-8S/1\", \"op\": \"rails_bayes\", \"statement\": \"abstain: the posterior of the best hypothesis is not above lambda/(1+lambda)\", \"decision\": \"abstain\", \"answer\": null, \"posterior\": {\"present\": 0.45454545454545453, \"absent\": 0.5454545454545451}, \"admitted\": [\"blood types at the scene\"], \"rejected\": [], \"rail_I\": {\"question\": \"The same question, when a wrong answer costs four times what a right one gains\", \"hypotheses\": [\"present\", \"absent\"], \"evidence_items\": 1}, \"rail_II\": {\"status\": \"exact in logs\", \"rule\": \"log posterior = log prior + sum of the admitted log likelihoods - log Z\", \"log_prior\": [-0.6931471805599453, -0.6931471805599453], \"log_posterior\": [-0.7884573603642702, -0.6061358035703162], \"log_evidence_nats\": -4.509860006183766, \"entropy_prior_bits\": 1.0, \"entropy_posterior_bits\": 0.9940302114769567}, \"rail_III\": {\"rule\": \"admit evidence e iff eta_ind(e) >= eps_ind and gain_bits(e) > eps_gain_bits; eta_ind is computed on the provenance tags; gain_bits = KL(posterior with e || posterior without e)\", \"eps_ind\": 0.5, \"eps_gain_bits\": 0.0, \"rank\": 1, \"items\": [{\"name\": \"blood types at the scene\", \"tags\": [\"scene\"], \"eta_ind\": 0.9999999999989999, \"gain_bits\": 0.005969788523042902, \"admitted\": true, \"reason\": \"admitted\", \"log_evidence_nats\": -4.509860006183766}]}, \"rail_IV\": {\"status\": \"structural analogue\", \"rule\": \"answer the most probable hypothesis only if its posterior exceeds lambda/(1+lambda); otherwise abstain\", \"lambda\": 4.0, \"threshold\": 0.8, \"posterior_max\": 0.5454545454545451, \"margin_log_odds\": 0.182321556793954, \"flip_factor\": 1.1999999999999993, \"threshold_margin_log_odds\": -1.2039728043259377, \"reason\": \"the posterior of the best hypothesis is not above lambda/(1+lambda)\"}, \"retraction\": {\"gates_off\": {\"posterior\": {\"present\": 0.45454545454545453, \"absent\": 0.5454545454545451}, \"answer\": null}, \"by_construction\": true, \"counts_as_evidence\": false, \"note\": \"every item admitted, whatever its provenance or gain: the plain product of all likelihoods\"}}",
    "report_oab": "{\"framework\": \"RAILS-8S/1\", \"op\": \"rails_bayes\", \"statement\": \"the most probable hypothesis is present, with posterior 0.9803921568627451\", \"decision\": \"answer\", \"answer\": \"present\", \"posterior\": {\"present\": 0.9803921568627451, \"absent\": 0.019607843137254895}, \"admitted\": [\"blood types at the scene\"], \"rejected\": [], \"rail_I\": {\"question\": \"The same evidence for a suspect of type AB: MacKay (3.27)\", \"hypotheses\": [\"present\", \"absent\"], \"evidence_items\": 1}, \"rail_II\": {\"status\": \"exact in logs\", \"rule\": \"log posterior = log prior + sum of the admitted log likelihoods - log Z\", \"log_prior\": [-0.6931471805599453, -0.6931471805599453], \"log_posterior\": [-0.019802627296179764, -3.931825632724326], \"log_evidence_nats\": -1.1841701770297561, \"entropy_prior_bits\": 1.0, \"entropy_posterior_bits\": 0.13923299905509887}, \"rail_III\": {\"rule\": \"admit evidence e iff eta_ind(e) >= eps_ind and gain_bits(e) > eps_gain_bits; eta_ind is computed on the provenance tags; gain_bits = KL(posterior with e || posterior without e)\", \"eps_ind\": 0.5, \"eps_gain_bits\": 0.0, \"rank\": 1, \"items\": [{\"name\": \"blood types at the scene\", \"tags\": [\"scene\"], \"eta_ind\": 0.9999999999989999, \"gain_bits\": 0.860767000944901, \"admitted\": true, \"reason\": \"admitted\", \"log_evidence_nats\": -1.1841701770297561}]}, \"rail_IV\": {\"status\": \"structural analogue\", \"rule\": \"answer the most probable hypothesis only if its posterior exceeds lambda/(1+lambda); otherwise abstain\", \"lambda\": 1.0, \"threshold\": 0.5, \"posterior_max\": 0.9803921568627451, \"margin_log_odds\": 3.9120230054281464, \"flip_factor\": 50.000000000000014, \"threshold_margin_log_odds\": 3.9120230054281437, \"reason\": \"the posterior of the best hypothesis is above lambda/(1+lambda)\"}, \"retraction\": {\"gates_off\": {\"posterior\": {\"present\": 0.9803921568627451, \"absent\": 0.019607843137254895}, \"answer\": \"present\"}, \"by_construction\": true, \"counts_as_evidence\": false, \"note\": \"every item admitted, whatever its provenance or gain: the plain product of all likelihoods\"}}"
   }
  },
  "accept_rails_bayes_r3": {
   "program": "kgd/accept_rails_bayes_r3.cmd",
   "source_sha512": "d9ef0998c12fa093219204f8c3385967703fffbaea54f00effaf1b911e42c41120ebab9161d63e67903a4ef494e6557cd484b6b71d23245eab85587f96976670",
   "runner": "lcufx\\LCUFX_KGD.cmd run --twice (tools\\KGD_ENGINE.cmd host)",
   "expected": "accept",
   "observed": "accept",
   "as_expected": true,
   "exit_code": 0,
   "seconds": 0.0,
   "receipt_chain_head": "3d476bd4c0806fed97389801189575f1acc52024c9231278fc8f7979e63086fab91a87abc4f4a18e13b779c78de1bea89b581856867c4c40fa1640d5aacd7972",
   "values": {
    "report_r3": "{\"framework\": \"RAILS-8S/1\", \"op\": \"rails_bayes\", \"statement\": \"the most probable hypothesis is s=1, with posterior 0.9\", \"decision\": \"answer\", \"answer\": \"s=1\", \"posterior\": {\"s=0\": 0.10000000000000006, \"s=1\": 0.9}, \"admitted\": [\"r1=0\", \"r2=1\", \"r3=1\"], \"rejected\": [], \"rail_I\": {\"question\": \"Which source bit was sent, given r = 011 over a binary symmetric channel with f = 0.1? MacKay (1.18)-(1.23)\", \"hypotheses\": [\"s=0\", \"s=1\"], \"evidence_items\": 3}, \"rail_II\": {\"status\": \"exact in logs\", \"rule\": \"log posterior = log prior + sum of the admitted log likelihoods - log Z\", \"log_prior\": [-0.6931471805599453, -0.6931471805599453], \"log_posterior\": [-2.302585092994045, -0.10536051565782634], \"log_evidence_nats\": -3.101092789211817, \"entropy_prior_bits\": 1.0, \"entropy_posterior_bits\": 0.46899559358928133}, \"rail_III\": {\"rule\": \"admit evidence e iff eta_ind(e) >= eps_ind and gain_bits(e) > eps_gain_bits; eta_ind is computed on the provenance tags; gain_bits = KL(posterior with e || posterior without e)\", \"eps_ind\": 0.5, \"eps_gain_bits\": 0.0, \"rank\": 3, \"items\": [{\"name\": \"r1=0\", \"tags\": [\"bit:1\"], \"eta_ind\": 0.9999999999989999, \"gain_bits\": 0.5310044064107189, \"admitted\": true, \"reason\": \"admitted\", \"log_evidence_nats\": -0.6931471805599452}, {\"name\": \"r2=1\", \"tags\": [\"bit:2\"], \"eta_ind\": 0.9999999999989999, \"gain_bits\": 0.7369655941662062, \"admitted\": true, \"reason\": \"admitted\", \"log_evidence_nats\": -1.7147984280919268}, {\"name\": \"r3=1\", \"tags\": [\"bit:3\"], \"eta_ind\": 0.9999999999989999, \"gain_bits\": 0.5310044064107188, \"admitted\": true, \"reason\": \"admitted\", \"log_evidence_nats\": -0.6931471805599454}]}, \"rail_IV\": {\"status\": \"structural analogue\", \"rule\": \"answer the most probable hypothesis only if its posterior exceeds lambda/(1+lambda); otherwise abstain\", \"lambda\": 1.0, \"threshold\": 0.5, \"posterior_max\": 0.9, \"margin_log_odds\": 2.1972245773362187, \"flip_factor\": 8.999999999999993, \"threshold_margin_log_odds\": 2.1972245773362196, \"reason\": \"the posterior of the best hypothesis is above lambda/(1+lambda)\"}, \"retraction\": {\"gates_off\": {\"posterior\": {\"s=0\": 0.10000000000000006, \"s=1\": 0.9}, \"answer\": \"s=1\"}, \"by_construction\": true, \"counts_as_evidence\": false, \"note\": \"every item admitted, whatever its provenance or gain: the plain product of all likelihoods\"}}"
   }
  },
  "accept_rails_codelen_unigram": {
   "program": "kgd/accept_rails_codelen_unigram.cmd",
   "source_sha512": "1fe77279f6aef8d2cfe857b216b1e25e029aaeb79c563fb1f31ddbf4987155266134e0d36cdd58239dfb5377ffabb9f439a67e0be4a76c9522aaa606f55ed64c",
   "runner": "lcufx\\LCUFX_KGD.cmd run --twice (tools\\KGD_ENGINE.cmd host)",
   "expected": "accept",
   "observed": "accept",
   "as_expected": true,
   "exit_code": 0,
   "seconds": 0.8,
   "receipt_chain_head": "36d6663e9022c9f51543807f5b62a79ddcb066ade78a42fc93f47b300d5313018b8cab280922b496fdb598c07dd39f881d3ac2b2d09ae10c4849981b4e30591e",
   "values": {
    "report_cl": "{\"framework\": \"RAILS-8S/1\", \"op\": \"rails_codelen\", \"statement\": \"the text decodes back exactly; 218.0 bits against 384.0 for the uniform byte code\", \"decision\": \"consistent\", \"answer\": null, \"witness\": {\"kind\": \"unigram\", \"alpha\": 1.0, \"data_sha512\": \"c17ea34319bad060391761fa490efc01bb51cefdfb44fc200fe90015e4c76942e1be8128dd7be260f3295335c218990c56ef67321fbb41279a1782ccd1787767\", \"bytes\": 3728629}, \"rail_I\": {\"text_bytes\": 48, \"coded_bits\": 218.0, \"roundtrip\": true, \"decode_error\": null}, \"rail_II\": {\"status\": \"exact in logs\", \"rule\": \"ideal code length = sum of -log2 p(byte | prefix); the first byte of a model witness is coded uniformly (8 bits)\", \"ideal_bits\": 217.29806076157266, \"bits_per_byte_ideal\": 4.527042932532764, \"ce_nats\": 3.1047841211286795, \"ce_rule\": \"mean of -ln p over bytes 2..n, the definition of next_token_ce\"}, \"rail_III\": {\"rule\": \"admit the witness as a compressor iff its coded length is below the uniform byte code (8 bits per byte)\", \"baseline_bits\": 384.0, \"gain_bits\": 166.0, \"admitted_as_compressor\": true, \"bits_per_byte_coded\": 4.541666666666667}, \"rail_IV\": {\"status\": \"linearised\", \"rule\": \"coded length = quantised ideal length + a remainder of at most 2 bits (Witten-Neal-Cleary coder)\", \"quantised_ideal_bits\": 217.4744269212754, \"remainder_bits\": 0.5255730787245909, \"bound_bits\": 2.0, \"within_bound\": true, \"prefix_vs_full_max_abs_logit_diff\": null, \"prefix_check\": \"a unigram has no context\"}, \"retraction\": {\"gates_off\": {\"coded_bits\": 384.0}, \"by_construction\": true, \"counts_as_evidence\": false, \"note\": \"witness switched off: the uniform byte code, 8 bits per byte\"}}"
   }
  },
  "accept_rails_meanfield_certified": {
   "program": "kgd/accept_rails_meanfield_certified.cmd",
   "source_sha512": "1c46f6a789c5c6a3ca329c3fb5836f51d41057ed84c40120ee8bf58f8870ef0d732b529ab3333652f498dbf578596a689e330febed1d7d2b5613a99105baf216",
   "runner": "lcufx\\LCUFX_KGD.cmd run --twice (tools\\KGD_ENGINE.cmd host)",
   "expected": "accept",
   "observed": "accept",
   "as_expected": true,
   "exit_code": 0,
   "seconds": 0.0,
   "receipt_chain_head": "4b79da2e6bfae944a4eebf1d87f1606de7a4d3a8e39a65dcf3d868134778e91264b5eab029b27c090de5f51da24803d09d8a09f826e27bcfde46e2737b83ae03",
   "values": {
    "report_mf": "{\"framework\": \"RAILS-8S/1\", \"op\": \"rails_meanfield\", \"statement\": \"coupled claims decided from their exact marginals; the mean-field gate agrees on every claim\", \"decision\": \"decide\", \"answer\": null, \"decisions\": {\"A\": \"accept\", \"B\": \"undecided\", \"C\": \"undecided\"}, \"marginals\": {\"A\": 0.7482784821861646, \"B\": 0.45160463295708003, \"C\": 0.5809526782572996}, \"kappa\": 0.45, \"certified\": true, \"rail_I\": {\"claims\": [\"A\", \"B\", \"C\"], \"model\": \"P(s) proportional to exp(sum_i h_i s_i / 2 + sum_{i<j} J_ij s_i s_j / 2), s_i = +1 when claim i holds\"}, \"rail_II\": {\"status\": \"exact in logs\", \"method\": \"complete enumeration of the 2^n states (MacKay chapter 21)\", \"marginals\": {\"A\": 0.7482784821861646, \"B\": 0.45160463295708003, \"C\": 0.5809526782572996}, \"log_partition\": 2.3071308772352985}, \"rail_III\": {\"rule\": \"mean-field gate p = sigma(h + J(2p - 1)) (8S gate layer); unique fixed point if kappa = max_i sum_j |J_ij| / 2 < 1 (Theorem H)\", \"status\": \"linearised\", \"kappa\": 0.45, \"certified\": true, \"iterations\": 21, \"last_change\": 8.606448886894214e-13, \"meanfield\": {\"A\": 0.7591571102686129, \"B\": 0.4480639413002487, \"C\": 0.5845667072509148}, \"decisions\": {\"A\": \"accept\", \"B\": \"undecided\", \"C\": \"undecided\"}}, \"rail_IV\": {\"max_abs_error_meanfield_vs_exact\": 0.010878628082448327, \"decisions_agree\": true, \"lambda\": 1.5, \"threshold\": 0.6, \"rule\": \"accept a claim if its marginal exceeds lambda/(1+lambda), reject it if the marginal is below 1 - lambda/(1+lambda), otherwise undecided\"}, \"retraction\": {\"gates_off\": {\"marginals\": {\"A\": 0.7685247834990175, \"B\": 0.401312339887548, \"C\": 0.574442516811659}}, \"by_construction\": true, \"counts_as_evidence\": false, \"note\": \"couplings switched off (J = 0): every claim on its own field\"}}"
   }
  },
  "accept_rails_parity_m1": {
   "program": "kgd/accept_rails_parity_m1.cmd",
   "source_sha512": "3b97311cdf35886cbf527713cc55dfb3b43dc76a5a1a4496df486fad0c0776722a64bee4f1537acca3f5f6ec4dea0ad263270b47b99dbe067a4929cff810ebba",
   "runner": "lcufx\\LCUFX_KGD.cmd run --twice (tools\\KGD_ENGINE.cmd host)",
   "expected": "accept",
   "observed": "accept",
   "as_expected": true,
   "exit_code": 0,
   "seconds": 4.2,
   "receipt_chain_head": "d3862b8d9e133b415fd6125fb2d467b2b5812d011b3a8b49c7ac172ba5bf1ae53ee5aebbe35b2b01ca8ecf31aa4f49d469b89af4466d8e83e226fd094c09c7ea",
   "values": {
    "report_cl": "{\"framework\": \"RAILS-8S/1\", \"op\": \"rails_codelen\", \"statement\": \"the text decodes back exactly; 386.0 bits against 384.0 for the uniform byte code\", \"decision\": \"consistent\", \"answer\": null, \"witness\": {\"kind\": \"weights\", \"tier\": \"EXACT-BF16\", \"set_sha512\": \"2824a03df39ab370306ebf0f04f9d72afccb7a171f06997c58eddfac420e697e235b83ae32f9a89b5aa956c7aef785b0920aacbd6ea95eacb74fbb7eae3fb627\", \"vocab\": 256, \"seq_len\": 128}, \"rail_I\": {\"text_bytes\": 48, \"coded_bits\": 386.0, \"roundtrip\": true, \"decode_error\": null}, \"rail_II\": {\"status\": \"exact in logs\", \"rule\": \"ideal code length = sum of -log2 p(byte | prefix); the first byte of a model witness is coded uniformly (8 bits)\", \"ideal_bits\": 385.45269647758187, \"bits_per_byte_ideal\": 8.030264509949623, \"ce_nats\": 5.566601539535843, \"ce_rule\": \"mean of -ln p over bytes 2..n, the definition of next_token_ce\"}, \"rail_III\": {\"rule\": \"admit the witness as a compressor iff its coded length is below the uniform byte code (8 bits per byte)\", \"baseline_bits\": 384.0, \"gain_bits\": -2.0, \"admitted_as_compressor\": false, \"bits_per_byte_coded\": 8.041666666666666}, \"rail_IV\": {\"status\": \"linearised\", \"rule\": \"coded length = quantised ideal length + a remainder of at most 2 bits (Witten-Neal-Cleary coder)\", \"quantised_ideal_bits\": 385.41546708972396, \"remainder_bits\": 0.5845329102760388, \"bound_bits\": 2.0, \"within_bound\": true, \"prefix_vs_full_max_abs_logit_diff\": 0.0, \"prefix_check\": \"the decoder recomputes every step's probabilities from the decoded prefix alone; the encoder used one forward pass over the whole text\"}, \"retraction\": {\"gates_off\": {\"coded_bits\": 384.0}, \"by_construction\": true, \"counts_as_evidence\": false, \"note\": \"witness switched off: the uniform byte code, 8 bits per byte\"}}",
    "loss": 5.566601539535843,
    "report_par": "{\"framework\": \"RAILS-8S/1\", \"op\": \"rails_parity\", \"statement\": \"the three routes agree\", \"decision\": \"decode\", \"answer\": null, \"syndrome\": \"000\", \"corrected\": false, \"outlier\": null, \"value\": 5.566601539535843, \"rail_I\": {\"routes\": {\"host forward (next_token_ce)\": 5.566601539535843, \"dense reference (programs make)\": 5.566601537285965, \"arithmetic-coder route (rails_codelen)\": 5.566601539535843}}, \"rail_II\": {\"status\": \"exact linear over F2\", \"rule\": \"check bits z_ab = [|a - b| > tol], z_bc, z_ac; (z_ab, z_bc) is the syndrome of R3 and z_ac the redundant check, which must equal z_ab xor z_bc\", \"tolerance\": 0.0001, \"relative\": false, \"checks\": {\"ab\": false, \"bc\": false, \"ac\": false}}, \"rail_III\": {\"rule\": \"majority decoding: one deviating route is outvoted; two or more, or an inconsistent syndrome, and the value is refused\", \"decoded_value\": 5.566601539535843}, \"rail_IV\": {\"status\": \"structural analogue\", \"spread\": 2.249877617543916e-09}, \"retraction\": {\"gates_off\": {\"value\": 5.566601539535843}, \"by_construction\": true, \"counts_as_evidence\": false, \"note\": \"checks switched off: the first route is taken as it is\"}}",
    "report_cl2": "{\"framework\": \"RAILS-8S/1\", \"op\": \"rails_codelen\", \"statement\": \"the text decodes back exactly; 388.0 bits against 384.0 for the uniform byte code\", \"decision\": \"consistent\", \"answer\": null, \"witness\": {\"kind\": \"weights\", \"tier\": \"TIER-2\", \"set_sha512\": \"555eb9eb9d0c1de18e04a22fc1517d66516c673d8116b14edba6076655883966d2ba27ca72f958c3da3bda0eb33ce9aced61128480f10f9c07881f2a2c157499\", \"vocab\": 256, \"seq_len\": 128}, \"rail_I\": {\"text_bytes\": 48, \"coded_bits\": 388.0, \"roundtrip\": true, \"decode_error\": null}, \"rail_II\": {\"status\": \"exact in logs\", \"rule\": \"ideal code length = sum of -log2 p(byte | prefix); the first byte of a model witness is coded uniformly (8 bits)\", \"ideal_bits\": 386.7962770842672, \"bits_per_byte_ideal\": 8.0582557725889, \"ce_nats\": 5.58641641420348, \"ce_rule\": \"mean of -ln p over bytes 2..n, the definition of next_token_ce\"}, \"rail_III\": {\"rule\": \"admit the witness as a compressor iff its coded length is below the uniform byte code (8 bits per byte)\", \"baseline_bits\": 384.0, \"gain_bits\": -4.0, \"admitted_as_compressor\": false, \"bits_per_byte_coded\": 8.083333333333334}, \"rail_IV\": {\"status\": \"linearised\", \"rule\": \"coded length = quantised ideal length + a remainder of at most 2 bits (Witten-Neal-Cleary coder)\", \"quantised_ideal_bits\": 386.7697152796265, \"remainder_bits\": 1.2302847203735041, \"bound_bits\": 2.0, \"within_bound\": true, \"prefix_vs_full_max_abs_logit_diff\": 0.0, \"prefix_check\": \"the decoder recomputes every step's probabilities from the decoded prefix alone; the encoder used one forward pass over the whole text\"}, \"retraction\": {\"gates_off\": {\"coded_bits\": 384.0}, \"by_construction\": true, \"counts_as_evidence\": false, \"note\": \"witness switched off: the uniform byte code, 8 bits per byte\"}}",
    "report_par2": "{\"framework\": \"RAILS-8S/1\", \"op\": \"rails_parity\", \"statement\": \"route 'arithmetic-coder route on the Tier-2 view (a wrong route)' disagrees with the other two and is outvoted\", \"decision\": \"decode\", \"answer\": null, \"syndrome\": \"011\", \"corrected\": true, \"outlier\": \"arithmetic-coder route on the Tier-2 view (a wrong route)\", \"value\": 5.566601539535843, \"rail_I\": {\"routes\": {\"host forward (next_token_ce)\": 5.566601539535843, \"dense reference (programs make)\": 5.566601537285965, \"arithmetic-coder route on the Tier-2 view (a wrong route)\": 5.58641641420348}}, \"rail_II\": {\"status\": \"exact linear over F2\", \"rule\": \"check bits z_ab = [|a - b| > tol], z_bc, z_ac; (z_ab, z_bc) is the syndrome of R3 and z_ac the redundant check, which must equal z_ab xor z_bc\", \"tolerance\": 0.0001, \"relative\": false, \"checks\": {\"ab\": false, \"bc\": true, \"ac\": true}}, \"rail_III\": {\"rule\": \"majority decoding: one deviating route is outvoted; two or more, or an inconsistent syndrome, and the value is refused\", \"decoded_value\": 5.566601539535843}, \"rail_IV\": {\"status\": \"structural analogue\", \"spread\": 0.019814876917514823}, \"retraction\": {\"gates_off\": {\"value\": 5.566601539535843}, \"by_construction\": true, \"counts_as_evidence\": false, \"note\": \"checks switched off: the first route is taken as it is\"}}"
   }
  },
  "accept_rails_witness_m1_abstains": {
   "program": "kgd/accept_rails_witness_m1_abstains.cmd",
   "source_sha512": "5c2bfd204fba17262f3db264f3469055b7bcdccf2e28fe544279da2ef6b2770e3012cd8ee23c6e37b9f7cd6d78b93963330c6f84d98199f3e4e2035ddaf6907a",
   "runner": "lcufx\\LCUFX_KGD.cmd run --twice (tools\\KGD_ENGINE.cmd host)",
   "expected": "accept",
   "observed": "accept",
   "as_expected": true,
   "exit_code": 0,
   "seconds": 1.5,
   "receipt_chain_head": "53f76d5b676d0e1d7b086eddbc4542e66f27223d3580ecb916f99d658991109937f62a6dc1cf823211da7f60e40d7cda2927e65a6e8d9c96136b2efb6b3f2b22",
   "values": {
    "report_wq": "{\"framework\": \"RAILS-8S/1\", \"op\": \"rails_witness\", \"statement\": \"abstain: the witness was not admitted, so the decision rests on the prior alone; the two most probable hypotheses are tied\", \"decision\": \"abstain\", \"answer\": null, \"posterior\": {\"inference\": 0.5, \"qzxjvkwbp\": 0.5}, \"witness\": {\"kind\": \"weights\", \"tier\": \"EXACT-BF16\", \"set_sha512\": \"2824a03df39ab370306ebf0f04f9d72afccb7a171f06997c58eddfac420e697e235b83ae32f9a89b5aa956c7aef785b0920aacbd6ea95eacb74fbb7eae3fb627\", \"vocab\": 256, \"seq_len\": 128}, \"rail_I\": {\"prompt\": \"Information theory and \", \"candidates\": [\"inference\", \"qzxjvkwbp\"], \"calibration_bytes\": 64}, \"rail_II\": {\"status\": \"exact in logs\", \"rule\": \"log P(candidate | prompt) = sum over its bytes of log p(byte | everything before it), teacher-forced (complete enumeration over the candidates)\", \"candidate_log_likelihood_nats\": {\"inference\": -54.33079006583552, \"qzxjvkwbp\": -51.85575126874746}, \"candidate_code_bits\": {\"inference\": 78.38276139556027, \"qzxjvkwbp\": 74.81203519699353}, \"calibration_bits\": 518.9117986527069, \"calibration_bits_per_byte\": 8.107996853948546}, \"rail_III\": {\"rule\": \"admit the witness iff it codes the calibration text in fewer bits than the uniform byte code by more than eps_gain_bits (evidence ratio > 1, MacKay chapter 28)\", \"baseline_bits\": 512.0, \"gain_bits\": -6.911798652706921, \"eps_gain_bits\": 0.0, \"admitted\": false, \"reason\": \"the witness predicts the calibration text no better than chance\"}, \"rail_IV\": {\"status\": \"structural analogue\", \"rule\": \"answer the most probable hypothesis only if its posterior exceeds lambda/(1+lambda); otherwise abstain\", \"lambda\": 1.0, \"threshold\": 0.5, \"posterior_max\": 0.5, \"margin_log_odds\": 0.0, \"flip_factor\": 1.0, \"threshold_margin_log_odds\": 0.0, \"reason\": \"the witness was not admitted, so the decision rests on the prior alone; the two most probable hypotheses are tied\", \"equal_lengths\": true, \"length_normalised_ranking_agrees\": true}, \"retraction\": {\"gates_off\": {\"posterior\": {\"inference\": 0.07762668460910498, \"qzxjvkwbp\": 0.9223733153908929}, \"answer\": \"qzxjvkwbp\"}, \"by_construction\": true, \"counts_as_evidence\": false, \"note\": \"witness admitted whatever its gain: the posterior an ungated system would report\"}}"
   }
  },
  "accept_rails_witness_unigram": {
   "program": "kgd/accept_rails_witness_unigram.cmd",
   "source_sha512": "975e9efd448904c5ec40dc85392f7767354ebec1f2afce34fe726641afbaca65ac7ad6855cd9711cbcf3bb7f85b82093089324e547bbd1bc060f848ba42f2c81",
   "runner": "lcufx\\LCUFX_KGD.cmd run --twice (tools\\KGD_ENGINE.cmd host)",
   "expected": "accept",
   "observed": "accept",
   "as_expected": true,
   "exit_code": 0,
   "seconds": 0.8,
   "receipt_chain_head": "2750cc9454cb1466a126621cc090a5ba8b0406f23edacfbe56ffa37803ca185c46cc1f266244d2b41ffa6a3d8f6e77283e731cdaa07dc2b94291caab764bb36c",
   "values": {
    "report_wq": "{\"framework\": \"RAILS-8S/1\", \"op\": \"rails_witness\", \"statement\": \"the answer is 'inference'\", \"decision\": \"answer\", \"answer\": \"inference\", \"posterior\": {\"inference\": 0.9999999999475229, \"qzxjvkwbp\": 5.247718051854563e-11}, \"witness\": {\"kind\": \"unigram\", \"alpha\": 1.0, \"data_sha512\": \"c17ea34319bad060391761fa490efc01bb51cefdfb44fc200fe90015e4c76942e1be8128dd7be260f3295335c218990c56ef67321fbb41279a1782ccd1787767\", \"bytes\": 3728629}, \"rail_I\": {\"prompt\": \"Information theory and \", \"candidates\": [\"inference\", \"qzxjvkwbp\"], \"calibration_bytes\": 64}, \"rail_II\": {\"status\": \"exact in logs\", \"rule\": \"log P(candidate | prompt) = sum over its bytes of log p(byte | everything before it), teacher-forced (complete enumeration over the candidates)\", \"candidate_log_likelihood_nats\": {\"inference\": -26.72645107867926, \"qzxjvkwbp\": -50.397093776238}, \"candidate_code_bits\": {\"inference\": 38.55811843177206, \"qzxjvkwbp\": 72.70763726619461}, \"calibration_bits\": 343.5832238013789, \"calibration_bits_per_byte\": 5.368487871896545}, \"rail_III\": {\"rule\": \"admit the witness iff it codes the calibration text in fewer bits than the uniform byte code by more than eps_gain_bits (evidence ratio > 1, MacKay chapter 28)\", \"baseline_bits\": 512.0, \"gain_bits\": 168.4167761986211, \"eps_gain_bits\": 0.0, \"admitted\": true, \"reason\": \"the witness predicts the calibration text better than chance\"}, \"rail_IV\": {\"status\": \"structural analogue\", \"rule\": \"answer the most probable hypothesis only if its posterior exceeds lambda/(1+lambda); otherwise abstain\", \"lambda\": 1.0, \"threshold\": 0.5, \"posterior_max\": 0.9999999999475229, \"margin_log_odds\": 23.670642697558744, \"flip_factor\": 19055901823.72925, \"threshold_margin_log_odds\": 23.670643588784298, \"reason\": \"the posterior of the best hypothesis is above lambda/(1+lambda)\", \"equal_lengths\": true, \"length_normalised_ranking_agrees\": true}, \"retraction\": {\"gates_off\": {\"posterior\": {\"inference\": 0.9999999999475229, \"qzxjvkwbp\": 5.247718051854563e-11}, \"answer\": \"inference\"}, \"by_construction\": true, \"counts_as_evidence\": false, \"note\": \"witness admitted whatever its gain: the posterior an ungated system would report\"}}"
   }
  },
  "reject_core_header_at_kgd_host": {
   "program": "kgd/reject_core_header_at_kgd_host.cmd",
   "source_sha512": "7088c6b41de01d36e1b0696124af236573305e22d1a4eb12f9010b742d550869b3890c77550291ef69b064852d74c43dd6ff0859100263d5c92f6cc788d7f9ba",
   "runner": "lcufx\\LCUFX_KGD.cmd run --twice (tools\\KGD_ENGINE.cmd host)",
   "expected": "reject",
   "observed": "reject",
   "as_expected": true,
   "exit_code": 2,
   "seconds": 0.0,
   "diagnostic": "required header LCUF-X/0.2+lkvexa.kgd_imq/0.2"
  },
  "reject_kgd_alpha_q16_step_above_half": {
   "program": "core/reject_kgd_alpha_q16_step_above_half.cmd",
   "source_sha512": "6a0d43935724ef165c25b8114551d6cc0117a7d8e77e3b413a2c4611814eaa78f12695985bf4192adfede5ad28ce4efcace88016875a245d997b138852806d38",
   "runner": "lcuf_x.py (the user's LCUF-X/0.2 compiler)",
   "expected": "reject",
   "observed": "not_run",
   "as_expected": false,
   "exit_code": -1,
   "seconds": 0.0
  },
  "reject_kgd_imq_profile_at_core_compiler": {
   "program": "core/reject_kgd_imq_profile_at_core_compiler.cmd",
   "source_sha512": "6ed9691650e8acadc2139d36a8dbab7440933413aba2836a9ff3b064fff2434b1c2c15d603f6f3b03f2fd5596e58f5eacd7bf2b26a3cc3475a9751eb237006b7",
   "runner": "lcuf_x.py (the user's LCUF-X/0.2 compiler)",
   "expected": "reject",
   "observed": "not_run",
   "as_expected": false,
   "exit_code": -1,
   "seconds": 0.0
  },
  "reject_m1_work_underreserve": {
   "program": "kgd/reject_m1_work_underreserve.cmd",
   "source_sha512": "be3896ca00225697a1748aff33535191c1c3479d30fdd90650b0f19c7f3e12e8747e3d73ec0fa6e2f07e31255483881f948ac47ca1265c91cb926a24c6d5b168",
   "runner": "lcufx\\LCUFX_KGD.cmd run --twice (tools\\KGD_ENGINE.cmd host)",
   "expected": "reject",
   "observed": "reject",
   "as_expected": true,
   "exit_code": 2,
   "seconds": 0.0,
   "diagnostic": "line 14: kernel work reservation below modeled minimum (23592959 < 23592960)"
  },
  "reject_m1_wrong_pin": {
   "program": "kgd/reject_m1_wrong_pin.cmd",
   "source_sha512": "e479cb60c2e05c0f5a8ef2b9fe630e65a640e7bb81c2eaccdbf596a089cfbf85d287eea7ef76bb53497e46821bcb95ef8c370f0a7b214b241fd9cf5dd9066db7",
   "runner": "lcufx\\LCUFX_KGD.cmd run --twice (tools\\KGD_ENGINE.cmd host)",
   "expected": "reject",
   "observed": "reject",
   "as_expected": true,
   "exit_code": 2,
   "seconds": 0.0,
   "diagnostic": "line 9: weight set SHA-512 is not the pinned one"
  },
  "reject_m2_tier2_unavailable": {
   "program": "kgd/reject_m2_tier2_unavailable.cmd",
   "source_sha512": "fd1282fd49ce32350d7d65cf7a39329d407282b53bcb1525394ce85b781b43e0bd513d4f806b8790a5b54dcb2d187e3c642f3310a03186bb255322514b8638e5",
   "runner": "lcufx\\LCUFX_KGD.cmd run --twice (tools\\KGD_ENGINE.cmd host)",
   "expected": "reject",
   "observed": "reject",
   "as_expected": true,
   "exit_code": 2,
   "seconds": 0.0,
   "diagnostic": "line 9: tier TIER-2 is not available in a TIER-1 set"
  },
  "reject_rails_meanfield_uncertified": {
   "program": "kgd/reject_rails_meanfield_uncertified.cmd",
   "source_sha512": "18c1e92c602fee84c872ee59afbec5ad84e1fc1fe5ea9634db03a42c71b90643e83610c9794c4999d383d19afb38afdd88a9c5561a521e8a284cb0dc6f6f6b14",
   "runner": "lcufx\\LCUFX_KGD.cmd run --twice (tools\\KGD_ENGINE.cmd host)",
   "expected": "reject",
   "observed": "reject",
   "as_expected": true,
   "exit_code": 2,
   "seconds": 0.0,
   "diagnostic": "rails_meanfield: no contraction certificate: kappa = 1.25 >= 1, so the gate may have several fixed points and its answer is not unique"
  },
  "reject_rails_parity_no_majority": {
   "program": "kgd/reject_rails_parity_no_majority.cmd",
   "source_sha512": "5576312f7b4ef3e72e9124f60601e2f6aea618525d4565d54a29e314c8f6cb06820687f700976175de6035053a142792a3c37387c4c13c58dd3ed35a4f23789f",
   "runner": "lcufx\\LCUFX_KGD.cmd run --twice (tools\\KGD_ENGINE.cmd host)",
   "expected": "reject",
   "observed": "reject",
   "as_expected": true,
   "exit_code": 2,
   "seconds": 1.4,
   "diagnostic": "rails_parity: no majority among the three routes (pairwise checks ab, bc, ac = 111)"
  }
 },
 "all_run_as_expected": true,
 "programs": 26,
 "not_run": [
  "core/accept_kgd_alpha_gate.cmd",
  "core/accept_littlebit_block_sign.cmd",
  "core/reject_kgd_alpha_q16_step_above_half.cmd",
  "core/reject_kgd_imq_profile_at_core_compiler.cmd"
 ],
 "core_compiler": null,
 "kgd_host": {
  "version": "0.3.0",
  "engine_sha512": "d94f95780b65a336da57eb5f96277d6400e0ef6aacfcf4a06eeb0534b8d58e79461c5619bcf8476dd601b7288b3a2425180ccd0125ac2820bf01b8f7bc450900"
 }
}