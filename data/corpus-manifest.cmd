@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): corpus-manifest.json. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to print the document, with /check to check its SHA-512, or with /extract FILE to write it out.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=corpus-manifest.json"
set "LB_DOC_TYPE=json"
set "LB_DOC_BYTES=165764"
set "LB_DOC_SHA512=d5ec5085a951728501e556b5f1a96c9733739c896081d5595b716f0a76e326f2226f3e18845281a5c03662215b81701f933d4914b4515c280526aec48f64c5c3"
set "LB_SELF=%~f0"
set "LB_ARG=%~1"
set "LB_OUT=%~f2"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$n=[int]$env:LB_DOC_BYTES;$b=[IO.File]::ReadAllBytes($env:LB_SELF);$o=$b.Length-$n;$h=-join((New-Object Security.Cryptography.SHA512Managed).ComputeHash($b,$o,$n)|%%{$_.ToString('x2')});if($h -ne $env:LB_DOC_SHA512){[Console]::Error.WriteLine('LB-DOC/1: the SHA-512 of '+$env:LB_DOC+' differs from LB_DOC_SHA512');exit 1};if($env:LB_ARG -eq '/check'){'ok: '+$env:LB_DOC;exit 0};if($env:LB_ARG -eq '/extract'){$d=New-Object byte[] $n;[Array]::Copy($b,$o,$d,0,$n);[IO.File]::WriteAllBytes($env:LB_OUT,$d);'written: '+$env:LB_OUT;exit 0};[Console]::OutputEncoding=New-Object Text.UTF8Encoding $false;[Console]::Out.Write([Text.Encoding]::UTF8.GetString($b,$o,$n));exit 0"
set "LB_RC=%errorlevel%"
if "%LB_ARG%"=="" pause
exit /b %LB_RC%
rem ---- document ----
{
 "split_rule": "held out when int(sha256(document name), 16) % 10 == 0: split by document, not by sequence",
 "separator": "\\n\\x1e\\n",
 "train": [
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C001-definition-and-scope-specification/results.md",
   "bytes": 301,
   "sha256": "57168b8883e60eabf0b9d205fe0c36bf7dd9ed4b16d976e7207b8c5b126442ad"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C001-definition-and-scope-specification/resume.md",
   "bytes": 287,
   "sha256": "d3e2c3f0f2fede2f6fdebc184a55c84178e49a2bc2174db8aa26c09094ccdd7d"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C001-definition-and-scope-specification/scope.md",
   "bytes": 642,
   "sha256": "6a1d3c3eadab04923edc300b970d49aaf573ddd3f5210a186ead131a7dd30415"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C001-definition-and-scope-specification/source-register.md",
   "bytes": 521,
   "sha256": "f4d54c71adc8169e3ce4d1b63677dae1d08b69a3e36c52f0b8c0397cec51443b"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C001-definition-and-scope-specification/task-evidence.md",
   "bytes": 1933,
   "sha256": "e40f86fef674b378012a672f1a7e346aecd16a55f6fb8e6ceff81da7df145ea0"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C001-definition-and-scope-specification/terminology.md",
   "bytes": 453,
   "sha256": "762e293bc3828377c7f5ebb08aa8d286fa38b6b1788e33280874082ad0b6e50b"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C001-definition-and-scope-specification/variant-map.md",
   "bytes": 342,
   "sha256": "2c123a08417ad54d7773a4cf26159f717dcf6592a9a5398b852d6cbaf6b9bab2"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C002-original-source-and-version-registry/access-gaps.md",
   "bytes": 292,
   "sha256": "e33a88260030e8257dd095fcfe250f06517464bf01ba4af40c86e764c2ceaed2"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C002-original-source-and-version-registry/decisions.md",
   "bytes": 464,
   "sha256": "24aef6cb75223440256beef6a294f1290d0866824d24f94d46cb614240e72598"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C002-original-source-and-version-registry/results.md",
   "bytes": 301,
   "sha256": "9f3e9452b68a605807a2fd9da8894d104c1864f9edaf4076707ad2ece5bd530d"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C002-original-source-and-version-registry/resume.md",
   "bytes": 287,
   "sha256": "baa05775c78999edecdf2f6b3f713e527128e3c1371de547461421b8feefc2a0"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C002-original-source-and-version-registry/source-register.md",
   "bytes": 521,
   "sha256": "5a7234b1f9b4cd8d1cc6701dceff1079e701a05f1fb069f0464275ea827df197"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C002-original-source-and-version-registry/task-evidence.md",
   "bytes": 1933,
   "sha256": "c8dff480ca2b305e53258538d4c16444c47285148c5030377c795643874e2bbf"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C003-implementation-or-study-objective/decisions.md",
   "bytes": 464,
   "sha256": "0211b73bed60dbcdf8d816fa53df90fba2a7a89de14469bafb19d3f2cb839781"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C003-implementation-or-study-objective/objective.md",
   "bytes": 466,
   "sha256": "11dbdfa2930de263ef9049ddf60016f0d64060771fceb832ef829e81a7bae248"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C003-implementation-or-study-objective/resume.md",
   "bytes": 287,
   "sha256": "90eb3e3ba6823631e2f8d5763bc7566b066ec3364376d18e92b88b1a8186dc6e"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C003-implementation-or-study-objective/scope-decisions.md",
   "bytes": 276,
   "sha256": "041b1635d857045ac11a835436f06e05166c816f166b6510a9559b8cb454399b"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C003-implementation-or-study-objective/source-register.md",
   "bytes": 521,
   "sha256": "6f48cef3eedf351be208d6f8b4ddba7eeb0e60307abd43f188eccfa3cad1ce97"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C003-implementation-or-study-objective/task-evidence.md",
   "bytes": 1933,
   "sha256": "99b51cc60052b071ac1c23b2a56396aae5163ff8568bd486f8834015c3a56730"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C004-prerequisites-and-dependency-map/decisions.md",
   "bytes": 464,
   "sha256": "3a0620a2da618e245f9f63399e4bfca056af5fca3ec09dcc97cee5870a56bcdf"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C004-prerequisites-and-dependency-map/dependencies.md",
   "bytes": 646,
   "sha256": "a04b7fa715e67e50a3e996ef74f0ed54954485e714ff321fc6ca72a4a7f09dc1"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C004-prerequisites-and-dependency-map/readiness-checks.md",
   "bytes": 231,
   "sha256": "4bf4e1f562dcf39101f4cc8c34294b3fba8429bc201d53ffa79d87a388a8a698"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C004-prerequisites-and-dependency-map/results.md",
   "bytes": 302,
   "sha256": "dda006f56cc3abc99b525594714a7878a7909a3dd3cdbf0f734b8a116e34f359"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C004-prerequisites-and-dependency-map/source-register.md",
   "bytes": 521,
   "sha256": "9322abba09d84218a32192f230dddf8a39a59039e02ed8a17d15bef50c80ee45"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C004-prerequisites-and-dependency-map/task-evidence.md",
   "bytes": 1931,
   "sha256": "45e442aa744989aeb19dfcd0cf3a38f2b25be6b3c9a9581256d5e725aa0ac0ee"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C005-inputs-outputs-and-boundary-contract/contract.md",
   "bytes": 504,
   "sha256": "4d0afcfea5c43a056a35e53e395aed73333f490530db4eb61dc5daac58ed5b28"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C005-inputs-outputs-and-boundary-contract/decisions.md",
   "bytes": 464,
   "sha256": "9c0a901fbf61b46ea1eaef3c2cc862f08800c2145e151340ae1de781ce491313"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C005-inputs-outputs-and-boundary-contract/source-register.md",
   "bytes": 521,
   "sha256": "257d1b497b74809ba7fef9ba612d88025b2ce463463e0eb7ae6427eaf6fbea2b"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C006-core-mechanism-decomposition/assumptions.md",
   "bytes": 387,
   "sha256": "43feb2ce9cc85002a12c2052fe8753e89e866ff91e2c83ff8bfb4fffd8260f82"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C006-core-mechanism-decomposition/decisions.md",
   "bytes": 464,
   "sha256": "b82548a4e127719657df4b1ee4b7791c0a4a9aefef896862d64c19bcfd147945"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C006-core-mechanism-decomposition/mechanism-map.md",
   "bytes": 744,
   "sha256": "be6326b5fac1428a324be08de88fa1ebce2337bf4cb28c815690f7f818f6859e"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C006-core-mechanism-decomposition/results.md",
   "bytes": 301,
   "sha256": "5e33dd0068c808724917c3e610d4116b83085600f05ccfbcc2c61b12901aab2d"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C006-core-mechanism-decomposition/resume.md",
   "bytes": 287,
   "sha256": "5a6f3c15f4b30cb2404e9802e9afa89577b3af2eb28b38c477d44ed9d754553c"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C006-core-mechanism-decomposition/source-register.md",
   "bytes": 521,
   "sha256": "7f01da78823a8a7626ad2a66c698d96c37bdb856ca089023ac7fa1cf2e384250"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C006-core-mechanism-decomposition/task-evidence.md",
   "bytes": 1933,
   "sha256": "d981ebe620fac71dc98992a7cd3fccc702266b26f75cc8dbe4872fe9c348ef8e"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C006-core-mechanism-decomposition/worked-trace.md",
   "bytes": 243,
   "sha256": "307cb98bd2476331bafb1a991703105517e70397cbb2ab1da7b1c44cd69ad3b8"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C007-representative-use-case-collection/case-selection.md",
   "bytes": 187,
   "sha256": "001581ddeddfe7fcc1c2f3f0d278e7813e4182a0c6b3a860aed7639826b35991"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C007-representative-use-case-collection/decisions.md",
   "bytes": 464,
   "sha256": "739cc6421079839a02b4a9c6a36a0ff691b6e872b31d7f4cbe71362aaa8ff6af"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C007-representative-use-case-collection/resume.md",
   "bytes": 287,
   "sha256": "61f5eb0357e09b9c8e64e59ff9ce8475aea245f20ce31e53c7298ecae65efc21"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C007-representative-use-case-collection/source-register.md",
   "bytes": 521,
   "sha256": "dc2c7b3494c46951594f2335d640a2421261b4c07d94f0e4663e33af6d6d63bf"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C007-representative-use-case-collection/task-evidence.md",
   "bytes": 1933,
   "sha256": "f182ebe93f6b3a1f906c95bed71b23b9421e295679e3e469c7471f91334375d6"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C008-minimal-working-or-simulated-example/decisions.md",
   "bytes": 467,
   "sha256": "11aaaf8eb1e5b365028263c09d07a4a702fe47df20511bf4187a481a1a564994"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C008-minimal-working-or-simulated-example/demo/README.md",
   "bytes": 152,
   "sha256": "e408b7aa3dbd6f60b1855804f126cf306e45e5c4d9caf43a46996befd2c8c665"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C008-minimal-working-or-simulated-example/results.md",
   "bytes": 301,
   "sha256": "2e6d5e43155ab42ef5feeb53f3b4c3cd3ce47e33636d92ec58a1f8e7aae6d539"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C008-minimal-working-or-simulated-example/resume.md",
   "bytes": 287,
   "sha256": "437e9f574a43b75e7690677feae5c660e3365a1f7f52cb34d0c0a7266f8b6d9f"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C008-minimal-working-or-simulated-example/run-instructions.md",
   "bytes": 321,
   "sha256": "810b9f6f911dec589a12e16cbc270714c2bba68daf360bb5ca79adec73af295e"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C008-minimal-working-or-simulated-example/source-register.md",
   "bytes": 521,
   "sha256": "da2d5640d4e6e8fce927ab4fe2f88c6f9ae735c1d829dca2da0dc9b908e896e9"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C008-minimal-working-or-simulated-example/task-evidence.md",
   "bytes": 1933,
   "sha256": "186e7931b8410c65d4362b9a441cdc2a57ecea7440570a7894788675f87bf05c"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C009-comparison-baseline-selection/baseline-spec.md",
   "bytes": 594,
   "sha256": "9bb043f3bc61581ba709ac2ff0bbbbec8206b792f2321329b171bcdfc7864fa2"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C009-comparison-baseline-selection/comparison-results/README.md",
   "bytes": 87,
   "sha256": "18ed587c042cf25d40af5e3f7397bfe130c7267a0156f730f7454ef13922db1f"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C009-comparison-baseline-selection/decisions.md",
   "bytes": 464,
   "sha256": "f3cfb64c371ed2594315c2c8ddd9796d0f96750b1b0324ad3074e3a5dbdf163a"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C009-comparison-baseline-selection/results.md",
   "bytes": 303,
   "sha256": "39434e3c5efc74bdd6e1ed9e6e41f647d7c20a2489c20774929a330c8ee6cb5a"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C009-comparison-baseline-selection/resume.md",
   "bytes": 287,
   "sha256": "33986cafb48ad8cd286f288f180082a2f3e11694ddd237250ee83dafc95acc0a"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C009-comparison-baseline-selection/source-register.md",
   "bytes": 521,
   "sha256": "4503ad7895b9a64e85fd67c988643f40e9f7175dc70c1a8163bd22f387e862bd"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C009-comparison-baseline-selection/task-evidence.md",
   "bytes": 1930,
   "sha256": "823c91d624575ec381e0b77919d1ede94464bb817091bcd17ab3152eb1333821"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C010-completion-and-acceptance-criteria/acceptance.md",
   "bytes": 764,
   "sha256": "c2ee48c1d86d6c857dcab6accd2dbe6e6ae4612fd5fbacbd301005601a586aca"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C010-completion-and-acceptance-criteria/decisions.md",
   "bytes": 464,
   "sha256": "d0ec4fbe06564adc2d5add5dd359a4122dac8ad9412d92068d7dfe528418e306"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C010-completion-and-acceptance-criteria/evidence-matrix.md",
   "bytes": 369,
   "sha256": "05e5b075a6ed186d2920c71d7a1797ed46eb97a8b0f54df53eac9ad8ebc94134"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C010-completion-and-acceptance-criteria/results.md",
   "bytes": 301,
   "sha256": "e5d2c5665391af00c143181efd383f04d2347c0f005cad9a7a12a880cb7dfcd4"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C010-completion-and-acceptance-criteria/resume.md",
   "bytes": 287,
   "sha256": "fff39d8a91a26462ac625000dcd87ccdbd8035fa9c63847f847e3146e0b59919"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C010-completion-and-acceptance-criteria/review-record.md",
   "bytes": 352,
   "sha256": "684cc3b5e3940aeee15dc29b7a17495459715e15f14e426a58b034469615cc40"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C010-completion-and-acceptance-criteria/source-register.md",
   "bytes": 521,
   "sha256": "b7c2415ac0240a0bc73ce8f2fc532f9d519a912e8fe08c3c9842ba958f08c5e4"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C010-completion-and-acceptance-criteria/task-evidence.md",
   "bytes": 1933,
   "sha256": "3c473ffb53bd5dfa7f8d91d15a319a560cd2ae7a7383c14e7fcf8679165a250b"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C011-token-vocabulary/decisions.md",
   "bytes": 469,
   "sha256": "192a098564ea729a033e22f9f7b34c508a9cd83999d1f0f092095363b77233c6"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C011-token-vocabulary/lifecycle-checks.md",
   "bytes": 328,
   "sha256": "6b30c0617794b7fba82391fd3f3c8812bec79c5b3b3b05b098c952b6a8fce1f7"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C011-token-vocabulary/resume.md",
   "bytes": 263,
   "sha256": "a6d9621300f9d0cd4ee3f4b0780a931f583f0af99d12bfb10913804b533a3d30"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C011-token-vocabulary/source-register.md",
   "bytes": 541,
   "sha256": "470b5f891983f32e796c30147b406f1c1ed47db10f4bdd548f2c08647dd5fe60"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C011-token-vocabulary/task-evidence.md",
   "bytes": 3256,
   "sha256": "d333715135a4b60a68016943a570232521d1605887cd5162104419d166724a44"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C012-token-embedding-layer/decisions.md",
   "bytes": 484,
   "sha256": "0e194f0b518851f5f6ee03660d5c211919a8ec76704a433701bea1c641e7a19d"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C012-token-embedding-layer/model-spec.md",
   "bytes": 406,
   "sha256": "eff61e894c0d2299530eb649b6ee948a50d89cc66a16fdd8dc8b428787808780"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C012-token-embedding-layer/module/README.md",
   "bytes": 101,
   "sha256": "6fdc7ffd92a794f47166a66e9c035ae30c081b7bcebd4aff09b675de0954f70d"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C012-token-embedding-layer/results.md",
   "bytes": 305,
   "sha256": "65ffe38af6b464199d781c44e8f73cca0ee6fb258084b26405d676e8cc826e3a"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C012-token-embedding-layer/resume.md",
   "bytes": 263,
   "sha256": "c55ae816977834df2642c4f12a9c1407100fcec0e6f94300b0f192ce1cefac43"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C012-token-embedding-layer/source-register.md",
   "bytes": 556,
   "sha256": "07dfb24772b476a0cebaaab8ffdd30d8d80bf03c5c9cc032bc11fffa0e8e8891"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C012-token-embedding-layer/task-evidence.md",
   "bytes": 3543,
   "sha256": "d47c2141a2504d68ba3cb9f2b2c0840c154d3633c2cd24651e1e23012b6e5f2d"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C013-position-representation/decisions.md",
   "bytes": 457,
   "sha256": "f03a1c2c391657f1796afb757794062c427d6ef1efa0fb91bbb99cf095fba4c1"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C013-position-representation/model-spec.md",
   "bytes": 461,
   "sha256": "3ffea3d990367a5755aeb51ef67c10338f77f058a50667ec11b7ae0162eae9cc"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C013-position-representation/module/README.md",
   "bytes": 101,
   "sha256": "6fdc7ffd92a794f47166a66e9c035ae30c081b7bcebd4aff09b675de0954f70d"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C013-position-representation/results.md",
   "bytes": 274,
   "sha256": "3a5436580df3da97305abae5111bfa8166273cd1a2c9360b011d4b49ce6f643d"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C013-position-representation/source-register.md",
   "bytes": 529,
   "sha256": "33f35e6cfaab4dc0345d1513f1e754b86b33e577bf44b756dd785cd93ef19d10"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C013-position-representation/task-evidence.md",
   "bytes": 3035,
   "sha256": "cfc7850e278feee9d3201e6e261d4951bef8c7917b4003aa4b0f8bd30a0d2fc4"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C014-sequence-masking-rules/decisions.md",
   "bytes": 461,
   "sha256": "0ccad5199ad6037b88d16d4d90cff34d78771b44be22968ae513f907e11d22ba"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C014-sequence-masking-rules/policy.md",
   "bytes": 567,
   "sha256": "ad8864dd93f2aae90a3a5b0a13e022fa667359ec0164909af9d99be58d290f72"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C014-sequence-masking-rules/results.md",
   "bytes": 280,
   "sha256": "e0473e6cc279ddb29f04460798f1e942ef02786cff84d1a6b8b0e5874504729f"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C014-sequence-masking-rules/source-register.md",
   "bytes": 533,
   "sha256": "af6a3f7babc265aaaeaa284e99accbcf283ecfd7c16fdf412b52c36d2e3e16fc"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C014-sequence-masking-rules/task-evidence.md",
   "bytes": 3110,
   "sha256": "5aa7063e10d9cd9a90463470b2cfdd8efdad743e3b981bd22127c215e37442e7"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C015-hidden-state-representation/decisions.md",
   "bytes": 442,
   "sha256": "a36062cc457d8991596763a7292048de8e4afd7f60a143f51271213feef0d83d"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C015-hidden-state-representation/results.md",
   "bytes": 261,
   "sha256": "5323d4286396c1797eaadcbf9dae53c3938d5608069130d38beb862dbe8d032b"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C015-hidden-state-representation/resume.md",
   "bytes": 263,
   "sha256": "a1aa5f1fa4044598efc06abdd3598d914572017f0fbcdbb2bdd57b11208aea7e"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C015-hidden-state-representation/source-register.md",
   "bytes": 514,
   "sha256": "a0705bc0450f4096d3296c8ad804ecf93f0618b5e4a2788d6161de8dd334200f"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C015-hidden-state-representation/state-model.md",
   "bytes": 504,
   "sha256": "0ae5bfb3293e1df260e5da83fe91b8c97f9ee11a0a0759576a482400eb9ff46f"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C015-hidden-state-representation/task-evidence.md",
   "bytes": 2749,
   "sha256": "ef7943a062c20acab9d12dc9f968ac6e57aac621442cd114d10920de3ca90700"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C016-layer-composition-specification/decisions.md",
   "bytes": 475,
   "sha256": "d23bd154a839bc46fcd93132f5cf07769cf6eaa29466eeccaf366400c4860794"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C016-layer-composition-specification/model-spec.md",
   "bytes": 569,
   "sha256": "866518cc2be14da909446eaff45e85167dcc4620d0b2032dc079640f0f3d4390"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C016-layer-composition-specification/module/README.md",
   "bytes": 101,
   "sha256": "6fdc7ffd92a794f47166a66e9c035ae30c081b7bcebd4aff09b675de0954f70d"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C016-layer-composition-specification/results.md",
   "bytes": 296,
   "sha256": "4863a74431bb5520a7f77078392cb6d2af42d7b8f3ab4ed297bbacaa0a9dd7aa"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C016-layer-composition-specification/resume.md",
   "bytes": 263,
   "sha256": "5a322a4e6ddded4fd6ed6c79ba3d0f1a1830c982fa5e6c4b4904dbdfc0dcfee1"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C016-layer-composition-specification/source-register.md",
   "bytes": 547,
   "sha256": "f0edfbd6b53f7650c4c792d9a9a58d9840ef63c44778268676629184f9cd360d"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C016-layer-composition-specification/task-evidence.md",
   "bytes": 3372,
   "sha256": "54fbaab268b34a34cc9b225e7b7911b1461bd4d2b124085ffe881ba79e590385"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C017-attention-operator/decisions.md",
   "bytes": 441,
   "sha256": "21caf0a45f38dbd6a4d548898837be22fb9cdf63001ff7be80484dfa06314095"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C017-attention-operator/module/README.md",
   "bytes": 101,
   "sha256": "6fdc7ffd92a794f47166a66e9c035ae30c081b7bcebd4aff09b675de0954f70d"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C017-attention-operator/results.md",
   "bytes": 262,
   "sha256": "0cad6a2c72611c5cf27ef44a68cc9a2611333f8cde94f446e80e5840d47a0ea8"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C017-attention-operator/source-register.md",
   "bytes": 513,
   "sha256": "7a9d3662bf8d39658c86398a59bb481f986f69b0fcda6f7eec3b9744310e6087"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C017-attention-operator/task-evidence.md",
   "bytes": 2726,
   "sha256": "606f7cdc09dd7ab5d49272e41d85572b0688f2083341c751b386bac0cd1ff97e"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C018-feed-forward-operator/decisions.md",
   "bytes": 465,
   "sha256": "d3a9db6b0bc1841549221777b80255f0104560199feebd23cd8fec5604b94c7b"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C018-feed-forward-operator/model-spec.md",
   "bytes": 354,
   "sha256": "e870048d684d75310c79f139d4400205b71b111e4bee26d5e549a7d50caa7f34"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C018-feed-forward-operator/results.md",
   "bytes": 282,
   "sha256": "3cc1ba1a6f827cb31b0f7a2197c8dd6c77e49933061d6cd558315effa72b9d40"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C018-feed-forward-operator/resume.md",
   "bytes": 263,
   "sha256": "f41fc422c0af5ff2e72b7b49ebf789a0bba56cead51e5cc44ed8bb5206bec3b6"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C018-feed-forward-operator/source-register.md",
   "bytes": 537,
   "sha256": "eb14c5d2d8d12df434d0da625b03d485e4bc255d349469355837ebee458071a2"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C018-feed-forward-operator/task-evidence.md",
   "bytes": 3187,
   "sha256": "d41af57d8d20634201b2beac42efaa5214b2ec9f2f75fa8e6d36f986c4613478"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C019-residual-path/decisions.md",
   "bytes": 457,
   "sha256": "7d138297820ca4073fba2791d70288bf27ab79955690014a82a3884edba71eb2"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C019-residual-path/model-spec.md",
   "bytes": 406,
   "sha256": "8e543a8bc0cc13977a6b6d7ca9674fda9b7e888dc2f5b26a5dc133a6fbafbac2"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C019-residual-path/module/README.md",
   "bytes": 101,
   "sha256": "6fdc7ffd92a794f47166a66e9c035ae30c081b7bcebd4aff09b675de0954f70d"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C019-residual-path/results.md",
   "bytes": 274,
   "sha256": "46c2498f8ccfb9d61153962bde2f89b3b42ea0b5fa634f56426f4a674c269173"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C019-residual-path/resume.md",
   "bytes": 263,
   "sha256": "0ee21e195a60748927636de1d6767df544bc39b721781f0e98c7334a8d035c2b"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C019-residual-path/source-register.md",
   "bytes": 529,
   "sha256": "2851b3d94ab79f01a126fc6f587c4839916a4a943eea65bb3404d45288f7e035"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C019-residual-path/task-evidence.md",
   "bytes": 3035,
   "sha256": "4f069b6f4391cee6a20dc6b56d8a870489c80e8d7d2fa804e314e785d3cbb59a"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C020-normalization-layer/conversion-module/README.md",
   "bytes": 56,
   "sha256": "72a04fb89673da976d5d5ee64262b73ca19db7ec644571a9ff1c006ae95931b2"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C020-normalization-layer/decisions.md",
   "bytes": 454,
   "sha256": "93c8a532805decb0d2dd71b6183c78c672d507d9b870b8e4349548249a1db2d5"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C020-normalization-layer/results.md",
   "bytes": 273,
   "sha256": "5e4da5771229296260f42f5727125e02eb2d0a9b38c34012df12dba76e21dd8c"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C020-normalization-layer/resume.md",
   "bytes": 263,
   "sha256": "cb7b0d8162c16b2d7b46bfd60c03edd3352d6b1cba7567bfd22ad2e4614a09fb"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C020-normalization-layer/source-register.md",
   "bytes": 526,
   "sha256": "19cd4a034fc6c4de3ccae543d02045740ef43cd815351494f5eef93d09175432"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C020-normalization-layer/task-evidence.md",
   "bytes": 2980,
   "sha256": "1024bd0f8c952eb6c91c50962b0c730c10a82081556699d6e396bc55ac392b78"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C020-normalization-layer/transform-spec.md",
   "bytes": 727,
   "sha256": "290797cfc9c6b9f1cf91b415f0c07709e19c4986ddf90637f4580536f65f1cde"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C021-activation-function/module/README.md",
   "bytes": 83,
   "sha256": "27eeae60411a49f8812cb9785c0eed443c70610c9a242e5e61f1967e31cb731e"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C021-activation-function/results.md",
   "bytes": 231,
   "sha256": "f78490c2320df21f99f569eac9dcf0c48a76c5fa61a62b1114ef7a38b1501bc6"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C021-activation-function/resume.md",
   "bytes": 351,
   "sha256": "a8d40bc7b355d3a4693156420f3cac565dadbd8b6630c669e024519907b51fa1"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C021-activation-function/source-register.md",
   "bytes": 392,
   "sha256": "972a9a13124a6fabceae2327bc4638a670594f8e93668b177a2ccd77a41fe982"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C021-activation-function/task-evidence.md",
   "bytes": 2499,
   "sha256": "9a455df04a1064a25115bbe44191426942613bb86720f5e5a99963285eeeb512"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C022-parameter-initialization/decisions.md",
   "bytes": 379,
   "sha256": "f13b7ddb77c08c62a4adcea114ca98986cee0c15bf2c5a5ab8c24f860903c818"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C022-parameter-initialization/resume.md",
   "bytes": 351,
   "sha256": "debfe13440c3419015af19ec0993a170d6f4650dd32d5ad29e212ba6d2214aa6"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C022-parameter-initialization/task-evidence.md",
   "bytes": 2165,
   "sha256": "65939133de472741483087288a1928f9723f589232c17fe5fdf65e8af626c37b"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C022-parameter-initialization/training-spec.md",
   "bytes": 502,
   "sha256": "c2786963fe362f0a859b025eef855dfe7bda007119c6a554d72f79c2087023cb"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C023-output-projection-layer/decisions.md",
   "bytes": 346,
   "sha256": "424af8f01bca54f5824c5a929097bb3b93552360cdece4a041a7286c5af9a66f"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C023-output-projection-layer/model-spec.md",
   "bytes": 274,
   "sha256": "5e6cb123c928028a18aa9776ea198e3fce0ebfc031477358f8ebab55b7f88562"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C023-output-projection-layer/module/README.md",
   "bytes": 83,
   "sha256": "27eeae60411a49f8812cb9785c0eed443c70610c9a242e5e61f1967e31cb731e"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C023-output-projection-layer/results.md",
   "bytes": 240,
   "sha256": "b258802eb4cbc9cf3dd144123f7ccc1d4d7011b1eb9ad79f537fe1877318b6b2"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C023-output-projection-layer/resume.md",
   "bytes": 351,
   "sha256": "1afd4e8ad50afdce810d79ab3397052ce3cd02029b6921297d6df58a89e7a33d"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C023-output-projection-layer/source-register.md",
   "bytes": 401,
   "sha256": "9a86427ec80976cd90531bc587a1fedf58a2cd4ddddd0ea70d3bc133ec473cd8"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C023-output-projection-layer/task-evidence.md",
   "bytes": 2567,
   "sha256": "34db42becc5dd674cc32dab96a3c73520da94b1fdde770a358d5d7ce1b543bdb"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C024-autoregressive-head/decisions.md",
   "bytes": 420,
   "sha256": "5697dc7430f0e92d15a0028fcf6d438c1dd06536cfbc208b76f42210946153fe"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C024-autoregressive-head/model-spec.md",
   "bytes": 294,
   "sha256": "82b75bc129c850c9704f36b2979448b7e3b7dcb48b857fc882df81df4a4f8fa5"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C024-autoregressive-head/module/README.md",
   "bytes": 83,
   "sha256": "27eeae60411a49f8812cb9785c0eed443c70610c9a242e5e61f1967e31cb731e"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C024-autoregressive-head/results.md",
   "bytes": 221,
   "sha256": "009057143590dfc47ee36f043ddef1e8d47c42d4713065cb3d1f859bef2b5f3f"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C024-autoregressive-head/resume.md",
   "bytes": 351,
   "sha256": "314992bce4514fd0deaba224841c746425b752c06b2f53ded8277cbd4750ee27"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C024-autoregressive-head/source-register.md",
   "bytes": 382,
   "sha256": "0233b6cfaef2feb9bb0d688f6c46c3a4b74ebb04832d2bcd7078f9e746debe68"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C024-autoregressive-head/task-evidence.md",
   "bytes": 2296,
   "sha256": "131fbc1c7b617059022ef3d29f0042571e8777d902e7e130499988e577f7014f"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C025-non-autoregressive-head-option/decisions.md",
   "bytes": 373,
   "sha256": "06902d849672b2c67c067a1b6cfe862698ba3876b1097e186da7558a60eaae0e"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C025-non-autoregressive-head-option/model-spec.md",
   "bytes": 217,
   "sha256": "9292daa181d71353ae8989cbd6e177326d02b11f8edb95031c936bf8dee22907"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C025-non-autoregressive-head-option/module/README.md",
   "bytes": 83,
   "sha256": "27eeae60411a49f8812cb9785c0eed443c70610c9a242e5e61f1967e31cb731e"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C025-non-autoregressive-head-option/results.md",
   "bytes": 204,
   "sha256": "95f3d9b200d40948186c8129d4c6670d168d84cd8d60f6366c58118563671714"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C025-non-autoregressive-head-option/resume.md",
   "bytes": 351,
   "sha256": "e00fb35ec8b34f7afd2674d6831d47c7d0d8701b6d587cec646ab5b8bf5494f9"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C025-non-autoregressive-head-option/source-register.md",
   "bytes": 364,
   "sha256": "080d3d01ea522c709bdec8377a74d8f2fdfc4476fc902a35e3d8e7fd74bb04f1"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C026-recurrent-state-option/decisions.md",
   "bytes": 364,
   "sha256": "f26f58463d30637f2e72e95e1760c44366424436266a9f79194fd24794ca3bbe"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C026-recurrent-state-option/results.md",
   "bytes": 206,
   "sha256": "d50060a7c6dfaf70f4bd545f7534e073628324df2d61d8cdf3344ffc892de2a0"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C026-recurrent-state-option/resume.md",
   "bytes": 351,
   "sha256": "e317120ca136489b824153f303c4320079e796dbfde72de1125bcd1f541140e2"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C026-recurrent-state-option/source-register.md",
   "bytes": 368,
   "sha256": "dc705966c546786cf033f462356a0a13192ce1b42adf5d6ec4428d3aa572eaa1"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C026-recurrent-state-option/state-model.md",
   "bytes": 354,
   "sha256": "26574029d75403c8e5ce0e99d8ae7887088030fc29c36cc4b5a72046ef9f50a4"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C026-recurrent-state-option/task-evidence.md",
   "bytes": 1988,
   "sha256": "d1a3ddabea9e9246574ecfb414d3c3a4c8da02563587b88c457981e4b3927ed9"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C027-sparse-activation-option/decisions.md",
   "bytes": 381,
   "sha256": "d24c03a19fc5ec640f91a4f614cbb526e85d2e36215f9b47e01583582112cbab"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C027-sparse-activation-option/model-spec.md",
   "bytes": 227,
   "sha256": "7677ce0dcfd31811f47d272734054dc9729d6ccfe2904eab811b4c007067bfe5"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C027-sparse-activation-option/module/README.md",
   "bytes": 83,
   "sha256": "27eeae60411a49f8812cb9785c0eed443c70610c9a242e5e61f1967e31cb731e"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C027-sparse-activation-option/results.md",
   "bytes": 210,
   "sha256": "c442184d6dab00d65e83cd098442fbd747ff049162af87f5457a3cf710adfac0"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C027-sparse-activation-option/resume.md",
   "bytes": 351,
   "sha256": "f2bf306f125a0f8a0aa7e0941f6c38682143c2c24c557a4c4616a4d7ab94d0e6"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C027-sparse-activation-option/task-evidence.md",
   "bytes": 2041,
   "sha256": "3671e239a50b9781ac236595aa951a1ce64907fb27870f7fbd6b897245fe8f39"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C028-expert-routing-option/budget-comparison.md",
   "bytes": 183,
   "sha256": "83a78d68e5157fdb47bf093514269a9a4100c9a883c4b2c9b0ebb082d17cf9e8"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C028-expert-routing-option/decisions.md",
   "bytes": 360,
   "sha256": "0c7ba87351c6e5910445ec788390b6430c1435c7ddfe09401c0b41f2b935e5b3"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C028-expert-routing-option/results.md",
   "bytes": 203,
   "sha256": "c43d845e4434ae91e4c0a78a2516f3d8cec778f7c817bf006e6a170e796973b5"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C028-expert-routing-option/resume.md",
   "bytes": 351,
   "sha256": "0dc04f129b0d3c49dd5225c344ecca583a9ca800149274e12475f28f39a24f13"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C028-expert-routing-option/search-spec.md",
   "bytes": 399,
   "sha256": "82c7213786c1b4c1424732c6213d0e15c0bfc9ff045484e9248f2c9e61f6ce44"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C028-expert-routing-option/source-register.md",
   "bytes": 364,
   "sha256": "f40a81911835cd737acbe363025bbeaf45ddd023c61772aac877db186bba80b2"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C028-expert-routing-option/task-evidence.md",
   "bytes": 1912,
   "sha256": "1169976618b316f10c74eb05f312ac1c3ffb8158821d88c2feb7b6013d9e7bf2"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C029-context-extension-interface/adapter/README.md",
   "bytes": 48,
   "sha256": "39fb768edbe051992dc1f627b90bec19524838a32a494bd4d106e7923d2a4ebf"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C029-context-extension-interface/adapter-contract.md",
   "bytes": 343,
   "sha256": "db29220971cff70aa9429d5ec1c549de49f7cc946122378ecec2ffbf852eec7c"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C029-context-extension-interface/decisions.md",
   "bytes": 432,
   "sha256": "a9346192369a2bbc560e6a33a7f2228994f8ca8c163aa9e5b305dffdb0f0bad5"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C029-context-extension-interface/results.md",
   "bytes": 192,
   "sha256": "d58530a87442b64607a126125ba5f92b7bf410ceede3abebd12376fb39fdb798"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C029-context-extension-interface/resume.md",
   "bytes": 351,
   "sha256": "006c5d7c16f7c5232ae5efe8c8d08cd215cdf462c4d272424ee0cbde7ae2a661"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C029-context-extension-interface/source-register.md",
   "bytes": 353,
   "sha256": "078db2fb645da045329cc587945a2468caff5ff82cbf2425ac9e710dce1fcfea"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C029-context-extension-interface/task-evidence.md",
   "bytes": 1786,
   "sha256": "60beb49e89236f4d8704bc0037ece222d5b8232cedb2074bbc5a9abada46dfcb"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C030-architecture-configuration-schema/contract.md",
   "bytes": 411,
   "sha256": "17f87226aee2353d3ac9d8324699140e4a03e1601f1152feac972f2ed12d6bf2"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C030-architecture-configuration-schema/decisions.md",
   "bytes": 404,
   "sha256": "418b09420305da82a5679b43dd44448ce2b6e8b51fde274fd7182bc53cb7efb2"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C030-architecture-configuration-schema/resume.md",
   "bytes": 351,
   "sha256": "6b975defdfaa92a2d8eef1b15915e4b26c9cbfe6da080b97bc4847805fda4cf1"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C030-architecture-configuration-schema/source-register.md",
   "bytes": 383,
   "sha256": "b67c48c4489e7378742d3c5db5a5464572807b511b2bc811c9fa394e19e4bc0f"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C030-architecture-configuration-schema/task-evidence.md",
   "bytes": 2298,
   "sha256": "c0a0efe79ceaa6058bdacd64a405c2fe371ef2772d20981fda86b3bb08e92ab4"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C031-forward-pass-implementation/decisions.md",
   "bytes": 473,
   "sha256": "56426054d14dc133b29537ab49f8836a002cb1c72329ab61bdf4153d3180efa5"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C031-forward-pass-implementation/model-spec.md",
   "bytes": 543,
   "sha256": "e7d11dc93c7c4cbf01e17fdd58641f70994d147e3f1fd84e8da700a6824bbe50"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C031-forward-pass-implementation/module/README.md",
   "bytes": 59,
   "sha256": "be802c8965798db0607841ec7dab976034993d4c519f6a1ab2845567035c41d6"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C031-forward-pass-implementation/results.md",
   "bytes": 257,
   "sha256": "719568ad945650b986dc666c0333aaa5fe9b63b4dbf25d0af9e0d3b91359bca7"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C031-forward-pass-implementation/resume.md",
   "bytes": 276,
   "sha256": "bf967146d933a97094c64278136fd5035c6f2ad343915d56588dee2da97c6637"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C031-forward-pass-implementation/source-register.md",
   "bytes": 417,
   "sha256": "6c7fc4827909f3904925b9a7f3bc3a1dedbfc2907c86e1fcc12869e111f1b9fc"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C031-forward-pass-implementation/task-evidence.md",
   "bytes": 2983,
   "sha256": "e46051f7456c3b7a89a8c7c6c0940e3bfd81d53603dae788cfa83e358bf2dff4"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C032-backward-pass-validation/decisions.md",
   "bytes": 450,
   "sha256": "9f1dda547d699c971d5b0f6fbe6ee9cc811f26d96ce6cbab1b52081efd59c8e8"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C032-backward-pass-validation/results.md",
   "bytes": 250,
   "sha256": "0108a83dc7cc05774e34051e92f5076a0ed7db3728a2c054bb26b2a5ef4cf7fa"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C032-backward-pass-validation/resume.md",
   "bytes": 276,
   "sha256": "3e77569d4806abc147e897839986d42b8b21e582e2dd517a8ca7eaad8abdd019"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C032-backward-pass-validation/source-register.md",
   "bytes": 412,
   "sha256": "6481817eb90b34a9a0c5def0f857714b5313160ad844610537fb349da0ed229a"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C032-backward-pass-validation/task-evidence.md",
   "bytes": 2873,
   "sha256": "271abe7f1569b8997f0c11a5ce4e6c961edbe092c124eb975cbd8d0239114b3d"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C032-backward-pass-validation/test-plan.md",
   "bytes": 482,
   "sha256": "8adcee9bc2d37b158b7399f5985e18c274a599dbe168600e576172508947869f"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C032-backward-pass-validation/verification-results/results.md",
   "bytes": 190,
   "sha256": "4a0461d848dd404fc2d9e78b5120bca49394569fd7d6d5b3dfed4ca59abc2d8c"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C033-attention-cache-interface/cache-prototype/README.md",
   "bytes": 61,
   "sha256": "028eedad0fc069a10daff7e63c7806117ba7c9be157c5bec5474028a893facaf"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C033-attention-cache-interface/cache-spec.md",
   "bytes": 496,
   "sha256": "ac44a917b29da1c883a427afe8c8159385ae87cb3fdc2fde38dd1df2c9d0c372"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C033-attention-cache-interface/decisions.md",
   "bytes": 370,
   "sha256": "481a54e4e2665196d6aeabd02d6dd795ca5fa336825f82fc613a7be53bf01042"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C033-attention-cache-interface/results.md",
   "bytes": 225,
   "sha256": "1a76277a80c5816f74c8a900455c5785162deb6877f5e1a2270b4d1c3e08751a"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C033-attention-cache-interface/resume.md",
   "bytes": 276,
   "sha256": "8a66528289fb2a91e99e89db3f798f2d4d3e908bb8592b85b98ddf5fae0cb7e3"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C033-attention-cache-interface/source-register.md",
   "bytes": 385,
   "sha256": "972bced317656fad0e20eaeb32e75a9304cf2abaa46140f7fd883b7e7d20a64c"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C033-attention-cache-interface/task-evidence.md",
   "bytes": 2304,
   "sha256": "c7780d73da801092be1ce4712ff06ec21857557fb47dee823f2a0f67fe9e3459"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C034-sequence-batching-adapter/adapter/README.md",
   "bytes": 61,
   "sha256": "d10609b953029c1e18f61084dfdecffd63e6ae343619324b5f7c060f1bc5e659"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C034-sequence-batching-adapter/adapter-contract.md",
   "bytes": 594,
   "sha256": "3017e3fda6966a72caa37a238f61243e841f74836d28096afe98eb816e960255"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C034-sequence-batching-adapter/results.md",
   "bytes": 234,
   "sha256": "7e621079853a935ee356e6682874d874287513b52a812fe732e76d1ff10d6708"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C034-sequence-batching-adapter/resume.md",
   "bytes": 276,
   "sha256": "bdc2fef2e90602a200b2f62653730818522d1481663ce76b91fd73bfffa6ed72"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C034-sequence-batching-adapter/source-register.md",
   "bytes": 395,
   "sha256": "fd279d0aa6f72a6777c192c3f2ee178204072ffd028ad72621f94e0712290853"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C034-sequence-batching-adapter/task-evidence.md",
   "bytes": 2587,
   "sha256": "a3ed5d7fa019b3d953c8a9c9fb72d04119e7127755842e35bf93dc6051dae642"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C035-padding-treatment/conversion-module/README.md",
   "bytes": 37,
   "sha256": "653a2963fc434b9875bda716c828b54b3c07bc41bc01e63dbf662658930fc9ca"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C035-padding-treatment/decisions.md",
   "bytes": 457,
   "sha256": "981f69c95e040260b10cd2f7812f30cb183f7bc8bd932ada8492474e3dc24137"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C035-padding-treatment/results.md",
   "bytes": 233,
   "sha256": "f69559668b886eee77b1e57a7e55375fbbf08598a088acf2d10903c1d3e64689"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C035-padding-treatment/resume.md",
   "bytes": 276,
   "sha256": "06191e099cbaa635c444631c8bdc064021c68f0a482ba7c06960ad1ccd6d6f13"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C035-padding-treatment/source-register.md",
   "bytes": 394,
   "sha256": "547adb3446d1596e29701b3d55762a5c42bedcf019a83ba8521cb3cf17e41d0f"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C035-padding-treatment/task-evidence.md",
   "bytes": 2553,
   "sha256": "114d9e2288fb09156bf749de2befaf89bc724d74c1de8d8dbab8298e91969619"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C036-long-sequence-partitioner/conversion-module/README.md",
   "bytes": 29,
   "sha256": "8ab9e3f795783bf553bae3ab888bcd52f9bfcbe8e2b4397c9e837587f2550e22"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C036-long-sequence-partitioner/decisions.md",
   "bytes": 496,
   "sha256": "8e065c88c0f8ef647d2434af5e71e215da922b2ef43eabb086732a187544e22c"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C036-long-sequence-partitioner/results.md",
   "bytes": 221,
   "sha256": "99dff9f60c6acbbf27ecd4107384ce8d0bcff20d143920f1634d2e87a700a908"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C036-long-sequence-partitioner/task-evidence.md",
   "bytes": 2379,
   "sha256": "4c6d8e3d80f5c9e5dfee76a3f566feea07760964914f6e06150415ae76433948"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C036-long-sequence-partitioner/transform-spec.md",
   "bytes": 518,
   "sha256": "e03e86c7f3f19e9adbbc960f54b09ee2bd6a343936b60d3a3eb2c37edf680d1b"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C037-mixed-precision-boundary/decisions.md",
   "bytes": 439,
   "sha256": "f667e60c369b9ff979e72097b4e3c08fe4f417e1b56721342c84482099835cb7"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C037-mixed-precision-boundary/protection-spec/README.md",
   "bytes": 80,
   "sha256": "087849d0c6f3e3228e9eb906b9e61c5ecc98b7c3137d9521e411599702a050bb"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C037-mixed-precision-boundary/results.md",
   "bytes": 225,
   "sha256": "0326462b64f7773f9740a64ef97486b4915e544e1062e512d76553f3d90a1067"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C037-mixed-precision-boundary/resume.md",
   "bytes": 276,
   "sha256": "9864a7d79890d46d9929fb237c18d5d3faf5fd2614540811afacbb082ff52e26"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C037-mixed-precision-boundary/source-register.md",
   "bytes": 386,
   "sha256": "b188c52a0464ffa07c4259008388a3e710323a71490374e2eb0d98e7a52564e7"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C037-mixed-precision-boundary/task-evidence.md",
   "bytes": 2391,
   "sha256": "9428b905579e3037d5571a9ebc26013f29474b365bc246885d9908acc5d06621"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C037-mixed-precision-boundary/threat-model.md",
   "bytes": 673,
   "sha256": "2677ee424c6f617fa4bb934c00ec1e4b3ea56e9a1a92d3931c51652292aed08a"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C038-parameter-sharing-policy/decisions.md",
   "bytes": 439,
   "sha256": "35b290517f291bf75bc695a7503696a67817c7377fe81e6beeaaa38796dea003"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C038-parameter-sharing-policy/policy.md",
   "bytes": 705,
   "sha256": "f2b6a694b45a3be7d4bab9295aa62ffbf81039b51320b80accce3fe32654ec9a"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C038-parameter-sharing-policy/results.md",
   "bytes": 212,
   "sha256": "959ebf88a861f6a95c92d70b02243c2521e1317ee1177528cc584d09913da583"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C038-parameter-sharing-policy/source-register.md",
   "bytes": 373,
   "sha256": "5e8e1333d816de14a85571f6789eb1276e6753b919a4dca7b9fad1936ba7ebeb"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C038-parameter-sharing-policy/task-evidence.md",
   "bytes": 2157,
   "sha256": "5af7e32cb0034ad479ff4fdb6de3fec99eab7d54ec568da2dc71363006c0c131"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C039-checkpoint-format/checkpoint-spec.md",
   "bytes": 559,
   "sha256": "92e9a2e6ccb7c72d42ad0b04c7c4c04f3d62d865849cde1f4dff1b7ee612d04c"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C039-checkpoint-format/decisions.md",
   "bytes": 438,
   "sha256": "25c11bad1282fb4c5db8be52f0b2fed7e2fdd37d05dc3d71faffa08f425b44e4"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C039-checkpoint-format/replay-results/results.md",
   "bytes": 165,
   "sha256": "078bf146276507365390befd850f9aee51dbb76ba9dae63a50e08221c8319ec2"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C039-checkpoint-format/results.md",
   "bytes": 225,
   "sha256": "9ceb2cbd8a656ac31777cf21e8ef56d24d8824fa75021cc1f7a6bf7972b24b00"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C039-checkpoint-format/resume.md",
   "bytes": 276,
   "sha256": "5b77774e497f6a01f5c2dde485ca5762406189b12dc431a59a5c9bb0ae3783c4"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C039-checkpoint-format/source-register.md",
   "bytes": 384,
   "sha256": "17bf5c15cd5f5483e0af7100e34c0b7dc09e4818efa22f11d47fbca1fa6cb6a0"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C039-checkpoint-format/task-evidence.md",
   "bytes": 2354,
   "sha256": "9c4626a18d4e715c8d92bbb0453273605ee6279a1741ca4652cbe8a90958b2f2"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C040-architecture-inspection-utility/analysis-spec.md",
   "bytes": 480,
   "sha256": "7ead3031ecd8d4f76fee0cfd51641460371981102370aa3baadf86d6833c774d"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C040-architecture-inspection-utility/decisions.md",
   "bytes": 413,
   "sha256": "b155ca6d66e0a79c9dd6e8126805248c03d86961683a0b059502095255f9624f"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C040-architecture-inspection-utility/interpretation.md",
   "bytes": 249,
   "sha256": "c77d3cc1d9948b21af3a95e61d19411da53a36ca67f04df3f4e40425a5c90bd4"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C040-architecture-inspection-utility/results.md",
   "bytes": 245,
   "sha256": "dab385048d917a4107bc0995f7638aaf2b9d079e27482d791e43e6f2b9adc51f"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C040-architecture-inspection-utility/resume.md",
   "bytes": 276,
   "sha256": "401ad8a0fcaa7887bb6d24408b99f075ae309d9581e35eaaa0962455d0f6e818"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C040-architecture-inspection-utility/source-register.md",
   "bytes": 407,
   "sha256": "6a8239ce2f1e120817a2c8eb91aa978e091e60327f149a5f2990f6fa0eacf2f7"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C040-architecture-inspection-utility/task-evidence.md",
   "bytes": 2746,
   "sha256": "87aaf4b5547b5caeac2c5bf1baf0829f82c8b44ea6d1e9bd2c1dff901ba79e46"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C041-parameter-count-report/analysis-spec.md",
   "bytes": 1042,
   "sha256": "a61ac3af1313a7ff421035cb5e0185bd27ec647a06e363a6fd1bbf61001a937b"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C041-parameter-count-report/decisions.md",
   "bytes": 566,
   "sha256": "c43d549677f4806a7cb6c9cf99a988b739808d3b8e3ce7fb1f20b9b3875534ca"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C041-parameter-count-report/interpretation.md",
   "bytes": 413,
   "sha256": "f0495b9105130f3353c6693292fc6090e05b504486c984ac6e109de56a14ae5f"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C041-parameter-count-report/results.md",
   "bytes": 396,
   "sha256": "fab6aa20b901488ee7c633d32afde48ee2d67e646ae4b4b3ef73172eef79cf25"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C041-parameter-count-report/resume.md",
   "bytes": 312,
   "sha256": "6defe35ed23d2186425e377758c42c81f922074a90b1255b838c65f55f10021d"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C041-parameter-count-report/source-register.md",
   "bytes": 620,
   "sha256": "0777ed895313fc37e04da318fed34917416a2daa32b99dc5592ecfa1bd884859"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C041-parameter-count-report/task-evidence.md",
   "bytes": 5515,
   "sha256": "c3e41f90a4b2480fbe97790b7bfcd139c2e7367754f85062e13b049a0faadeba"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C042-compute-estimate/analysis-spec.md",
   "bytes": 1399,
   "sha256": "aa2127e7a219435a8aab061603e6ad857f7d7f554301c5b4adf2da9b55a3d2d0"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C042-compute-estimate/decisions.md",
   "bytes": 699,
   "sha256": "4b476bed654f58b66da15b5bd6675f311cb92a67fbed5f0deaf1f1b721b8f5d2"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C042-compute-estimate/interpretation.md",
   "bytes": 274,
   "sha256": "1555252caf554d045f878bf0beb3a0d88ca716dd4e692555e9c74e6113db8134"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C042-compute-estimate/results.md",
   "bytes": 360,
   "sha256": "bb7e0b33b8d874bf1726dedf3b058a782b2e9e1f90bd77d7d0abc9977d8ed272"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C042-compute-estimate/resume.md",
   "bytes": 312,
   "sha256": "b948bbdd06e77f28da33eb67552e20fe21b92ad30d5692c309271fb6cd8b3769"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C042-compute-estimate/source-register.md",
   "bytes": 583,
   "sha256": "be61e6875b4ff3a5aceb7d67dd160a45f6bc53a09062d0c317f2808d36a4c34a"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C042-compute-estimate/task-evidence.md",
   "bytes": 4982,
   "sha256": "611bb549bb41bfa0e1f96061755653a1c3101861a9d8619c73eaf4b92ba8fd5f"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C043-activation-memory-estimate/analysis-spec.md",
   "bytes": 1035,
   "sha256": "32942592f9d6a7f74ca4c5ff4ad470ef2b6922f1a088216e7214ed1732306ee8"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C043-activation-memory-estimate/interpretation.md",
   "bytes": 209,
   "sha256": "6fcdd9c87f1c937a454f8b4a7a7d9d3c76b1f68b301b379b8feea8bdb7763f9f"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C043-activation-memory-estimate/results.md",
   "bytes": 292,
   "sha256": "cae68959714b6a245e8687050a2c241308873781047b6a989c868067064e960c"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C043-activation-memory-estimate/resume.md",
   "bytes": 312,
   "sha256": "0925da44d3758fc5dcbdd7f94356527c81781ff1eeedca6654cdcf9bdb35e91a"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C043-activation-memory-estimate/source-register.md",
   "bytes": 515,
   "sha256": "b8be6a2bd0f95973f0ae6fd26656c8bcedaa8567689048c3289c2c4997b03aed"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C043-activation-memory-estimate/task-evidence.md",
   "bytes": 3676,
   "sha256": "cbc6ac1be19a52d2fa0d8460218d5d1f23907bc1f8e8bc95c02ed3ea96ac77f3"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C044-receptive-field-analysis/analysis-spec.md",
   "bytes": 1036,
   "sha256": "94fb2de82badb05c03b49937ae3910bcb6ececf87fadc720e30cc973704f6530"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C044-receptive-field-analysis/decisions.md",
   "bytes": 572,
   "sha256": "8a764bb50f6f7dc853ec7880f799cf9202b1bf6b2e70e7e3b15ded7aa74dad19"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C044-receptive-field-analysis/results.md",
   "bytes": 317,
   "sha256": "dd4d73019eb34ccd85a4ff5be410d8fd21cc61b6943181540ab026679593e436"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C044-receptive-field-analysis/resume.md",
   "bytes": 312,
   "sha256": "ee6b21b77e9df58320f57f41c47ac46a9a1f6c9d3ac14475cfd1b38bade4db65"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C044-receptive-field-analysis/source-register.md",
   "bytes": 541,
   "sha256": "1edfa1efb6c0bbc679acb0f1d83cbf6885db0ad823eb829c16899605ed62c640"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C044-receptive-field-analysis/task-evidence.md",
   "bytes": 4099,
   "sha256": "aaaba92d99ef8d5415e60318d46ea02bd7fcf3062ff4bb398bbde16e681de1be"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C045-context-utilization-probe/decisions.md",
   "bytes": 602,
   "sha256": "2a20219fbc2f89417bd22dfced0619bcd90e1daace8ba2fa1bd21182c32cbf86"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C045-context-utilization-probe/diagnostic-report.md",
   "bytes": 302,
   "sha256": "40ad4adb26e5049d2146d7618df77d6d450030b92627e70f1c989f3944dd6a70"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C045-context-utilization-probe/instrumentation-spec.md",
   "bytes": 853,
   "sha256": "e272bc03af936451384a53348a2b0c31e9fa2143b19fb57e0941d38503a68827"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C045-context-utilization-probe/results.md",
   "bytes": 343,
   "sha256": "a2d9816cd83a055657183b2921e8d357e731321f89c80e9b07f8ededebf37b0a"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C045-context-utilization-probe/source-register.md",
   "bytes": 565,
   "sha256": "a4198209ee51fe51988cf538889afbae0e5e6c8d4af7112e476bfd9de6109466"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C045-context-utilization-probe/task-evidence.md",
   "bytes": 4561,
   "sha256": "3a33f1a21c5fdf3fe54a3f8da78458c4df548a2175a4e49de44d08e7b83bc5d9"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C046-layer-activation-probes/decisions.md",
   "bytes": 635,
   "sha256": "a3b8eab18188b9396f625d92dd01ee853f570727013ac94819d6e3be789edfb7"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C046-layer-activation-probes/diagnostic-report.md",
   "bytes": 177,
   "sha256": "000e3f921a99fe71150d0ea02b3684b1f47c2a082b9a7431e28c4eb085a71865"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C046-layer-activation-probes/instrumentation-spec.md",
   "bytes": 795,
   "sha256": "396990c2217278e32a7b82a3e01a97ad52a6c57f3f6d95ee5c19c8a2b32b9938"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C046-layer-activation-probes/results.md",
   "bytes": 326,
   "sha256": "dadf4371b5c7b0ec9b2bcf94b4f54fc74e57420af00b8c1b6c56694f4bfa3b3d"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C046-layer-activation-probes/task-evidence.md",
   "bytes": 4288,
   "sha256": "35b40ba3e7e6f5677e06d7b5ff181e2fd8bdf6e3b9c2a83c3559eb387b8fda4a"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C047-gradient-flow-probes/diagnostic-report.md",
   "bytes": 220,
   "sha256": "97edb04cc312c534ceb174bfef0ef3d8ca43c2872eac967e8286200c6b5d97ec"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C047-gradient-flow-probes/instrumentation-spec.md",
   "bytes": 1054,
   "sha256": "6c8909895487450da423d374d6773d82aa7b1bc5289faebf2665f3066dece7f2"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C047-gradient-flow-probes/results.md",
   "bytes": 368,
   "sha256": "136c581024079de69c0e95b37b0ce89582f6b70c2cd92dfa9d10d5215d4c0994"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C047-gradient-flow-probes/resume.md",
   "bytes": 312,
   "sha256": "981d9cfe3983fb460855ef38d949eada3f40922d2bf217f2a11e359cc7d4e021"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C047-gradient-flow-probes/source-register.md",
   "bytes": 590,
   "sha256": "0523bc493959928f4a4af0f45f41e05b7dbca26fd0ad7b71e722881065c03e90"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C047-gradient-flow-probes/task-evidence.md",
   "bytes": 5055,
   "sha256": "e92054d379215ac0d2fca1886dd1bd84f92b989e8c1ec76065475e2f7e8cda22"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C048-token-prediction-metric/decisions.md",
   "bytes": 634,
   "sha256": "55ea08639d6a658abc862034475b5be17379bc682a276ae36e89beb7e0a7a479"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C048-token-prediction-metric/measurement-report.md",
   "bytes": 321,
   "sha256": "4456595d3f94534a470327b21c21d4085f6df5adcc48b6be0c5db4a88c01e8ad"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C048-token-prediction-metric/metric-spec.md",
   "bytes": 1145,
   "sha256": "8184d0953cbd90a82f2f57f645ca2359e6c50cf0ae368575be268beefaf984ad"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C048-token-prediction-metric/results.md",
   "bytes": 338,
   "sha256": "5175d2dabce696644d0c89ed502565f4b7fe78149376482a50d22554dd4fdbcb"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C048-token-prediction-metric/resume.md",
   "bytes": 312,
   "sha256": "eb9f2d85591db64d3418e18a4fd28846a24c32cff1c28541216139adc77248bf"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C048-token-prediction-metric/source-register.md",
   "bytes": 561,
   "sha256": "48a805b4230804967e074b600f21d5f9aa98feeb6ffe8d9ff59ff7711976802b"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C048-token-prediction-metric/task-evidence.md",
   "bytes": 4524,
   "sha256": "2ddee64fba10fc3491c7afc058d8693429d5d6a2a5cbd5199247a80319191422"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C049-architecture-stability-metric/decisions.md",
   "bytes": 721,
   "sha256": "7f2bbf87b3244853f0541bfb4f04f8287932f0358d6e71933362fbe582a0add7"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C049-architecture-stability-metric/measurement-report.md",
   "bytes": 472,
   "sha256": "2f5cca4a0ca0595d61a0b294cb37606f362893f6b4efee088851dfa62b5b9be7"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C049-architecture-stability-metric/metric-spec.md",
   "bytes": 1469,
   "sha256": "3b10b6f24357bece125e66b28723812d6a070d0938bd487ad6b038c281038d45"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C049-architecture-stability-metric/results.md",
   "bytes": 358,
   "sha256": "f7092a1e8940acfc5fd3909b306573a2f25271f4902d7925aaa95affa6264da4"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C049-architecture-stability-metric/resume.md",
   "bytes": 312,
   "sha256": "da1f13e3855f712f93faa5c87f7b38dc2bb3c591cb88f82f4e2e513a1de9e3f6"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C049-architecture-stability-metric/source-register.md",
   "bytes": 581,
   "sha256": "240ed3c87b85150688ba23b990ae3a9fef9a64e4a12868883773d53d50be6b8c"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C049-architecture-stability-metric/task-evidence.md",
   "bytes": 4971,
   "sha256": "8ec6e1731399692bbf656236e107291888684866fbbe8f3259c5b43985acd44b"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C050-cross-length-generalization-metric/decisions.md",
   "bytes": 654,
   "sha256": "0c60ff430a9ac01cae1a33218e7b87a75a00ed341077fecd3cf8cf52b9ac07e0"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C050-cross-length-generalization-metric/measurement-report.md",
   "bytes": 236,
   "sha256": "33759f34ad8de53d2494183b54948fe0e0c355712f6f6d3b69c6babd7948afd3"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C050-cross-length-generalization-metric/metric-spec.md",
   "bytes": 1121,
   "sha256": "bbe8aa1296922efd35f57f35be510ef5a303283f9bf1402e8a924ae0c4104bd4"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C050-cross-length-generalization-metric/results.md",
   "bytes": 309,
   "sha256": "e778b4e927710436cbd7948381d636e646fb89c589a51a0f253840f1af9afa0f"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C050-cross-length-generalization-metric/resume.md",
   "bytes": 312,
   "sha256": "b9c3ca91b1824e4900d3704b571490be0bd68ba9af1b0afa2f4c2b2c6452f549"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C050-cross-length-generalization-metric/source-register.md",
   "bytes": 532,
   "sha256": "78c202c4d7782f46192b79df7c0a04e29b102f79a85123bb0b657ca32bf214ce"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C050-cross-length-generalization-metric/task-evidence.md",
   "bytes": 4019,
   "sha256": "8a88f35fab659b2148d8d9b74f70df15dc0fe5edab6317c73f6bcbcfdfd706b8"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C051-reference-architecture-baseline/baseline-config/README.md",
   "bytes": 258,
   "sha256": "c76a9e05f1a08e0e120e8244f8fba59b1ce980dff414a32c5fa2fb4e762b823b"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C051-reference-architecture-baseline/baseline-spec.md",
   "bytes": 2865,
   "sha256": "48dbee28bdee3d68578a04fd038352a3fa2fc0ab2195abe33f18c97111eafe25"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C051-reference-architecture-baseline/comparison-results/not-run.md",
   "bytes": 98,
   "sha256": "d0c426fdddcb49e7ce9615488d8ae50ea7e3c1b734fbde9aba45e8e91e7e5809"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C051-reference-architecture-baseline/comparison-results/not-the-baseline.md",
   "bytes": 335,
   "sha256": "66c33fc76f0744311a9ee4aeec0b78adfe8ecdb3f9e6db70aefaaca2efabb495"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C051-reference-architecture-baseline/decisions.md",
   "bytes": 2672,
   "sha256": "15ba3e91a8fbb32a0a01abe40b7b0b39ce0faf2483f7e0fa0b4ab82d495734ca"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C051-reference-architecture-baseline/results.md",
   "bytes": 799,
   "sha256": "10d06132c3be25fed2919d94cb2de2535226b1b4ff241d7c95ee478fb4d69315"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C051-reference-architecture-baseline/resume.md",
   "bytes": 757,
   "sha256": "e6847d9e672023eea78258e7e88d7e68bbfa22317532946eafc14855c14234ae"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C051-reference-architecture-baseline/source-register.md",
   "bytes": 3517,
   "sha256": "871ead33f97174210b798ce51006c2e72a96b0c0dada7197e22e3ab1daa20866"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C051-reference-architecture-baseline/task-evidence.md",
   "bytes": 5205,
   "sha256": "0d1aa9caf65d32330bc8c33f2b2b74109eb86b512c53b0ccd7caef4302f1c6dc"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C052-attention-variant-comparison/analysis-and-results/integers.md",
   "bytes": 106,
   "sha256": "a9f818e1ff953743831552f92fb778cf4c0436db0e976e0489d863fabb4a6bf5"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C052-attention-variant-comparison/analysis-and-results/summary.md",
   "bytes": 1326,
   "sha256": "9f5a64c474e7919c50501c688843480752fbae53dd08029d89e96f732239012c"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C052-attention-variant-comparison/decisions.md",
   "bytes": 2267,
   "sha256": "9572ee4c7d7ace0c5373cec0bbc6bf23e8a9373bc1c8dd0e5482d373dd4dcaaa"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C052-attention-variant-comparison/experiment-protocol.md",
   "bytes": 1788,
   "sha256": "5f7466192de36e9322e428c12e9e854f4577dd893cc9923b312853158ee215b7"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C052-attention-variant-comparison/results.md",
   "bytes": 405,
   "sha256": "80f5fc572e27b139aa9dc3a9cea662878afecb53d2dda625e7ccd496616cdcf5"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C052-attention-variant-comparison/resume.md",
   "bytes": 606,
   "sha256": "575e86bc16cc3415b466f0f5710acf1bc3d8d17dc9ee29fd9afd2a447477a31e"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C053-depth-scaling-experiment/analysis-and-results/integers.md",
   "bytes": 106,
   "sha256": "a9f818e1ff953743831552f92fb778cf4c0436db0e976e0489d863fabb4a6bf5"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C053-depth-scaling-experiment/analysis-and-results/summary.md",
   "bytes": 1451,
   "sha256": "c4bab72123320df620a6d70fae3c678f90a123d61615553acb53eddfb75d7b1a"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C053-depth-scaling-experiment/decisions.md",
   "bytes": 2270,
   "sha256": "3375ad3b177ab7c798246773bcfef318133490213facf93280c68968ad66b052"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C053-depth-scaling-experiment/experiment-protocol.md",
   "bytes": 1101,
   "sha256": "a671e57f307c235eeeb78b18d70e9a335975d29d4315a2a284ba7a97e736b3ca"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C053-depth-scaling-experiment/results.md",
   "bytes": 400,
   "sha256": "f3021db16aa35218a1cf77e92e28c3553667683d9d99e5035ae0ea8e713bee76"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C053-depth-scaling-experiment/resume.md",
   "bytes": 610,
   "sha256": "6a71a67c1acae97e3ff8c6bc44765bd511a91eda69666a702fddc6617d6e46f1"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C053-depth-scaling-experiment/source-register.md",
   "bytes": 3400,
   "sha256": "66e776fe223a3f574985af8e1389e5f27265e08f24af59d7dd0273f6ec944fcd"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C054-width-scaling-experiment/analysis-and-results/integers.md",
   "bytes": 106,
   "sha256": "a9f818e1ff953743831552f92fb778cf4c0436db0e976e0489d863fabb4a6bf5"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C054-width-scaling-experiment/analysis-and-results/summary.md",
   "bytes": 1499,
   "sha256": "d7a3420a215ebb2ddae6f4b9e1e90f3e1e33034e508212e2369abee6d873b7ce"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C054-width-scaling-experiment/decisions.md",
   "bytes": 2196,
   "sha256": "aca518af1aac2498e951cf05a137f3e26b5bbb9669b80c221ad6c8f2f81a47c0"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C054-width-scaling-experiment/experiment-protocol.md",
   "bytes": 1026,
   "sha256": "4f17b7e51e4934d412609d216fbbb4a19950c493c4c9c40dd2378f13e3e97667"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C054-width-scaling-experiment/source-register.md",
   "bytes": 3466,
   "sha256": "c2e9740ee49ef93f259002761a5eda4c11cc8b917dd304637a1f44b44e8c774a"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C054-width-scaling-experiment/task-evidence.md",
   "bytes": 5013,
   "sha256": "f2908b9a036511bddd6081fee0cc34909ba99ae7e5c73628e31270ff0cd252d3"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C055-position-encoding-ablation/analysis-and-results/integers.md",
   "bytes": 106,
   "sha256": "a9f818e1ff953743831552f92fb778cf4c0436db0e976e0489d863fabb4a6bf5"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C055-position-encoding-ablation/decisions.md",
   "bytes": 2162,
   "sha256": "1f9abee27cf3c30a715ad952cdf50c63923226b48f194de996022bd83fcc4578"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C055-position-encoding-ablation/experiment-protocol.md",
   "bytes": 1327,
   "sha256": "ad78304e0d05a0572d0ca8c7c049ce544a9ef3f27496e39435917654a66919f7"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C055-position-encoding-ablation/results.md",
   "bytes": 492,
   "sha256": "d5457cf8b3845d5293d77ef122651ec9b7475730f827e8569b36f74673efa946"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C055-position-encoding-ablation/resume.md",
   "bytes": 682,
   "sha256": "b0d0983860a5de1985572dbf76d0d33eb15b9f2d4e8462ac69ccb434b1d64d39"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C055-position-encoding-ablation/source-register.md",
   "bytes": 3447,
   "sha256": "c94df41dc747323b94d5fb665b276a734ecc9274d90fb1716af73aa48afef2bf"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C055-position-encoding-ablation/task-evidence.md",
   "bytes": 5013,
   "sha256": "be78bb1f4617ea79827b333e9dfca016886259b6c93c0f5dd3aa9b6addd0e246"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C056-normalization-ablation/analysis-and-results/integers.md",
   "bytes": 106,
   "sha256": "a9f818e1ff953743831552f92fb778cf4c0436db0e976e0489d863fabb4a6bf5"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C056-normalization-ablation/analysis-and-results/summary.md",
   "bytes": 2711,
   "sha256": "b3558ef3aec687cc61da832ac7e6275370d23056516c40d828cbb3e07a35d4fc"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C056-normalization-ablation/experiment-protocol.md",
   "bytes": 980,
   "sha256": "389bbf34fa4ad6bdb100251c5697aa07d6cfdb2d839a6124507f8c775f380fab"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C056-normalization-ablation/results.md",
   "bytes": 742,
   "sha256": "a3532e19fe4d177ffc6581356f46532df140bb616419abccae1301a60cdd776c"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C056-normalization-ablation/resume.md",
   "bytes": 699,
   "sha256": "222de3ac5008d2618e775b1bc96d951581481833faaccc9d4cb6679eff3b14f7"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C056-normalization-ablation/source-register.md",
   "bytes": 3479,
   "sha256": "965166c061ff790c39fee93a3ff569d58e09c6cd69adc3feb2f54f92873ae624"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C057-sparsity-experiment/analysis-and-results/integers.md",
   "bytes": 106,
   "sha256": "a9f818e1ff953743831552f92fb778cf4c0436db0e976e0489d863fabb4a6bf5"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C057-sparsity-experiment/analysis-and-results/summary.md",
   "bytes": 1350,
   "sha256": "5c7e25be0fc53c6f37a445f8e14190e009249ddca1f96c5ed15612e7da4b913e"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C057-sparsity-experiment/decisions.md",
   "bytes": 2271,
   "sha256": "57b843f4c54560035bdc998eac2e931a578b0e033dbc67c07c54fd234b5e0e8d"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C057-sparsity-experiment/experiment-protocol.md",
   "bytes": 710,
   "sha256": "81d883c694058dc2231375bf8963b351b59e75c1580327007df03957fb0e3e8a"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C057-sparsity-experiment/results.md",
   "bytes": 429,
   "sha256": "158c8f8a4a148aba2360c2d6a03869255329abfcb34efcfd2f595604454fc63a"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C057-sparsity-experiment/resume.md",
   "bytes": 658,
   "sha256": "268603b7f317f78ff6f9da5dbe1fc250e3eafe44dd2a8bfb73c2174d790b62ec"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C057-sparsity-experiment/source-register.md",
   "bytes": 3388,
   "sha256": "78b7f3f819e8231a5cf194ab7ffd34c81290fb716de007ff3401f8530a9ece35"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C057-sparsity-experiment/task-evidence.md",
   "bytes": 5013,
   "sha256": "b28073aa0b31b81ba009c2811e90a1b0d126472d6e68e692556086320efde048"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C058-recurrence-experiment/analysis-and-results/integers.md",
   "bytes": 106,
   "sha256": "a9f818e1ff953743831552f92fb778cf4c0436db0e976e0489d863fabb4a6bf5"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C058-recurrence-experiment/analysis-and-results/summary.md",
   "bytes": 2038,
   "sha256": "545a40ae3d97eb6cf3d527720744fc99f4361daf83d9b2c8b7aad5a215376c6c"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C058-recurrence-experiment/decisions.md",
   "bytes": 2688,
   "sha256": "6d68207bc7e651efbd6eff8f367e8467299f97c173f74d16ce38b16cbd49b396"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C058-recurrence-experiment/experiment-protocol.md",
   "bytes": 1131,
   "sha256": "905f20623275a303fd695e6caae089e02d26173e86c69b055d4f778c280b91bf"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C058-recurrence-experiment/results.md",
   "bytes": 585,
   "sha256": "2844880beb671b69ebdc1355c40a8352e98f55f4fb068c3bd0c0048235478ae6"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C058-recurrence-experiment/resume.md",
   "bytes": 681,
   "sha256": "b21c268ba75fd76b1faa3bfa3259106c3a8568309386c8ccbcbb9a41ee7ea7ad"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C058-recurrence-experiment/source-register.md",
   "bytes": 3419,
   "sha256": "fbda076e070ba0db9cc5cb3547e391f3af8d55c082f7f8c927eaad39b65d71e1"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C058-recurrence-experiment/task-evidence.md",
   "bytes": 5013,
   "sha256": "7e31e6bb2612a9cadf051addedeceb79c93733025550ea8c41504cdf63116557"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C059-context-length-stress-test/decisions.md",
   "bytes": 2759,
   "sha256": "9284734766579b2ef6b935d92893e7b312526ece1771ab483fdd4c277b2bc490"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C059-context-length-stress-test/fixtures/defective-checker.md",
   "bytes": 314,
   "sha256": "b0ed43ec9a4c7665b23ced116ecccd13489c4529e6d557518a34549ffdf1aeb5"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C059-context-length-stress-test/results.md",
   "bytes": 1169,
   "sha256": "f61e350d22cef0148ca85b0ee9522734de2153779cc52d45006683684ffafae8"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C059-context-length-stress-test/resume.md",
   "bytes": 410,
   "sha256": "9749653a23e023575a53494fcafa89de021e4a2dae430e30b8df3aa45b4287eb"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C059-context-length-stress-test/source-register.md",
   "bytes": 3433,
   "sha256": "cd649bf84984065eddcc810904db14d6db53dcb0d07aa2326eb1ae17934d169e"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C059-context-length-stress-test/task-evidence.md",
   "bytes": 4036,
   "sha256": "fc3e8aeccd572a5065463375d2c4773fc003677d3b47376fd4dbfe296bb9f4e0"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C059-context-length-stress-test/test-plan.md",
   "bytes": 1945,
   "sha256": "e8e12e8e9a38583b020026ad627cc47a39cf8fdea3c0e115751caeb81c9a4336"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C059-context-length-stress-test/verification-results/caught.md",
   "bytes": 430,
   "sha256": "1821d88e220ffa7998ab2aff1edb86198f0b8ca80deb8a23e07af36ce3d87f40"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C060-architecture-transfer-study/analysis-and-results/integers.md",
   "bytes": 106,
   "sha256": "a9f818e1ff953743831552f92fb778cf4c0436db0e976e0489d863fabb4a6bf5"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C060-architecture-transfer-study/analysis-and-results/summary.md",
   "bytes": 1546,
   "sha256": "228f02611c779d475ce673980da48af74a66268629f53ff70b168c18254466d7"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C060-architecture-transfer-study/decisions.md",
   "bytes": 2284,
   "sha256": "05940ee44660455cd746fff15d0bd90f24b75b7a0ee7e84066529c4b7d2f6c3c"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C060-architecture-transfer-study/experiment-protocol.md",
   "bytes": 1719,
   "sha256": "cd0e88d74c6e6b12ac9e5410ac08769e9f1f4bd4649dd53bb1e5720fc27c286d"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C060-architecture-transfer-study/results.md",
   "bytes": 710,
   "sha256": "551e91a7b47db3a1ecb170bddb44d95168c30ec3830982870f491e343a607699"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C060-architecture-transfer-study/resume.md",
   "bytes": 694,
   "sha256": "4d233080093b3853f3c1d19cd4429889d0c215938137f5033fbba65bb6199223"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C060-architecture-transfer-study/source-register.md",
   "bytes": 3492,
   "sha256": "9715aaf67ffbd81fa3ea6e3f441972fc1d69fce3ef97fde5fff6094f988e1b70"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C061-data-to-update-accounting/decisions.md",
   "bytes": 682,
   "sha256": "0f225271dffff11d1d0c47c84b60dff002f8fabfafeb699446877c008c4a4549"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C061-data-to-update-accounting/metric-spec.md",
   "bytes": 1833,
   "sha256": "ab0e37ebc07b7e666a6788686f5a6d84b68f998bb200146d064ce0f9042425ea"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C061-data-to-update-accounting/results.md",
   "bytes": 561,
   "sha256": "13995faea483bea1e305d682f20cf6a6076bff4810248619107e6b126ef874bc"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C061-data-to-update-accounting/resume.md",
   "bytes": 367,
   "sha256": "4a2e704c2521d4c2a602e0f4ccd02d4abe3de966de49b57a2e8002e2bdc2314c"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C061-data-to-update-accounting/source-register.md",
   "bytes": 1123,
   "sha256": "d3c62dd5e786ed02f974d26d6a3b16e2994609c4017c1669cca3bcfda21b1d22"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C061-data-to-update-accounting/task-evidence.md",
   "bytes": 4367,
   "sha256": "4f5bc2b7d8fdfba6e8fa56c735685ea9e2c1d88fef69d609110d4ae607c4e913"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C062-effective-batch-calculation/decisions.md",
   "bytes": 428,
   "sha256": "c94185585430b399828835a3b44d38345977c3487994e77f0ab9048b920047ae"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C062-effective-batch-calculation/metric-spec.md",
   "bytes": 1751,
   "sha256": "2cb3b1c6e61fd10ffa824a971a0d1616bc87de6108b7d6ff77eb8411bf333266"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C062-effective-batch-calculation/results.md",
   "bytes": 514,
   "sha256": "ca6ae8fe87f2dcf5a7fa4044c75526897e72e9b0aaabec9bb5406f568ba0609c"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C062-effective-batch-calculation/task-evidence.md",
   "bytes": 4246,
   "sha256": "87d43c6f69c5bf5cdf4894f4323465f855c5ba7a41a3b81501997cc1b963c462"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C063-gradient-variance-estimate/measurement-report.md",
   "bytes": 1376,
   "sha256": "9e9f0500b7c0a5a8c16ace55365045a5a304c47bc8a26aaabdddf709602bfec0"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C063-gradient-variance-estimate/metric-spec.md",
   "bytes": 1777,
   "sha256": "4a613b9be3a9d106dad9a846d88cb06a8ca5e4d580f45576c86c0261b4f76b54"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C063-gradient-variance-estimate/results.md",
   "bytes": 689,
   "sha256": "1666feea7314a202b616e87a9f423f57a60c29f151d327f5739540571be0cdd3"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C063-gradient-variance-estimate/resume.md",
   "bytes": 300,
   "sha256": "506302dcf6391511a61fe06c8391dad9c781db5892a7d971ead0a6065c0abb14"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C063-gradient-variance-estimate/source-register.md",
   "bytes": 1100,
   "sha256": "8bbe2517d4570265982ffdb510110819a83eda978d1e72808019ea5489ca63d5"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C063-gradient-variance-estimate/task-evidence.md",
   "bytes": 4233,
   "sha256": "93526134590f37f2ef3cee70a76b2ffdf6cb39f07b94dd04fd48c955981435e7"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C064-loss-scale-tracking/decisions.md",
   "bytes": 872,
   "sha256": "909531f14e70270d000f134a21afb14544fd8645be3b6d3342f23beb4b1288f0"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C064-loss-scale-tracking/learning-records/summary.md",
   "bytes": 422,
   "sha256": "98941669fd0b6b3fcdb429c7f7f566ea74341fce1eeac1abe7949e23d7a6592b"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C064-loss-scale-tracking/resume.md",
   "bytes": 272,
   "sha256": "60c9288c306e54070ccbb05947e6a181598321d61d45bcf0749a91e0fdbf3f8e"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C064-loss-scale-tracking/source-register.md",
   "bytes": 1161,
   "sha256": "5d36a8a4e69aa6deac424cad4232cf1e9e69e12d78fed014dfca2809e88f8df7"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C064-loss-scale-tracking/task-evidence.md",
   "bytes": 4299,
   "sha256": "e23e04cd7aa4bf3595836b37f981559180169b76b39737d2c0065ba81977d722"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C064-loss-scale-tracking/training-spec.md",
   "bytes": 1848,
   "sha256": "72102713a5679f95a2293259739a34f5ed1ff53103f1178c398d0a9ca18ddd0a"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C065-optimizer-state-inspection/decisions.md",
   "bytes": 762,
   "sha256": "cf641a91fbb5d32304f855c11e151b51790635af4c18f4870f60ffe8b431ba77"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C065-optimizer-state-inspection/results.md",
   "bytes": 989,
   "sha256": "85d9cad42d584b7132436e00a8731f89601247d04fa111e6ace24af635442444"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C065-optimizer-state-inspection/resume.md",
   "bytes": 209,
   "sha256": "75aaac3b0760267f7abc39d255f56215cfb1b5345acecf699f44368e89c2dd80"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C065-optimizer-state-inspection/source-register.md",
   "bytes": 1238,
   "sha256": "cfb17dac4e5c5cd45a321101bbb11303de473c8b681a1aac0ea95ae1f8c06b4d"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C065-optimizer-state-inspection/state-model.md",
   "bytes": 2439,
   "sha256": "b89e52a0ce9674636a673b798db3da01ffd0c096e499c0fdf727e5eb9e7bceb5"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C065-optimizer-state-inspection/task-evidence.md",
   "bytes": 4540,
   "sha256": "1d4d0f74bf33e8f89d8112e2cfde43ab75397b9b51b7a5564ca45da2ada7b2ab"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C066-update-magnitude-monitor/decisions.md",
   "bytes": 773,
   "sha256": "2ec743b4df36811b8dac586ae02dab925997afe6446a850ef48b85ceac3587c1"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C066-update-magnitude-monitor/diagnostic-report.md",
   "bytes": 2683,
   "sha256": "b3a7fcb60d92b829f35d96e79771093087fb2ce02579572d5cedbace4d146ae8"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C066-update-magnitude-monitor/instrumentation-spec.md",
   "bytes": 2159,
   "sha256": "acb76760fd2808878f88356469472a65f8fcf861318200c6f4bc2ddae0a5f334"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C066-update-magnitude-monitor/results.md",
   "bytes": 575,
   "sha256": "303a0cd9893656f0d9a4768b5946f479de4f0eff8c80fd1e450811cb153a85fe"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C066-update-magnitude-monitor/resume.md",
   "bytes": 225,
   "sha256": "c827f347f1734835b5f2d67962abb69d2c6cfacd334fbf5fe202967176f4da91"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C066-update-magnitude-monitor/source-register.md",
   "bytes": 1258,
   "sha256": "79fa23ede0af327934e15e6546483dcd7479f91d651e47a4eccb3db181e2fbca"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C066-update-magnitude-monitor/task-evidence.md",
   "bytes": 4546,
   "sha256": "09050e7ac433c7893f950a6f326bac0a73170a709dba1326d49f4e7fd635eef3"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C067-curriculum-progression-record/decisions.md",
   "bytes": 495,
   "sha256": "1c4f722530db771882d6e7c93e1d666bd6457782fa1f5ac843c1f3828a8e9c3a"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C067-curriculum-progression-record/lifecycle-checks.md",
   "bytes": 2125,
   "sha256": "69d640bcf2d623984866a05dfcc3ba7660d17660ebd5ac29a582120470aa7768"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C067-curriculum-progression-record/results.md",
   "bytes": 987,
   "sha256": "4138fc073320396c705f0c4ee455426d34a993ca68438a90201ab019970d054a"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C067-curriculum-progression-record/resume.md",
   "bytes": 166,
   "sha256": "1517357d256da87e602c7ed51e3eed36f1c358cdc6e2cae383f527ef3a97cd5d"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C067-curriculum-progression-record/source-register.md",
   "bytes": 1089,
   "sha256": "e5ef3fcfda5f8bebf98b752ef1e600bb7f37b2f4c8ca63db3941b3b547600e01"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C067-curriculum-progression-record/task-evidence.md",
   "bytes": 4025,
   "sha256": "41012edb198b58ecd1ae5a9c43caace54a3cab678dfb3b2ff83d21bef25ba738"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C068-training-instability-taxonomy/decisions.md",
   "bytes": 624,
   "sha256": "d66948421561eaf5f8298fe5321ca70b380fe85bb3a26a4f9e5fd5de3a0bd1ba"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C068-training-instability-taxonomy/lifecycle-checks.md",
   "bytes": 1301,
   "sha256": "8fc08d8839e11f27675e30f088531869517e16360e9284b5f35841923dbbd643"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C068-training-instability-taxonomy/results.md",
   "bytes": 497,
   "sha256": "b60dc39ba90134a5d27843f09359a6e389f9fc393057a60e2f0e0f50ac645998"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C068-training-instability-taxonomy/resume.md",
   "bytes": 198,
   "sha256": "d501e6c8a18ca724b59cc76c394359be00ea8a884d934eaab709429f880130bd"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C068-training-instability-taxonomy/source-register.md",
   "bytes": 1291,
   "sha256": "345118cd6a61e5e3d59de898b98bfaffadd23a744d956b1f9b71a9efd7f3a282"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C068-training-instability-taxonomy/task-evidence.md",
   "bytes": 3894,
   "sha256": "4fbedb0227db8c040d30a702bf27719fd00b0c23a8d47b74bfaa98670b70364f"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C069-checkpoint-comparison-probes/decisions.md",
   "bytes": 544,
   "sha256": "25d596a670e67cb0bb53bd0e6d9cda0fca0fad43d33ac4681018fc9bebb9de1a"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C069-checkpoint-comparison-probes/diagnostic-report.md",
   "bytes": 1532,
   "sha256": "d444c6c41c511ea7b36046592d8aa773d6f0312ac1532ba81cf5b516ab604c21"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C069-checkpoint-comparison-probes/instrumentation-spec.md",
   "bytes": 1413,
   "sha256": "6abf730693b4c1c6f1479304ef615ef75c6ac52c5f3f4b5904231b573819c9af"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C069-checkpoint-comparison-probes/results.md",
   "bytes": 426,
   "sha256": "971d2daf77f771d719fbe51477c7405b937a5bdd3daea528b2aea3c82149594d"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C069-checkpoint-comparison-probes/resume.md",
   "bytes": 260,
   "sha256": "8cc80e9f32c05eef469a4793d25b4c08d63389a1eeb43b88b8948783b4333515"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C069-checkpoint-comparison-probes/source-register.md",
   "bytes": 1177,
   "sha256": "201c1b8c3a03af3e3b26c25230a74e63a58a6801785be5dfbca883cb79d742ca"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C069-checkpoint-comparison-probes/task-evidence.md",
   "bytes": 4276,
   "sha256": "13fe062a4c69eda2acd6fc3ce226615fdf66ca23259085610d73c0d3eeed8b03"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C070-warm-start-study/analysis-and-results/analysis.md",
   "bytes": 2464,
   "sha256": "8b5e910ee4bcf696c6a5ca8c16f02343d8fe0fe2c8a87ce813df07d209c3de28"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C070-warm-start-study/experiment-protocol.md",
   "bytes": 2151,
   "sha256": "136b48a316a723e5d3d5329b084427bdbfce93d8e3e8e1b36d2ecde2e2ca4121"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C070-warm-start-study/results.md",
   "bytes": 707,
   "sha256": "ae93af2bed90851efaf5e7decccb2b931d677d4247a8faee874d26b0a709a293"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C070-warm-start-study/resume.md",
   "bytes": 306,
   "sha256": "d49302058d6aec6f28cfb1b39d6f604db6d4a91cee08ee3b4bcefd908fa9f4b4"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C070-warm-start-study/source-register.md",
   "bytes": 1251,
   "sha256": "76dc3a564740b388d145b4b427b84078d3d6df4198e976eabc54a4e7bba28251"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C070-warm-start-study/task-evidence.md",
   "bytes": 4502,
   "sha256": "e2387234e830814fb9d72f8c3063d615ef1d561c9332755bf00c22c47cc41f7b"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C081-prototype-directory-layout/decisions.md",
   "bytes": 5185,
   "sha256": "cc213eb07b0ac9f59ee223b27e795839356961942b38658de5003c2d20d79ffe"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C081-prototype-directory-layout/package-layout.md",
   "bytes": 9472,
   "sha256": "cf2f839818d1e2d1b432f1c292c21e7f67b0b9ee29db264cd056358172b5470d"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C081-prototype-directory-layout/results.md",
   "bytes": 2778,
   "sha256": "458f0154b18c4651b4bc5e7770148a67c463d235e0b8f2667f7ea1e41bb19966"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C081-prototype-directory-layout/resume.md",
   "bytes": 1256,
   "sha256": "bab41f2a1aee526753f782ccb8b3e1eef6a67f07a82c5394714aa4ae12c9d19c"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C081-prototype-directory-layout/setup-and-reproduction.md",
   "bytes": 7222,
   "sha256": "e42a5068217c74accb85195c8e31fce82ba332eaca9580178c2a55dda0d97a19"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C081-prototype-directory-layout/task-evidence.md",
   "bytes": 5523,
   "sha256": "9a38aa8dd2c3b24e9e12a9a96669e9f0f3d7223275fe4f8101222398ca5aeec2"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C081-prototype-directory-layout/verification/walkthrough.md",
   "bytes": 2154,
   "sha256": "659dc2fa3fad4c297e7ae0d3f03cdab8e346dfc47af94ddbe68a12fe4004462d"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C082-dependency-installation-recipe/decisions.md",
   "bytes": 3197,
   "sha256": "29a28658bb144b617ec6916f587a8085d98cd8616ebb4d88a07a6cdde822423a"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C082-dependency-installation-recipe/package-layout.md",
   "bytes": 6909,
   "sha256": "51ffe81657d52822dd15c5e115c43e57778766c3e4879acb178dddcba803c12a"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C082-dependency-installation-recipe/results.md",
   "bytes": 2386,
   "sha256": "c98da5b3d89c433e29dbc1e7ecb9d06101ba062812fa070c192167488117a2ae"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C082-dependency-installation-recipe/resume.md",
   "bytes": 1341,
   "sha256": "62789e8a23549d3542a0b5f9e7c7a8e0503a8b1c2ec87928af36e33ff16709cc"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C082-dependency-installation-recipe/setup-and-reproduction.md",
   "bytes": 5164,
   "sha256": "fdc33f57bd423c40fd4c3149c6f166db228a95642bdd72e48328cafe797ce82e"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C082-dependency-installation-recipe/task-evidence.md",
   "bytes": 5184,
   "sha256": "3f0ab26542fcf35dde178957169fc5afa9ef7cf26614c08da05c46b78c7d2336"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C082-dependency-installation-recipe/verification/walkthrough.md",
   "bytes": 1362,
   "sha256": "e23f63d2cdd3f4cb2cd1ce84c4991ec26b73ac074bd53f30a10043f0e3d52393"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C083-machine-readable-configuration-file/configuration-schema/overview.md",
   "bytes": 8953,
   "sha256": "15e588fe38ccfaccaf9d022f0c00c8d1dcd743a925e308c1cacc5d92dbeb0bd9"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C083-machine-readable-configuration-file/decisions.md",
   "bytes": 4364,
   "sha256": "edaf171565d5ac534196cca04325efc243494a5dec5a4f47f0b3f6c8c74ef15a"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C083-machine-readable-configuration-file/results.md",
   "bytes": 2910,
   "sha256": "17fc1838b53e573e6d66e1b15d7f68e14a63dce198a8d74f4296785557057959"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C083-machine-readable-configuration-file/resume.md",
   "bytes": 1209,
   "sha256": "eabac1f294cd840092744fee899d4a3f68646aaac3246f3b5f27e3dbf267ebdd"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C083-machine-readable-configuration-file/source-register.md",
   "bytes": 3845,
   "sha256": "99bb9cfb9f269a3d8fd5c689297755422527d784f00ca6d5fe8987e58922d597"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C083-machine-readable-configuration-file/task-evidence.md",
   "bytes": 5487,
   "sha256": "57578ad4a0db0160ab93c8a0771206e4c6a482b61776cbcef46868f2011fc5ff"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C083-machine-readable-configuration-file/verification/walkthrough.md",
   "bytes": 1934,
   "sha256": "129ea9b203c7a98ebfe59bb70e1734768c982b39984346fe40ad14d4fa0b5686"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C084-input-output-integration-adapter/adapter-contract.md",
   "bytes": 5901,
   "sha256": "29113c324974873316da1782da3e17353236eca7ae63c07219d06b99321069d1"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C084-input-output-integration-adapter/decisions.md",
   "bytes": 3458,
   "sha256": "79ee0fcfabb7043fe040986159c2dc044cb167e7a4018d79b567f411b589cd70"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C084-input-output-integration-adapter/results.md",
   "bytes": 2309,
   "sha256": "dfc8c9f5f207042c073be7b88fa1083d2fac10a619f3debf342c1921de0e1da4"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C084-input-output-integration-adapter/resume.md",
   "bytes": 1131,
   "sha256": "cdb5c182cb61df3513a8976dbf9f8eee3be6a43678ded06e1dde5a9b63df4fe8"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C084-input-output-integration-adapter/source-register.md",
   "bytes": 3674,
   "sha256": "2badb38b7d3bc1ad85f6fd24872274c1b917369e4f1827607e795e3c877d2758"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C084-input-output-integration-adapter/verification/walkthrough.md",
   "bytes": 1179,
   "sha256": "6b001c678c057b4165e860ead661a9c3ce6439cfabc1bc19a74536ba67c18bae"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C085-deterministic-example-runner/decisions.md",
   "bytes": 2760,
   "sha256": "04542577f0d799051509ecd1ee9410edb43aa1d432803ae91744a65bed4417ce"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C085-deterministic-example-runner/results.md",
   "bytes": 1901,
   "sha256": "41cea7248121066ae14e0c042fef2cfcf14ac7cd696cfccdb32aba9bd9654b53"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C085-deterministic-example-runner/resume.md",
   "bytes": 1187,
   "sha256": "c39833514916dfa34c505001e03d762bbfaaceee37d73017d55ea0911ccfa21c"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C085-deterministic-example-runner/run-instructions.md",
   "bytes": 5278,
   "sha256": "a6301a5433bebd87122a67d977728d537b4a5725c70709f4aa0a7472220dea41"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C085-deterministic-example-runner/source-register.md",
   "bytes": 2871,
   "sha256": "954d816e233408f245298a984dcd422890d351b34eb60f5fb15d26834bbf5425"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C085-deterministic-example-runner/task-evidence.md",
   "bytes": 4507,
   "sha256": "2a958ad7cb74d940bbe3f814b6340644f8c9d0d044b1cadc1d47fae6ba8f7fcb"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C085-deterministic-example-runner/verification/walkthrough.md",
   "bytes": 1056,
   "sha256": "fa350a5355bb37e80fa6291da67385002ad744346334c198897df84292f11d0d"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C086-structured-diagnostic-logs/decisions.md",
   "bytes": 5353,
   "sha256": "6d678c81a61b852bd5ecc8f4479371d86ed43d6379b6088ef9d7d1cb7ea1949f"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C086-structured-diagnostic-logs/diagnostic-report.md",
   "bytes": 11256,
   "sha256": "0f98e7e55d5fdcecd2a52ed9c20bb68f34e79b39c059cbf165408cc55bf7fe79"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C086-structured-diagnostic-logs/instrumentation-spec.md",
   "bytes": 6062,
   "sha256": "505fadb0c4d602f366a37c816d5fe96b764e2fc9b4b7599b22722a125f67e103"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C086-structured-diagnostic-logs/results.md",
   "bytes": 2577,
   "sha256": "e7536383f60a50b947a0d102647ff44c88936321a18ece1ef680d4a092d5180e"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C086-structured-diagnostic-logs/resume.md",
   "bytes": 1212,
   "sha256": "27288742066b6f8a448cb97429d138c5c94658aea6d91318d222757a67701331"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C086-structured-diagnostic-logs/signal-fixtures/logs/README.md",
   "bytes": 839,
   "sha256": "1ba2b15520ab83c845b0be6679ff2245f4dd9df7f16920e2017cc83a77a967af"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C086-structured-diagnostic-logs/source-register.md",
   "bytes": 3035,
   "sha256": "366744a0226dc71db3dcfcc0b70a2d85054a976ee404f963620186f765629cf4"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C086-structured-diagnostic-logs/task-evidence.md",
   "bytes": 4494,
   "sha256": "cb6a2f39b922b45b7d605ae42b9c1c4fb3ae38d60e6da2b5dd28e0d4ec480ccc"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C086-structured-diagnostic-logs/verification/walkthrough.md",
   "bytes": 1104,
   "sha256": "393d12e2fe3a53df997babd3cd8a78289f7eb7c97309ec574a69e8f5561e7542"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C087-resumable-execution-checkpoint/checkpoint-spec.md",
   "bytes": 8663,
   "sha256": "6325ca54c0dce62200e7bf29cf6b0e127875a0c6154dfc1844fe34af94cdc31d"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C087-resumable-execution-checkpoint/decisions.md",
   "bytes": 4824,
   "sha256": "54de7350008a7666a4fe3b4c8ed9a4f58290d5ff5a63d81a771df4c21c4ba78b"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C087-resumable-execution-checkpoint/replay-results/guarantees-and-recovery.md",
   "bytes": 4227,
   "sha256": "cb1e43945a7dde7cca9fda0ab31a87cb1b9c5e840901478dd5a66a0dee625c4a"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C087-resumable-execution-checkpoint/replay-results/run1-stale-defect/README.md",
   "bytes": 948,
   "sha256": "66ab83c9c32b913c5f5594605f8c7feb3984a1229a200ad55db1ae04ea9da8c9"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C087-resumable-execution-checkpoint/results.md",
   "bytes": 4571,
   "sha256": "293393ac1a3ecee51e801cf244ecb6d3e44c1f99d0cedca491ad3e17e3c89b80"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C087-resumable-execution-checkpoint/resume.md",
   "bytes": 1470,
   "sha256": "dd45966f968a66c7bada56938774e597d9b34b23d4c0e977f122cddf8ffe6b93"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C087-resumable-execution-checkpoint/source-register.md",
   "bytes": 2925,
   "sha256": "0726a76dd7f16a2cde0e4a3faf0736ea0928a1fe73dcf0d811b0ff72efac77b0"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C087-resumable-execution-checkpoint/task-evidence.md",
   "bytes": 4336,
   "sha256": "24ba2d1ba8be65831b07d0a8bd54942ba3573fa5495957c80904570f89d482cf"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C087-resumable-execution-checkpoint/verification/walkthrough.md",
   "bytes": 963,
   "sha256": "f60db9c2f595da30b3180347efff1986b126262fce9673e1d8a1bc5246689381"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C088-artifact-naming-convention/decisions.md",
   "bytes": 4249,
   "sha256": "b10c48d242efdb282bdf5145616b41b3b11b168220d62cbc3e471c2ece890098"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C088-artifact-naming-convention/package-layout.md",
   "bytes": 8505,
   "sha256": "2b67c3520a326b6145963cd01019b14d6993823db12d69f34dffa11686590f85"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C088-artifact-naming-convention/results.md",
   "bytes": 2861,
   "sha256": "06a21b5d5d5c9f64e8bb1c9a1fabaa474f12e0579ba894bde772e72778cbd7c0"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C088-artifact-naming-convention/resume.md",
   "bytes": 1331,
   "sha256": "8ed0f160e0a07ffab8e17581cfcb0f1e8941f73bef24b4bf4c8688d681cc6be0"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C088-artifact-naming-convention/setup-and-reproduction.md",
   "bytes": 5326,
   "sha256": "18716653e96007068bcdee68c02bd6fb55b33d32bb91724d088fa82165ba342d"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C088-artifact-naming-convention/source-register.md",
   "bytes": 3504,
   "sha256": "0ba655eb74c2233669d0a30b2a0a04df8a2ec4a75361763d5617cd7ba23d6ca4"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C088-artifact-naming-convention/task-evidence.md",
   "bytes": 5038,
   "sha256": "9261b858370f6431f057223b15a58bb453566a4bd8a41e2fe7ca587786ebf646"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C088-artifact-naming-convention/verification/walkthrough.md",
   "bytes": 2340,
   "sha256": "afd24a9c48d5c3bb5cbde575ab8e68101dd69b03d0225f6145d8117aa5ba5b92"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C089-automated-validation-command/decisions.md",
   "bytes": 3642,
   "sha256": "0785857845bb77152fe61bc6c01564672b1787af74456dc7e1359b018c241a70"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C089-automated-validation-command/resume.md",
   "bytes": 827,
   "sha256": "dcfbeb25d6ae43649ac378cbb58c73d091ebec748ec0d02a77051dadac53a92c"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C089-automated-validation-command/source-register.md",
   "bytes": 2501,
   "sha256": "18d01ad2b3c0267d65e55c9c052f4f0729baa757314a27f48da9b5d1fc225b2c"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C089-automated-validation-command/task-evidence.md",
   "bytes": 3496,
   "sha256": "385afa5d21ed25779196a391f075109f7c390052082cd527ea0ce7810fa784b7"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C089-automated-validation-command/test-plan.md",
   "bytes": 6889,
   "sha256": "455c6f8aee2685992b24e6d889ba98199ea0520558c56aec6986915329fbf8b2"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C089-automated-validation-command/verification/walkthrough.md",
   "bytes": 633,
   "sha256": "83540ce7a91f665039938b6f64eef4318f4a7ed21c167a32190e560c38bedb4a"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C090-portable-result-export/decisions.md",
   "bytes": 4539,
   "sha256": "e9d5b9e5dbe6c64a491a26fa7924692e3e424ec1027b8ec5624ac5585d63f9e2"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C090-portable-result-export/environment-manifest/requirements.md",
   "bytes": 1655,
   "sha256": "134be8eeccf8836d0b96c433756df75f014313e690f439cfdb5100ee4a4ff7a3"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C090-portable-result-export/examples/bundles/README.md",
   "bytes": 516,
   "sha256": "aadee37589ae40c5b1ba0b8d09b43ad710a948f7d9c8fb4d5109b3b30ee863db"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C090-portable-result-export/examples/bundles/elsewhere/record-8M/README.md",
   "bytes": 1413,
   "sha256": "7c60f1a809ec2fcbeaeab77b594c5d525e19a661590d8c48060b314fe123716a"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C090-portable-result-export/examples/bundles/elsewhere/record-8M/leaderboard-row.md",
   "bytes": 126,
   "sha256": "7c53529d3d4aaa039c0b85ab3d7949767885908d24c3e1fb0c59c6ca5357b014"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C090-portable-result-export/examples/bundles/record-100M/README.md",
   "bytes": 1413,
   "sha256": "7c60f1a809ec2fcbeaeab77b594c5d525e19a661590d8c48060b314fe123716a"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C090-portable-result-export/examples/bundles/record-100M/leaderboard-row.md",
   "bytes": 130,
   "sha256": "40ceac684bcf8fe37018eb87f24d18caff1e2f0e3d3064783c7d62b0f0785a86"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C090-portable-result-export/examples/bundles/record-20M/README.md",
   "bytes": 1413,
   "sha256": "7c60f1a809ec2fcbeaeab77b594c5d525e19a661590d8c48060b314fe123716a"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C090-portable-result-export/examples/bundles/record-20M/leaderboard-row.md",
   "bytes": 128,
   "sha256": "db9ca91d5d62fb2cb84f4ae843ace89164b46f3338e1a793cab6c3e6d0ae6b23"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C090-portable-result-export/examples/bundles/record-8M/README.md",
   "bytes": 1413,
   "sha256": "7c60f1a809ec2fcbeaeab77b594c5d525e19a661590d8c48060b314fe123716a"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C090-portable-result-export/examples/bundles/record-8M/leaderboard-row.md",
   "bytes": 126,
   "sha256": "7c53529d3d4aaa039c0b85ab3d7949767885908d24c3e1fb0c59c6ca5357b014"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C090-portable-result-export/package-layout.md",
   "bytes": 6216,
   "sha256": "0537c28ab3cab3a1cc0525d5c6f97902de7ef6fce5efb6b1e749b295b9adf5ff"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C090-portable-result-export/results.md",
   "bytes": 2499,
   "sha256": "f1d05fa2f42290fc624c5abefbfc13329e492c87ec5bd67d8a1e62259caa96aa"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C090-portable-result-export/resume.md",
   "bytes": 880,
   "sha256": "6497dfc6115cafe5a1e54cdce89ffe9ef1214875af9c7ec7102c7dcbb979fdde"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C090-portable-result-export/setup-and-reproduction.md",
   "bytes": 1974,
   "sha256": "a7eb10242116827fad6af53e3c27977f3655de49a66b63fd455b2dd367990783"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C090-portable-result-export/source-register.md",
   "bytes": 2517,
   "sha256": "a2cb86e414f845cb48bf58fc52543b336ebec3634ed1e0a6406004757db5f9b9"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C090-portable-result-export/verification/walkthrough.md",
   "bytes": 702,
   "sha256": "8e70b7c675b042cc783ef4362f8cb7e7298a62e19b1c0b0fe31191b8a2793e57"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C091-concept-glossary-with-worked-examples/guide.md",
   "bytes": 6616,
   "sha256": "15ac92b91956a95d7bc1e33d06f2b4c30d6d4228897846914a2b9db6487a7650"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C091-concept-glossary-with-worked-examples/results.md",
   "bytes": 1597,
   "sha256": "fb32e2fdf438770108ee7a72d8b6ad6b7686eaec5f22aacd759133692d5e7eb0"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C091-concept-glossary-with-worked-examples/resume.md",
   "bytes": 500,
   "sha256": "21a52804e2939b57efe2838fb7fde68d9654effa3f07e15815e74ee139237ce1"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C091-concept-glossary-with-worked-examples/review-notes.md",
   "bytes": 2158,
   "sha256": "cdc2ae553771747007f29efc4d6523783d22e378577cc734dd6f5b98158091c4"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C091-concept-glossary-with-worked-examples/source-register.md",
   "bytes": 1196,
   "sha256": "fc152a958c87ef16ae75e22b05e28cbf592ef0200c004d9d775a375f5ccdfb7b"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C091-concept-glossary-with-worked-examples/worked-examples/worked-examples.md",
   "bytes": 3340,
   "sha256": "a90711d5a297fd8edf01ee588695b002bca209ca575807d3b6eaff6d1f4ecfa1"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C092-annotated-original-source-reading-guide/decisions.md",
   "bytes": 1625,
   "sha256": "5f5ccf2a1ad6e70672bd16cc0144d3ff3076c3eef6f4e10570de34e02c1335e0"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C092-annotated-original-source-reading-guide/guide.md",
   "bytes": 7389,
   "sha256": "801d5870714051cc2f0c8d7dcfda58210737c04f5fce93b9bc7a8f5546683b1a"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C092-annotated-original-source-reading-guide/results.md",
   "bytes": 1453,
   "sha256": "0ad75aeecce1977435d60a48be4492afc9118acd6ffa4c044f06f68777d759eb"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C092-annotated-original-source-reading-guide/resume.md",
   "bytes": 501,
   "sha256": "508c124af5ad495ce45f9762250d4e714211a07e16f11a730b844d29e29ad7f4"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C092-annotated-original-source-reading-guide/review-notes.md",
   "bytes": 1605,
   "sha256": "ff5f27d5e0c9bfe0bba2c0eeb28f4979c1f9d5cfaf849962175aabee9cc0c6f4"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C092-annotated-original-source-reading-guide/source-register.md",
   "bytes": 1013,
   "sha256": "b8c8eb21735aeb07202cc576ecaa0f40264863d7a3f08aecbc42b544bfca0c9b"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C092-annotated-original-source-reading-guide/task-evidence.md",
   "bytes": 3049,
   "sha256": "e876fd7ea3292010b9c40c558062896813e80e0e271924a019bea29249c41eaa"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C092-annotated-original-source-reading-guide/verification/walkthrough.md",
   "bytes": 369,
   "sha256": "e73de5ca865d2b567c661526d1676779803a84ef3ab8a49c23d5e0ae58384d82"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C092-annotated-original-source-reading-guide/worked-examples/traced-readings.md",
   "bytes": 2493,
   "sha256": "99ff4bebc255dfdf2d561fe38d94ceb10877313d6bce1237279510ce3e88ab14"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C093-implementation-versus-theory-comparison-notes/decisions.md",
   "bytes": 1824,
   "sha256": "1fa880c3b7f8578ccb2a0dec4c3cfaa8789c71855e6cd08ecc63475aa74e5052"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C093-implementation-versus-theory-comparison-notes/guide.md",
   "bytes": 7765,
   "sha256": "7f64e23341251209b79cb7e212464018f99496839c2a5fbb2484e19276655907"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C093-implementation-versus-theory-comparison-notes/results.md",
   "bytes": 2095,
   "sha256": "31a26ee5ea7e6307027b72dab08e4e2cb912346d22c516431ecf6c15ec0961ce"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C093-implementation-versus-theory-comparison-notes/resume.md",
   "bytes": 539,
   "sha256": "60d69dcec5c1c99f5956793ff6f44964623db4cac0998ae17bdb64475ee5bcb7"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C093-implementation-versus-theory-comparison-notes/review-notes.md",
   "bytes": 1423,
   "sha256": "9465737ba9e5fe0a8aedfbebb6c158bf8371e97dc27b48c63d449e178dbd3bc4"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C093-implementation-versus-theory-comparison-notes/source-register.md",
   "bytes": 2578,
   "sha256": "b2f13453bc4bd4959aca7db33086098c128b7c65711178290b008c666d7d85f0"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C093-implementation-versus-theory-comparison-notes/task-evidence.md",
   "bytes": 3092,
   "sha256": "25148161ded7915fd1c7861a557a877538767be6a01836ce174a5a2306019e38"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C093-implementation-versus-theory-comparison-notes/verification/walkthrough.md",
   "bytes": 350,
   "sha256": "5487dc54893e7054d7c193e6e7488ebcc90820fd1fb27b3c225f27a396c37e72"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C093-implementation-versus-theory-comparison-notes/worked-examples/worked-examples.md",
   "bytes": 1406,
   "sha256": "5316b686eede7f616e25fb94bfa49e209dd9acb8b314bd9ac6310cbaf2698046"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C094-small-reproducible-demonstration-notebook/decisions.md",
   "bytes": 1737,
   "sha256": "680edd45c8de9ce668eef2c222b9a637e137bdfbe18042888b837fe0099bf60d"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C094-small-reproducible-demonstration-notebook/guide.md",
   "bytes": 3762,
   "sha256": "b5492a6b3c7ef34e147889a303e532866f474cc82bd6dfa3c28f2909d88ff5f6"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C094-small-reproducible-demonstration-notebook/results.md",
   "bytes": 1483,
   "sha256": "65dfd3e9ec8e8dc82b0a5da6cc47224e34b81029d951d30df8ab65cf144fcb35"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C094-small-reproducible-demonstration-notebook/resume.md",
   "bytes": 461,
   "sha256": "522b03d7ecdbb3db4a36d09b75f46968c7d370fde9581edc2ff444522f668492"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C094-small-reproducible-demonstration-notebook/review-notes.md",
   "bytes": 926,
   "sha256": "2093a321a6c7fb0a7f0010d91e24cc78f78756f012fe0f557f25ccd267b8c715"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C094-small-reproducible-demonstration-notebook/source-register.md",
   "bytes": 1094,
   "sha256": "08f250c4b9954fe6a05ece3aa49e0b872f5d9c590a135b7b9c1776de50438b7a"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C094-small-reproducible-demonstration-notebook/task-evidence.md",
   "bytes": 3078,
   "sha256": "cd31f0829b8e6ecb5e879dff3ead4727818740f2c99f6738ffa9ea2733431dbd"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C094-small-reproducible-demonstration-notebook/verification/walkthrough.md",
   "bytes": 394,
   "sha256": "bfaecc47a48de1c455a908f0f42491064352e87090ad96239a269b0acd5e22f1"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C095-baseline-reproduction-instructions/decisions.md",
   "bytes": 1764,
   "sha256": "d48303b4168646503b9d8464c5f2ebd9017677a148920b2de6bd2f947a72e46d"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C095-baseline-reproduction-instructions/results.md",
   "bytes": 1783,
   "sha256": "5b5e471bde9f7daecb47c96c68285830054148b404b3c42b62310a64288d9644"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C095-baseline-reproduction-instructions/resume.md",
   "bytes": 477,
   "sha256": "a972e06fc4150e09dbb70863d915d4cf245f132263eec1f47b2001b1469bcd4c"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C095-baseline-reproduction-instructions/review-notes.md",
   "bytes": 1262,
   "sha256": "83a7941cdb17a8c6056ecba2305e4dec9d068b6b041161a44ae7042f36e28f5f"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C095-baseline-reproduction-instructions/source-register.md",
   "bytes": 1187,
   "sha256": "6148fed188ab5eb752b6df91589f2b564e2fdb0c139c65738e56409840843412"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C095-baseline-reproduction-instructions/task-evidence.md",
   "bytes": 2984,
   "sha256": "16b350cb3f289f5a45bf5460ed161839ed00682bdbdf24011cc1f6a1bcb5150f"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C095-baseline-reproduction-instructions/verification/walkthrough.md",
   "bytes": 390,
   "sha256": "240de726949bdf2a857e36ce0e9a810d7401f63c1f27cd26535cc8e80482413d"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C095-baseline-reproduction-instructions/worked-examples/case-8M.md",
   "bytes": 1807,
   "sha256": "f181736ed02b04b21b950f3ad4be7a66df8f819c919a66291d65f9e0edf3ec68"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C096-failure-case-explanation-cards/decisions.md",
   "bytes": 1485,
   "sha256": "615081587b1afc72a7fde91c8091154b7fe61550cc0248651c52febff064db69"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C096-failure-case-explanation-cards/guide.md",
   "bytes": 6311,
   "sha256": "2ff650d3b726ad6e42d13c6df515f13fb6518a6bc0add4db43f2f1938fc8cf83"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C096-failure-case-explanation-cards/results.md",
   "bytes": 1373,
   "sha256": "1ecfa99d3d7375ca0280d40e87eaa900ecd5cc5bdac44800fe84a5381d300936"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C096-failure-case-explanation-cards/review-notes.md",
   "bytes": 1291,
   "sha256": "fdc50c8fe3810f7434d3b509af9046d101d8d38b033d5e02d6a05849e6213a2e"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C096-failure-case-explanation-cards/source-register.md",
   "bytes": 964,
   "sha256": "7cf70549ddc3c197acddf468d39251ac3ccdf96e34637371c7e57747d5bb0bef"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C096-failure-case-explanation-cards/task-evidence.md",
   "bytes": 2609,
   "sha256": "390c7f53f22d40bfa49b1473ef68a74ff7da9dec75a79a5c5f30519f7010de8b"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C096-failure-case-explanation-cards/verification/walkthrough.md",
   "bytes": 293,
   "sha256": "f279da828fbd297caae67c43dc21d47eb3535912bcd51be58396b275adb52b15"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C096-failure-case-explanation-cards/worked-examples/checks-on-paper.md",
   "bytes": 1529,
   "sha256": "55a2996cc600562c07d27e4c6fa601818e0e8ffd45a6011076cd75e9252d7f35"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C097-assumption-to-experiment-traceability-map/change-impact.md",
   "bytes": 3560,
   "sha256": "8a4be1f6a59fa685907c7baa150571f788bb56f5e8beaf41f8f54f3362258332"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C097-assumption-to-experiment-traceability-map/coverage-gaps.md",
   "bytes": 5457,
   "sha256": "626c9550f30423a0277ab3a073808d60da3d2a53297a1feda15304caea1a2eef"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C097-assumption-to-experiment-traceability-map/decisions.md",
   "bytes": 1769,
   "sha256": "b6acab2875ccab39df834ebb1ca4029cf40f99132171cd13696c58bf70b905d1"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C097-assumption-to-experiment-traceability-map/results.md",
   "bytes": 1972,
   "sha256": "8fd00becb8247f1b6ace64cbab82ebb0aaddac16e8ee7fd1a65b2f6e79ef4b53"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C097-assumption-to-experiment-traceability-map/resume.md",
   "bytes": 419,
   "sha256": "b3e58027d7378e0bb7625a6b3903b4965a55fd5fe81bbec5b69c01bb716b4c30"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C097-assumption-to-experiment-traceability-map/task-evidence.md",
   "bytes": 3064,
   "sha256": "10b8af25a39b1cbe5ddf07a0428cea51df63dcaedb3fd64bbf1f7e303d3d34e1"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C097-assumption-to-experiment-traceability-map/verification/walkthrough.md",
   "bytes": 426,
   "sha256": "bad990c0172665ebdde0bf808a1d5a3646d234f486d3cf036be670c1b983d79a"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C098-results-interpretation-worksheet/guide.md",
   "bytes": 4124,
   "sha256": "993dcfb6f68d02ba3c971e8ff611a6435f818c24d692a05abca3e951356a14fa"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C098-results-interpretation-worksheet/results.md",
   "bytes": 1508,
   "sha256": "1bd1d2d03f3deb79c7a3c346d54c3bda953cf346bda16879aae7573339664c36"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C098-results-interpretation-worksheet/resume.md",
   "bytes": 324,
   "sha256": "0dcd1b21159890192a8d2b0de3b9be1db937e8c119a95edefdcd26be784388d6"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C098-results-interpretation-worksheet/review-notes.md",
   "bytes": 947,
   "sha256": "7f30ed17d26333d1909b246a136e326db579dc69a733cbb39079837d89a51b1b"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C098-results-interpretation-worksheet/source-register.md",
   "bytes": 976,
   "sha256": "00be202c45746031250517c9a2a06ad46e44949fe7f0390cf65639315a4223b0"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C098-results-interpretation-worksheet/task-evidence.md",
   "bytes": 2798,
   "sha256": "622f32a24753fe1bac6e49b1a0277bad51352bf3769de66e4e4b16e2a23ebdf0"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C098-results-interpretation-worksheet/verification/walkthrough.md",
   "bytes": 303,
   "sha256": "7d15237619fc5b2fc9562ff9890bce3d6511112a2656b7c8c19990c62b1212c2"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C098-results-interpretation-worksheet/worked-examples/worked-steps.md",
   "bytes": 1999,
   "sha256": "32a1a14d48f65b45d2ff2e2d0fa91313c5e27ebdfb582684b6455ec0251cab29"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C099-unresolved-limitations-register/decisions.md",
   "bytes": 3898,
   "sha256": "3c0ec65f8c821fb0a61c0276b456b11193d4a49fb2298fab0c62382f162350b7"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C099-unresolved-limitations-register/lifecycle-checks.md",
   "bytes": 13555,
   "sha256": "fdb753d9dcc4a5997f233f1ea2d83c6077c9acc2843a42b397134713ffca2d20"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C099-unresolved-limitations-register/results.md",
   "bytes": 2711,
   "sha256": "678c0d6ba7531303646bdb2fdb74f04c66d055d336d4948f64305d6e54430015"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C099-unresolved-limitations-register/resume.md",
   "bytes": 914,
   "sha256": "ed1df6dbf7359181d0a479e1e2e62264a1f2ae6227ed7d9e6acbca04988766d5"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C099-unresolved-limitations-register/source-register.md",
   "bytes": 1631,
   "sha256": "b1e2ba892f367a343656056080b8ee84a1eeace35abd4941d272c754cc3cc5a6"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C099-unresolved-limitations-register/task-evidence.md",
   "bytes": 4080,
   "sha256": "9343f1aa404d7ef51041b17193c26ca0892c1d9e6bc84a31b6a7c8a78a51a61b"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C099-unresolved-limitations-register/verification/walkthrough.md",
   "bytes": 1604,
   "sha256": "7092deae28345c5db45d795576150745ca19acb1b8fd3e47fff95825e97d9a3e"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C100-next-iteration-implementation-and-study-plan/decisions.md",
   "bytes": 2020,
   "sha256": "ea6a3d0f52b6c77e851f9b29ac08f17110dfa551bc568013c5260a8a8e43445d"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C100-next-iteration-implementation-and-study-plan/milestone-evidence.md",
   "bytes": 1488,
   "sha256": "38c3401b6fc52aa92404dc629fd6829901f7272b0c97a56d70fde5b6e8c347a5"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C100-next-iteration-implementation-and-study-plan/resume.md",
   "bytes": 530,
   "sha256": "c2684bd7d438e0460f9021a0de0c4f166227c68889db11cab1d1c9dccc72ec02"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C100-next-iteration-implementation-and-study-plan/source-register.md",
   "bytes": 1587,
   "sha256": "cc667b74c242149c15691ff4a58f60ebe3e78648dad593b271c3ba04e608acb4"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C100-next-iteration-implementation-and-study-plan/task-evidence.md",
   "bytes": 3268,
   "sha256": "09d9a98094be1cf1a9616be84c2aade1ce0eb274759a677ff14c5531c3270545"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C100-next-iteration-implementation-and-study-plan/unresolved-work.md",
   "bytes": 1278,
   "sha256": "d748c2c51425e4081f5525961d445872acfd2a3d329ca02039f3f1e9d5673d7d"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C100-next-iteration-implementation-and-study-plan/verification/walkthrough.md",
   "bytes": 1272,
   "sha256": "0fd9e62f89e44d8ab015d02eb6e5f83b99a6ca64ffc137b92cec3fc5eb3d497d"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C100-next-iteration-implementation-and-study-plan/work-plan.md",
   "bytes": 13636,
   "sha256": "74ca9e86bb29a65635821ef11796fc5cf4170572a8c0395ec59960b9117fbb69"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/README.md",
   "bytes": 9433,
   "sha256": "81a6058600d7ccb76ddba77a90bddcf7252ec5974bad0aae6e0167997ef10293"
  },
  {
   "kind": "pair-file",
   "name": "0b5c6c41-SHEP-00012-C096_-_Failure_case_explanation_cards.md",
   "bytes": 95427,
   "sha256": "1bffc19b205450e2a9f8a7be6a5df604e3fa1b01d9fde987c95947b4461a35db"
  },
  {
   "kind": "pair-file",
   "name": "0e00f59d-SHEP-00012-C099_-_Unresolved_limitations_register.md",
   "bytes": 91267,
   "sha256": "fe0eaecf13eb889a00c600070cfdd6df82b3bc989e044a61b78b73944d6bd565"
  },
  {
   "kind": "pair-file",
   "name": "13c80a6a-SHEP-00012-C075_-_Weight_drift_analysis.md",
   "bytes": 95273,
   "sha256": "af1d491949108c6d56970b0a290ba8d3c6872b5b9af758155f0a64f62b808ea1"
  },
  {
   "kind": "pair-file",
   "name": "2899530a-SHEP-00012-C089_-_Automated_validation_command.md",
   "bytes": 95656,
   "sha256": "adfdf38e1c970f9831e568febefa82e5deae1582412d32b78078624eb10b9c78"
  },
  {
   "kind": "pair-file",
   "name": "2985d8e1-SHEP-00012-C085_-_Deterministic_example_runner.md",
   "bytes": 94375,
   "sha256": "922a1b351e98e237521ecf4958064794fe29121d3834424ff36a4a63b60ad970"
  },
  {
   "kind": "pair-file",
   "name": "2ea61dde-SHEP-00012-C083_-_Machine-readable_configuration_file.md",
   "bytes": 96312,
   "sha256": "884cf22c3e08c712bda7af77dd46c0cd4c369b168fe57c16fa7734951fb7d127"
  },
  {
   "kind": "pair-file",
   "name": "3015f707-SHEP-00012-C091_-_Concept_glossary_with_worked_examples.md",
   "bytes": 93212,
   "sha256": "151f01ebc45489949cd582ce2752ca1eb8cef61e4ed900d53b731f6dbdea1684"
  },
  {
   "kind": "pair-file",
   "name": "3360d22e-SHEP-00012-C092_-_Annotated_original-source_reading_guide.md",
   "bytes": 94732,
   "sha256": "cea8e104df6a15bfca8488eccf34afddf93e4f211df5fa8ed92f869f627cba63"
  },
  {
   "kind": "pair-file",
   "name": "358ce329-SHEP-00012-C082_-_Dependency_installation_recipe.md",
   "bytes": 93252,
   "sha256": "52dfdbb882fa3a82ccb134e56917d2db75b55501b9aa3504642b1438dfd460ab"
  },
  {
   "kind": "pair-file",
   "name": "523ca009-SHEP-00012-C088_-_Artifact_naming_convention.md",
   "bytes": 92883,
   "sha256": "ef7b1f2b6c9ab81a4cc3edd26e884da3744e1a814c1b3f291f434c4fe91a484f"
  },
  {
   "kind": "pair-file",
   "name": "5881794a-SHEP-00012-C071_-_Sample_order_sensitivity_test.md",
   "bytes": 100651,
   "sha256": "674c3a870b23114a36ad142b256aa2e2fa4b5718ce60d85943ab5c493cbdb639"
  },
  {
   "kind": "pair-file",
   "name": "5ff16e44-SHEP-00012-C080_-_Training_reproducibility_checklist.md",
   "bytes": 103509,
   "sha256": "21ac14e9634a540d841656e3adae9f5ebdd741414b73dbae1f6513d12348b5fc"
  },
  {
   "kind": "pair-file",
   "name": "68eb447c-SHEP-00012-C093_-_Implementation-versus-theory_comparison_notes.md",
   "bytes": 96398,
   "sha256": "a54450367b3f1d2de5f126472bb0f5af0966853c796015f79e5441317a006dd2"
  },
  {
   "kind": "pair-file",
   "name": "6e4f4a30-SHEP-00012-C077_-_Generalization_gap_analysis.md",
   "bytes": 93868,
   "sha256": "e0b692417b4a1b89af8cddbe0f0e9ffd562e299f5dffa8144bc3a3905700cdba"
  },
  {
   "kind": "pair-file",
   "name": "6f331570-SHEP-00012-C078_-_Data-efficiency_curve.md",
   "bytes": 96830,
   "sha256": "d1f9210d39391561b353aa2f5c89c61e3fa38baf8293514759f6519dba8eb589"
  },
  {
   "kind": "pair-file",
   "name": "798a2685-SHEP-00012-C094_-_Small_reproducible_demonstration_notebook.md",
   "bytes": 93424,
   "sha256": "53cd1b68bba402798ef637d71e88e2d0407333e6256e4cad8561d71d9d1ebe7d"
  },
  {
   "kind": "pair-file",
   "name": "83728b8a-SHEP-00012-C081_-_Prototype_directory_layout.md",
   "bytes": 92537,
   "sha256": "aadaa37f680bed5c6e7053c2b79e16241ca950f3bf5ab210cc62cbb5bf2be41f"
  },
  {
   "kind": "pair-file",
   "name": "89e9b073-SHEP-00012-C090_-_Portable_result_export.md",
   "bytes": 94720,
   "sha256": "2b4a6b5c3d2d11a77c205cb183b7f37a51036fb01263c7e52a854feb27114231"
  },
  {
   "kind": "pair-file",
   "name": "8c3c706e-SHEP-00012-C084_-_Input_output_integration_adapter.md",
   "bytes": 92899,
   "sha256": "3a106dba9bd1005ddb1e4a0a5aa5a3c210d3c4cad52af6380d795bc70076b7b7"
  },
  {
   "kind": "pair-file",
   "name": "95646305-SHEP-00012-C072_-_Learning-rate_range_study.md",
   "bytes": 99595,
   "sha256": "50b34c31c6aacb66f652b61df7cb45dbaab293a2575d3d12573e6b4e582c8c52"
  },
  {
   "kind": "pair-file",
   "name": "9697dabe-SHEP-00012-C095_-_Baseline_reproduction_instructions.md",
   "bytes": 97804,
   "sha256": "db6fb2faaf3c2247a4720f02bf56481eb2e64b7062271b1acd6fb3d021177363"
  },
  {
   "kind": "pair-file",
   "name": "96c7620b-SHEP-00012-C098_-_Results_interpretation_worksheet.md",
   "bytes": 96537,
   "sha256": "4949222484bbe5b7c927b628636f12ed3caf0c40d8e011b341847259aab0a552"
  },
  {
   "kind": "pair-file",
   "name": "af0173aa-SHEP-00012-C086_-_Structured_diagnostic_logs.md",
   "bytes": 96397,
   "sha256": "50bea9a68aca17056da68e750a61b1d5a2923253b00cedfb14b09034a255bfbf"
  },
  {
   "kind": "pair-file",
   "name": "b4bbb951-SHEP-00012-C074_-_Training_duration_sweep.md",
   "bytes": 100705,
   "sha256": "e3daa3051c609c86d731617735e5cf2942492053b04c3874e973c8fa040bf634"
  },
  {
   "kind": "pair-file",
   "name": "b99e4a1e-SHEP-00012-C079_-_Compute-efficiency_curve.md",
   "bytes": 95425,
   "sha256": "7c91a0c77a2ddc4ad5d635dab2760ef4f75f9db6cfa403f479a783418212d333"
  },
  {
   "kind": "pair-file",
   "name": "c361b4e6-SHEP-00012-C097_-_Assumption-to-experiment_traceability_map.md",
   "bytes": 95341,
   "sha256": "8e9ed0e551d9997660c04899cca1b0cfb2875b0cb48c7351c12661782122d42e"
  },
  {
   "kind": "pair-file",
   "name": "c97fa5e2-SHEP-00012-C100_-_Next-iteration_implementation_and_study_plan.md",
   "bytes": 97016,
   "sha256": "0a61623da8181d7c4ed42c0bba82f78f8dc1ffe2e2faf902984cc42337bd76c8"
  },
  {
   "kind": "pair-file",
   "name": "8cabe2e3-INDEX.md",
   "bytes": 16109,
   "sha256": "8de0433a80efd90abb4037b0f652ed50973c7e5ab60e3ebe03773390face559a"
  },
  {
   "kind": "language",
   "name": "JA21-DeepML-Core-Language-Suite-1.0.0-main/README.md",
   "bytes": 2358,
   "sha256": "c29d0c604d202fbe7ca559149c01da1fc5d701c5a6a9f3b285f088859cfce90c"
  },
  {
   "kind": "language",
   "name": "JA21-DeepML-Kernel-Language-Suite-1.0.0-main/README.md",
   "bytes": 2395,
   "sha256": "4e4cbaeb3f20419a6ccf69c681a873c92651a848ecad21e13d316c05b8eeaa7c"
  },
  {
   "kind": "language",
   "name": "JA21-DeepML-Kernel-Language-Suite-1.0.0-main/payload/JA21-DeepML-Kernel-Language-Suite-1.0.0-main/JA21_DMK_Suite_1.0.0.expanded/JA21_DMK_Suite_1.0.0/README.md",
   "bytes": 4070,
   "sha256": "03341fb0556c881bf0cbaa67c6250d6c865b3dee2d4d6342cbc170f58e0d5323"
  },
  {
   "kind": "language",
   "name": "JA21-DeepML-Kernel-Language-Suite-1.0.0-main/payload/JA21-DeepML-Kernel-Language-Suite-1.0.0-main/JA21_DMK_Suite_1.0.0.expanded/JA21_DMK_Suite_1.0.0/specifications/DEEPML_KERNEL_LANGUAGE.ebnf",
   "bytes": 2668,
   "sha256": "8e8d06bcfaf0db1deca9b9f751e82d70fe33e8c98162aebfd3d5d2cd0bf802b5"
  },
  {
   "kind": "language",
   "name": "JA21-DeepML-Kernel-Language-Suite-1.0.0-main/payload/JA21-DeepML-Kernel-Language-Suite-1.0.0-main/JA21_DMK_Suite_1.0.0.expanded/JA21_DMK_Suite_1.0.0/specifications/LANGUAGE_SPECIFICATION.md",
   "bytes": 2621,
   "sha256": "81e12bdb7beae60220a988cd1a711331ac3eb9763229447236eb1d3f9505707d"
  },
  {
   "kind": "language",
   "name": "JA21-DeepML-Kernel-Language-Suite-1.0.0-main/payload/JA21-DeepML-Kernel-Language-Suite-1.0.0-main/JA21_DMK_Suite_1.0.0.expanded/JA21_DMK_Suite_1.0.0/starter/hello_kernel.dmk",
   "bytes": 413,
   "sha256": "9a24410edae0e02d521436878e169d87feb0efa9b8d20c679c06740db6505a16"
  },
  {
   "kind": "language",
   "name": "LCUF-Research-Corpus-Type-A-main/FULL_DESCRIPTION.md",
   "bytes": 10747,
   "sha256": "887d509d3effaeeb24160059e5d7ba396823d13c8ddc68e8988e58dd9f61e0e3"
  },
  {
   "kind": "language",
   "name": "LCUF-Research-Corpus-Type-A-main/README.md",
   "bytes": 14625,
   "sha256": "9137f8c2f16f6e6c3648c32d30cd5cf3d442d182c3eb88bc51a7d6fe0a355148"
  },
  {
   "kind": "language",
   "name": "LCUF-Research-Corpus-Type-A-main/REPOSITORY_GUIDE.md",
   "bytes": 3154,
   "sha256": "2d474b5912fe93d28fffc5849fab45f8573fa2a4d049ab27a3f8e14b7742ba32"
  },
  {
   "kind": "language",
   "name": "MSSL_WRITERS_CORPUS_1.0.0-main/payload/MSSL_WRITERS_CORPUS_1.0.0/README_START_HERE.md",
   "bytes": 1161,
   "sha256": "24edd77b5eb52159eb2d157081598320097dd837c88b24db9886ec99cd9000b9"
  },
  {
   "kind": "language",
   "name": "MSSL_WRITERS_CORPUS_1.0.0-main/payload/MSSL_WRITERS_CORPUS_1.0.0/VERIFY_CORPUS.cmd",
   "bytes": 189,
   "sha256": "f23bcb8bd33c8caf2270879d167025871e355f3d337cb1413cc0527b645c7b7e"
  },
  {
   "kind": "language",
   "name": "Photon-main/Photon-main/Notice and README",
   "bytes": 16805,
   "sha256": "7bd46833bc341140a639f11e4fa87279d8f5c73747b16d98191d95feacb43b4d"
  },
  {
   "kind": "language",
   "name": "RUSSL-Zarr-main/README.md",
   "bytes": 5147,
   "sha256": "d55cd36ef09ae5b733a9e9f560453e328125c3007eaf88f13f61192ad5904d72"
  },
  {
   "kind": "language",
   "name": "RUSSL-Zarr-main/corpus/README_START_HERE.md",
   "bytes": 4356,
   "sha256": "cefe2dee76247a18b896b0e11341e9117bc12dc474a6b91bbd766c3b9df96e71"
  },
  {
   "kind": "language",
   "name": "LCUF_RESEARCH_CORPUS_0.2.0/design/01_LANGUAGE_EXTENSION_AND_ADMISSION.md",
   "bytes": 15424,
   "sha256": "fd8eeaf9ac81afd34cfb49633de776b77252cee78c28491931cbd5c86ce5aaa2"
  },
  {
   "kind": "language",
   "name": "LCUF_RESEARCH_CORPUS_0.2.0/examples/accept_capped_valuation.lcufx",
   "bytes": 383,
   "sha256": "4a5d2fe037dc5e8e0d48a401b1526644b49de642fc10dfeeba06c61e170793b9"
  },
  {
   "kind": "language",
   "name": "LCUF_RESEARCH_CORPUS_0.2.0/examples/accept_coset_global.lcufx",
   "bytes": 503,
   "sha256": "3dece87ff56323dce1b9415459e92c1f1bb64d128b12aa764f629a2ae24cd8fe"
  },
  {
   "kind": "language",
   "name": "LCUF_RESEARCH_CORPUS_0.2.0/examples/accept_coset_identity.lcufx",
   "bytes": 505,
   "sha256": "fc4bccfabec8d6122729e2cfbafbae5de9631761556d0d6fa43e249967f9a81c"
  },
  {
   "kind": "language",
   "name": "LCUF_RESEARCH_CORPUS_0.2.0/examples/accept_coset_prefix.lcufx",
   "bytes": 503,
   "sha256": "938f11a990ae379c7f9ce1c25dea5c957f935662a01d13d3e06ea1b5886c74b7"
  },
  {
   "kind": "language",
   "name": "LCUF_RESEARCH_CORPUS_0.2.0/examples/accept_cyclic_permutation.lcufx",
   "bytes": 479,
   "sha256": "29b1b08ecdf882c33d3e1edf3dd7f61510a26fbde57c85fc05ec91b9cfa0f34f"
  },
  {
   "kind": "language",
   "name": "LCUF_RESEARCH_CORPUS_0.2.0/examples/accept_exact_raster_translation.lcufx",
   "bytes": 493,
   "sha256": "8ab040c91c92f66f89f42e9957edc611d21d07427c10ca6ea70561228cdb07ce"
  },
  {
   "kind": "language",
   "name": "LCUF_RESEARCH_CORPUS_0.2.0/examples/accept_explicit_signed_conversion.lcufx",
   "bytes": 399,
   "sha256": "0fbf210ae0c0d0100c3590787050e9ad8d9555c3749fd534cb3ef235788b25cb"
  },
  {
   "kind": "language",
   "name": "LCUF_RESEARCH_CORPUS_0.2.0/examples/accept_hrr_basis_bind.lcufx",
   "bytes": 501,
   "sha256": "7c91e2d75930911691e4d7efafb5222b0d41b7aa8b2422073f1d07b6e252c962"
  },
  {
   "kind": "language",
   "name": "LCUF_RESEARCH_CORPUS_0.2.0/examples/accept_hrr_basis_correlation.lcufx",
   "bytes": 513,
   "sha256": "6f3b3dbbd4684ced9f020a7a255dd9b4a1c6174a06099a88f57afa107b272d5d"
  },
  {
   "kind": "language",
   "name": "LCUF_RESEARCH_CORPUS_0.2.0/examples/accept_hrr_noninverse.lcufx",
   "bytes": 596,
   "sha256": "3c53ec10437f4dbd6c2596e39e0e50a476ef5fbb68e5dd29d7d5a35b99878a0c"
  },
  {
   "kind": "language",
   "name": "LCUF_RESEARCH_CORPUS_0.2.0/examples/accept_local_residual.lcufx",
   "bytes": 685,
   "sha256": "8f89bbcbfb17062f88fc7428df66ee6953bcded8899cb59beec94960ae1ae02f"
  },
  {
   "kind": "language",
   "name": "LCUF_RESEARCH_CORPUS_0.2.0/examples/accept_periodic_convex_diffusion.lcufx",
   "bytes": 511,
   "sha256": "9d7d9405961857dc286a6b4b3fddad10185143e424f544657a1a7fc4b7a2fcbb"
  },
  {
   "kind": "language",
   "name": "LCUF_RESEARCH_CORPUS_0.2.0/examples/accept_precision_reduction.lcufx",
   "bytes": 394,
   "sha256": "ab181d8293ff41d7c50ed3f9616b2b5650df58ef9a65f029de97797034f7ce77"
  },
  {
   "kind": "language",
   "name": "LCUF_RESEARCH_CORPUS_0.2.0/examples/accept_remote_wire.lcufx",
   "bytes": 1040,
   "sha256": "40f653763bd22dfe2b93ee3e4db5e6770fe31bf87618e0029baa8378b1b6e9aa"
  },
  {
   "kind": "language",
   "name": "LCUF_RESEARCH_CORPUS_0.2.0/examples/accept_residue_add.lcufx",
   "bytes": 461,
   "sha256": "4505955e52b0399f5aa39c50240e95b57465448230ec926ed39d69dd1d8e524d"
  },
  {
   "kind": "language",
   "name": "LCUF_RESEARCH_CORPUS_0.2.0/examples/accept_residue_mul.lcufx",
   "bytes": 461,
   "sha256": "1dd7c6756519f579db68fd356da63383d41bcc8675a3529ee2772502d98ba7a9"
  },
  {
   "kind": "language",
   "name": "LCUF_RESEARCH_CORPUS_0.2.0/examples/accept_sign_packet_decode.lcufx",
   "bytes": 789,
   "sha256": "cc279236477f869961892a4c06b7e5625b01a2a3c457ee893f1835074c75f792"
  },
  {
   "kind": "language",
   "name": "LCUF_RESEARCH_CORPUS_0.2.0/examples/metamorphic_bom.lcufx",
   "bytes": 501,
   "sha256": "7c91e2d75930911691e4d7efafb5222b0d41b7aa8b2422073f1d07b6e252c962"
  },
  {
   "kind": "language",
   "name": "LCUF_RESEARCH_CORPUS_0.2.0/examples/metamorphic_cell_spacing.lcufx",
   "bytes": 501,
   "sha256": "7c91e2d75930911691e4d7efafb5222b0d41b7aa8b2422073f1d07b6e252c962"
  },
  {
   "kind": "language",
   "name": "LCUF_RESEARCH_CORPUS_0.2.0/examples/metamorphic_comments.lcufx",
   "bytes": 501,
   "sha256": "7c91e2d75930911691e4d7efafb5222b0d41b7aa8b2422073f1d07b6e252c962"
  },
  {
   "kind": "language",
   "name": "LCUF_RESEARCH_CORPUS_0.2.0/examples/metamorphic_crlf.lcufx",
   "bytes": 501,
   "sha256": "7c91e2d75930911691e4d7efafb5222b0d41b7aa8b2422073f1d07b6e252c962"
  },
  {
   "kind": "language",
   "name": "LCUF_RESEARCH_CORPUS_0.2.0/examples/metamorphic_row_order.lcufx",
   "bytes": 501,
   "sha256": "7c91e2d75930911691e4d7efafb5222b0d41b7aa8b2422073f1d07b6e252c962"
  },
  {
   "kind": "language",
   "name": "LCUF_RESEARCH_CORPUS_0.2.0/examples/metamorphic_typed_float_literal_normalization.lcufx",
   "bytes": 501,
   "sha256": "7c91e2d75930911691e4d7efafb5222b0d41b7aa8b2422073f1d07b6e252c962"
  },
  {
   "kind": "language",
   "name": "LCUF_RESEARCH_CORPUS_0.2.0/examples/reject_boolean_float.lcufx",
   "bytes": 296,
   "sha256": "9c550dd7cbc7c220cc7793aa34fb1ca3a4c7de651940d5a5655ccf5e897cbb8b"
  },
  {
   "kind": "language",
   "name": "LCUF_RESEARCH_CORPUS_0.2.0/examples/reject_boolean_residue.lcufx",
   "bytes": 302,
   "sha256": "51e5cdb153c8f2d3933c6adb99bcc8180e8956c518a981ff575a077ac52775ee"
  },
  {
   "kind": "language",
   "name": "LCUF_RESEARCH_CORPUS_0.2.0/examples/reject_bundle_transfer.lcufx",
   "bytes": 787,
   "sha256": "e219a36492cad335c02cede998210bc02f963baa9fdb0bf56875ff8c30f69f46"
  },
  {
   "kind": "language",
   "name": "LCUF_RESEARCH_CORPUS_0.2.0/examples/reject_composite_radix.lcufx",
   "bytes": 299,
   "sha256": "25bff73c28a4ff07a63baa7978fa5956e162a3ce4bfb463afaf5061ae2720daa"
  },
  {
   "kind": "language",
   "name": "LCUF_RESEARCH_CORPUS_0.2.0/examples/reject_dependency_cycle.lcufx",
   "bytes": 364,
   "sha256": "422401c2bd3e7905a047d3edb3b7ff2c701b812cf51c799ba908efeda1d33cc7"
  },
  {
   "kind": "language",
   "name": "LCUF_RESEARCH_CORPUS_0.2.0/examples/reject_diffusion_unstable_step.lcufx",
   "bytes": 503,
   "sha256": "deaf1b435ac03f76c7a214a70cc1c1bc6268f95eae75d6526243a88b528b444d"
  },
  {
   "kind": "language",
   "name": "LCUF_RESEARCH_CORPUS_0.2.0/examples/reject_duplicate_writer.lcufx",
   "bytes": 368,
   "sha256": "1ed398cebf26ad1d6285fc35b4316abc1e10ae884b648177485d4ecfca064314"
  },
  {
   "kind": "language",
   "name": "LCUF_RESEARCH_CORPUS_0.2.0/examples/reject_erased_state_effect.lcufx",
   "bytes": 518,
   "sha256": "b05f2cec2c140a5aea23b033f4db24438b4f2a4d169d7edc2420344a707c33e1"
  },
  {
   "kind": "language",
   "name": "LCUF_RESEARCH_CORPUS_0.2.0/examples/reject_excess_precision.lcufx",
   "bytes": 301,
   "sha256": "046a503f9afcbddebd3f929fcfd6ccf761d2329ae5da6dbd2cd67dd0af8e20e7"
  },
  {
   "kind": "language",
   "name": "LCUF_RESEARCH_CORPUS_0.2.0/examples/reject_float_overflow_literal.lcufx",
   "bytes": 306,
   "sha256": "5adbb5e1781cbf9f378b3bc5fe13998940c09139069de5068f9e4394a945b920"
  },
  {
   "kind": "language",
   "name": "LCUF_RESEARCH_CORPUS_0.2.0/examples/reject_hrr_shape_mismatch.lcufx",
   "bytes": 486,
   "sha256": "536c10b83a7a6f16657e48d09ae7ae26b851015f06b3082c36c9c0d029fe35b1"
  },
  {
   "kind": "language",
   "name": "LCUF_RESEARCH_CORPUS_0.2.0/examples/reject_implicit_refinement.lcufx",
   "bytes": 393,
   "sha256": "476f3e137dab54b0037695fb04bad8f3ab003523e9eaaedb1d81a18fde15eb87"
  },
  {
   "kind": "language",
   "name": "LCUF_RESEARCH_CORPUS_0.2.0/examples/reject_invalid_utf8.lcufx",
   "bytes": 297,
   "sha256": "7dddaa036248d0dfc246b06a56dc97d51db268616b618e3d1f3d8d6c13024ed0"
  },
  {
   "kind": "language",
   "name": "LCUF_RESEARCH_CORPUS_0.2.0/examples/reject_large_raster_sample.lcufx",
   "bytes": 325,
   "sha256": "3d61ec1910213eca3c799128c475e6d66df20f8e3bdec6d953364dfeb42ca948"
  },
  {
   "kind": "language",
   "name": "LCUF_RESEARCH_CORPUS_0.2.0/examples/reject_missing_directed_link.lcufx",
   "bytes": 518,
   "sha256": "02afb60d68e4cd74b7a12e2c7826c77a71d6bca25e249c91c3f1a2507fce0b41"
  },
  {
   "kind": "language",
   "name": "LCUF_RESEARCH_CORPUS_0.2.0/examples/reject_missing_receiver.lcufx",
   "bytes": 521,
   "sha256": "149ef6e79729356e8358223c84297d7113f3d94624a5a568ea5b7d1aececc98b"
  },
  {
   "kind": "language",
   "name": "LCUF_RESEARCH_CORPUS_0.2.0/examples/reject_missing_sender.lcufx",
   "bytes": 522,
   "sha256": "c8335d446acb008caad08e876a0ccb931db417fdb763c0a976d6ca467765e7d5"
  },
  {
   "kind": "language",
   "name": "LCUF_RESEARCH_CORPUS_0.2.0/examples/reject_missing_state_grant.lcufx",
   "bytes": 494,
   "sha256": "78b20252e323a6f29a9f519a3bd4055cc15e5ce5adc4b8bb306edc392a1cd040"
  },
  {
   "kind": "language",
   "name": "LCUF_RESEARCH_CORPUS_0.2.0/examples/reject_negative_raster_sample.lcufx",
   "bytes": 327,
   "sha256": "b2968e989e16c16f7e40ffaf41f32da7ae4fc64fc896746752e675e9b1173529"
  },
  {
   "kind": "language",
   "name": "LCUF_RESEARCH_CORPUS_0.2.0/examples/reject_nonzero_residual_literal.lcufx",
   "bytes": 323,
   "sha256": "a336c9480390bcdea69337d2d0b4ee7646882e0843c2467da03e6fdb2ca3c22d"
  },
  {
   "kind": "language",
   "name": "LCUF_RESEARCH_CORPUS_0.2.0/examples/reject_packet_literal.lcufx",
   "bytes": 305,
   "sha256": "a4c99d8a9beed62ec32bbcce0c466d323eeee76bd63aa419ae342d9d98a24114"
  },
  {
   "kind": "language",
   "name": "LCUF_RESEARCH_CORPUS_0.2.0/examples/reject_payload_scratch_underreserve.lcufx",
   "bytes": 408,
   "sha256": "0deffc98f2e51146fbb1b37d18deb9a5023df4917bbe57b9348be4f903089339"
  },
  {
   "kind": "language",
   "name": "LCUF_RESEARCH_CORPUS_0.2.0/examples/reject_radix_mismatch.lcufx",
   "bytes": 459,
   "sha256": "c1d58353962843d8eb2271a3dd36f1fd458e0d72593caa50f2fa72720f20f55f"
  },
  {
   "kind": "language",
   "name": "LCUF_RESEARCH_CORPUS_0.2.0/examples/reject_raster_shape.lcufx",
   "bytes": 307,
   "sha256": "fadf65f2ad599fc354acf982f7d64cc189f6405333af064597df405889fc0fd8"
  },
  {
   "kind": "language",
   "name": "LCUF_RESEARCH_CORPUS_0.2.0/examples/reject_residual_transfer.lcufx",
   "bytes": 650,
   "sha256": "5f38a29bbdf66afc19f508e9818d7293ab70d8008d22af6d1df5b2b94421b075"
  },
  {
   "kind": "language",
   "name": "LCUF_RESEARCH_CORPUS_0.2.0/examples/reject_unsupported_physical_op.lcufx",
   "bytes": 315,
   "sha256": "72075384854f711df86048ce55b8a4b257f48ce39796d889f67b8f07163b45a9"
  },
  {
   "kind": "language",
   "name": "LCUF_RESEARCH_CORPUS_0.2.0/examples/reject_vector_empty.lcufx",
   "bytes": 300,
   "sha256": "fb4fb24df5fa95bf2f750369b6aba10fde9e9be998b0caea545e129d80f2d6e8"
  },
  {
   "kind": "language",
   "name": "LCUF_RESEARCH_CORPUS_0.2.0/examples/reject_vector_limit.lcufx",
   "bytes": 1071,
   "sha256": "48888ca1c2e389c206f4b1a735ddeae4f8779031dd30706c47e252877c00c25a"
  },
  {
   "kind": "language",
   "name": "LCUF_RESEARCH_CORPUS_0.2.0/examples/reject_vector_shape.lcufx",
   "bytes": 304,
   "sha256": "fbee416bd3418694b412f4eeb87c8f6014ec80e7e7075fa7ccd5107ddbc8eb7f"
  },
  {
   "kind": "language",
   "name": "LCUF_RESEARCH_CORPUS_0.2.0/examples/reject_wrong_language_header.lcufx",
   "bytes": 303,
   "sha256": "09246752622f5d681d6f24688203690578e8fb9b6a54c338d8fce7d60ea41703"
  },
  {
   "kind": "technical-note",
   "name": "Littlebit_Cmd_Weights_Five_Dollar_Llm_Technical_Note.pdf (text)",
   "bytes": 92115,
   "sha256": "c5f26f3cc855d25c3530e36dfd33517beb1945a3737ecfd64c106408e69a9256"
  }
 ],
 "heldout": [
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C001-definition-and-scope-specification/decisions.md",
   "bytes": 464,
   "sha256": "d8e3b411b4681fecc644e7dc96583c390ac7cf93c68ce233f16307737a8eac61"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C002-original-source-and-version-registry/evidence-locations.md",
   "bytes": 376,
   "sha256": "354f3bfbf9c7cbd524bd62ea85a035a642e3acc631aec73cc6f5f0840fee2f2e"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C003-implementation-or-study-objective/results.md",
   "bytes": 301,
   "sha256": "1b741582a314b0dddaf437a3760a2d4339a98059b4b2a4c04837d09cf9353a23"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C003-implementation-or-study-objective/success-measures.md",
   "bytes": 280,
   "sha256": "1e82c0eae9a2d20fabbad14e1c2aced066ecb1a6ca127a6f2bc33fc6ec9ffe40"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C004-prerequisites-and-dependency-map/resume.md",
   "bytes": 287,
   "sha256": "3604c48cc2053a442b0dc9bd5d62712d9fc751dc0aac752d86057421e4e57601"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C005-inputs-outputs-and-boundary-contract/results.md",
   "bytes": 301,
   "sha256": "8fcf106d3587158eb9d7affb0cb85d46bb62407d71028784e497dae141f69eb4"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C005-inputs-outputs-and-boundary-contract/resume.md",
   "bytes": 287,
   "sha256": "baa5c68c12146a0b223460e16c32b7802b6a69c7d4a297bcd13926e9dd511431"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C005-inputs-outputs-and-boundary-contract/task-evidence.md",
   "bytes": 1933,
   "sha256": "65fb27006a31c2b66178cd68e8be1b2fac6ad983f9aa3e1a1f022e1d91b80fe2"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C007-representative-use-case-collection/coverage-map.md",
   "bytes": 243,
   "sha256": "499d822499105890b557219a85259e2fde2ceb2690f578dc99703d9702b9beb5"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C007-representative-use-case-collection/results.md",
   "bytes": 301,
   "sha256": "d9590acfc0993e2beeb472f5ab52032d0b03cf608d6e756ca1bbbbb651d11c69"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C011-token-vocabulary/results.md",
   "bytes": 290,
   "sha256": "e51c2b624a6961e8da8e07850b79d33e153b74634b9256e0ba577fa824c0ecb2"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C013-position-representation/resume.md",
   "bytes": 263,
   "sha256": "02228c215837d243bfbc84a40642ac62ea87ced76d1866d2f0ffd3bc272cd0b3"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C014-sequence-masking-rules/resume.md",
   "bytes": 263,
   "sha256": "11d49137b72ef859471a317a8d44b38b177df4a94e94fdedb776444eae73fd93"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C017-attention-operator/model-spec.md",
   "bytes": 492,
   "sha256": "afff7b9d8d2ac0bd0cf4330b3fcae8720201a5e32e48bbb728354854c239cb37"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C017-attention-operator/resume.md",
   "bytes": 263,
   "sha256": "514a98c32945a8abae4a5360a36eed2b60679bd48fce96b3cc9f951c1d6fe880"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C018-feed-forward-operator/module/README.md",
   "bytes": 101,
   "sha256": "6fdc7ffd92a794f47166a66e9c035ae30c081b7bcebd4aff09b675de0954f70d"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C021-activation-function/decisions.md",
   "bytes": 440,
   "sha256": "d026403cd77c322ff1760638f3343254359726bdc5d564ca8219d65f724d1847"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C021-activation-function/model-spec.md",
   "bytes": 284,
   "sha256": "9246c66322d067b19c6d0c8ff9d74b4e45a6ce8a29d2026bb9ba954c11ae9677"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C022-parameter-initialization/results.md",
   "bytes": 217,
   "sha256": "ba7f743a70a84440eb0e8663b0c1aedbf72e3666f7e4a4337850c1413648f079"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C022-parameter-initialization/source-register.md",
   "bytes": 377,
   "sha256": "42f9581fb88f31b0eacf61b6d951441ac5f3d4242da00b2cdbd030103b99dd88"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C025-non-autoregressive-head-option/task-evidence.md",
   "bytes": 1925,
   "sha256": "6022aba3e913d4a5cbd642026deecde92bcf759d43c3da5e868a92cd016f6595"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C027-sparse-activation-option/source-register.md",
   "bytes": 370,
   "sha256": "9e8e03dfd50445b520de922f70a31d078019c009facea730c8710d8ee65cbf72"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C030-architecture-configuration-schema/results.md",
   "bytes": 222,
   "sha256": "040d9a00828675a224dacd18781f6d668a21d50a9627a094834d4649b046107c"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C034-sequence-batching-adapter/decisions.md",
   "bytes": 470,
   "sha256": "a73782fdabc32781be753667d3221646a08dc353141c5af0701c6dffad0f1102"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C035-padding-treatment/transform-spec.md",
   "bytes": 447,
   "sha256": "c0559d7571adfbff2ae259c39880b2642d3cfe044d566469a2dd065b09ab4cb1"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C036-long-sequence-partitioner/resume.md",
   "bytes": 276,
   "sha256": "c2fce1a72713fff0c5c063db76cdad6414c1cc102f4b55146be8154a41f53a5f"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C036-long-sequence-partitioner/source-register.md",
   "bytes": 382,
   "sha256": "3c7b4dd097052dbbdbe1734a4e40ac7989998e45b855373ee52a6bc6bd386525"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C038-parameter-sharing-policy/resume.md",
   "bytes": 276,
   "sha256": "4cf78f3057c2404aff6c8676368419b7c35ffcf0d3041fe09c7f99d990bc8c7b"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C043-activation-memory-estimate/decisions.md",
   "bytes": 617,
   "sha256": "7ebac17c7d06c564d9ab4f433714b845718a84985c0f7c0df2a29649c64d087c"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C044-receptive-field-analysis/interpretation.md",
   "bytes": 289,
   "sha256": "d433196f73efb4ec3e815b6618554fa56f6db1c7c7523c430fb38a48e8149dd6"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C045-context-utilization-probe/resume.md",
   "bytes": 312,
   "sha256": "2d53db4154894dc13ec6a6855f78209b1ce514071cfd913de0c7ac41a29ae88c"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C046-layer-activation-probes/resume.md",
   "bytes": 312,
   "sha256": "a51ea8d486d7d5d372267cc0b2811818c5453acf118efb799195537ff4df75db"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C046-layer-activation-probes/source-register.md",
   "bytes": 548,
   "sha256": "cc794408d72b468cf9e910134a7ffdd2e2c5e43431d45e85f79a38a07f1de8b8"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C047-gradient-flow-probes/decisions.md",
   "bytes": 643,
   "sha256": "1d71b7098d761b814c38e1a5df5860838b4b875ed8d63e1929f50469da367b99"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C052-attention-variant-comparison/source-register.md",
   "bytes": 3418,
   "sha256": "cc56398f89a262b987ab8ca5c4b168946d04440dedc7b40cb60714fc9948a13e"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C052-attention-variant-comparison/task-evidence.md",
   "bytes": 5013,
   "sha256": "5cb6842bd4ad1efa70dc27c756731ee00a27012dc42c6e78b956296118f0f133"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C053-depth-scaling-experiment/task-evidence.md",
   "bytes": 5013,
   "sha256": "d53bb553298836862a32bd9a38377cfc6cf581be887deb3cab190cc8b625a984"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C054-width-scaling-experiment/results.md",
   "bytes": 511,
   "sha256": "09bc4b9ffeff5c47830e2af22219d7bd33de2686196712ffd5d2c3fe1d410730"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C054-width-scaling-experiment/resume.md",
   "bytes": 649,
   "sha256": "bdf8f82c501769ad3e186855db9811f534a33b2c6a656e74904e7e723b372250"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C055-position-encoding-ablation/analysis-and-results/summary.md",
   "bytes": 2199,
   "sha256": "73d77bc3efa7d1643fe7c63c82cb9fa8d1fc08fd197a61cbb8b255e3534341e0"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C056-normalization-ablation/decisions.md",
   "bytes": 2309,
   "sha256": "fc52f129a3ffae849e63a24723f489324c9f6086e0143ca2a5d0b301fea40205"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C056-normalization-ablation/task-evidence.md",
   "bytes": 5013,
   "sha256": "ed77c06535a590e984fa91027b09d8419f63cbdfa9ad375067c6c07202295165"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C060-architecture-transfer-study/task-evidence.md",
   "bytes": 5013,
   "sha256": "28483c4541395c658c5dfd4a081dd44bee67973e75f42741abbe7717c5bc11f5"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C061-data-to-update-accounting/measurement-report.md",
   "bytes": 2638,
   "sha256": "c9300012bfb606c5115184ce8947d647cbb6a3043052eb90e9b00e5b7a91b2bd"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C062-effective-batch-calculation/measurement-report.md",
   "bytes": 1339,
   "sha256": "613d62382adaa15b7e00802da3ae7692be78161de4d9ada326cbea00e1f9750c"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C062-effective-batch-calculation/resume.md",
   "bytes": 185,
   "sha256": "6be7f50ffd94402a121f2f402f0f8fe6cce38f0162498f3a6db171040219d071"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C062-effective-batch-calculation/source-register.md",
   "bytes": 1147,
   "sha256": "1dfeb17573e7902f8479b6a60116f8bbd2d4d8052c47732e11ab914cfe302a9b"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C063-gradient-variance-estimate/decisions.md",
   "bytes": 492,
   "sha256": "18683e1ef0413228b8e23a16dfeec5dbee782ce79e6f6aac0b7cac47d22cd6ed"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C064-loss-scale-tracking/results.md",
   "bytes": 940,
   "sha256": "3d4ccf5f35cb2ac8702d5c2a8e567b90d74090e021dbe28292bc4c5cd64b2867"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C070-warm-start-study/decisions.md",
   "bytes": 937,
   "sha256": "bc215e3156ac448b910d39381abff973d9b27a8070c9f06e270efa4b12568237"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C081-prototype-directory-layout/source-register.md",
   "bytes": 5271,
   "sha256": "ed82c8e5137d2b7db900e12bf6ac79ecacb88146d67f7fba0e1c551697c4a3bf"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C082-dependency-installation-recipe/source-register.md",
   "bytes": 3901,
   "sha256": "69f33b2610801f7d4ae31ab83373155219ed66b7dd35f0bb1ec8a2507ebc1078"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C084-input-output-integration-adapter/task-evidence.md",
   "bytes": 5205,
   "sha256": "6952d7d89dd4a4b2448f5a4407283bde4f7255e9ffac8140a5f35baf1ea40875"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C089-automated-validation-command/results.md",
   "bytes": 1939,
   "sha256": "e7b949108e3704f5a270ee8e71cfeffed8f85ea9dd30f8ba72c2ca53265900af"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C090-portable-result-export/task-evidence.md",
   "bytes": 3501,
   "sha256": "66d8e2d62920f1f6fc5a8ef2c8704610e64304916ba06cb25457efe1389baeeb"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C091-concept-glossary-with-worked-examples/decisions.md",
   "bytes": 1786,
   "sha256": "96ee0bf9bc1c95534172a1432cab0760127f102c29c3b44f87c2448568ecc1b6"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C091-concept-glossary-with-worked-examples/task-evidence.md",
   "bytes": 3224,
   "sha256": "f366f9e96c6c20c1f9da124e3ee2a49b2c0cb65945c81f7a4bdc13baba6f9bdf"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C091-concept-glossary-with-worked-examples/verification/walkthrough.md",
   "bytes": 355,
   "sha256": "29a32d8070dfc9e28c41a541343b460782c0956f61f8d381f9594a96c5deb387"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C095-baseline-reproduction-instructions/guide.md",
   "bytes": 4633,
   "sha256": "26a7318f007b3d94c5b6eac9368516025f4d5b9d87ed4a8d3ea46ce686fd45b0"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C096-failure-case-explanation-cards/resume.md",
   "bytes": 464,
   "sha256": "7e0b567f2d5ad65f2f43c1aa19e42afb9ac33b34a109e89806b7b2a2c6b29757"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C097-assumption-to-experiment-traceability-map/source-register.md",
   "bytes": 1175,
   "sha256": "eb838d4110609d18808aba5c3bc03de0587930e1cf9729370d0234faf26bcf38"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C098-results-interpretation-worksheet/decisions.md",
   "bytes": 1403,
   "sha256": "8cadc495ed4b5237a05ec3686826dc26736bb1d9e6da51a68380cb84e4c002cd"
  },
  {
   "kind": "deliverable",
   "name": "deliverables/00012/C100-next-iteration-implementation-and-study-plan/results.md",
   "bytes": 1901,
   "sha256": "1921eb7b5c3f16ee4b671f0ff167715d233ac4d5955c6c5e122ab14a79d26915"
  },
  {
   "kind": "pair-file",
   "name": "880ab62b-SHEP-00012-C087_-_Resumable_execution_checkpoint.md",
   "bytes": 95778,
   "sha256": "7bba058b76b99e3d41c83286725a07d207be40829c348d3bc9b580ff7694cc69"
  },
  {
   "kind": "pair-file",
   "name": "8e8146e0-SHEP-00012-C073_-_Regularization_sensitivity_study.md",
   "bytes": 100085,
   "sha256": "8b22224615575ab5f4385d58f21c6715b79d4f05b94be9aedf0d4642bc279dd3"
  },
  {
   "kind": "pair-file",
   "name": "d1a5c757-SHEP-00012-C076_-_Capability_retention_benchmark.md",
   "bytes": 98427,
   "sha256": "b99c39d2b59bcb4b45f000b489200dfe3aedf7240bf6bd9bd1c0e197bbf8acb0"
  },
  {
   "kind": "language",
   "name": "LCUF_RESEARCH_CORPUS_0.2.0/examples/reject_kernel_work_underreserve.lcufx",
   "bytes": 407,
   "sha256": "95d5fb1423ae84db3e9f6d0f3ec033959f537803df232b556cd9eeab0fad1803"
  },
  {
   "kind": "language",
   "name": "LCUF_RESEARCH_CORPUS_0.2.0/examples/reject_noncanonical_residue.lcufx",
   "bytes": 305,
   "sha256": "159ae2bd5aa4487d9f5e7cf2df169425b1ba8eab0c64b9298e600a9a07cc7f40"
  }
 ]
}