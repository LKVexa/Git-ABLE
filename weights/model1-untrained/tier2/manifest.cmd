@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): manifest.json. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to print the document, with /check to check its SHA-512, or with /extract FILE to write it out.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=manifest.json"
set "LB_DOC_TYPE=json"
set "LB_DOC_BYTES=3743"
set "LB_DOC_SHA512=cc0745952e410a42abb7ce3625137e9a6ad1caf7947608be055a76edf2d9e4cf969e7aa72babd08f509c1e4cbd166bc39fed8eb9f60ed3ef3c3485122cab4fd1"
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
 "tier": "TIER-2",
 "g_block": 256,
 "encoding": "sign bitplane (row-major, 32 per word) with mean-|W| scales per block of 256 elements (U0.16 with a power-of-two SHIFT); Dual-SVID rank-2 factors U1 V1 U2 V2 with shared SR/SC scales; norms and KGD alpha/c in Q16.16",
 "reconstruction": "W_ij = sign_ij * block_scale(ij); the Dual-SVID factors are carried as in the note and are not combined in this reconstruction",
 "arithmetic": "block scales and Dual-SVID in float64 with every sum in index order (SPEC section 6), so any implementation writes the same words",
 "format": "LB-CMD/1",
 "shards": [
  {
   "file": "shard_L00.cmd",
   "bytes": 928273,
   "sha512": "cde2aaf16fe121e92631e7bc8c299b4921abd7418e227b815e0d08e304793691031271eb724b555fe57b82caf4ec0393d17963a3a8503ad7469a4a46ecc63231",
   "payload_sha512": "5307b85c56f521232f20770e97a6f6148e4ab9d8bb6b4695ebff57eeb01f549a8eebdfc48e9cf97e389ac4e6450c03b916b7b30e8f841f23b977a0ec48c8658b",
   "payload_lines": 26603,
   "l1_checksum": 25011915232883
  },
  {
   "file": "shard_L01.cmd",
   "bytes": 928792,
   "sha512": "02cb40be5a802734a73934a986b5dc8166d998d8a58a19544327caf601842c37bc47127eb308758aace0273ca45fcd74ddfbf9fe202cc4bbcf967c2343e10acb",
   "payload_sha512": "f8ffb879a09e99d90d6d49a2ee1319a7119d595f564ed31feec541c8713743d5d65675e8f6e49793f0b304b48e211dc23e3a31eca7f82fb7d2f084d683213f36",
   "payload_lines": 26603,
   "l1_checksum": 25247463724469
  },
  {
   "file": "shard_L02.cmd",
   "bytes": 928760,
   "sha512": "1126d2ba801354fae1f30baccc562e8d851f8247524835a507d37d66d07389d3e219bb464226e85d8573a6567a2df67fd7245d962d340d6cf0518ce7f409d384",
   "payload_sha512": "3d87d2d0c5a852711ebb98fdb66d997090b41cf161e05f7b1311b471f70a522f16e156052f2af70a817a702f5b8082013d94126b1002534e3c4084cca523928e",
   "payload_lines": 26603,
   "l1_checksum": 25393905749463
  },
  {
   "file": "shard_L03.cmd",
   "bytes": 928832,
   "sha512": "2007fb44290800b96cb4ab6c5542d6c5d4adc338e70ec1fa8afac323aeeec535a99d7a0c0ecb462b8d8f0ab3a86a46bf878d60bf82b792232a9c914a3423588f",
   "payload_sha512": "880f26087209ad4dd1a66fd648051736379845e718f7fbb9bd92dc8614f97499b34ca3432116dde104fee0e3c92563dd15e37b0bb56dee3ca0eef7388266446f",
   "payload_lines": 26603,
   "l1_checksum": 25356358094438
  },
  {
   "file": "shard_EMB.cmd",
   "bytes": 83133,
   "sha512": "666b970161ed258d322142c8fbe865b39e76b1644a8aa6804f5295300b09158f53bfd30635dea7203b5c3e530423a54ddeeb6eb5b7c3a01f2100571f54f170aa",
   "payload_sha512": "8a80063c6f152d7c340f4392486def7adf455aae9127ab677a92fd207146870849cb2322065fd36fba8bce993bb6b52d64c5d3cd1a253463039ab124bffcfb52",
   "payload_lines": 2723,
   "l1_checksum": 2339741523437
  }
 ],
 "set_sha512": "555eb9eb9d0c1de18e04a22fc1517d66516c673d8116b14edba6076655883966d2ba27ca72f958c3da3bda0eb33ce9aced61128480f10f9c07881f2a2c157499",
 "concatenated_sha512": "37c073eb22d2b3e80f5f444e1ccf3ddd2ac9a69b6fba95c0814495cabe5ec72d003b49f32211f10116e09bc366d2d9868e13d08c1db15b0bdf7325929f0ee90f",
 "total_bytes": 3797790,
 "set_rule": "set_sha512 = SHA-512 of the lines '<file> <sha512>\\n' in shard order"
}