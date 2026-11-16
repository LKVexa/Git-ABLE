@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): accept_rails_codelen_unigram.json. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to print the document, with /check to check its SHA-512, or with /extract FILE to write it out.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=accept_rails_codelen_unigram.json"
set "LB_DOC_TYPE=json"
set "LB_DOC_BYTES=7809"
set "LB_DOC_SHA512=ffee2f19717d271f543e2cf8bc6d412abdae6121a5ad0d1125def095df7e2c58f7e74ad5a49c6793acd904fd2930fae21eb2ed407d5f8eca5e3b55c0668448b8"
set "LB_SELF=%~f0"
set "LB_ARG=%~1"
set "LB_OUT=%~f2"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$n=[int]$env:LB_DOC_BYTES;$b=[IO.File]::ReadAllBytes($env:LB_SELF);$o=$b.Length-$n;$h=-join((New-Object Security.Cryptography.SHA512Managed).ComputeHash($b,$o,$n)|%%{$_.ToString('x2')});if($h -ne $env:LB_DOC_SHA512){[Console]::Error.WriteLine('LB-DOC/1: the SHA-512 of '+$env:LB_DOC+' differs from LB_DOC_SHA512');exit 1};if($env:LB_ARG -eq '/check'){'ok: '+$env:LB_DOC;exit 0};if($env:LB_ARG -eq '/extract'){$d=New-Object byte[] $n;[Array]::Copy($b,$o,$d,0,$n);[IO.File]::WriteAllBytes($env:LB_OUT,$d);'written: '+$env:LB_OUT;exit 0};[Console]::OutputEncoding=New-Object Text.UTF8Encoding $false;[Console]::Out.Write([Text.Encoding]::UTF8.GetString($b,$o,$n));exit 0"
set "LB_RC=%errorlevel%"
if "%LB_ARG%"=="" pause
exit /b %LB_RC%
rem ---- document ----
{
 "program": "kgd/accept_rails_codelen_unigram.cmd",
 "source_sha512": "1fe77279f6aef8d2cfe857b216b1e25e029aaeb79c563fb1f31ddbf4987155266134e0d36cdd58239dfb5377ffabb9f439a67e0be4a76c9522aaa606f55ed64c",
 "file_sha512": "9546115606816f607ae9ffcd0cf7a3a00725575255d5577e73bcc3d38b8e9b4318aa2188bff232c5e0e8d4735fdbcfce809ee53515e25082c3c0851b77740c7f",
 "runner": "lcufx\\LCUFX_KGD.cmd run --twice (tools\\KGD_ENGINE.cmd host)",
 "expected": "accept",
 "observed": "accept",
 "as_expected": true,
 "exit_code": 0,
 "seconds": 0.8,
 "output": {
  "status": "host_research_pass",
  "language": "LCUF-X/0.2+lkvexa.kgd_imq/0.2",
  "source_sha512": "1fe77279f6aef8d2cfe857b216b1e25e029aaeb79c563fb1f31ddbf4987155266134e0d36cdd58239dfb5377ffabb9f439a67e0be4a76c9522aaa606f55ed64c",
  "semantic_sha512": "82e7b2427cc1639b1a7db1de9ca4bce0c6b72f7756731b3dccbcc1bb829db2001f98c16c5d6d356629879d1e7f5d143f21a21067acc4676e9392fc319cb9ac38",
  "values": {
   "alpha": 1.0,
   "dpin": "c17ea34319bad060391761fa490efc01bb51cefdfb44fc200fe90015e4c76942e1be8128dd7be260f3295335c218990c56ef67321fbb41279a1782ccd1787767",
   "exp_cl": "{\"rail_I.roundtrip\": true, \"rail_IV.within_bound\": true, \"rail_III.admitted_as_compressor\": true}",
   "shards": "[\"../../../data/train_bytes_00.cmd\", \"../../../data/train_bytes_01.cmd\"]",
   "text": "07 | complete | See the core specification and v",
   "report_cl": "{\"framework\": \"RAILS-8S/1\", \"op\": \"rails_codelen\", \"statement\": \"the text decodes back exactly; 218.0 bits against 384.0 for the uniform byte code\", \"decision\": \"consistent\", \"answer\": null, \"witness\": {\"kind\": \"unigram\", \"alpha\": 1.0, \"data_sha512\": \"c17ea34319bad060391761fa490efc01bb51cefdfb44fc200fe90015e4c76942e1be8128dd7be260f3295335c218990c56ef67321fbb41279a1782ccd1787767\", \"bytes\": 3728629}, \"rail_I\": {\"text_bytes\": 48, \"coded_bits\": 218.0, \"roundtrip\": true, \"decode_error\": null}, \"rail_II\": {\"status\": \"exact in logs\", \"rule\": \"ideal code length = sum of -log2 p(byte | prefix); the first byte of a model witness is coded uniformly (8 bits)\", \"ideal_bits\": 217.29806076157266, \"bits_per_byte_ideal\": 4.527042932532764, \"ce_nats\": 3.1047841211286795, \"ce_rule\": \"mean of -ln p over bytes 2..n, the definition of next_token_ce\"}, \"rail_III\": {\"rule\": \"admit the witness as a compressor iff its coded length is below the uniform byte code (8 bits per byte)\", \"baseline_bits\": 384.0, \"gain_bits\": 166.0, \"admitted_as_compressor\": true, \"bits_per_byte_coded\": 4.541666666666667}, \"rail_IV\": {\"status\": \"linearised\", \"rule\": \"coded length = quantised ideal length + a remainder of at most 2 bits (Witten-Neal-Cleary coder)\", \"quantised_ideal_bits\": 217.4744269212754, \"remainder_bits\": 0.5255730787245909, \"bound_bits\": 2.0, \"within_bound\": true, \"prefix_vs_full_max_abs_logit_diff\": null, \"prefix_check\": \"a unigram has no context\"}, \"retraction\": {\"gates_off\": {\"coded_bits\": 384.0}, \"by_construction\": true, \"counts_as_evidence\": false, \"note\": \"witness switched off: the uniform byte code, 8 bits per byte\"}}"
  },
  "admission": {
   "reserved_work": {
    "s": 33130908
   },
   "retained_payload_bytes": {
    "s": 6497
   },
   "peak_modeled_scratch_bytes": {
    "s": 3730677
   },
   "minimum_row_work": {
    "c_shards": 1,
    "c_dpin": 1,
    "c_alpha": 1,
    "u": 33106324,
    "c_text": 1,
    "cl": 24577,
    "c_exp_cl": 1,
    "chk_cl": 1,
    "out_cl": 1
   }
  },
  "row_order": [
   "c_alpha",
   "c_dpin",
   "c_exp_cl",
   "c_shards",
   "c_text",
   "u",
   "cl",
   "chk_cl",
   "out_cl"
  ],
  "receipts": [
   {
    "scope": "LCUF_X_KGD_HOST_RESEARCH",
    "row": "u",
    "site": "s",
    "profile": "lkvexa.rails8s",
    "semantic_sha512": "82e7b2427cc1639b1a7db1de9ca4bce0c6b72f7756731b3dccbcc1bb829db2001f98c16c5d6d356629879d1e7f5d143f21a21067acc4676e9392fc319cb9ac38",
    "previous_sha512": "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
    "result_sha512": "209ef0583820d261ee11236cd8fe6566fc1878d571b73f22033fee9fe6e71c6d4b52aa9167be2519278331d4a7c108ec5b5c2eb3178385bf91850d59de656884",
    "sha512": "f5c94603d6504a33d1fac32724f240c48e856161c32d7d48fe77fb233760b26fc70854acd9a1a61090046be0a7407edec4c93943e59da3c5ddf85ebf2affe59c"
   },
   {
    "scope": "LCUF_X_KGD_HOST_RESEARCH",
    "row": "cl",
    "site": "s",
    "profile": "lkvexa.rails8s",
    "semantic_sha512": "82e7b2427cc1639b1a7db1de9ca4bce0c6b72f7756731b3dccbcc1bb829db2001f98c16c5d6d356629879d1e7f5d143f21a21067acc4676e9392fc319cb9ac38",
    "previous_sha512": "f5c94603d6504a33d1fac32724f240c48e856161c32d7d48fe77fb233760b26fc70854acd9a1a61090046be0a7407edec4c93943e59da3c5ddf85ebf2affe59c",
    "result_sha512": "fa4601a34378c94568034cae8fedbb1f95e016c4952e080785f2bd07066e0d928c5134c4144a4199218e2a4a63a28e83165b2ba4335e676c349e5ee58c9357cf",
    "sha512": "fcc783a2588130fd088a4395e13e0a250dce90f4480ca8478d3ccf87bb003d31f2efcdc5bdbf649d2da6538028f2e0a425fd3642a4e01753e75904ce61a3f15d"
   },
   {
    "scope": "LCUF_X_KGD_HOST_RESEARCH",
    "row": "out_cl",
    "site": "s",
    "profile": "lcuf.evidence",
    "semantic_sha512": "82e7b2427cc1639b1a7db1de9ca4bce0c6b72f7756731b3dccbcc1bb829db2001f98c16c5d6d356629879d1e7f5d143f21a21067acc4676e9392fc319cb9ac38",
    "previous_sha512": "fcc783a2588130fd088a4395e13e0a250dce90f4480ca8478d3ccf87bb003d31f2efcdc5bdbf649d2da6538028f2e0a425fd3642a4e01753e75904ce61a3f15d",
    "result_sha512": "fa4601a34378c94568034cae8fedbb1f95e016c4952e080785f2bd07066e0d928c5134c4144a4199218e2a4a63a28e83165b2ba4335e676c349e5ee58c9357cf",
    "value": "{\"framework\": \"RAILS-8S/1\", \"op\": \"rails_codelen\", \"statement\": \"the text decodes back exactly; 218.0 bits against 384.0 for the uniform byte code\", \"decision\": \"consistent\", \"answer\": null, \"witness\": {\"kind\": \"unigram\", \"alpha\": 1.0, \"data_sha512\": \"c17ea34319bad060391761fa490efc01bb51cefdfb44fc200fe90015e4c76942e1be8128dd7be260f3295335c218990c56ef67321fbb41279a1782ccd1787767\", \"bytes\": 3728629}, \"rail_I\": {\"text_bytes\": 48, \"coded_bits\": 218.0, \"roundtrip\": true, \"decode_error\": null}, \"rail_II\": {\"status\": \"exact in logs\", \"rule\": \"ideal code length = sum of -log2 p(byte | prefix); the first byte of a model witness is coded uniformly (8 bits)\", \"ideal_bits\": 217.29806076157266, \"bits_per_byte_ideal\": 4.527042932532764, \"ce_nats\": 3.1047841211286795, \"ce_rule\": \"mean of -ln p over bytes 2..n, the definition of next_token_ce\"}, \"rail_III\": {\"rule\": \"admit the witness as a compressor iff its coded length is below the uniform byte code (8 bits per byte)\", \"baseline_bits\": 384.0, \"gain_bits\": 166.0, \"admitted_as_compressor\": true, \"bits_per_byte_coded\": 4.541666666666667}, \"rail_IV\": {\"status\": \"linearised\", \"rule\": \"coded length = quantised ideal length + a remainder of at most 2 bits (Witten-Neal-Cleary coder)\", \"quantised_ideal_bits\": 217.4744269212754, \"remainder_bits\": 0.5255730787245909, \"bound_bits\": 2.0, \"within_bound\": true, \"prefix_vs_full_max_abs_logit_diff\": null, \"prefix_check\": \"a unigram has no context\"}, \"retraction\": {\"gates_off\": {\"coded_bits\": 384.0}, \"by_construction\": true, \"counts_as_evidence\": false, \"note\": \"witness switched off: the uniform byte code, 8 bits per byte\"}}",
    "sha512": "36d6663e9022c9f51543807f5b62a79ddcb066ade78a42fc93f47b300d5313018b8cab280922b496fdb598c07dd39f881d3ac2b2d09ae10c4849981b4e30591e"
   }
  ],
  "receipt_chain_head": "36d6663e9022c9f51543807f5b62a79ddcb066ade78a42fc93f47b300d5313018b8cab280922b496fdb598c07dd39f881d3ac2b2d09ae10c4849981b4e30591e",
  "evaluated_twice": true,
  "native_cmd_execution": false
 }
}