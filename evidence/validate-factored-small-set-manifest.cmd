@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): manifest.json. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to print the document, with /check to check its SHA-512, or with /extract FILE to write it out.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=manifest.json"
set "LB_DOC_TYPE=json"
set "LB_DOC_BYTES=3576"
set "LB_DOC_SHA512=f9b31de8f623dfe846ef2058968204673763ce03aed835438637db8d5fdeb08810c084dab1018e7fb8bad3771c448ea5b0ecf085651fd8c73cb1afe96dd1c7d6"
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
  "d": 256,
  "n_layers": 2,
  "n_heads": 4,
  "n_kv": 2,
  "d_k": 64,
  "d_ff": 1024,
  "seq_len": 2048,
  "rope_base": 10000.0,
  "kgd": true,
  "alpha_init": 0.05,
  "c_init": 1.0,
  "emb_clusters": 16,
  "emb_cluster_rows": 3072
 },
 "trained": false,
 "seed": 7,
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
 "nominal_parameters": 14026244,
 "stored_words": 50848,
 "stored_bits": 1627136,
 "random_sign_words": 18880,
 "rank_bound": {
  "tier0": 2,
  "tier1": 10,
  "effective_at_init": 2
 },
 "caps": {
  "shard_bytes": 24000000,
  "applies_to": "bytes_bound_any_values of every shard (the largest size any trained values can give)"
 },
 "total_bytes_bound_any_values": 1710765,
 "format": "LB-CMD/1",
 "shards": [
  {
   "file": "shard_EMB0.cmd",
   "bytes": 687296,
   "sha512": "3e49521d251e50c75d659dfe90498efb147622b534f86ff17b89723372c106157305f638a2348a6a72e6c7f75f9c35508e198d405f739c68635cb5b9982ac854",
   "payload_sha512": "6b722efe0e13152656cb206f0e8fa3c6956a580686511ff38f81e30138cebca6e00e193a1b5e21ebdf5c8995ae66978cf71cac8bba805a6b7b6280e8518e8e0b",
   "payload_lines": 21712,
   "l1_checksum": 16215837117948,
   "nominal_parameters": 6291456,
   "bytes_bound_any_values": 723154
  },
  {
   "file": "shard_EMB1.cmd",
   "bytes": 693121,
   "sha512": "ed7ea877e4e0c6ac8280666de29a2e9e8c016473969ae04df3b5a6e2ad199d9fe999734adb8a6d9426bcfc880f5dad79d52ba625143dcd4c0a87d17685db7529",
   "payload_sha512": "ba843b6e48b76bd2cb6aa569505d1d8fa52df51336e5d014f1336e3ffb9f9b4b7b4688be108c8ac75033f21a4473aef313aaae4b9559316a1374c205cc12635c",
   "payload_lines": 21968,
   "l1_checksum": 16227826701150,
   "nominal_parameters": 6291712,
   "bytes_bound_any_values": 730469
  },
  {
   "file": "shard_L00.cmd",
   "bytes": 119694,
   "sha512": "edee847a577345446b4a5e09aa54af42a47936e804ee56c960e1f9736b3585413bdaefe534d852541aafe2aa692d010f7e7c00dd62498ff573c675f5534871ac",
   "payload_sha512": "52dd5f23e3efdd1746207dbed1b5748a39f56157e9a7ab73fc7dd9e263847ec294b753163c4914e9100ce8c743404a9f0ea56e5b1e785a68d93203e6ff69fd4c",
   "payload_lines": 3584,
   "l1_checksum": 2187763584176,
   "nominal_parameters": 721538,
   "bytes_bound_any_values": 128571
  },
  {
   "file": "shard_L01.cmd",
   "bytes": 119714,
   "sha512": "65ec7c18be853616277e0ae4eae72bd4ba106023b4aec10e4021acacc611fbe3dabed7cca80dc8fd48dd1ad1156fb35126ed66fb1061e851f6c639d6d20b7594",
   "payload_sha512": "bc1518e4074f60e91fcdd93d00a9ff9b80f70eddbc48858c113637345d983d45dcaa93f24e7e44debd42231edb361392a68bf164ac8eb930bcd1b80b2bac87b2",
   "payload_lines": 3584,
   "l1_checksum": 2190533821050,
   "nominal_parameters": 721538,
   "bytes_bound_any_values": 128571
  }
 ],
 "set_sha512": "b7b0124745fb70c1f127ce8405c6d9251541762ae3316b73c257b1a240cd7d65fa20cd15119022d0662a737cc5e6f36c084bc80c4619826753dd41df0e9e7048",
 "concatenated_sha512": "ff22c834c8ea4e555b234aea729481318e35db9e617f349bef0fb3f20eaff4e277c3a66fc2d4c79c3e9d1c0366bffe613d90bda1d601c6d38d0898e2652c9a30",
 "total_bytes": 1619825,
 "set_rule": "set_sha512 = SHA-512 of the lines '<file> <sha512>\\n' in shard order"
}