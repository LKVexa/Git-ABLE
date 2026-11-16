@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): accept_rails_admit_steps.json. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to print the document, with /check to check its SHA-512, or with /extract FILE to write it out.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=accept_rails_admit_steps.json"
set "LB_DOC_TYPE=json"
set "LB_DOC_BYTES=7397"
set "LB_DOC_SHA512=e531e6cfe92cb89bd58c82573e58e5e0d5bed8b413e054aa8934214183f27e88efa4ea0378f07d848be0c7ba301e9870052b4da9cc20d1d040be6ff00f103676"
set "LB_SELF=%~f0"
set "LB_ARG=%~1"
set "LB_OUT=%~f2"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$n=[int]$env:LB_DOC_BYTES;$b=[IO.File]::ReadAllBytes($env:LB_SELF);$o=$b.Length-$n;$h=-join((New-Object Security.Cryptography.SHA512Managed).ComputeHash($b,$o,$n)|%%{$_.ToString('x2')});if($h -ne $env:LB_DOC_SHA512){[Console]::Error.WriteLine('LB-DOC/1: the SHA-512 of '+$env:LB_DOC+' differs from LB_DOC_SHA512');exit 1};if($env:LB_ARG -eq '/check'){'ok: '+$env:LB_DOC;exit 0};if($env:LB_ARG -eq '/extract'){$d=New-Object byte[] $n;[Array]::Copy($b,$o,$d,0,$n);[IO.File]::WriteAllBytes($env:LB_OUT,$d);'written: '+$env:LB_OUT;exit 0};[Console]::OutputEncoding=New-Object Text.UTF8Encoding $false;[Console]::Out.Write([Text.Encoding]::UTF8.GetString($b,$o,$n));exit 0"
set "LB_RC=%errorlevel%"
if "%LB_ARG%"=="" pause
exit /b %LB_RC%
rem ---- document ----
{
 "program": "kgd/accept_rails_admit_steps.cmd",
 "source_sha512": "6c4e7bc9b6b889bb0450dc29d66fa1d5f9a628fc81a19c0df289925f4c31a835682c0a34a236c8f2034a88b2258cd02ed0984893e36bd9307f6abee413f78752",
 "file_sha512": "7e0462287d60408c6f338933e08d67a59c4e6d6490f28482d5c47a8ba4b44821e31e49245c9b853661ecaf87da9c689bc879ca94eec1dfdaeb3349d2ee94b480",
 "runner": "lcufx\\LCUFX_KGD.cmd run --twice (tools\\KGD_ENGINE.cmd host)",
 "expected": "accept",
 "observed": "accept",
 "as_expected": true,
 "exit_code": 0,
 "seconds": 0.0,
 "output": {
  "status": "host_research_pass",
  "language": "LCUF-X/0.2+lkvexa.kgd_imq/0.2",
  "source_sha512": "6c4e7bc9b6b889bb0450dc29d66fa1d5f9a628fc81a19c0df289925f4c31a835682c0a34a236c8f2034a88b2258cd02ed0984893e36bd9307f6abee413f78752",
  "semantic_sha512": "042226fad3864bb4c435dfce7e4c3e1a6125deed3fa30ee6157f267cdedb3a339df0a804b47f337ef47d68b81a81ba2f3cf148298b1379c60d7e3f1af4313af3",
  "values": {
   "exp_steps": "{\"admitted\": [\"s1\", \"s2\", \"s6\"], \"rejected\": [\"s3\", \"s4\", \"s5\"], \"rank\": 3, \"total_gain_bits\": {\"center\": 3.3, \"tolerance\": 1e-12}, \"retraction.gates_off.rank\": 3}",
   "spec_steps": "{\"question\": \"Which of six reasoning steps add something new? (8S Theorem A: a rank-increment test)\", \"items\": [{\"name\": \"s1\", \"code\": [1, 0, 0], \"gain_bits\": 2.0}, {\"name\": \"s2\", \"code\": [0, 1, 0], \"gain_bits\": 1.0}, {\"name\": \"s3\", \"code\": [1, 1, 0], \"gain_bits\": 0.7}, {\"name\": \"s4\", \"code\": [0, 0, 1], \"gain_bits\": 0.0}, {\"name\": \"s5\", \"code\": [1, 1, 0.001], \"gain_bits\": 0.4}, {\"name\": \"s6\", \"code\": [0, 0, 2], \"gain_bits\": 0.3}], \"eps_ind\": 0.01, \"eps_gain_bits\": 0.0}",
   "report_steps": "{\"framework\": \"RAILS-8S/1\", \"op\": \"rails_admit\", \"statement\": \"admitted 3 of 6 steps; rank 3\", \"decision\": \"admit\", \"answer\": null, \"admitted\": [\"s1\", \"s2\", \"s6\"], \"rejected\": [\"s3\", \"s4\", \"s5\"], \"rank\": 3, \"total_gain_bits\": 3.3, \"rail_I\": {\"steps\": 6, \"code_dimension\": 3, \"codes\": \"numbers\"}, \"rail_II\": {\"status\": \"exact linear\", \"rule\": \"eta_ind = ||(I - C C+) e||^2 / (||e||^2 + 1e-12): the residual of e after projection on the span C of the admitted codes\"}, \"rail_III\": {\"rule\": \"Admit(8S) iff eta_ind >= eps_ind and gain_bits > eps_gain_bits; rank(C) grows by one per admitted step (Theorem A)\", \"eps_ind\": 0.01, \"eps_gain_bits\": 0.0, \"items\": [{\"name\": \"s1\", \"eta_ind\": 0.9999999999989999, \"gain_bits\": 2.0, \"admitted\": true, \"reason\": \"admitted\"}, {\"name\": \"s2\", \"eta_ind\": 0.9999999999989999, \"gain_bits\": 1.0, \"admitted\": true, \"reason\": \"admitted\"}, {\"name\": \"s3\", \"eta_ind\": 0.0, \"gain_bits\": 0.7, \"admitted\": false, \"reason\": \"not independent: in the span of the admitted codes\"}, {\"name\": \"s4\", \"eta_ind\": 0.9999999999989999, \"gain_bits\": 0.0, \"admitted\": false, \"reason\": \"no gain\"}, {\"name\": \"s5\", \"eta_ind\": 4.999997499998749e-07, \"gain_bits\": 0.4, \"admitted\": false, \"reason\": \"not independent: in the span of the admitted codes\"}, {\"name\": \"s6\", \"eta_ind\": 0.99999999999975, \"gain_bits\": 0.3, \"admitted\": true, \"reason\": \"admitted\"}]}, \"rail_IV\": {\"redundant_steps_rejected\": 2}, \"retraction\": {\"gates_off\": {\"rank\": 3, \"total_gain_bits\": 4.4}, \"by_construction\": true, \"counts_as_evidence\": false, \"note\": \"every step admitted: the gains of redundant steps are counted again\"}}"
  },
  "admission": {
   "reserved_work": {
    "s": 118
   },
   "retained_payload_bytes": {
    "s": 4732
   },
   "peak_modeled_scratch_bytes": {
    "s": 144
   },
   "minimum_row_work": {
    "c_spec_steps": 1,
    "steps": 114,
    "c_exp_steps": 1,
    "chk_steps": 1,
    "out_steps": 1
   }
  },
  "row_order": [
   "c_exp_steps",
   "c_spec_steps",
   "steps",
   "chk_steps",
   "out_steps"
  ],
  "receipts": [
   {
    "scope": "LCUF_X_KGD_HOST_RESEARCH",
    "row": "steps",
    "site": "s",
    "profile": "lkvexa.rails8s",
    "semantic_sha512": "042226fad3864bb4c435dfce7e4c3e1a6125deed3fa30ee6157f267cdedb3a339df0a804b47f337ef47d68b81a81ba2f3cf148298b1379c60d7e3f1af4313af3",
    "previous_sha512": "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
    "result_sha512": "d3d3c14fdeb1e6e42a4dd087c6a76d86d6f7ba79551e9d819b1599f26774f9d24dcac01038477dce83f67b73cc3d21543e5f639b74c2251550013b50ec226a6b",
    "sha512": "2742ed253d1d68da124f7798343b58437ce493a6dbcd7ed7fe2ed3fa5a3f0592193ac4e326c927ab8d024a9135228dcfa4bef3f09b1bda773c1b5acdd81ea4bf"
   },
   {
    "scope": "LCUF_X_KGD_HOST_RESEARCH",
    "row": "out_steps",
    "site": "s",
    "profile": "lcuf.evidence",
    "semantic_sha512": "042226fad3864bb4c435dfce7e4c3e1a6125deed3fa30ee6157f267cdedb3a339df0a804b47f337ef47d68b81a81ba2f3cf148298b1379c60d7e3f1af4313af3",
    "previous_sha512": "2742ed253d1d68da124f7798343b58437ce493a6dbcd7ed7fe2ed3fa5a3f0592193ac4e326c927ab8d024a9135228dcfa4bef3f09b1bda773c1b5acdd81ea4bf",
    "result_sha512": "d3d3c14fdeb1e6e42a4dd087c6a76d86d6f7ba79551e9d819b1599f26774f9d24dcac01038477dce83f67b73cc3d21543e5f639b74c2251550013b50ec226a6b",
    "value": "{\"framework\": \"RAILS-8S/1\", \"op\": \"rails_admit\", \"statement\": \"admitted 3 of 6 steps; rank 3\", \"decision\": \"admit\", \"answer\": null, \"admitted\": [\"s1\", \"s2\", \"s6\"], \"rejected\": [\"s3\", \"s4\", \"s5\"], \"rank\": 3, \"total_gain_bits\": 3.3, \"rail_I\": {\"steps\": 6, \"code_dimension\": 3, \"codes\": \"numbers\"}, \"rail_II\": {\"status\": \"exact linear\", \"rule\": \"eta_ind = ||(I - C C+) e||^2 / (||e||^2 + 1e-12): the residual of e after projection on the span C of the admitted codes\"}, \"rail_III\": {\"rule\": \"Admit(8S) iff eta_ind >= eps_ind and gain_bits > eps_gain_bits; rank(C) grows by one per admitted step (Theorem A)\", \"eps_ind\": 0.01, \"eps_gain_bits\": 0.0, \"items\": [{\"name\": \"s1\", \"eta_ind\": 0.9999999999989999, \"gain_bits\": 2.0, \"admitted\": true, \"reason\": \"admitted\"}, {\"name\": \"s2\", \"eta_ind\": 0.9999999999989999, \"gain_bits\": 1.0, \"admitted\": true, \"reason\": \"admitted\"}, {\"name\": \"s3\", \"eta_ind\": 0.0, \"gain_bits\": 0.7, \"admitted\": false, \"reason\": \"not independent: in the span of the admitted codes\"}, {\"name\": \"s4\", \"eta_ind\": 0.9999999999989999, \"gain_bits\": 0.0, \"admitted\": false, \"reason\": \"no gain\"}, {\"name\": \"s5\", \"eta_ind\": 4.999997499998749e-07, \"gain_bits\": 0.4, \"admitted\": false, \"reason\": \"not independent: in the span of the admitted codes\"}, {\"name\": \"s6\", \"eta_ind\": 0.99999999999975, \"gain_bits\": 0.3, \"admitted\": true, \"reason\": \"admitted\"}]}, \"rail_IV\": {\"redundant_steps_rejected\": 2}, \"retraction\": {\"gates_off\": {\"rank\": 3, \"total_gain_bits\": 4.4}, \"by_construction\": true, \"counts_as_evidence\": false, \"note\": \"every step admitted: the gains of redundant steps are counted again\"}}",
    "sha512": "186d09a82a4abff42e530c7d5133552d6620f1981556fbcfff45540c0ae48b40c2ef2d267aba876bfebab20db8ac4c141326a3fbede1dd76816d9f1cfe10c11d"
   }
  ],
  "receipt_chain_head": "186d09a82a4abff42e530c7d5133552d6620f1981556fbcfff45540c0ae48b40c2ef2d267aba876bfebab20db8ac4c141326a3fbede1dd76816d9f1cfe10c11d",
  "evaluated_twice": true,
  "native_cmd_execution": false
 }
}