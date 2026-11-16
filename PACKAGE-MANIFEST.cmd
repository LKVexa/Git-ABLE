@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): package-manifest.json. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to print the document, with /check to check its SHA-512, or with /extract FILE to write it out.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=package-manifest.json"
set "LB_DOC_TYPE=json"
set "LB_DOC_BYTES=45585"
set "LB_DOC_SHA512=903dd4f42adbccfa13474926669bd94434b55d94acf80ca3d537598ca6a50a1647a5e5962267ecfa48cf9e8b3ce2f9e2f9e691ce83b9b169c0f395f9bfa5484b"
set "LB_SELF=%~f0"
set "LB_ARG=%~1"
set "LB_OUT=%~f2"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$n=[int]$env:LB_DOC_BYTES;$b=[IO.File]::ReadAllBytes($env:LB_SELF);$o=$b.Length-$n;$h=-join((New-Object Security.Cryptography.SHA512Managed).ComputeHash($b,$o,$n)|%%{$_.ToString('x2')});if($h -ne $env:LB_DOC_SHA512){[Console]::Error.WriteLine('LB-DOC/1: the SHA-512 of '+$env:LB_DOC+' differs from LB_DOC_SHA512');exit 1};if($env:LB_ARG -eq '/check'){'ok: '+$env:LB_DOC;exit 0};if($env:LB_ARG -eq '/extract'){$d=New-Object byte[] $n;[Array]::Copy($b,$o,$d,0,$n);[IO.File]::WriteAllBytes($env:LB_OUT,$d);'written: '+$env:LB_OUT;exit 0};[Console]::OutputEncoding=New-Object Text.UTF8Encoding $false;[Console]::Out.Write([Text.Encoding]::UTF8.GetString($b,$o,$n));exit 0"
set "LB_RC=%errorlevel%"
if "%LB_ARG%"=="" pause
exit /b %LB_RC%
rem ---- document ----
{
 "package": "lkvexa-kgd-imq-5dllm",
 "edition": ".cmd only",
 "combined_weights_sha512": "eae0ff8cd1d8412a7d79e820cff3efaf065c38cf0abe38fd5fe45def437e0857f395bf55aa30cfd406a36a5714a245895f7d98bba804db75b10999e8eef054a6",
 "rule": "every file of the repository except this one and .git/, sorted by path; every file is a .cmd file except README.md and .gitattributes",
 "files": [
  {
   "path": ".gitattributes",
   "bytes": 283,
   "sha512": "999c234b19495bae07a5124c669aca16f4faea15aaa09615145ab5c9b98522fbca96e6c0f9eb4ebe5c54abeb770cfd15a447cf36cd5a246ce6f44d75d3fdd30b"
  },
  {
   "path": "PROFILE-lkvexa.kgd_imq-0.2.cmd",
   "bytes": 11896,
   "sha512": "edaab0938c40d4d71a3cfc7c50310be92a1c0a00e4bb60295182d1e8dd054c7ca4dbb3acc49a78c6d8921c49e70ad005c1dca992dddef1ce39194500909511c9"
  },
  {
   "path": "README.md",
   "bytes": 27321,
   "sha512": "a9671a7e5421b5142cbb6195b8f3fc8502072c5bdf320dd604671124c4874348cf3de168b8684b49a9069137ad27b0e02f94efb48eec7a9fa42e2d50afd999c1"
  },
  {
   "path": "REASONING-RAILS-8S.cmd",
   "bytes": 20080,
   "sha512": "0f8eb9393b406c9a97858cb3c25094d222f423dcae1720bfb111ff45743f623eb44b0fd93f516d34e01e9d64abef3a2af5f86ad5925bba779c5301802771788a"
  },
  {
   "path": "SPEC-LB-CMD-1.cmd",
   "bytes": 15048,
   "sha512": "e5c57ce6cc9ac8a4f04ad1cfc91e0d34fc6dc003c8845f3ce6b810562a095060fcc41b5a3be1a0df1650120cf91a8c16b332165e43cc7bbf4bae1f54bbe8e20b"
  },
  {
   "path": "data/corpus-manifest.cmd",
   "bytes": 167190,
   "sha512": "1e7b539b74aa2e8ce2228672a9a2428dee5c531e88d72506fe3eae0257929e0ce15ae33d403b9052c17b6afad0055e13939e104ad6de4a5b2fd2cf89e0e9b7c8"
  },
  {
   "path": "data/heldout_bytes_00.cmd",
   "bytes": 3306155,
   "sha512": "17011bb99d35b617a56b613c43ba069f9ed6a114bcb288b07fdfc8bb256e99ccdfec17b3e8c6f7de58bea0dfd2d015e0a058ac03a6d4387fca262fbeceeccf5f"
  },
  {
   "path": "data/train_bytes_00.cmd",
   "bytes": 17765711,
   "sha512": "4d9a2454573a592b0ef0218669f87da8712501d47f68423f3debde23c2a58e393a611dd882b29d752e707803af160c58b7ea00ac9264977b6f553d1dcd5b7d1d"
  },
  {
   "path": "data/train_bytes_01.cmd",
   "bytes": 15340613,
   "sha512": "137e3e6c9ebf5735a15ef27547d24bca69e3f50dea4dba30a0e87aebdbad3cf1923ce10621bd7a0977499cbf28251b29360a81a89a7058da72badc855ca3fbc2"
  },
  {
   "path": "evidence/engine-selftest.cmd",
   "bytes": 5168,
   "sha512": "931c7e6b0a76089058c0383eb8e15f6d81c4e00e248d83c10a8a53f064a5745b303f9c3fc1278fbce2891b0c9ca6206b87a357f4444ea6033d86a79a84385d0f"
  },
  {
   "path": "evidence/grad_check.cmd",
   "bytes": 2614,
   "sha512": "f35b69dd03f9ed62581a43bf31072400017ccf4d55e1b751a6d2a65e17146ae7ba838953fb024e6ad9ca68da8d84f562cce4a4339fea818da05cac527892ecda"
  },
  {
   "path": "evidence/heldout-overlap.cmd",
   "bytes": 4489,
   "sha512": "947c07a7e953322624e1095675cb2a6e608d5bfa0321113aca2019315a73dc93fe2e739f5db0119197bde9ecb0bd7ec92cb3dc2cfc8dbe13890aa5f8b34b7927"
  },
  {
   "path": "evidence/programs-summary.cmd",
   "bytes": 46419,
   "sha512": "d75569d1afeacf47cb7f8a07ef36d2770ac2e8cdc68fd4a3d8ad4b142aa95b52f1fcbf0c17f5da6efa2b322b846aeb513ef937c011553002533e037041100a1a"
  },
  {
   "path": "evidence/programs/accept_kgd_alpha_gate.cmd",
   "bytes": 2054,
   "sha512": "6e02e6371f3510f15198ba37e3cf559c58666a62aad3d7c1b5883b44533b654cef6289ec750942856f8eaf2f58c303de426bd0bc6c1a1bcebdb3f1d64724b0fd"
  },
  {
   "path": "evidence/programs/accept_littlebit_block_sign.cmd",
   "bytes": 2072,
   "sha512": "dfb5c94fa27aabcdf3a1f2c48f6db79614f9a84d95c6295c01478dd6a1554338f72cf207b74af11ce860d6bee5811d70f70bc5988d9b1a75d6102e3a1b896233"
  },
  {
   "path": "evidence/programs/accept_m1_exact_decode.cmd",
   "bytes": 5731,
   "sha512": "8d97a650d47aaea205cd9be24c2b67f26813181af3e1a010f2f0f796fa76f399981ad38e551e0bd6f7ab761fc50d2f227e167018ecd4ba7a9b318f49d2165795"
  },
  {
   "path": "evidence/programs/accept_m1_exact_forward.cmd",
   "bytes": 6363,
   "sha512": "b8e8b0fd5b844a274f7df4006cb850019db4fed02434ee36563a39b3d1e228fe4434bc92d17ad3a2edeeafd72e451f5fd7210a1f66d11173320f8c8e531e15ea"
  },
  {
   "path": "evidence/programs/accept_m1_tier2_forward.cmd",
   "bytes": 6362,
   "sha512": "720de4e3a40150c51199f92f45ba802b6a5266c1673d12c4679d039a1e7f96ccd2034f949770ab0006d26d198ffd190db479be94255a563e9d9921568ff08b45"
  },
  {
   "path": "evidence/programs/accept_m2_tier0_forward.cmd",
   "bytes": 10232,
   "sha512": "20312b7ed94f044afe4bf910be5303b4a714faaa525c72289ebeb20cabda3cb95a8318ffb73d7a390e2a45c402711af4e4eede959eaa14373efdbdada02d6f18"
  },
  {
   "path": "evidence/programs/accept_m2_tier1_forward.cmd",
   "bytes": 10267,
   "sha512": "3068cbe029381b5fa38977bd56fae4e40fc7b224909a6c758572c5980072e6662f2df3cfc6d9bf228de3bf70339ccdf0c52a4fa6d51cbeb141390baab43fe3db"
  },
  {
   "path": "evidence/programs/accept_port_loop.cmd",
   "bytes": 10846,
   "sha512": "c3f1d099a8f65ffae3d0c5d8f3eb198967f41ecf5cc56f4edd2faca4f876ab0c0ac36ad0ec7ceb5680bd4587e840d42e475bf58b5cbc36d2782ddf7227dc6100"
  },
  {
   "path": "evidence/programs/accept_port_source_checks.cmd",
   "bytes": 8764,
   "sha512": "20746d3d6c9fda35ef2b62f77f7a60ee229d0a263988c5e872c62cbb1467bad9428234387b8f9aced7ccf53b5968c46c27e9202f69fd79676b94664a7ef2382c"
  },
  {
   "path": "evidence/programs/accept_rails_admit_steps.cmd",
   "bytes": 8839,
   "sha512": "0ab95730202913e787b14abb2e8894aec276347f5ffff57257dbd3aa0962a003bc3401962b7b546665062b2df0160530859b164658a68452b829755d3d927f21"
  },
  {
   "path": "evidence/programs/accept_rails_bayes_disease.cmd",
   "bytes": 10413,
   "sha512": "ca574644c81369888d63a54d16394f4306fa418b4946fa2f6a104cba839822647568b345ae51c12e4e6d1fe20292b34494ffbaf22d2e6bee89e6023b97d61fed"
  },
  {
   "path": "evidence/programs/accept_rails_bayes_oliver.cmd",
   "bytes": 22206,
   "sha512": "314ecef4628a14948ea6a2a2f19d296380cced29a4a4dac642109813130464c27c1a0d6ddd4102065ca878539ed39552b120573491298715a9c24f5461e2d519"
  },
  {
   "path": "evidence/programs/accept_rails_bayes_r3.cmd",
   "bytes": 10120,
   "sha512": "ce4d92cb90d6c590b118de037b5968ba590efd93ab4445e90623ba6b6a83900781f223782e1fab0b4d62c7f691835cccd022409b2089e4866219e5865234f028"
  },
  {
   "path": "evidence/programs/accept_rails_codelen_unigram.cmd",
   "bytes": 9259,
   "sha512": "ee8ef2346c5d87ff562b2d7b3511af067b0e72683ca35b65c74896cea6b76a7da19c0e2ceb3b0b0a52526c4dc79672b398f255190d00b5c49cb36ad98ad0c7f7"
  },
  {
   "path": "evidence/programs/accept_rails_meanfield_certified.cmd",
   "bytes": 9169,
   "sha512": "0696fbf4a3c992baf641851b8a49f2e7bb9b68766f9da4296b92597b42460c0c6b0d78605efc3ba0159cd28fb1bb07369b0829fbb5b10460da69b6af83cdeb1f"
  },
  {
   "path": "evidence/programs/accept_rails_parity_m1.cmd",
   "bytes": 26684,
   "sha512": "c999372a3f549e4dc260dfeeea2479aaa7dbd2e434c0e09190e79b798f55b4c3e840cc828f1dc7dc2dbc6e1f5b85bcdda7fdc96a24cabe4d43b0e6d9cf0d3fb4"
  },
  {
   "path": "evidence/programs/accept_rails_witness_m1_abstains.cmd",
   "bytes": 10731,
   "sha512": "cb3c3d97f708f3343e3438433e26efd182cf9da888243fbc1c8afb7bd2436f8a09a6d1a29a4a99ec195e6799ff041850152761e85c2050bf56ae238dc52bceb0"
  },
  {
   "path": "evidence/programs/accept_rails_witness_unigram.cmd",
   "bytes": 10593,
   "sha512": "48b8128f476a6fbd1e840187b12bbddb2257ec8c07dff32bde0aba88c64954f2e72767713a4256a1db44471a61a212dcdd56e1cc73a190b614bff185addfd904"
  },
  {
   "path": "evidence/programs/reject_core_header_at_kgd_host.cmd",
   "bytes": 2090,
   "sha512": "03b266ec14facf455b29e9383e7589dc7d5fca5ab1e4ebf9a4f026966d4989ca5051898bc8767575d0c89b9e423b2134bf15eaa6168558dd81a0dc72ecb302f5"
  },
  {
   "path": "evidence/programs/reject_kgd_alpha_q16_step_above_half.cmd",
   "bytes": 2099,
   "sha512": "91b406a355207752d1a521b7841cac78f29c735ab60fd8d75a0c907f15b140b41d8c2e2b11a682fc0a645738088bf50416ce3664306e23d9b9e691364afb5ee0"
  },
  {
   "path": "evidence/programs/reject_kgd_imq_profile_at_core_compiler.cmd",
   "bytes": 2108,
   "sha512": "ab4ab6293d6d3f37c190647d072ba5d3cce28f61784d9732595669a468236eeaa6d1c0950ad555eda8e7fb1b76b137e449648252caa705ddb743371794350f3c"
  },
  {
   "path": "evidence/programs/reject_m1_work_underreserve.cmd",
   "bytes": 2112,
   "sha512": "51c5352695700438284a1f1dc5d68aefeaa4f199141b80ca24541417838c147d02ae900c3673f0854144e4cc9bfe2dd610e02e59651c376a252e72fd7387dafa"
  },
  {
   "path": "evidence/programs/reject_m1_wrong_pin.cmd",
   "bytes": 2060,
   "sha512": "2f1605cb36d1c52e91cc4e5959ca1465f64c200e4dfe7231666acedc1332dfe7182b5e4e410ba2a7284479f361107b8f005c2f68331f8e7d220894cebfa1eccf"
  },
  {
   "path": "evidence/programs/reject_m2_tier2_unavailable.cmd",
   "bytes": 2088,
   "sha512": "3f11e7ebf79252d6b8db8bf8021f34c81296a1c1d3736ecf0ab086b2bc23c64bfa60c37fe080f93c6113a31079aa77120050efeffc2e3dc07e37b4357ee75043"
  },
  {
   "path": "evidence/programs/reject_rails_meanfield_uncertified.cmd",
   "bytes": 2191,
   "sha512": "eebd3771640a627829065f760ed8e4735651290cfd9c9446d386be6f62920825c9dc1c64b950d062693e3b4399ed359eadb20997269f9a7038f43c87fbee6a4d"
  },
  {
   "path": "evidence/programs/reject_rails_parity_no_majority.cmd",
   "bytes": 2131,
   "sha512": "73fa93ce60c7762102c480db3f9609335c98d0bd1063fb850501cb6bed3f68ef1de684cf2a0f304cb1a9743b5208a8b727899dd6552428dfec7660b99fd31c71"
  },
  {
   "path": "evidence/rails-selftest.cmd",
   "bytes": 5870,
   "sha512": "22d3e621b895ca1d250079408d20c165f74d0e1d3e8b01b0eb846b49e46b0b0ac87db17399a86d4d191102f94409b388d27347ee38de547307b71b4235f4690d"
  },
  {
   "path": "evidence/size-bound-test.cmd",
   "bytes": 1756,
   "sha512": "4bcad88b6c8044fc41176ad5745bc1bd2cd3a295ef6d7732401b25bffb9597edba3038b11c3890ab9a819eff5938c9e2599e95d1019973b6f40b94fe49017f0e"
  },
  {
   "path": "evidence/size-drift.cmd",
   "bytes": 8546,
   "sha512": "57f2437dddb7a625f63aba6c109fb47a53833b23c9dee42bf8547aa4de210b83d868b434a03f3a8516d892a01260eb612c5767303d03d897c8e7ac34fbf0259f"
  },
  {
   "path": "evidence/superseded/model2-37-layers/accept_m2_tier0_forward.cmd",
   "bytes": 10454,
   "sha512": "cf649b2dfb014e5b8f12d170480c9a1601f40c7627dccad1d9d0cc7adb64fe180adc492eeb22a09eb24ea88ff4912dc12c4d55da2402f7076fe39443a08ef5ac"
  },
  {
   "path": "evidence/superseded/model2-37-layers/accept_m2_tier1_forward.cmd",
   "bytes": 10492,
   "sha512": "fccb6b2245577c802cd15e2ead8a556267f2dc14f42229da7545649b397f7abc5489bee53cba998ec995b76675f6cda051c5f39fa478bc6bd4dff08dcbff697d"
  },
  {
   "path": "evidence/superseded/model2-37-layers/reject_m2_tier2_unavailable.cmd",
   "bytes": 1905,
   "sha512": "f0958f28b03cc3bbb91141aca4ef21013579ff86a38ee6e6072bb8740185ce49571ca4fdc104a0f2a830d680a33555c1991194016af38cd70228175432726832"
  },
  {
   "path": "evidence/superseded/model2-37-layers/size-drift.cmd",
   "bytes": 6958,
   "sha512": "b3e7eed161853e9cc4b4421f8addf311f99c4ba5824e5650a0971ae853b63382dacd0826592ee4e8e4e2dea6e9cd5c141c863d442606bdc9c9f12f3d78df2c9d"
  },
  {
   "path": "evidence/superseded/model2-37-layers/verify-model2.cmd",
   "bytes": 6534,
   "sha512": "a2136be994fdb225cb585bca9b3894b562cef7388e737aaa7f164a55d7ed3838fa852ec9f2412d6759ad8cf412c77ea0cbb76231e941f41ebfff042f279bd69e"
  },
  {
   "path": "evidence/superseded/model2-37-layers/verify-stdlib-model2-tier1.cmd",
   "bytes": 12015,
   "sha512": "d9a9a8dd69a5ab5c8708e86219d28f7a4599b4b83bb06498b0a080ca876cccd52ec715007e8ffbf23f24807188731b287c5cd4a96283415b65f5df5592ccc427"
  },
  {
   "path": "evidence/superseded/model2-scale1046/accept_m2_tier0_forward.cmd",
   "bytes": 10452,
   "sha512": "e8bea7ec7f6506a67ce071905d215dc8188df170c9ef37efba25578b645570900f115162f8ede2c86daa894184b78e27b6c1f3d92214eb54807060e36193fed9"
  },
  {
   "path": "evidence/superseded/model2-scale1046/accept_m2_tier1_forward.cmd",
   "bytes": 10490,
   "sha512": "f1b5cd201919b900c552d909571068061f88f09f2f673cc6d370825ae9711e6a384a55ed979041d4c71d0570c963a9f5e9a98955b9fc941b3a6d69741ea94984"
  },
  {
   "path": "evidence/superseded/model2-scale1046/reject_m2_tier2_unavailable.cmd",
   "bytes": 1905,
   "sha512": "945bbf88b795e683976c50fd2a1691702277ea2acf7eef24401a37067ab9045abadfd198d4ff714446436e3300e4a331d3879643c521ca05ecea3ffad424aebf"
  },
  {
   "path": "evidence/superseded/model2-scale1046/verify-model2.cmd",
   "bytes": 6534,
   "sha512": "8a6be925b25612cbca0f93be33f953335bff0febf368ec254bbb276bb9df611706e213d3c2e2bef91d0694e0a6568e336d09f7209d0587eb82aa86852fc2b4df"
  },
  {
   "path": "evidence/superseded/model2-scale1046/verify-stdlib-model2-tier1.cmd",
   "bytes": 12015,
   "sha512": "b73b701b28f87cc57ab97c12de992cefe20c77a50e7886125f83b95c90936d91656331b450b1eda5df8378e02a345b2e1fbf5c2b1a7d841aa068ce82c266f9c6"
  },
  {
   "path": "evidence/validate-factored-small-set-manifest.cmd",
   "bytes": 4986,
   "sha512": "94a260e9f2204d68669589f754ca57ee21260cfafbde5df67874acf801b100b330528dd55f0d2332ddfa8548f479c9f2274e59be79a6234b1f10fd9a7e8a30c6"
  },
  {
   "path": "evidence/validate-factored.cmd",
   "bytes": 2253,
   "sha512": "552819911e106b80c6b77acfae2e913324beba43b635b6f88ce451873fe96e2c206f809fc5015ed699ece6d0095e679745b5f0f2c63faa73ec22542d5e05da98"
  },
  {
   "path": "evidence/verify-certutil-model1-exact.cmd",
   "bytes": 1843,
   "sha512": "9dfcd037e11eaebef195bf507352e4ebc0692327b4b9466dbea9dd49510df0e483c6fde3cc45c51f567c10b76a51096a173bde081cad197af66d247cc673aaef"
  },
  {
   "path": "evidence/verify-certutil-model1-tier2.cmd",
   "bytes": 1843,
   "sha512": "69d7e4104c3971c4897bc719652ad37a27930c6772229e8e0ea551a6671ebcbc079c1542debd968e1d1a9351982dd42c5b06d4065a3ae3a180d89a1dd1a41cc9"
  },
  {
   "path": "evidence/verify-certutil-model2.cmd",
   "bytes": 1822,
   "sha512": "8c029afafa873c2598464f25180f3dc7b8b05448ad0df86cfb7b073c22c8cb4403d85093bc1b2206fc848adbdc45d2ba42e36d716c3b8ee2e578b35c61ea570d"
  },
  {
   "path": "evidence/verify-combined.cmd",
   "bytes": 2714,
   "sha512": "3d24d3355c803049aa1e13d30200e7fb57a2083b6538d15021899a4d2a0f725d99610ddc53164f005cc264e372cf6f1bb8fba9fa59b9c58647e495fa10fb0cc5"
  },
  {
   "path": "evidence/verify-model1-exact.cmd",
   "bytes": 3646,
   "sha512": "800d5a7c2f9fac0bc2651a766c5b39cf8893c9724b1c623c60b11d2522dfbbcc9af66d6e91b10d7ead5a44ebe02fa8e320c859b7ae8ddf3eda1572815d6a3cb5"
  },
  {
   "path": "evidence/verify-model1-tier2.cmd",
   "bytes": 3596,
   "sha512": "5e9deac72caf3497157dd1c5930d05a563617e8c730faed465e0aca63b85963c2fbbf8f36418f5e526c81dd9992a50d9ab37befc7f1b7f6c176e83bd0a10fdae"
  },
  {
   "path": "evidence/verify-model2.cmd",
   "bytes": 24538,
   "sha512": "613101543231b5e524c78bb189b8c69c90159d168e97c540be349e7dc2558fda1d60c451de3a1b6f36ab5d7402148cd6963bfd009274df15b98c2059ae430cd7"
  },
  {
   "path": "examples/rails-admit-steps.cmd",
   "bytes": 1393,
   "sha512": "03b9b7b8064c6b4c5ec703ffae17d7b21299300a6d02c0a64f9f59947917a32d0c48aea93c3dbb1562e6376116bf743c96412e2e6c0f23daa6bcb260f566175c"
  },
  {
   "path": "examples/rails-bayes-disease.cmd",
   "bytes": 1167,
   "sha512": "84be21ac6f420e8266aad00bd386ce3afb738630f4556dc6db4f60ce8792ecb9d55212f61d1a80e6844afd2901865d518735ca4ffa68e1263cf860416afd8fd9"
  },
  {
   "path": "examples/rails-codelen-model1.cmd",
   "bytes": 1116,
   "sha512": "cad5511c625eec903e8e6ab0aa0d1d4b83458db71903f5ad1d0a7b11258c49df0ae09d018cd07ee662306474ec750b44a4929cc5c12e108db22d7d8857590a56"
  },
  {
   "path": "examples/rails-meanfield.cmd",
   "bytes": 1006,
   "sha512": "58d451b03807f9dfe42c947face702ed8fab19560567b0e937093f587f4f887718d23b699099641547cd8523a7fcc2f5c5a7132a489853723239c03348b1731e"
  },
  {
   "path": "examples/rails-witness-model1.cmd",
   "bytes": 1220,
   "sha512": "76d433bb2e2314c2c9687c06917e4b0d73096d5a6a87575b7e2db65c8e7034e9c934e49807384af9239d465663f388fd70265d0e056b7229519cbf5d75f87d0c"
  },
  {
   "path": "examples/rails-witness-unigram.cmd",
   "bytes": 1248,
   "sha512": "cb509e9915b73e3a9bd536e507994c8768189ad13c265ba8664964b5231ee21485a305d6b8053b1f70c2a2fef3b59fb03faf1b1ac2c336fee34645dbd0b1dddc"
  },
  {
   "path": "lcufx/LCUFX_KGD.cmd",
   "bytes": 276,
   "sha512": "549cf460877630d3e5e9ce451203e4448776f75ff783f90986c04370a771436873f3a384c757104e0dc9cda7316f9543e759de4efba50e630b62ef2fa97cfe23"
  },
  {
   "path": "lcufx/programs/core/accept_kgd_alpha_gate.cmd",
   "bytes": 2244,
   "sha512": "7570db0e7ce1ca91d92997de6191f61b33a18e05a06a6523c6c7ac7b8c7ddd56923c66fd47a8a4886372aae4b9f9302dfa013d17c231a8daaaa6e44cdff5223b"
  },
  {
   "path": "lcufx/programs/core/accept_littlebit_block_sign.cmd",
   "bytes": 6953,
   "sha512": "8bd36507461b58e432911db06f263d0bb890491028a64d5d06de47006c8bc457f2e962fcc1f011b9ec69c44170a152e0045bb40b24806a7af773ebab26fa8a65"
  },
  {
   "path": "lcufx/programs/core/reject_kgd_alpha_q16_step_above_half.cmd",
   "bytes": 1382,
   "sha512": "43b0d4f5d5b988cfa18a6d35f673801a17fda57b559e8523b5f5420254bac9cd582c06700ede18a9a2c01612ff8f1a5c968a5da3fa26fb9d8f0aacbface25677"
  },
  {
   "path": "lcufx/programs/core/reject_kgd_imq_profile_at_core_compiler.cmd",
   "bytes": 4017,
   "sha512": "849b2bcdbc9858fb986aa43c9f6723d77ac8dfc19343789c880bc97b7f72a6e3062edf036736527761e95abde698b95dbde92c7c1b835715e55b84119bab4046"
  },
  {
   "path": "lcufx/programs/kgd/accept_m1_exact_decode.cmd",
   "bytes": 2050,
   "sha512": "7247c51c0a56580aecc049e9f21aa622e333e3574177c5133d3ad38fcf36f2bfc55470316a9ede82c76bf43ae06eb333f2719ee21bf32e1d14164216c5aa098e"
  },
  {
   "path": "lcufx/programs/kgd/accept_m1_exact_forward.cmd",
   "bytes": 4001,
   "sha512": "db1a7ac20777f1ee9d919bc8087951694d676f739b5e679ad3592cf7f61dcd341fa7a52de08cff6bb9101e4120cdf9e271e1883450daeb7024278f6a59ff89db"
  },
  {
   "path": "lcufx/programs/kgd/accept_m1_tier2_forward.cmd",
   "bytes": 4000,
   "sha512": "b0d712fae13fe9efd05428d1bb2196eb20025be0ff1e6eec4bfa2fe8f5b05a1fa5481d6f822bdd774294beb8dccd2abf0b00bf8f2faae16c280764b2a9e6f86b"
  },
  {
   "path": "lcufx/programs/kgd/accept_m2_tier0_forward.cmd",
   "bytes": 15457,
   "sha512": "fa7e0c56f0ace6969a1ac2b775253075b61254a37961552013564409688b805e0c61f0014a000a8e84bdcd2354c37a1717a07edce38db90b8bf666e1fcc8f51e"
  },
  {
   "path": "lcufx/programs/kgd/accept_m2_tier1_forward.cmd",
   "bytes": 15492,
   "sha512": "b40028c627ad9261cc227ec1e7b25cca8314ba5ba7998799581c4859d7b1bffe06e3cb5cf8e4fffcfa48cbd3f3539e427028d62a609b5cc0581d1c4553e03cd5"
  },
  {
   "path": "lcufx/programs/kgd/accept_port_loop.cmd",
   "bytes": 4609,
   "sha512": "c6c5c1c296c33a6e9ec1e78a90c9c09fab90bf311797ba9a1d1c0e6c9fa44b93a86ce60d257612fe53fe0bc748a81fbc0c61e31579890ef921a7bb302115ead7"
  },
  {
   "path": "lcufx/programs/kgd/accept_port_source_checks.cmd",
   "bytes": 3883,
   "sha512": "24bac8aa8564846e7bf6d593dfc140c2bb229c68d969af760b5c250cef71bdcd39dd2fb010cd1a8410ca132f73a3cf5699aaaed2d8f9363ff5cf4a789f4f3e67"
  },
  {
   "path": "lcufx/programs/kgd/accept_rails_admit_steps.cmd",
   "bytes": 2236,
   "sha512": "7e0462287d60408c6f338933e08d67a59c4e6d6490f28482d5c47a8ba4b44821e31e49245c9b853661ecaf87da9c689bc879ca94eec1dfdaeb3349d2ee94b480"
  },
  {
   "path": "lcufx/programs/kgd/accept_rails_bayes_disease.cmd",
   "bytes": 2623,
   "sha512": "c18ecf115314b69863409689579d634a69f2f8edce023e08e4755db0ebd4950421feb77a72ea87101901b8516dd405b861dbec752565713e7671e04c256f8104"
  },
  {
   "path": "lcufx/programs/kgd/accept_rails_bayes_oliver.cmd",
   "bytes": 3727,
   "sha512": "1a7dfb3b94850244fe1e4f0df85e56383d3785904518ecadc144008600696d56f52e90b0b3323f48f3df1b853db0e78a9464ad2bf8e8b567560d3c437cc8e8a9"
  },
  {
   "path": "lcufx/programs/kgd/accept_rails_bayes_r3.cmd",
   "bytes": 2104,
   "sha512": "623d3e1ae8e71dd4f3acb49432c950c1b1291b32917624d4ab1647c4ed4e0692e71fc8647d4e76b29736d9980c24f9cc633a74215f0862a9c07461eb793c7948"
  },
  {
   "path": "lcufx/programs/kgd/accept_rails_codelen_unigram.cmd",
   "bytes": 2245,
   "sha512": "9546115606816f607ae9ffcd0cf7a3a00725575255d5577e73bcc3d38b8e9b4318aa2188bff232c5e0e8d4735fdbcfce809ee53515e25082c3c0851b77740c7f"
  },
  {
   "path": "lcufx/programs/kgd/accept_rails_meanfield_certified.cmd",
   "bytes": 2373,
   "sha512": "aade4d16b13269d427ed31706015707cdced7e65fac1673fbf9664880c79c53d2501c3fabdd0ef99b22ee04ad3c6b79dbe33b7d29dc8128daeda56693bc18305"
  },
  {
   "path": "lcufx/programs/kgd/accept_rails_parity_m1.cmd",
   "bytes": 6901,
   "sha512": "ac727a2e7cc54adcfa702d802853c48ad2ccadfe01df2fa53edbbcbeebf285736aefe1f3e472300bd830763dfdedfcba10c0f019ea5809b4816e16d5303532ab"
  },
  {
   "path": "lcufx/programs/kgd/accept_rails_witness_m1_abstains.cmd",
   "bytes": 2415,
   "sha512": "ad677525eecc0ed91b4ab23f6303c627eeffb9347f84b60c2a7d050d9b647e256c7aae4ccad4b971bc2be4f5b14eb160bd668e170e921496ee09ae00fa82a58b"
  },
  {
   "path": "lcufx/programs/kgd/accept_rails_witness_unigram.cmd",
   "bytes": 2435,
   "sha512": "81fe45dc43a6dd468e7a1435231bb5f57888710dbded73d595715aa4eaaae6cd4e7a649880a49377204d5a6ce67580fe35b2d4564ee6908bc6fa7d0d8f390c60"
  },
  {
   "path": "lcufx/programs/kgd/reject_core_header_at_kgd_host.cmd",
   "bytes": 3987,
   "sha512": "165f461b1d1152ccdce207f2205d97d28c7ee163037463d2482bd25e69e032ed42a501f42d4e7be7b4cdae4d22a0fd796a0dd833209e14b9e7ad93841dc53a6c"
  },
  {
   "path": "lcufx/programs/kgd/reject_m1_work_underreserve.cmd",
   "bytes": 4006,
   "sha512": "0fd49d9155419ef969dd0d38c145eb30655854a3786038bf24742213b2013baec7d6f115b49723edfc46abcc363f1958e76885d68f099acd7b5b5e9906ab8a72"
  },
  {
   "path": "lcufx/programs/kgd/reject_m1_wrong_pin.cmd",
   "bytes": 3982,
   "sha512": "4c1d5dc203f87af2060624dd5568a60eb1d57ded12ee631595dc754931520b38e168ef6ca1792e9405bba157626043f17296cbb8700282d19e16b827ffd16ea4"
  },
  {
   "path": "lcufx/programs/kgd/reject_m2_tier2_unavailable.cmd",
   "bytes": 15504,
   "sha512": "d7bc5446af2ed5224160ba4d0bd6868575843bedfdbb6f5510aee60ee60561bbddac8b29a96f41f24590f551bffc15c9615343c48a8ec5636fd7336ae9a92239"
  },
  {
   "path": "lcufx/programs/kgd/reject_rails_meanfield_uncertified.cmd",
   "bytes": 1662,
   "sha512": "48ab0027b57a7dbf7ad2d9ca2b5124efac8716f2ea0d017a3d77fe6a592723822b713af4d825aa0c3481513ac727962f340d253d8a59f4070501ee3e95b20ee4"
  },
  {
   "path": "lcufx/programs/kgd/reject_rails_parity_no_majority.cmd",
   "bytes": 5205,
   "sha512": "436fefadef366e6d80e4ce30a06f11f69be4a4dfea2f4cb19eeed6fd7e02d00b23f25581f97b7d912cba8d4878812f46192b2db03afc26f1d084414d2457bd3a"
  },
  {
   "path": "lcufx/programs/programs-made.cmd",
   "bytes": 6637,
   "sha512": "097423461e48ea94688f3f207a2c1d4aede395a09c082655bbd913c1b4d73ff9e6037bc7ac1059a3f50272ba82f3d942bffc92fd9f70a27208f0fe0059a703b1"
  },
  {
   "path": "tools/CHECKS.cmd",
   "bytes": 280,
   "sha512": "61ee3f95b39b24e0fca5e1cbbcc03217a3550c855f6d5825b9b4eb45da9e180e11676794d5fa91fe51dc916ea6f5154eb974a8a81ad3385f6c53bb26e63b012e"
  },
  {
   "path": "tools/DOC.cmd",
   "bytes": 261,
   "sha512": "311a799976f294ae87c0d812994f199ebe01fa12f9dcdbfedfbc845e4fe4c341ccfa9b4f79c49ea6efff7eaedfa06ce823fd4907b4fdc2b5f0bdbd43551668f8"
  },
  {
   "path": "tools/ENGINE-SELFTEST.cmd",
   "bytes": 4106,
   "sha512": "fea73030fb8ab055659a82d0a8fa4f3b1179a0730937f388163c203fe9a9930011b5de793e2cec2ebf1a2499b2b41764eef797c85ee93caf5e0d2f6f34b7b90b"
  },
  {
   "path": "tools/GEN_MODEL1.cmd",
   "bytes": 287,
   "sha512": "2e9709dfd7ba7ba05e710474d70e64e349ddcbfbf538479277badc78fb98f07bd25e5c4e7fb4242a475e105451885d83713e4aac7b4e08619b3a47f92fd36f37"
  },
  {
   "path": "tools/GEN_MODEL2.cmd",
   "bytes": 305,
   "sha512": "1ff301b356048d35285cfdb4c11c881669f35ca6c8f23f941623c240ec921b214789978b2a181836a5488f67ee00e5bd244b5a429601b5230d65c13df63250c0"
  },
  {
   "path": "tools/KGD_ENGINE.cmd",
   "bytes": 396464,
   "sha512": "d94f95780b65a336da57eb5f96277d6400e0ef6aacfcf4a06eeb0534b8d58e79461c5619bcf8476dd601b7288b3a2425180ccd0125ac2820bf01b8f7bc450900"
  },
  {
   "path": "tools/LB_CMD.cmd",
   "bytes": 438,
   "sha512": "244be6658f8d9b97c271ede4cd8edde996b02fbbbae16ef78c12bb5a994245f44e8346c60af468c6842c92c1dc30b588f0cb192af2deb6bfde9673889aacf5c0"
  },
  {
   "path": "tools/MAKE_COMBINED.cmd",
   "bytes": 176,
   "sha512": "a898c558170a961e19413e79889489d8389672612960099b8e7708040870a45189c24d7351c3b1fb092e9ae46412db52ef614656b2798b0f4a13f2e257ab1e15"
  },
  {
   "path": "tools/MAKE_DATA.cmd",
   "bytes": 282,
   "sha512": "2e0bc629b3e2278957481e9d9b7ce7470b8b7b0ecc890e0ba593c34cc1921dcfa0c91ae70de3414318c175be5ef85e7f8b6b26dffd63d124e3802bac8451e6ae"
  },
  {
   "path": "tools/MAKE_PROGRAMS.cmd",
   "bytes": 250,
   "sha512": "5cf1a4b2dfa93814c994c98ad712ed369e84da80b160ebb3d0429961fabf31606dec00aa144d50d00a29784d2c515ed97b369727ca3b4f8c4d2f285127493aed"
  },
  {
   "path": "tools/PACKAGE.cmd",
   "bytes": 300,
   "sha512": "e537d749ac4f711e97a0351ababe00408c2fd8d4b3b89c14abeeaddfd4d65377abacb819aa8df599f202f15011db5326b041b63883ab31d04e9e734978a38cb8"
  },
  {
   "path": "tools/REASON.cmd",
   "bytes": 323,
   "sha512": "648a17a00a655ecbd5d6c16d00bfee72bac4460452b04934ac0ce8269bd2c6094ad8cd3d2d69ef60265a0c305ba4af258b02f1dffd7a69a24a616dd42dac0181"
  },
  {
   "path": "tools/RUN_ALL.cmd",
   "bytes": 315,
   "sha512": "3e28266c48ccb32ead2441d0368028406d37eef4e7e8e6842b8525ce45f28517abd7821a56c4f347a45464116af63f432583b5ed3e4bccaec6d4a0ce9bb3cfa3"
  },
  {
   "path": "tools/RUN_CORE.cmd",
   "bytes": 1197,
   "sha512": "f62ccdca5fb36667bc34a8ca750cd1041298ccf2d396f9fed9415bcd98771ffc49e568fd55117d1b36178158ec96c9824ff02edaa8c08fba3195c8ef03df6a39"
  },
  {
   "path": "tools/VERIFY_WEIGHTS.cmd",
   "bytes": 1872,
   "sha512": "6b9bda19e2a5f5bdd9fa67776d8e321b2035e1ca0150ffc5029ec070bf38cb502f7c827a6fbbda12e792455dee0549eb2e684b99a373b6d4381e9ac2752dcc63"
  },
  {
   "path": "weights/COMBINED-MANIFEST.cmd",
   "bytes": 3223,
   "sha512": "9145268719ddc51903d0062a8abf9742620ba807dbf8762bf9db7a9f991f6414b6434474073c05f3143d94b445bd5d1cc6d03e8d3162bb361b40b47e869aebc5"
  },
  {
   "path": "weights/model1-untrained/exact/SHA512SUMS.cmd",
   "bytes": 2137,
   "sha512": "9f315674d7264f8daba1e8eb0f83d43de54f12ee559e9978d7e7ecefcaf79722c09be281f14dcf9a92f0cfea5fed11039a0434bfa260277d8bb7356dba12c54d"
  },
  {
   "path": "weights/model1-untrained/exact/manifest.cmd",
   "bytes": 4787,
   "sha512": "fe75d88b218d7e3cd66729ccfba06c35782521d7ee1570fd7af098cc2df5fb1616de9072cb6c56aa9f4371d52249f7e74c5e19beee220f90d507e9daac4a278c"
  },
  {
   "path": "weights/model1-untrained/exact/shard_EMB.cmd",
   "bytes": 1088079,
   "sha512": "a7747f3e8e50e3a5d32349ee8203d2a43bb3099886cf52c2f3fbdf308390cdd95a4eb72d49b75687cad6ee94d9ebbf445d713b9a36d74166d39e4b89b6616f4a"
  },
  {
   "path": "weights/model1-untrained/exact/shard_L00.cmd",
   "bytes": 13359052,
   "sha512": "1d069eedf6617d37cfadcd36b5e026dc4296abb928055549d23495a5c9b888e9d3d6289f366b1fd3243f4cf49e5df5ec9ecd98c80a013faad3429a32f72ffca3"
  },
  {
   "path": "weights/model1-untrained/exact/shard_L01.cmd",
   "bytes": 13359528,
   "sha512": "551ef103bb600961ac070858ad034a071ba993818df3d9be26d14f99912053497dc3a7fa398ff2bd0e915edd07325aae49724dfd830816d0fe257bb07412ce2b"
  },
  {
   "path": "weights/model1-untrained/exact/shard_L02.cmd",
   "bytes": 13359154,
   "sha512": "77fc5d7b9681725f76ac37a2b2be997dbd82d330616b8fd2d93e1230dce63292c60075a40784637bf7d55bb94a67e242b921b4501ebb646941a9677516da4b10"
  },
  {
   "path": "weights/model1-untrained/exact/shard_L03.cmd",
   "bytes": 13359681,
   "sha512": "26870b910d7dd7d2c202253554d4a159f79c6ab7323d37b9486a8d6fc114fae1c8063e5f3bb36ca1e84076917acf834a023bb1ac628837c683a78a7e04ed315b"
  },
  {
   "path": "weights/model1-untrained/export_report.cmd",
   "bytes": 4710,
   "sha512": "8f6f8d77d43608c2d96b60f53cc3fe291deabb7ca59b668e070b19b170d67a22fb632be39a142bc419e0fabdf5c52ba384cc70c091bee1c86430055e8148b03d"
  },
  {
   "path": "weights/model1-untrained/tier2/SHA512SUMS.cmd",
   "bytes": 2137,
   "sha512": "dd58bb438a1c15d413ac798287d2f09c5bef01f0b1f8c8d613410d7aa1d796135bf2b59940b598015f9d6e771aa7532c7532e235d300a097b2d5785ccdf16ed4"
  },
  {
   "path": "weights/model1-untrained/tier2/manifest.cmd",
   "bytes": 5153,
   "sha512": "45f197d1cb81731bd72e0c7d8addcc9717d7991c8ea618870a96283c544a5d6fb722ce9d620961691e5f741b1c528191a639de395b12d50c768fe5de9c207d91"
  },
  {
   "path": "weights/model1-untrained/tier2/shard_EMB.cmd",
   "bytes": 83133,
   "sha512": "666b970161ed258d322142c8fbe865b39e76b1644a8aa6804f5295300b09158f53bfd30635dea7203b5c3e530423a54ddeeb6eb5b7c3a01f2100571f54f170aa"
  },
  {
   "path": "weights/model1-untrained/tier2/shard_L00.cmd",
   "bytes": 928273,
   "sha512": "cde2aaf16fe121e92631e7bc8c299b4921abd7418e227b815e0d08e304793691031271eb724b555fe57b82caf4ec0393d17963a3a8503ad7469a4a46ecc63231"
  },
  {
   "path": "weights/model1-untrained/tier2/shard_L01.cmd",
   "bytes": 928792,
   "sha512": "02cb40be5a802734a73934a986b5dc8166d998d8a58a19544327caf601842c37bc47127eb308758aace0273ca45fcd74ddfbf9fe202cc4bbcf967c2343e10acb"
  },
  {
   "path": "weights/model1-untrained/tier2/shard_L02.cmd",
   "bytes": 928760,
   "sha512": "1126d2ba801354fae1f30baccc562e8d851f8247524835a507d37d66d07389d3e219bb464226e85d8573a6567a2df67fd7245d962d340d6cf0518ce7f409d384"
  },
  {
   "path": "weights/model1-untrained/tier2/shard_L03.cmd",
   "bytes": 928832,
   "sha512": "2007fb44290800b96cb4ab6c5542d6c5d4adc338e70ec1fa8afac323aeeec535a99d7a0c0ecb462b8d8f0ab3a86a46bf878d60bf82b792232a9c914a3423588f"
  },
  {
   "path": "weights/model2-tier1/SHA512SUMS.cmd",
   "bytes": 11807,
   "sha512": "80f9bb76ba32bb4a8a8f6652f0553e77162827e2945774da072019d37f3a18312514ae6d8487af5775342cc56e077e7bfab815ac524163fcb5898bfa60230149"
  },
  {
   "path": "weights/model2-tier1/manifest.cmd",
   "bytes": 37999,
   "sha512": "3b7dc605626eb7a09473bb07f8b1b11abb1352c1e19f3a13a1ab44fa8c6bcd8ee23c77cb56ae8a6aa3ec976fcc379e84a4b4fc26cccb640b6bf5c99ac963404f"
  },
  {
   "path": "weights/model2-tier1/shard_EMB0.cmd",
   "bytes": 11867560,
   "sha512": "31d13ec5d7d345999562228cc707691bed4c5f7eb419e6ae9e0b613d3603271529389a4f559da34c6ba0de1e4ef8fe057776a394bc3b366a050091dc12ff6838"
  },
  {
   "path": "weights/model2-tier1/shard_EMB1.cmd",
   "bytes": 13161506,
   "sha512": "5b7a0eeb201676b2c01eeb5b7d2080c791bf4ed491625d5f8cd20313bdbe5533cccce0ca6f7ff36c080879928625d11e1b5d9bdea32941e5c0c600cc1382a711"
  },
  {
   "path": "weights/model2-tier1/shard_L00_ATTN.cmd",
   "bytes": 8016044,
   "sha512": "d9e4092b4cf5bbe9f0358cfaf22987d019507df014166ae1760b0c532c785fdcccd2190f389978a2c5e54d6fdd2616967c3bb96a240fa77227c2f377c15d7db3"
  },
  {
   "path": "weights/model2-tier1/shard_L00_FFN.cmd",
   "bytes": 16958859,
   "sha512": "ce5cf629984109b0bb31dac86619999a9ddbe8d790c334de8d9df3fe9af703566c0377e60b9748d629ecd98a76a7b995a2f1714d5d07b6b13283065ad483f1c2"
  },
  {
   "path": "weights/model2-tier1/shard_L01_ATTN.cmd",
   "bytes": 8016454,
   "sha512": "aed436f23b8a071ec87c4ed6392afc8741aca8b3d9b9e1bcbca0f5022e50e831d6f18e3aea2403d05cbf0369ffb9e66034709d63538e9a3358111bf30d1dcadc"
  },
  {
   "path": "weights/model2-tier1/shard_L01_FFN.cmd",
   "bytes": 16958781,
   "sha512": "0171cf5eff3f7ad307537d597892061345f6c0c0b932dfa68900cfcdbf04edd6db238ecf9c5fbe3dbf4cd988e714a5e3f29e6ef8ec1a0506793e3ee80a53ff44"
  },
  {
   "path": "weights/model2-tier1/shard_L02_ATTN.cmd",
   "bytes": 8016058,
   "sha512": "28557dd674e1510c047df3d37c09d73f9c1df5d9d1a44d605aab115d84b8db8997334594924beb8f2913d15a3faa8fed0241ebb1fd33d37a07b93149a7ca4272"
  },
  {
   "path": "weights/model2-tier1/shard_L02_FFN.cmd",
   "bytes": 16957999,
   "sha512": "cef0398e00e264cc5ca4dcdf984417b2463ccdda6346f445aacf4866eecbbb1a61e66f53b3196d232860706cc4a1ce33ed786b822a6f3f3c3a0b43f152733250"
  },
  {
   "path": "weights/model2-tier1/shard_L03_ATTN.cmd",
   "bytes": 8016097,
   "sha512": "8ce28092e4e1f27975ab2b061cc71ca7587d8f8017fff9b1b2d8fabb8f30d3f51b0229e950278eaade1367bd8ed2b351a2c54ce4e39ae3fe4638f5ac87268b31"
  },
  {
   "path": "weights/model2-tier1/shard_L03_FFN.cmd",
   "bytes": 16958359,
   "sha512": "6a0b8e6de244a5d615bf2215e191f44375313ff4a4f9720adb9f7c58afc898d1a10f69ee9e84f91b7403b57ed6cf6f89e0576fbd9aeaef27d561a3051ca346c3"
  },
  {
   "path": "weights/model2-tier1/shard_L04_ATTN.cmd",
   "bytes": 8016287,
   "sha512": "b16837a9a4ac3a6dea2b6446d1f1d01aa54d83c302ba1d4cbc564a7c5290a22418638649934dc6f48050dd643b3807bd8e2e25b0fe8e02984f023e2468c62572"
  },
  {
   "path": "weights/model2-tier1/shard_L04_FFN.cmd",
   "bytes": 16958212,
   "sha512": "c1e3158a45f212517237bbb1acac76fc90cf8955272f2e7c04fdd86e319a2030486bfff6e61c62ee1032f08f9bb8d830ad38f00c87ad1873fd1f928863ef2d8d"
  },
  {
   "path": "weights/model2-tier1/shard_L05_ATTN.cmd",
   "bytes": 8016630,
   "sha512": "c5efcfd9f8de6555000c62f5fd64ece314759e571663ead85a5956f4f038df437a7ccba64639a1a3214e15f83d5fc819eb78c995af0ee1156c8962c6e72eae4b"
  },
  {
   "path": "weights/model2-tier1/shard_L05_FFN.cmd",
   "bytes": 16958465,
   "sha512": "b2408508299b4cfbf99a94fd506902c8ada9b47087df8f8f17d0fdffa063e9e465585a02a2de8293925c1fc9031b929e1ad6c5bb5da4987856e6377e0315770b"
  },
  {
   "path": "weights/model2-tier1/shard_L06_ATTN.cmd",
   "bytes": 8016263,
   "sha512": "ffe5be0209dbea1be55a3b991aa7c67b4c334f0c963d424bd4cb67b03301427aa7d7aa18551173eb55fbeace435efab6e173b321c22d1251c0ebf7da11ee6a87"
  },
  {
   "path": "weights/model2-tier1/shard_L06_FFN.cmd",
   "bytes": 16958684,
   "sha512": "6d20b73f812133238759a52fa5b8556dd835063f896ef5caccab7899a623190ac94d8a1310a2ae11ac0479bb11bb971f5ae93eed3153a7fd9d0d76db6d73bd7a"
  },
  {
   "path": "weights/model2-tier1/shard_L07_ATTN.cmd",
   "bytes": 8016189,
   "sha512": "922cb4681bf34162c5a978ab6ebe004315002d2d3c496db2456ec7744f7bb11e98093a0b1d2150d0f9267b8d1b55cd0986aa5949ad794130fd95118a46d11ee5"
  },
  {
   "path": "weights/model2-tier1/shard_L07_FFN.cmd",
   "bytes": 16958858,
   "sha512": "6b2f291ad02d13edf6f5bfec9977dee76d58fd0869f2c901f9f5e7f4e05a3dfff50ce871da6f0abec5d9883cfa18ddad79c9bb317344042a4b8f8d12cb7910a7"
  },
  {
   "path": "weights/model2-tier1/shard_L08_ATTN.cmd",
   "bytes": 8016180,
   "sha512": "e6ad4e5749766465ea98b69bf9961d86c44bb884600b03c71186bd273bbd8792c8c67c207d328af88f10bfbcd5b949b16a9ca7a6d86e95f6142fd04ea58de5ff"
  },
  {
   "path": "weights/model2-tier1/shard_L08_FFN.cmd",
   "bytes": 16958371,
   "sha512": "69bc71b3c749c293be38671ba6fe44cb0555d4d883c14c5972523e3582cd08f908d0d11bf0c462d404642dea768f415b4bdd86e37e7ae06d4a7044329a66a72f"
  },
  {
   "path": "weights/model2-tier1/shard_L09_ATTN.cmd",
   "bytes": 8016505,
   "sha512": "4f816dce845f4bd78af4550b095e9307f054e10fe2b5f426e305d11411f29f241f70acd3ac384dc94286ad543502df17e2c363dfc7f674bc36f6a0dfaf271130"
  },
  {
   "path": "weights/model2-tier1/shard_L09_FFN.cmd",
   "bytes": 16958808,
   "sha512": "1fafc0eca1cc9be15f264aa86831b56f2c00566b0015bf66457626e7116eaf291a4dccebb2ea4a8cb6acf2cbb9bdb461fb6300f5157d611b6f096a4cca66f0bb"
  },
  {
   "path": "weights/model2-tier1/shard_L10_ATTN.cmd",
   "bytes": 8016421,
   "sha512": "fd84254011d3a25470019d22eb4cef797e49e838bb5d51eef35d253ba8183f913b8b67c1b80daf77285b79f25ef25401f6bb6cb0dd6086d6bdfcb56e744a8f9c"
  },
  {
   "path": "weights/model2-tier1/shard_L10_FFN.cmd",
   "bytes": 16958112,
   "sha512": "f670414798fe406a9e45b64af2fbfa7cbc40c4914564b6e1ef915414a0c66d94a29e73e58807bf51a84d2d53534e4ccdd11c5c3faadfa27613b336f2c8fc6fb0"
  },
  {
   "path": "weights/model2-tier1/shard_L11_ATTN.cmd",
   "bytes": 8016666,
   "sha512": "3271bd6e83f235daef44d22bb600f16b4b43dc12c9b23d83d880a03a268014475f853773260df85789f3f4f11653fc081c5bdafdea489b12452eb429e6fd3fba"
  },
  {
   "path": "weights/model2-tier1/shard_L11_FFN.cmd",
   "bytes": 16958390,
   "sha512": "0c7e381873500ae2f1ae736c863166c8c3da6d0566596092d1763d64086161dc267eb6e451ce3335b65f057b5df3951ba3c24c601246b3cf6d662fdbb55bd323"
  },
  {
   "path": "weights/model2-tier1/shard_L12_ATTN.cmd",
   "bytes": 8016331,
   "sha512": "a075fe04446d669cba263167ab2682a711693a59688cf690ac540814ec3a782332727de98821773ae5034a4dfc803ce54eff0380c51e1ab4ce7c5c1b967d2262"
  },
  {
   "path": "weights/model2-tier1/shard_L12_FFN.cmd",
   "bytes": 16958748,
   "sha512": "e0e7608b136145e0554f93b826b9ff52d159ef70da99bd6fb4c95da9df4ac9e1c46717369553499c0c608cd6093609b4b7353b4598b5c6959b6df21464ed2e51"
  },
  {
   "path": "weights/model2-tier1/shard_L13_ATTN.cmd",
   "bytes": 8016288,
   "sha512": "e8c38ba7328936d73b8597c23622f89ebed1bcd598079c589d5a103dca5a6865dd4a446ec3f56871ba73de61e638b4a57b4f2a4a9e41a0fd72577fc758128239"
  },
  {
   "path": "weights/model2-tier1/shard_L13_FFN.cmd",
   "bytes": 16958544,
   "sha512": "c8f82f8aa57c90b48a1dd7012830b6e68fdbf81137751d62eeea9b21b7fd6931e72c3854c5805bed0e61737e590a49eefac93ae5fd90f6d4bad0a2abee576999"
  },
  {
   "path": "weights/model2-tier1/shard_L14_ATTN.cmd",
   "bytes": 8016109,
   "sha512": "914e3c3765ee40567bb60bcc6475d159027d84bcead56acc868709b340747889b97df205d59bebb7be4249a2c5f8a8cb8df5189e763c4c181c580bf0d09bfc2a"
  },
  {
   "path": "weights/model2-tier1/shard_L14_FFN.cmd",
   "bytes": 16958247,
   "sha512": "acc86d084ed8096b865054b49d10c067e6b926088439e6871d0445ab0f2a48b8868377dad94a452ec7e8f4bb111d6de4bb680bd35eb58b4666c7d761ed90e0d7"
  },
  {
   "path": "weights/model2-tier1/shard_L15_ATTN.cmd",
   "bytes": 8016278,
   "sha512": "59d82a0c835fe41aaf2b89cdad51b6771be3d2d2d243643fcca7459c5c3aba025a9743ea82adb2a82a213bb83fd5dc9562b5477f8c4938519cb0a0919cbee1a7"
  },
  {
   "path": "weights/model2-tier1/shard_L15_FFN.cmd",
   "bytes": 16958761,
   "sha512": "b5853653c39b7f0b5fd1126c39b52386ef1c4bc8b9a2c91fd53c04ff482c811462178892d75a26a02e5bf177f2f979408d72b341417c34e345f9920258d83624"
  },
  {
   "path": "weights/model2-tier1/shard_L16_ATTN.cmd",
   "bytes": 8015877,
   "sha512": "7a162d3ac8bd1fe97687b06048f6df324571aca8a60cee0d556368ab3e9f9a00753ad5dd365648b2eee0fc38553b9547b949b0af46ec641423ff2b59429e514e"
  },
  {
   "path": "weights/model2-tier1/shard_L16_FFN.cmd",
   "bytes": 16958788,
   "sha512": "6b07b32c403322aae238de6a05bd7e837a54045b4b7f6a20753207c734988c6ed221f447e95aeffe76d5404aed12f08c5cb0ec16d0e1c00f739c7dc5c31b2dc8"
  },
  {
   "path": "weights/model2-tier1/shard_L17_ATTN.cmd",
   "bytes": 8016277,
   "sha512": "5d0a64a1b06a715f78be059f130118cb6c7f029bb1669031f0ab88c1e1ac3ca6e3cbcae9d4b8488c106a08567df843d34890912f4ab36e288588704c1df4ce5c"
  },
  {
   "path": "weights/model2-tier1/shard_L17_FFN.cmd",
   "bytes": 16958038,
   "sha512": "4d66c66045616957bee1770ecb0ddbcd8d88f18c676141e57f429fa1669c539043da7eee01f4d72dd95761c263ccce0f013d4e3da12ae148de4b9d698020c8a8"
  },
  {
   "path": "weights/model2-tier1/shard_L18_ATTN.cmd",
   "bytes": 8016688,
   "sha512": "589eb5a4f3700a2484564d885159368eb8fe1881c2cb9c396905d53630289b82181a3d8cc4e364ef397fd3cf81bd2deadeeec8b14a6020466433a0fac5e853dc"
  },
  {
   "path": "weights/model2-tier1/shard_L18_FFN.cmd",
   "bytes": 16958654,
   "sha512": "b02eee47068e2f7046f2dcd898e3ec8194f04c02ec146d85ddc2ec04d1ecd3c735bc79c4394d1996649dc34818a6ac8ffc6aa5d61c6ff8613223e031dc49969b"
  },
  {
   "path": "weights/model2-tier1/shard_L19_ATTN.cmd",
   "bytes": 8016021,
   "sha512": "bc0f70ed11184a5c625294a6ca6ccc6f586a50de48c681392c3d9db77dfa04885fc3f76080ab7e4751e8b7b86565382d6f625a28f6ae4786a0bddcf9a8a91aea"
  },
  {
   "path": "weights/model2-tier1/shard_L19_FFN.cmd",
   "bytes": 16958524,
   "sha512": "dc34c473ae6ebe37dc2ad9922b30a0f1604bde26c443f9c5b380e9774519aa2f7193db6e224a3069329189b0d7723127580a821fef5de0244b367bd693081cad"
  },
  {
   "path": "weights/model2-tier1/shard_L20_ATTN.cmd",
   "bytes": 8016243,
   "sha512": "207a3577c244663468414d3ebc4a8e3dc18f2a5eac92c1078143eeec6fda9ab4a08d724ccfb9f69b50fe13d4659b8925f18c6e1e6b07082d37721ccb552e5105"
  },
  {
   "path": "weights/model2-tier1/shard_L20_FFN.cmd",
   "bytes": 16959136,
   "sha512": "4bbb1937256cf085c5244299c1703d6c042043118af62bf724c350e8d3a60b16e5782ff5c969d46ee5ad46fec1ee6d37f3b182c4919c0b83d743f4e138520519"
  },
  {
   "path": "weights/model2-tier1/shard_L21_ATTN.cmd",
   "bytes": 8016075,
   "sha512": "7a6cec13fd745f8258bf89051250e51ca15965d2143157a9741a13ca70f3c6b0082c8a18fc23e0ffecc478ba45eb5d89b1f331998d4544ec7f833317cada1401"
  },
  {
   "path": "weights/model2-tier1/shard_L21_FFN.cmd",
   "bytes": 16959468,
   "sha512": "caa9fe011770ae8fab4fd0e40f06b0ca3963f36bd45f265336c26b5182e12ddb37758f06b3bfa21c8f9c23ebdc62c260c566a449fcbb6e8dadb193ebb9d7d043"
  },
  {
   "path": "weights/model2-tier1/shard_L22_ATTN.cmd",
   "bytes": 8016252,
   "sha512": "4c26190b655928fa4a9b2c34e9a78c074f66ca28591500d0b75dfdf6f239da43e542af4e341e597eaef82291fb413b593b684c860c2695c7c74196d9ee63e658"
  },
  {
   "path": "weights/model2-tier1/shard_L22_FFN.cmd",
   "bytes": 16958427,
   "sha512": "59d277fdb5749cd5cf5f21714de2fc0e5a341be38ca29f0221838f13ea20e819147c4cc6677a80ff96103108b7d7c36cd63b1ebcd80f731eee49070e9139e1b4"
  },
  {
   "path": "weights/model2-tier1/shard_L23_ATTN.cmd",
   "bytes": 8016382,
   "sha512": "9ffbc0be107786d2091143b14de4eb26d2cbb6dc79e1b32c8a5a905817b9aed2dcc1917ab13ae208c0f712aaaba177a66eef39685e3622c147cea93f40d15a58"
  },
  {
   "path": "weights/model2-tier1/shard_L23_FFN.cmd",
   "bytes": 16958471,
   "sha512": "9fbe41fccd66945551a7acdfdd5b1958702560cbf4e6d28f051b3139a061f046c5e47c00053ef73c1b873ec01c21e29ea4914be3962b82fc40025abe45bd5ea9"
  },
  {
   "path": "weights/model2-tier1/shard_L24_ATTN.cmd",
   "bytes": 8016111,
   "sha512": "2853b4e1e89b3bcf06c2981a42bd63da3320db7dc62dc480976f34605a6311d727dc6fe89649c79f73827bfd0dba76e3ca9c4128bc77f531149942d3c34e998f"
  },
  {
   "path": "weights/model2-tier1/shard_L24_FFN.cmd",
   "bytes": 16958502,
   "sha512": "04655e7481df598a1582d89acc13f5f1108c5ea579c2153a723326dd703835b4203d95f458268d704dfcb837c0b4947dcbfe5e8bcfc6b1fa9812dd73648f683a"
  },
  {
   "path": "weights/model2-tier1/shard_L25_ATTN.cmd",
   "bytes": 8016111,
   "sha512": "93f2d6f97b37004f30902430a73240bc559ba61158b69c28507187e8b196802e966a8c3135534731a83ea6672c33dda5a23100b34eb93fff770921374c15fd88"
  },
  {
   "path": "weights/model2-tier1/shard_L25_FFN.cmd",
   "bytes": 16958676,
   "sha512": "e1d858979dc3d468e66727bb10d2fdfcd574378211f14d005ab5e87000e91f1ac23e4c6642d4dd48bdf8d09faccfb04042861c8c71a68c750d1654e3cf1e0fe8"
  },
  {
   "path": "weights/model2-tier1/shard_L26_ATTN.cmd",
   "bytes": 8016264,
   "sha512": "40d31daf69a4580105b1b71a0115041b2c8ebdfdbb56e8c4df1fe81f8c7d4eab33fc1b74b12328409ec399a97192f18c3492c0a80a938b36e3822c8aa21d46b5"
  },
  {
   "path": "weights/model2-tier1/shard_L26_FFN.cmd",
   "bytes": 16958193,
   "sha512": "7cb5dbd77fe9a32c86188c9fd200f9df2f283ee73e34dd8e1147cff4b073cbf602bd437a1560006ff00f1d7d111ec083cd3d292fed3790ddbf0a380fb771b8f4"
  },
  {
   "path": "weights/model2-tier1/shard_L27_ATTN.cmd",
   "bytes": 8016314,
   "sha512": "52c9af9e534daa2d03b23d3fc904eab243c6fe9b158ecbc0172cc5bf9a60eebf41c2408b24554fa9f3e2d04aa29cddddf105c86a73ee92782f2f51601edb9c24"
  },
  {
   "path": "weights/model2-tier1/shard_L27_FFN.cmd",
   "bytes": 16958965,
   "sha512": "0cd785a6dc0abe003cbda79735d5da88c9309d3b6fd4eaa00c10bc14d3ed6498992c81132196cada79dd8c2d8f8032d67091ead564e6648e275663139a1498d7"
  },
  {
   "path": "weights/model2-tier1/shard_L28_ATTN.cmd",
   "bytes": 8016195,
   "sha512": "39c0f67cc7301dcfcde990aa223cdc324d60711cdad69ac750d7b6240fc7150176aba2089cd6fea9c62787e442d6a9e2473ca2ddb1bf041096383aa7ee703caa"
  },
  {
   "path": "weights/model2-tier1/shard_L28_FFN.cmd",
   "bytes": 16958677,
   "sha512": "fbb57fa0dca5e7946f63d476016ad0bb07815373997840b4391efeb51631577a1e6162f818a17ebac07b72ce1ada08a8b301e5bdfd0b0a601493c068b5ba4b2d"
  },
  {
   "path": "weights/model2-tier1/shard_L29_ATTN.cmd",
   "bytes": 8016473,
   "sha512": "eea99a3f2a9ff1349b6c0161b692ae8d0942bd2189b6350e6a24c66b9ec37caa77dd8322939d3e1ad1de0c237d9bafdeb1cd4bf91c919c9eed179d1e63caad4d"
  },
  {
   "path": "weights/model2-tier1/shard_L29_FFN.cmd",
   "bytes": 16957919,
   "sha512": "e0ae00c9e57e3241528e43d4ce1938fbfaf978ce540eb52d77a628de6544e2a7c3877c22444f3a760a5220fb71dc5b5a057579200f9628bc750483b6a9cf83af"
  },
  {
   "path": "weights/model2-tier1/shard_L30_ATTN.cmd",
   "bytes": 8016114,
   "sha512": "f97219d7cd37af48c60d0e1d949121f29dbff80ddaa3189eda1511da6be464b0e7e085a777486741052fa9dcda471a67a1363c7ece4571322e107e924c0e4870"
  },
  {
   "path": "weights/model2-tier1/shard_L30_FFN.cmd",
   "bytes": 16958866,
   "sha512": "ad4bd0448dc2c65fe9e89d0855ff6573af5947c382744ae759099ab1f699260fbe5f88fc39dff320c665e70cecb79c5a6139a07813b31cf2d4de9898ae1e7d5f"
  },
  {
   "path": "weights/model2-tier1/shard_L31_ATTN.cmd",
   "bytes": 8016307,
   "sha512": "8febb366c52f2679633702498e36356384291f953efb33de4d25da7c6b63d711aeae8a7464eb12d3893d904e66090fc36cde7396c58f566b5d1fbf1881bdbbe4"
  },
  {
   "path": "weights/model2-tier1/shard_L31_FFN.cmd",
   "bytes": 16959059,
   "sha512": "fb4b7f9b62f4ac1bdf0b5d90393ce3335df306fc803daa362ee226caf57fbb2cc02acc9cae563e7e6f5f44e29904ed3ff7c133e02ab481b03bc74a10a05d57b0"
  },
  {
   "path": "weights/model2-tier1/shard_L32_ATTN.cmd",
   "bytes": 8016261,
   "sha512": "d40075796ba6fe64ad913c237473df470474d5ed878ad55df29feba5d61b645f3e2baf2b687813439201ec6ed9270afc1ee7336795e54704325a3d840700bc62"
  },
  {
   "path": "weights/model2-tier1/shard_L32_FFN.cmd",
   "bytes": 16958542,
   "sha512": "075a8e25d9fe7c8fd2fa388c34c93bec097c8d0032ba05d7822f574b648ac27eb7e889574ba02dcd20e0ffe67c3789a7773946727e53c943b940b11090ba3c49"
  },
  {
   "path": "weights/model2-tier1/shard_L33_ATTN.cmd",
   "bytes": 8016151,
   "sha512": "078bcdd00fe78c66a5b699c1f938d0530edd972e231556cb973293bf3175d15efe14eee15bed6ae3e3d374a451883889583c6226349743076d427afd3923bd61"
  },
  {
   "path": "weights/model2-tier1/shard_L33_FFN.cmd",
   "bytes": 16958560,
   "sha512": "05aba00c3a568c7d7e5e4f792d683b712f0280c8a2756b0baafe5ec5bb0492971d16a62d23f0559f3ca74ffc6cb90c54f8a15a8771c3ce88e8dca41c0d1dddf7"
  }
 ]
}