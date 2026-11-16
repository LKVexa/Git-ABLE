@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): accept_rails_meanfield_certified.json. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to print the document, with /check to check its SHA-512, or with /extract FILE to write it out.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=accept_rails_meanfield_certified.json"
set "LB_DOC_TYPE=json"
set "LB_DOC_BYTES=7711"
set "LB_DOC_SHA512=7cbba53ad70699b78473ca4defc98e87990297ebe871442983d8d351903c37338c1d346e247a1eebd4cf2da1e547c71abe9c823e2e04b87995d1f8a32146bea9"
set "LB_SELF=%~f0"
set "LB_ARG=%~1"
set "LB_OUT=%~f2"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$n=[int]$env:LB_DOC_BYTES;$b=[IO.File]::ReadAllBytes($env:LB_SELF);$o=$b.Length-$n;$h=-join((New-Object Security.Cryptography.SHA512Managed).ComputeHash($b,$o,$n)|%%{$_.ToString('x2')});if($h -ne $env:LB_DOC_SHA512){[Console]::Error.WriteLine('LB-DOC/1: the SHA-512 of '+$env:LB_DOC+' differs from LB_DOC_SHA512');exit 1};if($env:LB_ARG -eq '/check'){'ok: '+$env:LB_DOC;exit 0};if($env:LB_ARG -eq '/extract'){$d=New-Object byte[] $n;[Array]::Copy($b,$o,$d,0,$n);[IO.File]::WriteAllBytes($env:LB_OUT,$d);'written: '+$env:LB_OUT;exit 0};[Console]::OutputEncoding=New-Object Text.UTF8Encoding $false;[Console]::Out.Write([Text.Encoding]::UTF8.GetString($b,$o,$n));exit 0"
set "LB_RC=%errorlevel%"
if "%LB_ARG%"=="" pause
exit /b %LB_RC%
rem ---- document ----
{
 "program": "kgd/accept_rails_meanfield_certified.cmd",
 "source_sha512": "1c46f6a789c5c6a3ca329c3fb5836f51d41057ed84c40120ee8bf58f8870ef0d732b529ab3333652f498dbf578596a689e330febed1d7d2b5613a99105baf216",
 "file_sha512": "aade4d16b13269d427ed31706015707cdced7e65fac1673fbf9664880c79c53d2501c3fabdd0ef99b22ee04ad3c6b79dbe33b7d29dc8128daeda56693bc18305",
 "runner": "lcufx\\LCUFX_KGD.cmd run --twice (tools\\KGD_ENGINE.cmd host)",
 "expected": "accept",
 "observed": "accept",
 "as_expected": true,
 "exit_code": 0,
 "seconds": 0.0,
 "output": {
  "status": "host_research_pass",
  "language": "LCUF-X/0.2+lkvexa.kgd_imq/0.2",
  "source_sha512": "1c46f6a789c5c6a3ca329c3fb5836f51d41057ed84c40120ee8bf58f8870ef0d732b529ab3333652f498dbf578596a689e330febed1d7d2b5613a99105baf216",
  "semantic_sha512": "a1e6527b8baa17321a55411dee253d87c956dc749117aa36fc12a77a093270e9c6b2b80483e996c1119c5b036db9db8c57b4403f6521a001a719cbb619f01e8e",
  "values": {
   "exp_mf": "{\"certified\": true, \"kappa\": {\"center\": 0.45, \"tolerance\": 1e-15}, \"marginals.A\": {\"center\": 0.7482784821861647, \"tolerance\": 1e-12}, \"marginals.B\": {\"center\": 0.45160463295708014, \"tolerance\": 1e-12}, \"marginals.C\": {\"center\": 0.5809526782572996, \"tolerance\": 1e-12}, \"rail_III.meanfield.A\": {\"center\": 0.759157110268757, \"tolerance\": 1e-09}, \"rail_III.meanfield.B\": {\"center\": 0.44806394130017624, \"tolerance\": 1e-09}, \"rail_III.meanfield.C\": {\"center\": 0.5845667072507617, \"tolerance\": 1e-09}, \"decisions.A\": \"accept\", \"decisions.B\": \"undecided\", \"decisions.C\": \"undecided\"}",
   "spec_mf": "{\"question\": \"Three coupled claims: A supports B, B contradicts C (MacKay chapters 31 and 33)\", \"claims\": [\"A\", \"B\", \"C\"], \"h\": [1.2, -0.4, 0.3], \"J\": [[0, 0.5, 0], [0.5, 0, -0.4], [0, -0.4, 0]], \"lambda\": 1.5}",
   "report_mf": "{\"framework\": \"RAILS-8S/1\", \"op\": \"rails_meanfield\", \"statement\": \"coupled claims decided from their exact marginals; the mean-field gate agrees on every claim\", \"decision\": \"decide\", \"answer\": null, \"decisions\": {\"A\": \"accept\", \"B\": \"undecided\", \"C\": \"undecided\"}, \"marginals\": {\"A\": 0.7482784821861646, \"B\": 0.45160463295708003, \"C\": 0.5809526782572996}, \"kappa\": 0.45, \"certified\": true, \"rail_I\": {\"claims\": [\"A\", \"B\", \"C\"], \"model\": \"P(s) proportional to exp(sum_i h_i s_i / 2 + sum_{i<j} J_ij s_i s_j / 2), s_i = +1 when claim i holds\"}, \"rail_II\": {\"status\": \"exact in logs\", \"method\": \"complete enumeration of the 2^n states (MacKay chapter 21)\", \"marginals\": {\"A\": 0.7482784821861646, \"B\": 0.45160463295708003, \"C\": 0.5809526782572996}, \"log_partition\": 2.3071308772352985}, \"rail_III\": {\"rule\": \"mean-field gate p = sigma(h + J(2p - 1)) (8S gate layer); unique fixed point if kappa = max_i sum_j |J_ij| / 2 < 1 (Theorem H)\", \"status\": \"linearised\", \"kappa\": 0.45, \"certified\": true, \"iterations\": 21, \"last_change\": 8.606448886894214e-13, \"meanfield\": {\"A\": 0.7591571102686129, \"B\": 0.4480639413002487, \"C\": 0.5845667072509148}, \"decisions\": {\"A\": \"accept\", \"B\": \"undecided\", \"C\": \"undecided\"}}, \"rail_IV\": {\"max_abs_error_meanfield_vs_exact\": 0.010878628082448327, \"decisions_agree\": true, \"lambda\": 1.5, \"threshold\": 0.6, \"rule\": \"accept a claim if its marginal exceeds lambda/(1+lambda), reject it if the marginal is below 1 - lambda/(1+lambda), otherwise undecided\"}, \"retraction\": {\"gates_off\": {\"marginals\": {\"A\": 0.7685247834990175, \"B\": 0.401312339887548, \"C\": 0.574442516811659}}, \"by_construction\": true, \"counts_as_evidence\": false, \"note\": \"couplings switched off (J = 0): every claim on its own field\"}}"
  },
  "admission": {
   "reserved_work": {
    "s": 90076
   },
   "retained_payload_bytes": {
    "s": 4883
   },
   "peak_modeled_scratch_bytes": {
    "s": 136
   },
   "minimum_row_work": {
    "c_spec_mf": 1,
    "mf": 90072,
    "c_exp_mf": 1,
    "chk_mf": 1,
    "out_mf": 1
   }
  },
  "row_order": [
   "c_exp_mf",
   "c_spec_mf",
   "mf",
   "chk_mf",
   "out_mf"
  ],
  "receipts": [
   {
    "scope": "LCUF_X_KGD_HOST_RESEARCH",
    "row": "mf",
    "site": "s",
    "profile": "lkvexa.rails8s",
    "semantic_sha512": "a1e6527b8baa17321a55411dee253d87c956dc749117aa36fc12a77a093270e9c6b2b80483e996c1119c5b036db9db8c57b4403f6521a001a719cbb619f01e8e",
    "previous_sha512": "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
    "result_sha512": "be13e33301ea8a0fbfe6dc0a543a7ec92e88ef665463543b118c4669d44f5a544640e914c88cb3e729f8c0e09c79e9fd23da8ad089de1360433a126d543a99e9",
    "sha512": "fb75c9c8d3ea64fac24bf515b2e4c2bcb5b59b1ef6b40c2351c5f09272b2b77167ed143edc3902a8a85673041f20d60f6f3492ee6ab0315793ac9eedbe2f108d"
   },
   {
    "scope": "LCUF_X_KGD_HOST_RESEARCH",
    "row": "out_mf",
    "site": "s",
    "profile": "lcuf.evidence",
    "semantic_sha512": "a1e6527b8baa17321a55411dee253d87c956dc749117aa36fc12a77a093270e9c6b2b80483e996c1119c5b036db9db8c57b4403f6521a001a719cbb619f01e8e",
    "previous_sha512": "fb75c9c8d3ea64fac24bf515b2e4c2bcb5b59b1ef6b40c2351c5f09272b2b77167ed143edc3902a8a85673041f20d60f6f3492ee6ab0315793ac9eedbe2f108d",
    "result_sha512": "be13e33301ea8a0fbfe6dc0a543a7ec92e88ef665463543b118c4669d44f5a544640e914c88cb3e729f8c0e09c79e9fd23da8ad089de1360433a126d543a99e9",
    "value": "{\"framework\": \"RAILS-8S/1\", \"op\": \"rails_meanfield\", \"statement\": \"coupled claims decided from their exact marginals; the mean-field gate agrees on every claim\", \"decision\": \"decide\", \"answer\": null, \"decisions\": {\"A\": \"accept\", \"B\": \"undecided\", \"C\": \"undecided\"}, \"marginals\": {\"A\": 0.7482784821861646, \"B\": 0.45160463295708003, \"C\": 0.5809526782572996}, \"kappa\": 0.45, \"certified\": true, \"rail_I\": {\"claims\": [\"A\", \"B\", \"C\"], \"model\": \"P(s) proportional to exp(sum_i h_i s_i / 2 + sum_{i<j} J_ij s_i s_j / 2), s_i = +1 when claim i holds\"}, \"rail_II\": {\"status\": \"exact in logs\", \"method\": \"complete enumeration of the 2^n states (MacKay chapter 21)\", \"marginals\": {\"A\": 0.7482784821861646, \"B\": 0.45160463295708003, \"C\": 0.5809526782572996}, \"log_partition\": 2.3071308772352985}, \"rail_III\": {\"rule\": \"mean-field gate p = sigma(h + J(2p - 1)) (8S gate layer); unique fixed point if kappa = max_i sum_j |J_ij| / 2 < 1 (Theorem H)\", \"status\": \"linearised\", \"kappa\": 0.45, \"certified\": true, \"iterations\": 21, \"last_change\": 8.606448886894214e-13, \"meanfield\": {\"A\": 0.7591571102686129, \"B\": 0.4480639413002487, \"C\": 0.5845667072509148}, \"decisions\": {\"A\": \"accept\", \"B\": \"undecided\", \"C\": \"undecided\"}}, \"rail_IV\": {\"max_abs_error_meanfield_vs_exact\": 0.010878628082448327, \"decisions_agree\": true, \"lambda\": 1.5, \"threshold\": 0.6, \"rule\": \"accept a claim if its marginal exceeds lambda/(1+lambda), reject it if the marginal is below 1 - lambda/(1+lambda), otherwise undecided\"}, \"retraction\": {\"gates_off\": {\"marginals\": {\"A\": 0.7685247834990175, \"B\": 0.401312339887548, \"C\": 0.574442516811659}}, \"by_construction\": true, \"counts_as_evidence\": false, \"note\": \"couplings switched off (J = 0): every claim on its own field\"}}",
    "sha512": "4b79da2e6bfae944a4eebf1d87f1606de7a4d3a8e39a65dcf3d868134778e91264b5eab029b27c090de5f51da24803d09d8a09f826e27bcfde46e2737b83ae03"
   }
  ],
  "receipt_chain_head": "4b79da2e6bfae944a4eebf1d87f1606de7a4d3a8e39a65dcf3d868134778e91264b5eab029b27c090de5f51da24803d09d8a09f826e27bcfde46e2737b83ae03",
  "evaluated_twice": true,
  "native_cmd_execution": false
 }
}