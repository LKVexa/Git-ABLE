@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): accept_rails_parity_m1.json. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to print the document, with /check to check its SHA-512, or with /extract FILE to write it out.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=accept_rails_parity_m1.json"
set "LB_DOC_TYPE=json"
set "LB_DOC_BYTES=25245"
set "LB_DOC_SHA512=df35ebc12a228b09552d7cd70a287ccee6c346af152f5c5770b2d8c2779cdee16a7b4cdd33f2a8a21c449fa7178cde2698e4a54beb67fbe9866af40433db96d4"
set "LB_SELF=%~f0"
set "LB_ARG=%~1"
set "LB_OUT=%~f2"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$n=[int]$env:LB_DOC_BYTES;$b=[IO.File]::ReadAllBytes($env:LB_SELF);$o=$b.Length-$n;$h=-join((New-Object Security.Cryptography.SHA512Managed).ComputeHash($b,$o,$n)|%%{$_.ToString('x2')});if($h -ne $env:LB_DOC_SHA512){[Console]::Error.WriteLine('LB-DOC/1: the SHA-512 of '+$env:LB_DOC+' differs from LB_DOC_SHA512');exit 1};if($env:LB_ARG -eq '/check'){'ok: '+$env:LB_DOC;exit 0};if($env:LB_ARG -eq '/extract'){$d=New-Object byte[] $n;[Array]::Copy($b,$o,$d,0,$n);[IO.File]::WriteAllBytes($env:LB_OUT,$d);'written: '+$env:LB_OUT;exit 0};[Console]::OutputEncoding=New-Object Text.UTF8Encoding $false;[Console]::Out.Write([Text.Encoding]::UTF8.GetString($b,$o,$n));exit 0"
set "LB_RC=%errorlevel%"
if "%LB_ARG%"=="" pause
exit /b %LB_RC%
rem ---- document ----
{
 "program": "kgd/accept_rails_parity_m1.cmd",
 "source_sha512": "3b97311cdf35886cbf527713cc55dfb3b43dc76a5a1a4496df486fad0c0776722a64bee4f1537acca3f5f6ec4dea0ad263270b47b99dbe067a4929cff810ebba",
 "file_sha512": "ac727a2e7cc54adcfa702d802853c48ad2ccadfe01df2fa53edbbcbeebf285736aefe1f3e472300bd830763dfdedfcba10c0f019ea5809b4816e16d5303532ab",
 "runner": "lcufx\\LCUFX_KGD.cmd run --twice (tools\\KGD_ENGINE.cmd host)",
 "expected": "accept",
 "observed": "accept",
 "as_expected": true,
 "exit_code": 0,
 "seconds": 4.2,
 "output": {
  "status": "host_research_pass",
  "language": "LCUF-X/0.2+lkvexa.kgd_imq/0.2",
  "source_sha512": "3b97311cdf35886cbf527713cc55dfb3b43dc76a5a1a4496df486fad0c0776722a64bee4f1537acca3f5f6ec4dea0ad263270b47b99dbe067a4929cff810ebba",
  "semantic_sha512": "6b17aa2ba7c3877e6bb5ca294a684f4f8324bebd767e409512e3e6bf9fde13f15cad3a2eaff4653a18b3aa0be2ddfaceb8fc45948bd6b6caf44449d372b9368e",
  "values": {
   "exp_cl": "{\"rail_I.roundtrip\": true, \"rail_IV.within_bound\": true, \"rail_III.admitted_as_compressor\": false}",
   "exp_cl2": "{\"rail_I.roundtrip\": true, \"rail_IV.within_bound\": true}",
   "exp_par": "{\"syndrome\": \"000\", \"corrected\": false}",
   "exp_par2": "{\"syndrome\": \"011\", \"corrected\": true, \"outlier\": \"arithmetic-coder route on the Tier-2 view (a wrong route)\"}",
   "key": "rail_II.ce_nats",
   "l00": 0,
   "l01": 1,
   "l02": 2,
   "l03": 3,
   "path": "../../../weights/model1-untrained/exact/manifest.cmd",
   "path2": "../../../weights/model1-untrained/tier2/manifest.cmd",
   "pin": "2824a03df39ab370306ebf0f04f9d72afccb7a171f06997c58eddfac420e697e235b83ae32f9a89b5aa956c7aef785b0920aacbd6ea95eacb74fbb7eae3fb627",
   "pin2": "555eb9eb9d0c1de18e04a22fc1517d66516c673d8116b14edba6076655883966d2ba27ca72f958c3da3bda0eb33ce9aced61128480f10f9c07881f2a2c157499",
   "ps": "{\"routes\": [\"host forward (next_token_ce)\", \"dense reference (programs make)\", \"arithmetic-coder route (rails_codelen)\"], \"tolerance\": 0.0001}",
   "ps2": "{\"routes\": [\"host forward (next_token_ce)\", \"dense reference (programs make)\", \"arithmetic-coder route on the Tier-2 view (a wrong route)\"], \"tolerance\": 0.0001}",
   "ref": 5.566601537285965,
   "text": "07 | complete | See the core specification and v",
   "tier": "exact",
   "tier2": "tier2",
   "report_cl": "{\"framework\": \"RAILS-8S/1\", \"op\": \"rails_codelen\", \"statement\": \"the text decodes back exactly; 386.0 bits against 384.0 for the uniform byte code\", \"decision\": \"consistent\", \"answer\": null, \"witness\": {\"kind\": \"weights\", \"tier\": \"EXACT-BF16\", \"set_sha512\": \"2824a03df39ab370306ebf0f04f9d72afccb7a171f06997c58eddfac420e697e235b83ae32f9a89b5aa956c7aef785b0920aacbd6ea95eacb74fbb7eae3fb627\", \"vocab\": 256, \"seq_len\": 128}, \"rail_I\": {\"text_bytes\": 48, \"coded_bits\": 386.0, \"roundtrip\": true, \"decode_error\": null}, \"rail_II\": {\"status\": \"exact in logs\", \"rule\": \"ideal code length = sum of -log2 p(byte | prefix); the first byte of a model witness is coded uniformly (8 bits)\", \"ideal_bits\": 385.45269647758187, \"bits_per_byte_ideal\": 8.030264509949623, \"ce_nats\": 5.566601539535843, \"ce_rule\": \"mean of -ln p over bytes 2..n, the definition of next_token_ce\"}, \"rail_III\": {\"rule\": \"admit the witness as a compressor iff its coded length is below the uniform byte code (8 bits per byte)\", \"baseline_bits\": 384.0, \"gain_bits\": -2.0, \"admitted_as_compressor\": false, \"bits_per_byte_coded\": 8.041666666666666}, \"rail_IV\": {\"status\": \"linearised\", \"rule\": \"coded length = quantised ideal length + a remainder of at most 2 bits (Witten-Neal-Cleary coder)\", \"quantised_ideal_bits\": 385.41546708972396, \"remainder_bits\": 0.5845329102760388, \"bound_bits\": 2.0, \"within_bound\": true, \"prefix_vs_full_max_abs_logit_diff\": 0.0, \"prefix_check\": \"the decoder recomputes every step's probabilities from the decoded prefix alone; the encoder used one forward pass over the whole text\"}, \"retraction\": {\"gates_off\": {\"coded_bits\": 384.0}, \"by_construction\": true, \"counts_as_evidence\": false, \"note\": \"witness switched off: the uniform byte code, 8 bits per byte\"}}",
   "ce_codelen": 5.566601539535843,
   "loss": 5.566601539535843,
   "report_par": "{\"framework\": \"RAILS-8S/1\", \"op\": \"rails_parity\", \"statement\": \"the three routes agree\", \"decision\": \"decode\", \"answer\": null, \"syndrome\": \"000\", \"corrected\": false, \"outlier\": null, \"value\": 5.566601539535843, \"rail_I\": {\"routes\": {\"host forward (next_token_ce)\": 5.566601539535843, \"dense reference (programs make)\": 5.566601537285965, \"arithmetic-coder route (rails_codelen)\": 5.566601539535843}}, \"rail_II\": {\"status\": \"exact linear over F2\", \"rule\": \"check bits z_ab = [|a - b| > tol], z_bc, z_ac; (z_ab, z_bc) is the syndrome of R3 and z_ac the redundant check, which must equal z_ab xor z_bc\", \"tolerance\": 0.0001, \"relative\": false, \"checks\": {\"ab\": false, \"bc\": false, \"ac\": false}}, \"rail_III\": {\"rule\": \"majority decoding: one deviating route is outvoted; two or more, or an inconsistent syndrome, and the value is refused\", \"decoded_value\": 5.566601539535843}, \"rail_IV\": {\"status\": \"structural analogue\", \"spread\": 2.249877617543916e-09}, \"retraction\": {\"gates_off\": {\"value\": 5.566601539535843}, \"by_construction\": true, \"counts_as_evidence\": false, \"note\": \"checks switched off: the first route is taken as it is\"}}",
   "report_cl2": "{\"framework\": \"RAILS-8S/1\", \"op\": \"rails_codelen\", \"statement\": \"the text decodes back exactly; 388.0 bits against 384.0 for the uniform byte code\", \"decision\": \"consistent\", \"answer\": null, \"witness\": {\"kind\": \"weights\", \"tier\": \"TIER-2\", \"set_sha512\": \"555eb9eb9d0c1de18e04a22fc1517d66516c673d8116b14edba6076655883966d2ba27ca72f958c3da3bda0eb33ce9aced61128480f10f9c07881f2a2c157499\", \"vocab\": 256, \"seq_len\": 128}, \"rail_I\": {\"text_bytes\": 48, \"coded_bits\": 388.0, \"roundtrip\": true, \"decode_error\": null}, \"rail_II\": {\"status\": \"exact in logs\", \"rule\": \"ideal code length = sum of -log2 p(byte | prefix); the first byte of a model witness is coded uniformly (8 bits)\", \"ideal_bits\": 386.7962770842672, \"bits_per_byte_ideal\": 8.0582557725889, \"ce_nats\": 5.58641641420348, \"ce_rule\": \"mean of -ln p over bytes 2..n, the definition of next_token_ce\"}, \"rail_III\": {\"rule\": \"admit the witness as a compressor iff its coded length is below the uniform byte code (8 bits per byte)\", \"baseline_bits\": 384.0, \"gain_bits\": -4.0, \"admitted_as_compressor\": false, \"bits_per_byte_coded\": 8.083333333333334}, \"rail_IV\": {\"status\": \"linearised\", \"rule\": \"coded length = quantised ideal length + a remainder of at most 2 bits (Witten-Neal-Cleary coder)\", \"quantised_ideal_bits\": 386.7697152796265, \"remainder_bits\": 1.2302847203735041, \"bound_bits\": 2.0, \"within_bound\": true, \"prefix_vs_full_max_abs_logit_diff\": 0.0, \"prefix_check\": \"the decoder recomputes every step's probabilities from the decoded prefix alone; the encoder used one forward pass over the whole text\"}, \"retraction\": {\"gates_off\": {\"coded_bits\": 384.0}, \"by_construction\": true, \"counts_as_evidence\": false, \"note\": \"witness switched off: the uniform byte code, 8 bits per byte\"}}",
   "ce_codelen2": 5.58641641420348,
   "report_par2": "{\"framework\": \"RAILS-8S/1\", \"op\": \"rails_parity\", \"statement\": \"route 'arithmetic-coder route on the Tier-2 view (a wrong route)' disagrees with the other two and is outvoted\", \"decision\": \"decode\", \"answer\": null, \"syndrome\": \"011\", \"corrected\": true, \"outlier\": \"arithmetic-coder route on the Tier-2 view (a wrong route)\", \"value\": 5.566601539535843, \"rail_I\": {\"routes\": {\"host forward (next_token_ce)\": 5.566601539535843, \"dense reference (programs make)\": 5.566601537285965, \"arithmetic-coder route on the Tier-2 view (a wrong route)\": 5.58641641420348}}, \"rail_II\": {\"status\": \"exact linear over F2\", \"rule\": \"check bits z_ab = [|a - b| > tol], z_bc, z_ac; (z_ab, z_bc) is the syndrome of R3 and z_ac the redundant check, which must equal z_ab xor z_bc\", \"tolerance\": 0.0001, \"relative\": false, \"checks\": {\"ab\": false, \"bc\": true, \"ac\": true}}, \"rail_III\": {\"rule\": \"majority decoding: one deviating route is outvoted; two or more, or an inconsistent syndrome, and the value is refused\", \"decoded_value\": 5.566601539535843}, \"rail_IV\": {\"status\": \"structural analogue\", \"spread\": 0.019814876917514823}, \"retraction\": {\"gates_off\": {\"value\": 5.566601539535843}, \"by_construction\": true, \"counts_as_evidence\": false, \"note\": \"checks switched off: the first route is taken as it is\"}}"
  },
  "admission": {
   "reserved_work": {
    "s": 7148081528
   },
   "retained_payload_bytes": {
    "s": 59029283
   },
   "peak_modeled_scratch_bytes": {
    "s": 393216
   },
   "minimum_row_work": {
    "c_path": 1,
    "c_pin": 1,
    "c_tier": 1,
    "w": 54525494,
    "c_text": 1,
    "tok": 1,
    "e": 12288,
    "c_l00": 1,
    "a00": 10616832,
    "k00": 1769472,
    "f00": 25165824,
    "c_l01": 1,
    "a01": 10616832,
    "k01": 1769472,
    "f01": 25165824,
    "c_l02": 1,
    "a02": 10616832,
    "k02": 1769472,
    "f02": 25165824,
    "c_l03": 1,
    "a03": 10616832,
    "k03": 1769472,
    "f03": 25165824,
    "hd": 3145728,
    "ce": 12288,
    "c_ref": 1,
    "cl": 3468189696,
    "c_exp_cl": 1,
    "chk_cl": 1,
    "out_cl": 1,
    "c_key": 1,
    "ce_cl": 1,
    "c_ps": 1,
    "par": 3,
    "c_exp_par": 1,
    "chk_par": 1,
    "out_par": 1,
    "c_path2": 1,
    "c_pin2": 1,
    "c_tier2": 1,
    "w2": 3797790,
    "cl2": 3468189696,
    "c_exp_cl2": 1,
    "chk_cl2": 1,
    "out_cl2": 1,
    "ce_cl2": 1,
    "c_ps2": 1,
    "par2": 3,
    "c_exp_par2": 1,
    "chk_par2": 1,
    "out_par2": 1
   }
  },
  "row_order": [
   "c_exp_cl",
   "c_exp_cl2",
   "c_exp_par",
   "c_exp_par2",
   "c_key",
   "c_l00",
   "c_l01",
   "c_l02",
   "c_l03",
   "c_path",
   "c_path2",
   "c_pin",
   "c_pin2",
   "c_ps",
   "c_ps2",
   "c_ref",
   "c_text",
   "c_tier",
   "c_tier2",
   "tok",
   "w",
   "cl",
   "ce_cl",
   "chk_cl",
   "e",
   "a00",
   "k00",
   "f00",
   "a01",
   "k01",
   "f01",
   "a02",
   "k02",
   "f02",
   "a03",
   "k03",
   "f03",
   "hd",
   "ce",
   "out_cl",
   "par",
   "chk_par",
   "out_par",
   "w2",
   "cl2",
   "ce_cl2",
   "chk_cl2",
   "out_cl2",
   "par2",
   "chk_par2",
   "out_par2"
  ],
  "receipts": [
   {
    "scope": "LCUF_X_KGD_HOST_RESEARCH",
    "row": "w",
    "site": "s",
    "profile": "lkvexa.weights.cmd",
    "semantic_sha512": "6b17aa2ba7c3877e6bb5ca294a684f4f8324bebd767e409512e3e6bf9fde13f15cad3a2eaff4653a18b3aa0be2ddfaceb8fc45948bd6b6caf44449d372b9368e",
    "previous_sha512": "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
    "result_sha512": "2824a03df39ab370306ebf0f04f9d72afccb7a171f06997c58eddfac420e697e235b83ae32f9a89b5aa956c7aef785b0920aacbd6ea95eacb74fbb7eae3fb627",
    "sha512": "c98894b135b88d699f80ab39ed37041f5e7a682af82cc5f665c62022adfd418ac95ed2c2ad8ddb14bc78d5b6060e72e184090a74330ae19fdbcfe4a595ce0790"
   },
   {
    "scope": "LCUF_X_KGD_HOST_RESEARCH",
    "row": "cl",
    "site": "s",
    "profile": "lkvexa.rails8s",
    "semantic_sha512": "6b17aa2ba7c3877e6bb5ca294a684f4f8324bebd767e409512e3e6bf9fde13f15cad3a2eaff4653a18b3aa0be2ddfaceb8fc45948bd6b6caf44449d372b9368e",
    "previous_sha512": "c98894b135b88d699f80ab39ed37041f5e7a682af82cc5f665c62022adfd418ac95ed2c2ad8ddb14bc78d5b6060e72e184090a74330ae19fdbcfe4a595ce0790",
    "result_sha512": "130f3a309a87d6cd7681ef4f947b7d582a460b51e0b1282d8becf94c44e27b97cf6b8215478da0270be2e5e22dbf4578903a4bf3332ce238f6c8cbadaef52cab",
    "sha512": "70416f12558b39655c947f3cd2a88cd0d1cacc915f5909bbb92a8db0c5a17c376317cdcf394409f7d5fbff76f0967e70517cb91fe294521cc5b04c68828d2b7b"
   },
   {
    "scope": "LCUF_X_KGD_HOST_RESEARCH",
    "row": "ce",
    "site": "s",
    "profile": "lkvexa.llm",
    "semantic_sha512": "6b17aa2ba7c3877e6bb5ca294a684f4f8324bebd767e409512e3e6bf9fde13f15cad3a2eaff4653a18b3aa0be2ddfaceb8fc45948bd6b6caf44449d372b9368e",
    "previous_sha512": "70416f12558b39655c947f3cd2a88cd0d1cacc915f5909bbb92a8db0c5a17c376317cdcf394409f7d5fbff76f0967e70517cb91fe294521cc5b04c68828d2b7b",
    "result_sha512": "b6303c1b26ee7355b6d150bd420faf116f63e6ce76e443dfdc036434f3aeec8276649e4df9b5db3f2643bc5710b3363d43e5e78cd56690d4c59c7472ecde3cf5",
    "sha512": "743b4ecdede66ebea86bfa7e31c1f928f191c4ed7432694c434086ae38676d814855cb1722eaca9129898732625ad7c439c05847ea8a427f508896bab2248568"
   },
   {
    "scope": "LCUF_X_KGD_HOST_RESEARCH",
    "row": "out_cl",
    "site": "s",
    "profile": "lcuf.evidence",
    "semantic_sha512": "6b17aa2ba7c3877e6bb5ca294a684f4f8324bebd767e409512e3e6bf9fde13f15cad3a2eaff4653a18b3aa0be2ddfaceb8fc45948bd6b6caf44449d372b9368e",
    "previous_sha512": "743b4ecdede66ebea86bfa7e31c1f928f191c4ed7432694c434086ae38676d814855cb1722eaca9129898732625ad7c439c05847ea8a427f508896bab2248568",
    "result_sha512": "130f3a309a87d6cd7681ef4f947b7d582a460b51e0b1282d8becf94c44e27b97cf6b8215478da0270be2e5e22dbf4578903a4bf3332ce238f6c8cbadaef52cab",
    "value": "{\"framework\": \"RAILS-8S/1\", \"op\": \"rails_codelen\", \"statement\": \"the text decodes back exactly; 386.0 bits against 384.0 for the uniform byte code\", \"decision\": \"consistent\", \"answer\": null, \"witness\": {\"kind\": \"weights\", \"tier\": \"EXACT-BF16\", \"set_sha512\": \"2824a03df39ab370306ebf0f04f9d72afccb7a171f06997c58eddfac420e697e235b83ae32f9a89b5aa956c7aef785b0920aacbd6ea95eacb74fbb7eae3fb627\", \"vocab\": 256, \"seq_len\": 128}, \"rail_I\": {\"text_bytes\": 48, \"coded_bits\": 386.0, \"roundtrip\": true, \"decode_error\": null}, \"rail_II\": {\"status\": \"exact in logs\", \"rule\": \"ideal code length = sum of -log2 p(byte | prefix); the first byte of a model witness is coded uniformly (8 bits)\", \"ideal_bits\": 385.45269647758187, \"bits_per_byte_ideal\": 8.030264509949623, \"ce_nats\": 5.566601539535843, \"ce_rule\": \"mean of -ln p over bytes 2..n, the definition of next_token_ce\"}, \"rail_III\": {\"rule\": \"admit the witness as a compressor iff its coded length is below the uniform byte code (8 bits per byte)\", \"baseline_bits\": 384.0, \"gain_bits\": -2.0, \"admitted_as_compressor\": false, \"bits_per_byte_coded\": 8.041666666666666}, \"rail_IV\": {\"status\": \"linearised\", \"rule\": \"coded length = quantised ideal length + a remainder of at most 2 bits (Witten-Neal-Cleary coder)\", \"quantised_ideal_bits\": 385.41546708972396, \"remainder_bits\": 0.5845329102760388, \"bound_bits\": 2.0, \"within_bound\": true, \"prefix_vs_full_max_abs_logit_diff\": 0.0, \"prefix_check\": \"the decoder recomputes every step's probabilities from the decoded prefix alone; the encoder used one forward pass over the whole text\"}, \"retraction\": {\"gates_off\": {\"coded_bits\": 384.0}, \"by_construction\": true, \"counts_as_evidence\": false, \"note\": \"witness switched off: the uniform byte code, 8 bits per byte\"}}",
    "sha512": "646f44837a126b96a91d96b16a65ef8b9b008ffd7d28b3c1ac8c231381c812b16142316d109e2baa2feffecee9a6a1355b55bba372ea5c5de51841dba2dbcbc9"
   },
   {
    "scope": "LCUF_X_KGD_HOST_RESEARCH",
    "row": "par",
    "site": "s",
    "profile": "lkvexa.rails8s",
    "semantic_sha512": "6b17aa2ba7c3877e6bb5ca294a684f4f8324bebd767e409512e3e6bf9fde13f15cad3a2eaff4653a18b3aa0be2ddfaceb8fc45948bd6b6caf44449d372b9368e",
    "previous_sha512": "646f44837a126b96a91d96b16a65ef8b9b008ffd7d28b3c1ac8c231381c812b16142316d109e2baa2feffecee9a6a1355b55bba372ea5c5de51841dba2dbcbc9",
    "result_sha512": "a764474a1c9d3cb9244a1c66b6934f6ddd1de16f811cd995101b2638180484c76e37b6a53dcc41ca08b5fe3118b46eda364deb8e526a58d56140883ca72ccc4d",
    "sha512": "52337d0af5a65d5fae258ec32c3c8d59fb74c795f5ad85b1638eb87d07a4b3d79b42092ee2db03fce4efd42acf4b2abe305cfebeacdb348e1ac8f8d08a43af48"
   },
   {
    "scope": "LCUF_X_KGD_HOST_RESEARCH",
    "row": "out_par",
    "site": "s",
    "profile": "lcuf.evidence",
    "semantic_sha512": "6b17aa2ba7c3877e6bb5ca294a684f4f8324bebd767e409512e3e6bf9fde13f15cad3a2eaff4653a18b3aa0be2ddfaceb8fc45948bd6b6caf44449d372b9368e",
    "previous_sha512": "52337d0af5a65d5fae258ec32c3c8d59fb74c795f5ad85b1638eb87d07a4b3d79b42092ee2db03fce4efd42acf4b2abe305cfebeacdb348e1ac8f8d08a43af48",
    "result_sha512": "a764474a1c9d3cb9244a1c66b6934f6ddd1de16f811cd995101b2638180484c76e37b6a53dcc41ca08b5fe3118b46eda364deb8e526a58d56140883ca72ccc4d",
    "value": "{\"framework\": \"RAILS-8S/1\", \"op\": \"rails_parity\", \"statement\": \"the three routes agree\", \"decision\": \"decode\", \"answer\": null, \"syndrome\": \"000\", \"corrected\": false, \"outlier\": null, \"value\": 5.566601539535843, \"rail_I\": {\"routes\": {\"host forward (next_token_ce)\": 5.566601539535843, \"dense reference (programs make)\": 5.566601537285965, \"arithmetic-coder route (rails_codelen)\": 5.566601539535843}}, \"rail_II\": {\"status\": \"exact linear over F2\", \"rule\": \"check bits z_ab = [|a - b| > tol], z_bc, z_ac; (z_ab, z_bc) is the syndrome of R3 and z_ac the redundant check, which must equal z_ab xor z_bc\", \"tolerance\": 0.0001, \"relative\": false, \"checks\": {\"ab\": false, \"bc\": false, \"ac\": false}}, \"rail_III\": {\"rule\": \"majority decoding: one deviating route is outvoted; two or more, or an inconsistent syndrome, and the value is refused\", \"decoded_value\": 5.566601539535843}, \"rail_IV\": {\"status\": \"structural analogue\", \"spread\": 2.249877617543916e-09}, \"retraction\": {\"gates_off\": {\"value\": 5.566601539535843}, \"by_construction\": true, \"counts_as_evidence\": false, \"note\": \"checks switched off: the first route is taken as it is\"}}",
    "sha512": "f8103b0e16ae04e0e267dfc268d816daa1283d2cb79a484c931ba3c280654328fd9a437cad3a52447083fa4064e34127ecba0cfc27cc72e6ccd4f5616b946984"
   },
   {
    "scope": "LCUF_X_KGD_HOST_RESEARCH",
    "row": "w2",
    "site": "s",
    "profile": "lkvexa.weights.cmd",
    "semantic_sha512": "6b17aa2ba7c3877e6bb5ca294a684f4f8324bebd767e409512e3e6bf9fde13f15cad3a2eaff4653a18b3aa0be2ddfaceb8fc45948bd6b6caf44449d372b9368e",
    "previous_sha512": "f8103b0e16ae04e0e267dfc268d816daa1283d2cb79a484c931ba3c280654328fd9a437cad3a52447083fa4064e34127ecba0cfc27cc72e6ccd4f5616b946984",
    "result_sha512": "555eb9eb9d0c1de18e04a22fc1517d66516c673d8116b14edba6076655883966d2ba27ca72f958c3da3bda0eb33ce9aced61128480f10f9c07881f2a2c157499",
    "sha512": "b2cfbd190ca0a7ddd53c68a63287186b2d49a7a03ce142787205b858ae97c066f0d78a12e2cfa7ff55d17d1fe19094bff0ceaeba1ff4dcb6aa12db7c8cd4a8d1"
   },
   {
    "scope": "LCUF_X_KGD_HOST_RESEARCH",
    "row": "cl2",
    "site": "s",
    "profile": "lkvexa.rails8s",
    "semantic_sha512": "6b17aa2ba7c3877e6bb5ca294a684f4f8324bebd767e409512e3e6bf9fde13f15cad3a2eaff4653a18b3aa0be2ddfaceb8fc45948bd6b6caf44449d372b9368e",
    "previous_sha512": "b2cfbd190ca0a7ddd53c68a63287186b2d49a7a03ce142787205b858ae97c066f0d78a12e2cfa7ff55d17d1fe19094bff0ceaeba1ff4dcb6aa12db7c8cd4a8d1",
    "result_sha512": "dcee6effdc3beea276f791264664867943d094482d4fec88d4a456cea559498c299c3287a8017b36efafce938b1cd847bd9e85fd82cb2777dd44cc8b6ef757af",
    "sha512": "4c670825970a053ca3910ae3ed23cb855ef72b1fb2c4ad1db155211efc0263239c5cc2fbec1fc7974a4cf630e798bdbbe65a3030703793da1c6383c0e387ff90"
   },
   {
    "scope": "LCUF_X_KGD_HOST_RESEARCH",
    "row": "out_cl2",
    "site": "s",
    "profile": "lcuf.evidence",
    "semantic_sha512": "6b17aa2ba7c3877e6bb5ca294a684f4f8324bebd767e409512e3e6bf9fde13f15cad3a2eaff4653a18b3aa0be2ddfaceb8fc45948bd6b6caf44449d372b9368e",
    "previous_sha512": "4c670825970a053ca3910ae3ed23cb855ef72b1fb2c4ad1db155211efc0263239c5cc2fbec1fc7974a4cf630e798bdbbe65a3030703793da1c6383c0e387ff90",
    "result_sha512": "dcee6effdc3beea276f791264664867943d094482d4fec88d4a456cea559498c299c3287a8017b36efafce938b1cd847bd9e85fd82cb2777dd44cc8b6ef757af",
    "value": "{\"framework\": \"RAILS-8S/1\", \"op\": \"rails_codelen\", \"statement\": \"the text decodes back exactly; 388.0 bits against 384.0 for the uniform byte code\", \"decision\": \"consistent\", \"answer\": null, \"witness\": {\"kind\": \"weights\", \"tier\": \"TIER-2\", \"set_sha512\": \"555eb9eb9d0c1de18e04a22fc1517d66516c673d8116b14edba6076655883966d2ba27ca72f958c3da3bda0eb33ce9aced61128480f10f9c07881f2a2c157499\", \"vocab\": 256, \"seq_len\": 128}, \"rail_I\": {\"text_bytes\": 48, \"coded_bits\": 388.0, \"roundtrip\": true, \"decode_error\": null}, \"rail_II\": {\"status\": \"exact in logs\", \"rule\": \"ideal code length = sum of -log2 p(byte | prefix); the first byte of a model witness is coded uniformly (8 bits)\", \"ideal_bits\": 386.7962770842672, \"bits_per_byte_ideal\": 8.0582557725889, \"ce_nats\": 5.58641641420348, \"ce_rule\": \"mean of -ln p over bytes 2..n, the definition of next_token_ce\"}, \"rail_III\": {\"rule\": \"admit the witness as a compressor iff its coded length is below the uniform byte code (8 bits per byte)\", \"baseline_bits\": 384.0, \"gain_bits\": -4.0, \"admitted_as_compressor\": false, \"bits_per_byte_coded\": 8.083333333333334}, \"rail_IV\": {\"status\": \"linearised\", \"rule\": \"coded length = quantised ideal length + a remainder of at most 2 bits (Witten-Neal-Cleary coder)\", \"quantised_ideal_bits\": 386.7697152796265, \"remainder_bits\": 1.2302847203735041, \"bound_bits\": 2.0, \"within_bound\": true, \"prefix_vs_full_max_abs_logit_diff\": 0.0, \"prefix_check\": \"the decoder recomputes every step's probabilities from the decoded prefix alone; the encoder used one forward pass over the whole text\"}, \"retraction\": {\"gates_off\": {\"coded_bits\": 384.0}, \"by_construction\": true, \"counts_as_evidence\": false, \"note\": \"witness switched off: the uniform byte code, 8 bits per byte\"}}",
    "sha512": "136da96c174b3617c0288ef128cc9a0c828dc76d67d669adbdb62d03f9dd1b22fbc35d732203c93983e8df959ff049c4006fcfb8d8886b4a13d95b18aa85613a"
   },
   {
    "scope": "LCUF_X_KGD_HOST_RESEARCH",
    "row": "par2",
    "site": "s",
    "profile": "lkvexa.rails8s",
    "semantic_sha512": "6b17aa2ba7c3877e6bb5ca294a684f4f8324bebd767e409512e3e6bf9fde13f15cad3a2eaff4653a18b3aa0be2ddfaceb8fc45948bd6b6caf44449d372b9368e",
    "previous_sha512": "136da96c174b3617c0288ef128cc9a0c828dc76d67d669adbdb62d03f9dd1b22fbc35d732203c93983e8df959ff049c4006fcfb8d8886b4a13d95b18aa85613a",
    "result_sha512": "5d9d238d451fa36872f7be2acdefd030d464f8260c3a950fd20248bb54f4870913916d43b144bc119715b35c91a268427654518696af0045bbb782c7d6d1f852",
    "sha512": "58b4800475713391a77189e2576ad896a1ae06a9e10b25fbf2b09f5fa6e3641fd2b36f646f057f706accc6fa82a1d2dc6fcf046bd597cf8a9a9449c64db1b359"
   },
   {
    "scope": "LCUF_X_KGD_HOST_RESEARCH",
    "row": "out_par2",
    "site": "s",
    "profile": "lcuf.evidence",
    "semantic_sha512": "6b17aa2ba7c3877e6bb5ca294a684f4f8324bebd767e409512e3e6bf9fde13f15cad3a2eaff4653a18b3aa0be2ddfaceb8fc45948bd6b6caf44449d372b9368e",
    "previous_sha512": "58b4800475713391a77189e2576ad896a1ae06a9e10b25fbf2b09f5fa6e3641fd2b36f646f057f706accc6fa82a1d2dc6fcf046bd597cf8a9a9449c64db1b359",
    "result_sha512": "5d9d238d451fa36872f7be2acdefd030d464f8260c3a950fd20248bb54f4870913916d43b144bc119715b35c91a268427654518696af0045bbb782c7d6d1f852",
    "value": "{\"framework\": \"RAILS-8S/1\", \"op\": \"rails_parity\", \"statement\": \"route 'arithmetic-coder route on the Tier-2 view (a wrong route)' disagrees with the other two and is outvoted\", \"decision\": \"decode\", \"answer\": null, \"syndrome\": \"011\", \"corrected\": true, \"outlier\": \"arithmetic-coder route on the Tier-2 view (a wrong route)\", \"value\": 5.566601539535843, \"rail_I\": {\"routes\": {\"host forward (next_token_ce)\": 5.566601539535843, \"dense reference (programs make)\": 5.566601537285965, \"arithmetic-coder route on the Tier-2 view (a wrong route)\": 5.58641641420348}}, \"rail_II\": {\"status\": \"exact linear over F2\", \"rule\": \"check bits z_ab = [|a - b| > tol], z_bc, z_ac; (z_ab, z_bc) is the syndrome of R3 and z_ac the redundant check, which must equal z_ab xor z_bc\", \"tolerance\": 0.0001, \"relative\": false, \"checks\": {\"ab\": false, \"bc\": true, \"ac\": true}}, \"rail_III\": {\"rule\": \"majority decoding: one deviating route is outvoted; two or more, or an inconsistent syndrome, and the value is refused\", \"decoded_value\": 5.566601539535843}, \"rail_IV\": {\"status\": \"structural analogue\", \"spread\": 0.019814876917514823}, \"retraction\": {\"gates_off\": {\"value\": 5.566601539535843}, \"by_construction\": true, \"counts_as_evidence\": false, \"note\": \"checks switched off: the first route is taken as it is\"}}",
    "sha512": "d3862b8d9e133b415fd6125fb2d467b2b5812d011b3a8b49c7ac172ba5bf1ae53ee5aebbe35b2b01ca8ecf31aa4f49d469b89af4466d8e83e226fd094c09c7ea"
   }
  ],
  "receipt_chain_head": "d3862b8d9e133b415fd6125fb2d467b2b5812d011b3a8b49c7ac172ba5bf1ae53ee5aebbe35b2b01ca8ecf31aa4f49d469b89af4466d8e83e226fd094c09c7ea",
  "evaluated_twice": true,
  "native_cmd_execution": false
 }
}