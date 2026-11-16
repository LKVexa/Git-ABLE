@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): manifest.json. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to print the document, with /check to check its SHA-512, or with /extract FILE to write it out.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=manifest.json"
set "LB_DOC_TYPE=json"
set "LB_DOC_BYTES=36588"
set "LB_DOC_SHA512=e25c494ceb7de1183b2833ba758d7eff986d809e8dccb5b45c007692f8969bd782032cb2a8c5e755266270ebcd7d4e9259e73f7a6f8872d90653bc15268e738a"
set "LB_SELF=%~f0"
set "LB_ARG=%~1"
set "LB_OUT=%~f2"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$n=[int]$env:LB_DOC_BYTES;$b=[IO.File]::ReadAllBytes($env:LB_SELF);$o=$b.Length-$n;$h=-join((New-Object Security.Cryptography.SHA512Managed).ComputeHash($b,$o,$n)|%%{$_.ToString('x2')});if($h -ne $env:LB_DOC_SHA512){[Console]::Error.WriteLine('LB-DOC/1: the SHA-512 of '+$env:LB_DOC+' differs from LB_DOC_SHA512');exit 1};if($env:LB_ARG -eq '/check'){'ok: '+$env:LB_DOC;exit 0};if($env:LB_ARG -eq '/extract'){$d=New-Object byte[] $n;[Array]::Copy($b,$o,$d,0,$n);[IO.File]::WriteAllBytes($env:LB_OUT,$d);'written: '+$env:LB_OUT;exit 0};[Console]::OutputEncoding=New-Object Text.UTF8Encoding $false;[Console]::Out.Write([Text.Encoding]::UTF8.GetString($b,$o,$n));exit 0"
set "LB_RC=%errorlevel%"
if "%LB_ARG%"=="" pause
exit /b %LB_RC%
rem ---- document ----
{
 "model": "KGD-IMQ-5DLLM-M2",
 "tier": "TIER-1",
 "tier0_subset": "the U1, V1, U2, V2, SR and SC families of every matrix",
 "config": {
  "vocab": 49152,
  "d": 52224,
  "n_layers": 34,
  "n_heads": 816,
  "n_kv": 408,
  "d_k": 64,
  "d_ff": 208896,
  "seq_len": 2048,
  "rope_base": 10000.0,
  "kgd": true,
  "alpha_init": 0.05,
  "c_init": 1.0,
  "emb_clusters": 16,
  "emb_cluster_rows": 3072
 },
 "trained": false,
 "seed": 2026,
 "pinned_source_commit": "7eaa920315a7ef513f9b0ef3be99cdcfa6cf5d88",
 "init": {
  "sign_factors": "Rademacher, PCG64 seeded by SHA-512(seed:variable family)",
  "svid_scales": "row and column scales 0.12632376 each (U0.16 8279, note eq. 18); their product 0.01595769 = E|W| for N(0, 0.02^2)",
  "dictionary_weights": 0,
  "norms": 1.0,
  "kgd": {
   "alpha": 0.05,
   "c": 1.0
  }
 },
 "nominal_parameters": 1022597991748,
 "stored_words": 24525536,
 "stored_bits": 784817152,
 "random_sign_words": 8044800,
 "rank_bound": {
  "tier0": 2,
  "tier1": 10,
  "effective_at_init": 2
 },
 "caps": {
  "shard_bytes": 24000000,
  "applies_to": "bytes_bound_any_values of every shard (the largest size any trained values can give)"
 },
 "total_bytes_bound_any_values": 929758995,
 "format": "LB-CMD/1",
 "shards": [
  {
   "file": "shard_EMB0.cmd",
   "bytes": 11867560,
   "sha512": "31d13ec5d7d345999562228cc707691bed4c5f7eb419e6ae9e0b613d3603271529389a4f559da34c6ba0de1e4ef8fe057776a394bc3b366a050091dc12ff6838",
   "payload_sha512": "cb5a668970e5c5babd831aa61864c336db96d62b5e90429c84efa002dabacdb2fdf55494b10b547eadb84e1fd94a0be97ef2a1202641f1c4ebb9c0c528cd7de6",
   "payload_lines": 359504,
   "l1_checksum": 268625139606035,
   "nominal_parameters": 1283457024,
   "bytes_bound_any_values": 12450996
  },
  {
   "file": "shard_EMB1.cmd",
   "bytes": 13161506,
   "sha512": "5b7a0eeb201676b2c01eeb5b7d2080c791bf4ed491625d5f8cd20313bdbe5533cccce0ca6f7ff36c080879928625d11e1b5d9bdea32941e5c0c600cc1382a711",
   "payload_sha512": "b5ee60be76e4f6b1b5646befa17f9515cdce9a7b2307dae312412e4f76933e4de9ca51203fc06d4fc10c320f58bab73d3de87d703046c1167f0ae29644b90388",
   "payload_lines": 411728,
   "l1_checksum": 268358006601076,
   "nominal_parameters": 1283509248,
   "bytes_bound_any_values": 14058831
  },
  {
   "file": "shard_L00_ATTN.cmd",
   "bytes": 8016044,
   "sha512": "d9e4092b4cf5bbe9f0358cfaf22987d019507df014166ae1760b0c532c785fdcccd2190f389978a2c5e54d6fdd2616967c3bb96a240fa77227c2f377c15d7db3",
   "payload_sha512": "86c3123a656d0507a9705f09ce3467ded99f2f5f87bf56298f89bf779d0248368b3219d4ff3dea43f8b2c1cc97c42791909ba63f5639eb3dd08b8a9f7fcf3326",
   "payload_lines": 222092,
   "l1_checksum": 126608943755380,
   "nominal_parameters": 8182090882,
   "bytes_bound_any_values": 8605854
  },
  {
   "file": "shard_L00_FFN.cmd",
   "bytes": 16958859,
   "sha512": "ce5cf629984109b0bb31dac86619999a9ddbe8d790c334de8d9df3fe9af703566c0377e60b9748d629ecd98a76a7b995a2f1714d5d07b6b13283065ad483f1c2",
   "payload_sha512": "b471061baed9752cc7b7e080f6652b650977c1649c2dcd95f6c48688f846e3e456154f2168a0a2c5a0dc1cabe2a2a9db1a17be3b9822286bd08fd8659be1b96a",
   "payload_lines": 476564,
   "l1_checksum": 317216396934899,
   "nominal_parameters": 21818821632,
   "bytes_bound_any_values": 17960298
  },
  {
   "file": "shard_L01_ATTN.cmd",
   "bytes": 8016454,
   "sha512": "aed436f23b8a071ec87c4ed6392afc8741aca8b3d9b9e1bcbca0f5022e50e831d6f18e3aea2403d05cbf0369ffb9e66034709d63538e9a3358111bf30d1dcadc",
   "payload_sha512": "556c28f7660b02bd398df09406f7b9b27ba035f831b061f6796ab40ac01977c87a941a38b730077f011a214b6227a2553a8e0e2ac6325afb1765114246d3905b",
   "payload_lines": 222092,
   "l1_checksum": 126626013310569,
   "nominal_parameters": 8182090882,
   "bytes_bound_any_values": 8605854
  },
  {
   "file": "shard_L01_FFN.cmd",
   "bytes": 16958781,
   "sha512": "0171cf5eff3f7ad307537d597892061345f6c0c0b932dfa68900cfcdbf04edd6db238ecf9c5fbe3dbf4cd988e714a5e3f29e6ef8ec1a0506793e3ee80a53ff44",
   "payload_sha512": "2d75e4a8248219cdeac50bffedc194f9f4a920ca3e1552b48d0e9ec6fd1ce26d90e5e4faff5d968a5a5406ee2017fbdd0425f3625cc9e3e1d95149b49a820000",
   "payload_lines": 476564,
   "l1_checksum": 317024974745164,
   "nominal_parameters": 21818821632,
   "bytes_bound_any_values": 17960298
  },
  {
   "file": "shard_L02_ATTN.cmd",
   "bytes": 8016058,
   "sha512": "28557dd674e1510c047df3d37c09d73f9c1df5d9d1a44d605aab115d84b8db8997334594924beb8f2913d15a3faa8fed0241ebb1fd33d37a07b93149a7ca4272",
   "payload_sha512": "d76548b17d41cb0936c14705deb359974eb01f2585f19b946b07b0f5171ecbf6cc9da51bd692ae1066c1d1dd42d851c76f96d04be05a4002f9e17b4ad00b6b4c",
   "payload_lines": 222092,
   "l1_checksum": 126327143134880,
   "nominal_parameters": 8182090882,
   "bytes_bound_any_values": 8605854
  },
  {
   "file": "shard_L02_FFN.cmd",
   "bytes": 16957999,
   "sha512": "cef0398e00e264cc5ca4dcdf984417b2463ccdda6346f445aacf4866eecbbb1a61e66f53b3196d232860706cc4a1ce33ed786b822a6f3f3c3a0b43f152733250",
   "payload_sha512": "7223fe07758a10bce23566ed1d94007f8f524df11ed14169df1a52b59cbe9df364f2be42a8bdf060ed3602e35489fdc149285ce2a2d790dcaf35209d764eb46d",
   "payload_lines": 476564,
   "l1_checksum": 316815637189874,
   "nominal_parameters": 21818821632,
   "bytes_bound_any_values": 17960298
  },
  {
   "file": "shard_L03_ATTN.cmd",
   "bytes": 8016097,
   "sha512": "8ce28092e4e1f27975ab2b061cc71ca7587d8f8017fff9b1b2d8fabb8f30d3f51b0229e950278eaade1367bd8ed2b351a2c54ce4e39ae3fe4638f5ac87268b31",
   "payload_sha512": "2e17776545ebd2e5bdcef4ca002760f1b5fbf1b5ae36f9b38a2cace8aa12d42a89c8776fec882b37f718f9a83cbfb4de7951d391823bb45278bb7e3360075750",
   "payload_lines": 222092,
   "l1_checksum": 126668061361028,
   "nominal_parameters": 8182090882,
   "bytes_bound_any_values": 8605854
  },
  {
   "file": "shard_L03_FFN.cmd",
   "bytes": 16958359,
   "sha512": "6a0b8e6de244a5d615bf2215e191f44375313ff4a4f9720adb9f7c58afc898d1a10f69ee9e84f91b7403b57ed6cf6f89e0576fbd9aeaef27d561a3051ca346c3",
   "payload_sha512": "2943b25005038534c420ab17585221dc44ca59d93f3357af62623cf0cc7d36675a516107400b98c5ff40dc3ef09a49082d9eb8e6131b1ce2a9e2a774154ef01d",
   "payload_lines": 476564,
   "l1_checksum": 316783729332913,
   "nominal_parameters": 21818821632,
   "bytes_bound_any_values": 17960298
  },
  {
   "file": "shard_L04_ATTN.cmd",
   "bytes": 8016287,
   "sha512": "b16837a9a4ac3a6dea2b6446d1f1d01aa54d83c302ba1d4cbc564a7c5290a22418638649934dc6f48050dd643b3807bd8e2e25b0fe8e02984f023e2468c62572",
   "payload_sha512": "1ea2b8b6ff0fc1f158cb92e8199f025c28fbc245d55f74d6ebb71572408efef368a7d4618d1755c0e09c863d523a493327c19385bd6fc322e0a147f8556618eb",
   "payload_lines": 222092,
   "l1_checksum": 126958317600329,
   "nominal_parameters": 8182090882,
   "bytes_bound_any_values": 8605854
  },
  {
   "file": "shard_L04_FFN.cmd",
   "bytes": 16958212,
   "sha512": "c1e3158a45f212517237bbb1acac76fc90cf8955272f2e7c04fdd86e319a2030486bfff6e61c62ee1032f08f9bb8d830ad38f00c87ad1873fd1f928863ef2d8d",
   "payload_sha512": "bf722d4f35fbc3ec8f520c29ae5e8b59d13035e4d50ef750214dddfd5c3383676bfd1728a28869260f741eb1e1522675dce1c996f6ecf56a2f9b97dd10067574",
   "payload_lines": 476564,
   "l1_checksum": 316696062525221,
   "nominal_parameters": 21818821632,
   "bytes_bound_any_values": 17960298
  },
  {
   "file": "shard_L05_ATTN.cmd",
   "bytes": 8016630,
   "sha512": "c5efcfd9f8de6555000c62f5fd64ece314759e571663ead85a5956f4f038df437a7ccba64639a1a3214e15f83d5fc819eb78c995af0ee1156c8962c6e72eae4b",
   "payload_sha512": "1b7fe7d65c3d2adaecaf9aca08dddf2a46585858341468507c18f716d4ed641743a29f4a6e1ca8423c12a0027cf00ce39eb7dfc21d95b55217ad447370ba0e60",
   "payload_lines": 222092,
   "l1_checksum": 126975522788456,
   "nominal_parameters": 8182090882,
   "bytes_bound_any_values": 8605854
  },
  {
   "file": "shard_L05_FFN.cmd",
   "bytes": 16958465,
   "sha512": "b2408508299b4cfbf99a94fd506902c8ada9b47087df8f8f17d0fdffa063e9e465585a02a2de8293925c1fc9031b929e1ad6c5bb5da4987856e6377e0315770b",
   "payload_sha512": "52e8d32fe687ee93b50f15fc53d9a6d3fbc628a95c8034adb79e3b63ede3634b35cc3d66af6a5368ab002c7afb85612d548bcee10df692e0f9a4254852166b6b",
   "payload_lines": 476564,
   "l1_checksum": 316803164803491,
   "nominal_parameters": 21818821632,
   "bytes_bound_any_values": 17960298
  },
  {
   "file": "shard_L06_ATTN.cmd",
   "bytes": 8016263,
   "sha512": "ffe5be0209dbea1be55a3b991aa7c67b4c334f0c963d424bd4cb67b03301427aa7d7aa18551173eb55fbeace435efab6e173b321c22d1251c0ebf7da11ee6a87",
   "payload_sha512": "9ca0253aa66a08dc4cab32e9191c8966b62c6b7e72c0e21d37c5fc43bd721d4b6b9840993c2987ed6905e8459d22f812dc5238e53d75594f880e91afdb685909",
   "payload_lines": 222092,
   "l1_checksum": 126783521939699,
   "nominal_parameters": 8182090882,
   "bytes_bound_any_values": 8605854
  },
  {
   "file": "shard_L06_FFN.cmd",
   "bytes": 16958684,
   "sha512": "6d20b73f812133238759a52fa5b8556dd835063f896ef5caccab7899a623190ac94d8a1310a2ae11ac0479bb11bb971f5ae93eed3153a7fd9d0d76db6d73bd7a",
   "payload_sha512": "33789fad14f489dc5a548779d5fff5490af29511103ede1458ceebb2dc16c99f7b4ca47d2c825b4aa8682e1c1c8b0942467ded6e25499b1b8e98def13379c9d7",
   "payload_lines": 476564,
   "l1_checksum": 317127163974587,
   "nominal_parameters": 21818821632,
   "bytes_bound_any_values": 17960298
  },
  {
   "file": "shard_L07_ATTN.cmd",
   "bytes": 8016189,
   "sha512": "922cb4681bf34162c5a978ab6ebe004315002d2d3c496db2456ec7744f7bb11e98093a0b1d2150d0f9267b8d1b55cd0986aa5949ad794130fd95118a46d11ee5",
   "payload_sha512": "ff7c9ad85998dcd5cd5b31544d0e7bdeefcb0b0a35571b323e09e8e8cbc57d8b8b34b92785c135fbc6aa1adf85adfdb2ed230bdf60f170efc349657463701606",
   "payload_lines": 222092,
   "l1_checksum": 126701586801233,
   "nominal_parameters": 8182090882,
   "bytes_bound_any_values": 8605854
  },
  {
   "file": "shard_L07_FFN.cmd",
   "bytes": 16958858,
   "sha512": "6b2f291ad02d13edf6f5bfec9977dee76d58fd0869f2c901f9f5e7f4e05a3dfff50ce871da6f0abec5d9883cfa18ddad79c9bb317344042a4b8f8d12cb7910a7",
   "payload_sha512": "c89a5ce34e7a67d1b7da11478ee561641058f135d05210099a3c45ca001b871b7ec9eef806976788045ddb90e78143cfd02c9cc8235c4cfa47e1009b7a9f0d39",
   "payload_lines": 476564,
   "l1_checksum": 317111329482446,
   "nominal_parameters": 21818821632,
   "bytes_bound_any_values": 17960298
  },
  {
   "file": "shard_L08_ATTN.cmd",
   "bytes": 8016180,
   "sha512": "e6ad4e5749766465ea98b69bf9961d86c44bb884600b03c71186bd273bbd8792c8c67c207d328af88f10bfbcd5b949b16a9ca7a6d86e95f6142fd04ea58de5ff",
   "payload_sha512": "09c82c91909ccb0b0aa9b2bb8f08cb88085ce0e7a565b3acd1c4fc296b25b35c7f1071324ee499f2ba0a53977418d0e37a6e2c5f8b72a603b845f592fc48c37f",
   "payload_lines": 222092,
   "l1_checksum": 126821080083760,
   "nominal_parameters": 8182090882,
   "bytes_bound_any_values": 8605854
  },
  {
   "file": "shard_L08_FFN.cmd",
   "bytes": 16958371,
   "sha512": "69bc71b3c749c293be38671ba6fe44cb0555d4d883c14c5972523e3582cd08f908d0d11bf0c462d404642dea768f415b4bdd86e37e7ae06d4a7044329a66a72f",
   "payload_sha512": "27042cb093ea51ea250f3b56823ac9374c5e218f2b65695469339774d488f45f440acfd376059a9818e1dcab12490fde7b4ba4ef06c64fead9c1a3d32f0dd02d",
   "payload_lines": 476564,
   "l1_checksum": 316689692529038,
   "nominal_parameters": 21818821632,
   "bytes_bound_any_values": 17960298
  },
  {
   "file": "shard_L09_ATTN.cmd",
   "bytes": 8016505,
   "sha512": "4f816dce845f4bd78af4550b095e9307f054e10fe2b5f426e305d11411f29f241f70acd3ac384dc94286ad543502df17e2c363dfc7f674bc36f6a0dfaf271130",
   "payload_sha512": "7f7cb8fbb44934dd25e8ad8fdac4f0cd158fed32ab11a622d536ce983e053c106f820f8a63eb2199f7d21768595b20c369f740ab0ed969af683c536b85025849",
   "payload_lines": 222092,
   "l1_checksum": 126886176169400,
   "nominal_parameters": 8182090882,
   "bytes_bound_any_values": 8605854
  },
  {
   "file": "shard_L09_FFN.cmd",
   "bytes": 16958808,
   "sha512": "1fafc0eca1cc9be15f264aa86831b56f2c00566b0015bf66457626e7116eaf291a4dccebb2ea4a8cb6acf2cbb9bdb461fb6300f5157d611b6f096a4cca66f0bb",
   "payload_sha512": "21fbd431afbd4f21aa602292fb5d4b7a89f2a4d19b0f6bc3bbf1e9468ff807b0a718d3b2be83712757af1ffd0352b16898b462ac361cf7eb2e551929ce3f1709",
   "payload_lines": 476564,
   "l1_checksum": 317259964977837,
   "nominal_parameters": 21818821632,
   "bytes_bound_any_values": 17960298
  },
  {
   "file": "shard_L10_ATTN.cmd",
   "bytes": 8016421,
   "sha512": "fd84254011d3a25470019d22eb4cef797e49e838bb5d51eef35d253ba8183f913b8b67c1b80daf77285b79f25ef25401f6bb6cb0dd6086d6bdfcb56e744a8f9c",
   "payload_sha512": "cedccd1b43a680e8468d34764f2b3a749df9f7d5fc02a463635d3d41b69609fd39f338ed6043332168a18dc74174b695d27d0df5b2bc186a42eb717aa1f1e445",
   "payload_lines": 222092,
   "l1_checksum": 126613252394497,
   "nominal_parameters": 8182090882,
   "bytes_bound_any_values": 8605854
  },
  {
   "file": "shard_L10_FFN.cmd",
   "bytes": 16958112,
   "sha512": "f670414798fe406a9e45b64af2fbfa7cbc40c4914564b6e1ef915414a0c66d94a29e73e58807bf51a84d2d53534e4ccdd11c5c3faadfa27613b336f2c8fc6fb0",
   "payload_sha512": "b57df4e268200630ad272a1317c22efa431961c613a282ba9d250f1041498a6298d4ca4bd3c7dbac704b34ad7b0190c86bde45cd3b612e0ae160f9b43726cf7c",
   "payload_lines": 476564,
   "l1_checksum": 316494040923424,
   "nominal_parameters": 21818821632,
   "bytes_bound_any_values": 17960298
  },
  {
   "file": "shard_L11_ATTN.cmd",
   "bytes": 8016666,
   "sha512": "3271bd6e83f235daef44d22bb600f16b4b43dc12c9b23d83d880a03a268014475f853773260df85789f3f4f11653fc081c5bdafdea489b12452eb429e6fd3fba",
   "payload_sha512": "c7c06879620930a9455cd217af97b8d1ff54ffdc029dcbe6d9e2c979eeb5c072479891ef34734b2d430e6e53ca764e0a1ad8c91a0f39efa46b0157cf5c7429d5",
   "payload_lines": 222092,
   "l1_checksum": 126883443036201,
   "nominal_parameters": 8182090882,
   "bytes_bound_any_values": 8605854
  },
  {
   "file": "shard_L11_FFN.cmd",
   "bytes": 16958390,
   "sha512": "0c7e381873500ae2f1ae736c863166c8c3da6d0566596092d1763d64086161dc267eb6e451ce3335b65f057b5df3951ba3c24c601246b3cf6d662fdbb55bd323",
   "payload_sha512": "0dec2c8813d4036211b78b97a47954e692d115ca3160da792183132f7bea51c269a7768d36622c0171c449daa692e2cccbcd0e0ced38fd8548139ac578aa7ea3",
   "payload_lines": 476564,
   "l1_checksum": 316751505390115,
   "nominal_parameters": 21818821632,
   "bytes_bound_any_values": 17960298
  },
  {
   "file": "shard_L12_ATTN.cmd",
   "bytes": 8016331,
   "sha512": "a075fe04446d669cba263167ab2682a711693a59688cf690ac540814ec3a782332727de98821773ae5034a4dfc803ce54eff0380c51e1ab4ce7c5c1b967d2262",
   "payload_sha512": "70971a0c3a254277dc1ada5cb5cb2654573eb30a79c7334dac8bb7b53a05e6fa17f70460271d8e1e88fee5a0e605fd9978139203e478aa085eea97ce2d75e21c",
   "payload_lines": 222092,
   "l1_checksum": 126732530493436,
   "nominal_parameters": 8182090882,
   "bytes_bound_any_values": 8605854
  },
  {
   "file": "shard_L12_FFN.cmd",
   "bytes": 16958748,
   "sha512": "e0e7608b136145e0554f93b826b9ff52d159ef70da99bd6fb4c95da9df4ac9e1c46717369553499c0c608cd6093609b4b7353b4598b5c6959b6df21464ed2e51",
   "payload_sha512": "334099213160333adc4c3e48d1c183a936368d88e57374ba7d63157136197395272f5b11a90204760dd217307a10c9eeb1b57645c45e1989c8e81ea877e4cb03",
   "payload_lines": 476564,
   "l1_checksum": 317350460354314,
   "nominal_parameters": 21818821632,
   "bytes_bound_any_values": 17960298
  },
  {
   "file": "shard_L13_ATTN.cmd",
   "bytes": 8016288,
   "sha512": "e8c38ba7328936d73b8597c23622f89ebed1bcd598079c589d5a103dca5a6865dd4a446ec3f56871ba73de61e638b4a57b4f2a4a9e41a0fd72577fc758128239",
   "payload_sha512": "e7d31e66eb32e4c936cc97a598c00a70ea95fb121e8173095de4fd398139a4257a6a5819e2453a2d1cfaf9e2835ba94dfe5eaf6457dbc846c04baee5b382d01d",
   "payload_lines": 222092,
   "l1_checksum": 126678022857677,
   "nominal_parameters": 8182090882,
   "bytes_bound_any_values": 8605854
  },
  {
   "file": "shard_L13_FFN.cmd",
   "bytes": 16958544,
   "sha512": "c8f82f8aa57c90b48a1dd7012830b6e68fdbf81137751d62eeea9b21b7fd6931e72c3854c5805bed0e61737e590a49eefac93ae5fd90f6d4bad0a2abee576999",
   "payload_sha512": "c6ac592d12ba86b7c28d2d6dd55a6e2776a74212e6751029e5ad678c13e554f61dfde42cc41b368bbf52dab74b99270433269a4a0d4fe2868a5845d287a18ec8",
   "payload_lines": 476564,
   "l1_checksum": 316647316754670,
   "nominal_parameters": 21818821632,
   "bytes_bound_any_values": 17960298
  },
  {
   "file": "shard_L14_ATTN.cmd",
   "bytes": 8016109,
   "sha512": "914e3c3765ee40567bb60bcc6475d159027d84bcead56acc868709b340747889b97df205d59bebb7be4249a2c5f8a8cb8df5189e763c4c181c580bf0d09bfc2a",
   "payload_sha512": "6f6ca49a4cf05b45f9ea994f7e03b760d68b6790e0157dc90944e93dec1b2ad1c2f106eeb092745d585cfb829140e2ed74e91cd41d1342e0077485f85d1f546d",
   "payload_lines": 222092,
   "l1_checksum": 126774425023262,
   "nominal_parameters": 8182090882,
   "bytes_bound_any_values": 8605854
  },
  {
   "file": "shard_L14_FFN.cmd",
   "bytes": 16958247,
   "sha512": "acc86d084ed8096b865054b49d10c067e6b926088439e6871d0445ab0f2a48b8868377dad94a452ec7e8f4bb111d6de4bb680bd35eb58b4666c7d761ed90e0d7",
   "payload_sha512": "489d82bbcba04c4eb24aa12ba1b2761b194ea4f5f59671e7f6db4d5dafc54a17481bd4935afdf3db4ce2f130892aad67b13829182d85aa90268522bb23310564",
   "payload_lines": 476564,
   "l1_checksum": 316933809266054,
   "nominal_parameters": 21818821632,
   "bytes_bound_any_values": 17960298
  },
  {
   "file": "shard_L15_ATTN.cmd",
   "bytes": 8016278,
   "sha512": "59d82a0c835fe41aaf2b89cdad51b6771be3d2d2d243643fcca7459c5c3aba025a9743ea82adb2a82a213bb83fd5dc9562b5477f8c4938519cb0a0919cbee1a7",
   "payload_sha512": "6df86e1e3fd1d6fe5b47368fa25555f8c27e3d4fb1abfd0141c0050c2b21fc9c87195ea0acb8223cdb8e9e5088c99be37303df9fb0c036f948c9df6745da7b04",
   "payload_lines": 222092,
   "l1_checksum": 126650099381084,
   "nominal_parameters": 8182090882,
   "bytes_bound_any_values": 8605854
  },
  {
   "file": "shard_L15_FFN.cmd",
   "bytes": 16958761,
   "sha512": "b5853653c39b7f0b5fd1126c39b52386ef1c4bc8b9a2c91fd53c04ff482c811462178892d75a26a02e5bf177f2f979408d72b341417c34e345f9920258d83624",
   "payload_sha512": "a3f34ec00c26bb488b01bf0b589bbcdc5ac9cc465330b935bc42b3a41387e6766f649dd935ea803ed94f71d77701c10e5d669b4629c136e6f7b94b5c2ed2d530",
   "payload_lines": 476564,
   "l1_checksum": 317179201056380,
   "nominal_parameters": 21818821632,
   "bytes_bound_any_values": 17960298
  },
  {
   "file": "shard_L16_ATTN.cmd",
   "bytes": 8015877,
   "sha512": "7a162d3ac8bd1fe97687b06048f6df324571aca8a60cee0d556368ab3e9f9a00753ad5dd365648b2eee0fc38553b9547b949b0af46ec641423ff2b59429e514e",
   "payload_sha512": "a0d0088e94727d11b27e8021e5ef94234865bc15e9c820dcfdc6bb40c6a235dc6a08991477210acc6c7b0b3b6201c02a24000034205e626e0ea01c0ed7594eee",
   "payload_lines": 222092,
   "l1_checksum": 126371314948949,
   "nominal_parameters": 8182090882,
   "bytes_bound_any_values": 8605854
  },
  {
   "file": "shard_L16_FFN.cmd",
   "bytes": 16958788,
   "sha512": "6b07b32c403322aae238de6a05bd7e837a54045b4b7f6a20753207c734988c6ed221f447e95aeffe76d5404aed12f08c5cb0ec16d0e1c00f739c7dc5c31b2dc8",
   "payload_sha512": "433b87bb62908ecaf075e97e6e00cdf4b42a97fb3bbf24ac4f284856f212e3988b7f16717f4021eda975ec3e4b63ac1e583ed9af2ceeceb0d017338b3e83794b",
   "payload_lines": 476564,
   "l1_checksum": 317083690377142,
   "nominal_parameters": 21818821632,
   "bytes_bound_any_values": 17960298
  },
  {
   "file": "shard_L17_ATTN.cmd",
   "bytes": 8016277,
   "sha512": "5d0a64a1b06a715f78be059f130118cb6c7f029bb1669031f0ab88c1e1ac3ca6e3cbcae9d4b8488c106a08567df843d34890912f4ab36e288588704c1df4ce5c",
   "payload_sha512": "e27ce4b6e6259875b7915d7bfea9391058c8e79c1c976e59531b94c29c8dbe4fe4da9638c7441f5a51ed74533c5ff660368d97f64513a0df45adbc4f633122d9",
   "payload_lines": 222092,
   "l1_checksum": 126621461855941,
   "nominal_parameters": 8182090882,
   "bytes_bound_any_values": 8605854
  },
  {
   "file": "shard_L17_FFN.cmd",
   "bytes": 16958038,
   "sha512": "4d66c66045616957bee1770ecb0ddbcd8d88f18c676141e57f429fa1669c539043da7eee01f4d72dd95761c263ccce0f013d4e3da12ae148de4b9d698020c8a8",
   "payload_sha512": "4d2c9b22a288eec8c918f28b88b98c1615bb5526074e2b9d9f993a708cc264f6d61515d738978a2815c8dc655593ebd86176d21f70331fbc84fafff86517a223",
   "payload_lines": 476564,
   "l1_checksum": 316213267676220,
   "nominal_parameters": 21818821632,
   "bytes_bound_any_values": 17960298
  },
  {
   "file": "shard_L18_ATTN.cmd",
   "bytes": 8016688,
   "sha512": "589eb5a4f3700a2484564d885159368eb8fe1881c2cb9c396905d53630289b82181a3d8cc4e364ef397fd3cf81bd2deadeeec8b14a6020466433a0fac5e853dc",
   "payload_sha512": "bdcc2ee6d00c00000cddd8458aa648a89102eae702730c1df36f86e30032937da9fdb68c2dd8d22d8d524df7ab6690eab3c9147a0f4905433b7610446f601b36",
   "payload_lines": 222092,
   "l1_checksum": 126977528137711,
   "nominal_parameters": 8182090882,
   "bytes_bound_any_values": 8605854
  },
  {
   "file": "shard_L18_FFN.cmd",
   "bytes": 16958654,
   "sha512": "b02eee47068e2f7046f2dcd898e3ec8194f04c02ec146d85ddc2ec04d1ecd3c735bc79c4394d1996649dc34818a6ac8ffc6aa5d61c6ff8613223e031dc49969b",
   "payload_sha512": "3ee5a790e6181b7616d89419fef5d9e502a4e31608a54b2988d1a04720553bdfd1c24aef0d95df14abcd441057eece4d040d7d097709acfe5d08fa9f649dc412",
   "payload_lines": 476564,
   "l1_checksum": 317004466940857,
   "nominal_parameters": 21818821632,
   "bytes_bound_any_values": 17960298
  },
  {
   "file": "shard_L19_ATTN.cmd",
   "bytes": 8016021,
   "sha512": "bc0f70ed11184a5c625294a6ca6ccc6f586a50de48c681392c3d9db77dfa04885fc3f76080ab7e4751e8b7b86565382d6f625a28f6ae4786a0bddcf9a8a91aea",
   "payload_sha512": "9e7814f2052fafefdfaa3be7ebc3a209a197cce4d052480271b04b5fdd04fc2a1df6bfc46e8db60bbc1d765bcc281047dc6d56967fb0ef8365d3a7c35ae7cc32",
   "payload_lines": 222092,
   "l1_checksum": 126457276096959,
   "nominal_parameters": 8182090882,
   "bytes_bound_any_values": 8605854
  },
  {
   "file": "shard_L19_FFN.cmd",
   "bytes": 16958524,
   "sha512": "dc34c473ae6ebe37dc2ad9922b30a0f1604bde26c443f9c5b380e9774519aa2f7193db6e224a3069329189b0d7723127580a821fef5de0244b367bd693081cad",
   "payload_sha512": "82d9fd1647b0586902b44165d4455985a3744616571b20022578cfde5c73c3c2694cb94038fe1441261086ef1514b2dcf3ef8f9350ad79be9c0923dad9fb9f57",
   "payload_lines": 476564,
   "l1_checksum": 316919643471098,
   "nominal_parameters": 21818821632,
   "bytes_bound_any_values": 17960298
  },
  {
   "file": "shard_L20_ATTN.cmd",
   "bytes": 8016243,
   "sha512": "207a3577c244663468414d3ebc4a8e3dc18f2a5eac92c1078143eeec6fda9ab4a08d724ccfb9f69b50fe13d4659b8925f18c6e1e6b07082d37721ccb552e5105",
   "payload_sha512": "13e25343a54746e4ad937c9db1c547ea4770d61e79f8930652f11a65d55e6ac5040c8a5662563ce844f5f64c4d4a2ce3e9621408327d50baabd4583a2b57ae70",
   "payload_lines": 222092,
   "l1_checksum": 126799897258507,
   "nominal_parameters": 8182090882,
   "bytes_bound_any_values": 8605854
  },
  {
   "file": "shard_L20_FFN.cmd",
   "bytes": 16959136,
   "sha512": "4bbb1937256cf085c5244299c1703d6c042043118af62bf724c350e8d3a60b16e5782ff5c969d46ee5ad46fec1ee6d37f3b182c4919c0b83d743f4e138520519",
   "payload_sha512": "6bfd1616a4b4e1fa88848fd96f4534ce398fe093aaa3bc36e348ca9c7b96658e3297b1078e3a44fa1745f2f788b424dca0dbf8aaa1907e60678b5038cb7efd5b",
   "payload_lines": 476564,
   "l1_checksum": 317251646684986,
   "nominal_parameters": 21818821632,
   "bytes_bound_any_values": 17960298
  },
  {
   "file": "shard_L21_ATTN.cmd",
   "bytes": 8016075,
   "sha512": "7a6cec13fd745f8258bf89051250e51ca15965d2143157a9741a13ca70f3c6b0082c8a18fc23e0ffecc478ba45eb5d89b1f331998d4544ec7f833317cada1401",
   "payload_sha512": "7fcdaa318369a5b1c175ab31c729ba64765a0bd77a92457dd07ae57b9301536a721a1e2f36f32464b255c6a33c8c9d713e1b289410c06b52a13e83febac53bb4",
   "payload_lines": 222092,
   "l1_checksum": 126822744434711,
   "nominal_parameters": 8182090882,
   "bytes_bound_any_values": 8605854
  },
  {
   "file": "shard_L21_FFN.cmd",
   "bytes": 16959468,
   "sha512": "caa9fe011770ae8fab4fd0e40f06b0ca3963f36bd45f265336c26b5182e12ddb37758f06b3bfa21c8f9c23ebdc62c260c566a449fcbb6e8dadb193ebb9d7d043",
   "payload_sha512": "615de645814f24781d8e96df3b1f8ca77943fed4422f607f904b45e054565ae59530f4d26625d03a374f605c893a510c20b93dac2242cbc092e98b31d141b2e0",
   "payload_lines": 476564,
   "l1_checksum": 317645244288070,
   "nominal_parameters": 21818821632,
   "bytes_bound_any_values": 17960298
  },
  {
   "file": "shard_L22_ATTN.cmd",
   "bytes": 8016252,
   "sha512": "4c26190b655928fa4a9b2c34e9a78c074f66ca28591500d0b75dfdf6f239da43e542af4e341e597eaef82291fb413b593b684c860c2695c7c74196d9ee63e658",
   "payload_sha512": "407284d2324d4cef19aab515352c866c3b881e8361c8f39a2bd4e9ec00e3ee336fa00fdb39c30e41226c3cbb0bbdd5f2923454694cec8cffbb7a89c7b5fb3e7b",
   "payload_lines": 222092,
   "l1_checksum": 126828888554188,
   "nominal_parameters": 8182090882,
   "bytes_bound_any_values": 8605854
  },
  {
   "file": "shard_L22_FFN.cmd",
   "bytes": 16958427,
   "sha512": "59d277fdb5749cd5cf5f21714de2fc0e5a341be38ca29f0221838f13ea20e819147c4cc6677a80ff96103108b7d7c36cd63b1ebcd80f731eee49070e9139e1b4",
   "payload_sha512": "6db9c1617e864e6367a816db17600f4c8ee9e0dade9ede12ceb4b17e540cec2a9692bf5e931c72cc0f3af66bef24ec71a3ce00f1c5b510d8b365cbb36a8c117d",
   "payload_lines": 476564,
   "l1_checksum": 316602113603328,
   "nominal_parameters": 21818821632,
   "bytes_bound_any_values": 17960298
  },
  {
   "file": "shard_L23_ATTN.cmd",
   "bytes": 8016382,
   "sha512": "9ffbc0be107786d2091143b14de4eb26d2cbb6dc79e1b32c8a5a905817b9aed2dcc1917ab13ae208c0f712aaaba177a66eef39685e3622c147cea93f40d15a58",
   "payload_sha512": "b6bdc331f3030fbc116a4e6bd9d3f6c3c54811d055f0bfdd70cae0a13f3c565058c50d9a619466e8784fceac09edf0a82e0bd6b4fddce41bfcd4983f51c598be",
   "payload_lines": 222092,
   "l1_checksum": 126671369459786,
   "nominal_parameters": 8182090882,
   "bytes_bound_any_values": 8605854
  },
  {
   "file": "shard_L23_FFN.cmd",
   "bytes": 16958471,
   "sha512": "9fbe41fccd66945551a7acdfdd5b1958702560cbf4e6d28f051b3139a061f046c5e47c00053ef73c1b873ec01c21e29ea4914be3962b82fc40025abe45bd5ea9",
   "payload_sha512": "a070ec974edbbeeebfcee53fb5ab20e247e398f1dcce62f0dc128fb25eca3277fdde8d06ffa13fabf21509258389f9c71b0f1c0f391655153f53e6136746946b",
   "payload_lines": 476564,
   "l1_checksum": 316856112964712,
   "nominal_parameters": 21818821632,
   "bytes_bound_any_values": 17960298
  },
  {
   "file": "shard_L24_ATTN.cmd",
   "bytes": 8016111,
   "sha512": "2853b4e1e89b3bcf06c2981a42bd63da3320db7dc62dc480976f34605a6311d727dc6fe89649c79f73827bfd0dba76e3ca9c4128bc77f531149942d3c34e998f",
   "payload_sha512": "79b38688371e48321cae7e1de8213b7d38c24e881e521879ba265ad95ef2b4f3a54303ff28850437164684bd4debac822ad224f32f97ca44cec2337978cae544",
   "payload_lines": 222092,
   "l1_checksum": 126545217190008,
   "nominal_parameters": 8182090882,
   "bytes_bound_any_values": 8605854
  },
  {
   "file": "shard_L24_FFN.cmd",
   "bytes": 16958502,
   "sha512": "04655e7481df598a1582d89acc13f5f1108c5ea579c2153a723326dd703835b4203d95f458268d704dfcb837c0b4947dcbfe5e8bcfc6b1fa9812dd73648f683a",
   "payload_sha512": "91eb5923425e810c937832fc1036c57a0a199a05617f4b84ca5d9f409856980e12fdd6fd940f557699672e1ae393b19d814dcdadd088bc7ebb2049e928d5e2f8",
   "payload_lines": 476564,
   "l1_checksum": 317029202367425,
   "nominal_parameters": 21818821632,
   "bytes_bound_any_values": 17960298
  },
  {
   "file": "shard_L25_ATTN.cmd",
   "bytes": 8016111,
   "sha512": "93f2d6f97b37004f30902430a73240bc559ba61158b69c28507187e8b196802e966a8c3135534731a83ea6672c33dda5a23100b34eb93fff770921374c15fd88",
   "payload_sha512": "6f5c28350f7eb374b777b89b7b6b442cfea093768415cd6d2aac39720060465dd4d7667cd2e1b7d988bf6246cf242e7a906d80051b6cbc2f5feeaaa9a6461ab1",
   "payload_lines": 222092,
   "l1_checksum": 126497511151468,
   "nominal_parameters": 8182090882,
   "bytes_bound_any_values": 8605854
  },
  {
   "file": "shard_L25_FFN.cmd",
   "bytes": 16958676,
   "sha512": "e1d858979dc3d468e66727bb10d2fdfcd574378211f14d005ab5e87000e91f1ac23e4c6642d4dd48bdf8d09faccfb04042861c8c71a68c750d1654e3cf1e0fe8",
   "payload_sha512": "052a9e347e9c472daf342ac750f085330d8fff4a983dc71b94bd0398d06da174570e6ebc99771b06222e794977ed4f3601e62530254891c88990c96f823ddc01",
   "payload_lines": 476564,
   "l1_checksum": 316936283276372,
   "nominal_parameters": 21818821632,
   "bytes_bound_any_values": 17960298
  },
  {
   "file": "shard_L26_ATTN.cmd",
   "bytes": 8016264,
   "sha512": "40d31daf69a4580105b1b71a0115041b2c8ebdfdbb56e8c4df1fe81f8c7d4eab33fc1b74b12328409ec399a97192f18c3492c0a80a938b36e3822c8aa21d46b5",
   "payload_sha512": "d3fa1fd3371e3f3a5f22085e4f244b60c9662162ee1d91922c1dd1b51bc08565c9e2c8e3e7652932786af429452f37a6120e75bfa914842193079f7f42c56302",
   "payload_lines": 222092,
   "l1_checksum": 126780719936553,
   "nominal_parameters": 8182090882,
   "bytes_bound_any_values": 8605854
  },
  {
   "file": "shard_L26_FFN.cmd",
   "bytes": 16958193,
   "sha512": "7cb5dbd77fe9a32c86188c9fd200f9df2f283ee73e34dd8e1147cff4b073cbf602bd437a1560006ff00f1d7d111ec083cd3d292fed3790ddbf0a380fb771b8f4",
   "payload_sha512": "5db87d7c998e1ab01b9b0ac2b30e081bd05c8fea72493d94dab6d2e82255bed03ac5680c8d0b4a9e759f00e7f1b8e83b04397c5224ec9914804215548bf1a6e5",
   "payload_lines": 476564,
   "l1_checksum": 316479564081910,
   "nominal_parameters": 21818821632,
   "bytes_bound_any_values": 17960298
  },
  {
   "file": "shard_L27_ATTN.cmd",
   "bytes": 8016314,
   "sha512": "52c9af9e534daa2d03b23d3fc904eab243c6fe9b158ecbc0172cc5bf9a60eebf41c2408b24554fa9f3e2d04aa29cddddf105c86a73ee92782f2f51601edb9c24",
   "payload_sha512": "b6c1ca1165b49cc26e05af85d04d9cc1ead95093551b058f64e319856edee7423b167243cade61e68a323f31f86652dda86a5c7822d26caf973a47d44bb2bc98",
   "payload_lines": 222092,
   "l1_checksum": 126835973269216,
   "nominal_parameters": 8182090882,
   "bytes_bound_any_values": 8605854
  },
  {
   "file": "shard_L27_FFN.cmd",
   "bytes": 16958965,
   "sha512": "0cd785a6dc0abe003cbda79735d5da88c9309d3b6fd4eaa00c10bc14d3ed6498992c81132196cada79dd8c2d8f8032d67091ead564e6648e275663139a1498d7",
   "payload_sha512": "e3f1123c00d3ce2651e87978a2bdb994bf392ca29e7ed6c40feda5728a77fef72981eda8ac999faefeba1cde075aafb11d4f4c32715d12b3c0b7e118f6960eda",
   "payload_lines": 476564,
   "l1_checksum": 317315137633226,
   "nominal_parameters": 21818821632,
   "bytes_bound_any_values": 17960298
  },
  {
   "file": "shard_L28_ATTN.cmd",
   "bytes": 8016195,
   "sha512": "39c0f67cc7301dcfcde990aa223cdc324d60711cdad69ac750d7b6240fc7150176aba2089cd6fea9c62787e442d6a9e2473ca2ddb1bf041096383aa7ee703caa",
   "payload_sha512": "67ace858fc8e9d9b6cefd3bf81ed03fe9d7502c2219847ec086349cf074708b0ff6482c67dd515f1185483338bb50954fc1fc015b56a1207e8df40805f45e188",
   "payload_lines": 222092,
   "l1_checksum": 127009805764232,
   "nominal_parameters": 8182090882,
   "bytes_bound_any_values": 8605854
  },
  {
   "file": "shard_L28_FFN.cmd",
   "bytes": 16958677,
   "sha512": "fbb57fa0dca5e7946f63d476016ad0bb07815373997840b4391efeb51631577a1e6162f818a17ebac07b72ce1ada08a8b301e5bdfd0b0a601493c068b5ba4b2d",
   "payload_sha512": "d97e087dde8af3bb199db96fa86294b57e0f8f33387d96ae0cacf02285f53c3f7a2a7a775269da2cfc191b0af500f15edcf2c2d11236726736880ec852d084e7",
   "payload_lines": 476564,
   "l1_checksum": 317402172710422,
   "nominal_parameters": 21818821632,
   "bytes_bound_any_values": 17960298
  },
  {
   "file": "shard_L29_ATTN.cmd",
   "bytes": 8016473,
   "sha512": "eea99a3f2a9ff1349b6c0161b692ae8d0942bd2189b6350e6a24c66b9ec37caa77dd8322939d3e1ad1de0c237d9bafdeb1cd4bf91c919c9eed179d1e63caad4d",
   "payload_sha512": "fdc66ec5e4af91c42d92a9cba0504dfd8df6060155ae382124b3238bc61a4a17730c91a21969bf523037475bbc5382506fb69a0e2abcc741385a323ec5d3edcb",
   "payload_lines": 222092,
   "l1_checksum": 126953353779775,
   "nominal_parameters": 8182090882,
   "bytes_bound_any_values": 8605854
  },
  {
   "file": "shard_L29_FFN.cmd",
   "bytes": 16957919,
   "sha512": "e0ae00c9e57e3241528e43d4ce1938fbfaf978ce540eb52d77a628de6544e2a7c3877c22444f3a760a5220fb71dc5b5a057579200f9628bc750483b6a9cf83af",
   "payload_sha512": "6996082daa81e68b755e9fbe91a638ff138f21f6669e175e250ba213e06abd80b54fdb836afdd814b157e4b7967afac969c266c63046f3045b821c5645b27733",
   "payload_lines": 476564,
   "l1_checksum": 316563390174819,
   "nominal_parameters": 21818821632,
   "bytes_bound_any_values": 17960298
  },
  {
   "file": "shard_L30_ATTN.cmd",
   "bytes": 8016114,
   "sha512": "f97219d7cd37af48c60d0e1d949121f29dbff80ddaa3189eda1511da6be464b0e7e085a777486741052fa9dcda471a67a1363c7ece4571322e107e924c0e4870",
   "payload_sha512": "4a7fd16eef75623b38610239cb9477346cb5d6c08b2478c03b00e65f167c700d0f35a84f2bfd0d97df75439561fac5f955fc6aecb49db11745d41a8e4cb53ef2",
   "payload_lines": 222092,
   "l1_checksum": 126597473689882,
   "nominal_parameters": 8182090882,
   "bytes_bound_any_values": 8605854
  },
  {
   "file": "shard_L30_FFN.cmd",
   "bytes": 16958866,
   "sha512": "ad4bd0448dc2c65fe9e89d0855ff6573af5947c382744ae759099ab1f699260fbe5f88fc39dff320c665e70cecb79c5a6139a07813b31cf2d4de9898ae1e7d5f",
   "payload_sha512": "7ca2ffb413fdf5fac6428c8512b8152e1306139a5999c3c2ebf4bbb07772a3f4237fa13dc530cdfab54a48711af2915f5d39cdfdeba1853534745749b6370605",
   "payload_lines": 476564,
   "l1_checksum": 316941170747389,
   "nominal_parameters": 21818821632,
   "bytes_bound_any_values": 17960298
  },
  {
   "file": "shard_L31_ATTN.cmd",
   "bytes": 8016307,
   "sha512": "8febb366c52f2679633702498e36356384291f953efb33de4d25da7c6b63d711aeae8a7464eb12d3893d904e66090fc36cde7396c58f566b5d1fbf1881bdbbe4",
   "payload_sha512": "9440cc132b06641689b8302f2af3fdbb181eff1ab5bb86069f586ef364feed32540e05fc0198f3324c90675df9319de2f40fddf004d1763fc435c498ddd0e019",
   "payload_lines": 222092,
   "l1_checksum": 126731467870754,
   "nominal_parameters": 8182090882,
   "bytes_bound_any_values": 8605854
  },
  {
   "file": "shard_L31_FFN.cmd",
   "bytes": 16959059,
   "sha512": "fb4b7f9b62f4ac1bdf0b5d90393ce3335df306fc803daa362ee226caf57fbb2cc02acc9cae563e7e6f5f44e29904ed3ff7c133e02ab481b03bc74a10a05d57b0",
   "payload_sha512": "009f1520e40be0c96f2ac32c8e73370358724128723e83e26c1ccd580d626d5f2978fe2021e742f0b5b6c2f14781a708b663582c8bd148b1f4234f4fdf8e9096",
   "payload_lines": 476564,
   "l1_checksum": 317345837103442,
   "nominal_parameters": 21818821632,
   "bytes_bound_any_values": 17960298
  },
  {
   "file": "shard_L32_ATTN.cmd",
   "bytes": 8016261,
   "sha512": "d40075796ba6fe64ad913c237473df470474d5ed878ad55df29feba5d61b645f3e2baf2b687813439201ec6ed9270afc1ee7336795e54704325a3d840700bc62",
   "payload_sha512": "3880154c2e511eb770f9d2639043aa1a67eb365895a21fa860db054bba0b49ee391778bec4dcea7c9caeda4fe1c026749f2f6d4e77930d1e17f90c376cc141db",
   "payload_lines": 222092,
   "l1_checksum": 126906493945910,
   "nominal_parameters": 8182090882,
   "bytes_bound_any_values": 8605854
  },
  {
   "file": "shard_L32_FFN.cmd",
   "bytes": 16958542,
   "sha512": "075a8e25d9fe7c8fd2fa388c34c93bec097c8d0032ba05d7822f574b648ac27eb7e889574ba02dcd20e0ffe67c3789a7773946727e53c943b940b11090ba3c49",
   "payload_sha512": "5a74ef54a62f7a71478e5d900bb571ac785c08bcd45bc2c4d85141c194d941b19f86c1a2dcfd6339d6b21b001d659d12350411469430238ec6262ee8e3e396e5",
   "payload_lines": 476564,
   "l1_checksum": 317172220664410,
   "nominal_parameters": 21818821632,
   "bytes_bound_any_values": 17960298
  },
  {
   "file": "shard_L33_ATTN.cmd",
   "bytes": 8016151,
   "sha512": "078bcdd00fe78c66a5b699c1f938d0530edd972e231556cb973293bf3175d15efe14eee15bed6ae3e3d374a451883889583c6226349743076d427afd3923bd61",
   "payload_sha512": "356b30ce4623f39d2af345f7ddaa9c02179bbfa9f5a2ce100b1df90ef2ebe36a78b83174c97757406d9a200683fd399928d2151a7872df8dc518dd1af222e8c9",
   "payload_lines": 222092,
   "l1_checksum": 126787067655308,
   "nominal_parameters": 8182090882,
   "bytes_bound_any_values": 8605854
  },
  {
   "file": "shard_L33_FFN.cmd",
   "bytes": 16958560,
   "sha512": "05aba00c3a568c7d7e5e4f792d683b712f0280c8a2756b0baafe5ec5bb0492971d16a62d23f0559f3ca74ffc6cb90c54f8a15a8771c3ce88e8dca41c0d1dddf7",
   "payload_sha512": "a01443dc97f98e3e682ad5bd2b8137865d04b6b7885599ef22ba297e00ebb4faf3d4c792aa15cf31dce9d59cd4cf6649fb59e93e3d75b799cf937ceb90937ded",
   "payload_lines": 476564,
   "l1_checksum": 316889637834792,
   "nominal_parameters": 21818821632,
   "bytes_bound_any_values": 17960298
  }
 ],
 "set_sha512": "89485985ebb6d0b46ce5fb2cb492d897b53f073b95943cea8b73cd589a8b1f3f49c3cb917a26e7e9329fbfe777f3a094ead282445a4b7bf858f2299c64d0cb77",
 "concatenated_sha512": "c8a05029dd45b19c3198b30fcb3383658328fef2bcd2ad247519e47b3885973da744ec46b845dd18a18098c7d5e9b9b05d44dbcdbf3f9f111a145db4bfd31768",
 "total_bytes": 874173645,
 "set_rule": "set_sha512 = SHA-512 of the lines '<file> <sha512>\\n' in shard order"
}