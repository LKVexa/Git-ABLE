@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): manifest.json. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to print the document, with /check to check its SHA-512, or with /extract FILE to write it out.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=manifest.json"
set "LB_DOC_TYPE=json"
set "LB_DOC_BYTES=3377"
set "LB_DOC_SHA512=ec669d32ef5b4c55cec277f6af83f9d748d60d75bdc5d27a60bef7df60ef7d78d8494c4b9eacf5e9aad9e1593bca13a4f1124b1b73e6e1286ffad0ca398310a0"
set "LB_SELF=%~f0"
set "LB_ARG=%~1"
set "LB_OUT=%~f2"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$n=[int]$env:LB_DOC_BYTES;$b=[IO.File]::ReadAllBytes($env:LB_SELF);$o=$b.Length-$n;$h=-join((New-Object Security.Cryptography.SHA512Managed).ComputeHash($b,$o,$n)|%%{$_.ToString('x2')});if($h -ne $env:LB_DOC_SHA512){[Console]::Error.WriteLine('LB-DOC/1: the SHA-512 of '+$env:LB_DOC+' differs from LB_DOC_SHA512');exit 1};if($env:LB_ARG -eq '/check'){'ok: '+$env:LB_DOC;exit 0};if($env:LB_ARG -eq '/extract'){$d=New-Object byte[] $n;[Array]::Copy($b,$o,$d,0,$n);[IO.File]::WriteAllBytes($env:LB_OUT,$d);'written: '+$env:LB_OUT;exit 0};[Console]::OutputEncoding=New-Object Text.UTF8Encoding $false;[Console]::Out.Write([Text.Encoding]::UTF8.GetString($b,$o,$n));exit 0"
set "LB_RC=%errorlevel%"
if "%LB_ARG%"=="" pause
exit /b %LB_RC%
rem ---- document ----
{
 "model": "KGD-IMQ-5DLLM-M1",
 "config": {
  "vocab": 256,
  "d": 256,
  "n_layers": 4,
  "n_heads": 4,
  "n_kv": 2,
  "d_k": 64,
  "d_ff": 1024,
  "seq_len": 128,
  "rope_base": 10000.0,
  "alpha_init": 0.05,
  "c_init": 1.0,
  "kgd": true
 },
 "parameters": 2951944,
 "pinned_source_commit": "7eaa920315a7ef513f9b0ef3be99cdcfa6cf5d88",
 "tensor_names": "the engine's Model.Shapes(config), the order of kgd_model.tensor_shapes",
 "trained": false,
 "seed": 0,
 "init": {
  "matrices": "N(0, 0.02^2): numpy's PCG64 per tensor, seeded by SHA-512(\"seed:name\") (kgd_model.init_params)",
  "norms": 1.0,
  "kgd": {
   "alpha": 0.05,
   "c": 1.0
  }
 },
 "tier": "EXACT-BF16",
 "encoding": "every tensor as bfloat16 pairs (low half = even element), row-major; KGD_W holds the raw (a, b) of alpha = 0.5 sigmoid(a), c = softplus(b)",
 "format": "LB-CMD/1",
 "shards": [
  {
   "file": "shard_L00.cmd",
   "bytes": 13359052,
   "sha512": "1d069eedf6617d37cfadcd36b5e026dc4296abb928055549d23495a5c9b888e9d3d6289f366b1fd3243f4cf49e5df5ec9ecd98c80a013faad3429a32f72ffca3",
   "payload_sha512": "211bb654d69e10cd01bba41040b379fbbbe35452b9136224471e2ad6a0ba73ff37db52c48a4d76e5ffb00a15bc2bc8f434c07f6849ed845c57429819597fa936",
   "payload_lines": 360771,
   "l1_checksum": 387298229414317
  },
  {
   "file": "shard_L01.cmd",
   "bytes": 13359528,
   "sha512": "551ef103bb600961ac070858ad034a071ba993818df3d9be26d14f99912053497dc3a7fa398ff2bd0e915edd07325aae49724dfd830816d0fe257bb07412ce2b",
   "payload_sha512": "f0ecaf0f08373349fd22859d6e85800d0b7da9e86ae2d15e301a03bfb51a7567c37432b0d8489cec89c39747ddd4bbbf58a5f9ec532388c011cf22867c619bab",
   "payload_lines": 360771,
   "l1_checksum": 387344829969334
  },
  {
   "file": "shard_L02.cmd",
   "bytes": 13359154,
   "sha512": "77fc5d7b9681725f76ac37a2b2be997dbd82d330616b8fd2d93e1230dce63292c60075a40784637bf7d55bb94a67e242b921b4501ebb646941a9677516da4b10",
   "payload_sha512": "0ca9a5be0dea1ce9edcd4b0d4ec96b56ca1391275f22ddcaadc47947a1fcfca5542e71ed712a0d9348b9219010cfebe9ae10c3aab1f8171c4bc128dc43948b99",
   "payload_lines": 360771,
   "l1_checksum": 387336039074091
  },
  {
   "file": "shard_L03.cmd",
   "bytes": 13359681,
   "sha512": "26870b910d7dd7d2c202253554d4a159f79c6ab7323d37b9486a8d6fc114fae1c8063e5f3bb36ca1e84076917acf834a023bb1ac628837c683a78a7e04ed315b",
   "payload_sha512": "6368e1c24a4d7d04655866a08256199c87a9ee1f8b32ea86ee4ab3488cd7d57d135e9f478c5f9fe9b38803d30ebd7bb2c0ada38333d8dba73fa5feb44480ba86",
   "payload_lines": 360771,
   "l1_checksum": 387379110393256
  },
  {
   "file": "shard_EMB.cmd",
   "bytes": 1088079,
   "sha512": "a7747f3e8e50e3a5d32349ee8203d2a43bb3099886cf52c2f3fbdf308390cdd95a4eb72d49b75687cad6ee94d9ebbf445d713b9a36d74166d39e4b89b6616f4a",
   "payload_sha512": "3a9785cc5b16dbf67fefee8c26b3c0fab18ccd628483d6ec025d9a7cd12de642b5d3df2c687c99386babd26e14f2ab7eafd235a93a41414602e83a3f8ed0ca4e",
   "payload_lines": 32896,
   "l1_checksum": 35324216678614
  }
 ],
 "set_sha512": "2824a03df39ab370306ebf0f04f9d72afccb7a171f06997c58eddfac420e697e235b83ae32f9a89b5aa956c7aef785b0920aacbd6ea95eacb74fbb7eae3fb627",
 "concatenated_sha512": "47d89048a6de5dd0781536c28ced936d79ddcee6646faa81023f18f31733cc280bc1c0a8c13c80b8d61dcac22a66406638afca2d1a7985039fa98eb2a0e83dec",
 "total_bytes": 54525494,
 "set_rule": "set_sha512 = SHA-512 of the lines '<file> <sha512>\\n' in shard order"
}