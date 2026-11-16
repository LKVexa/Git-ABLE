@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): COMBINED-MANIFEST.json. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to print the document, with /check to check its SHA-512, or with /extract FILE to write it out.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=COMBINED-MANIFEST.json"
set "LB_DOC_TYPE=json"
set "LB_DOC_BYTES=1795"
set "LB_DOC_SHA512=e9df77947ef6fa0e875520b492d42e09bba2a4dd9001cd6444a0dc6c883f3f22761989b00572fd0d0b2423d6b65ba6b5b85dc87dd014dcc9e92817f40c659197"
set "LB_SELF=%~f0"
set "LB_ARG=%~1"
set "LB_OUT=%~f2"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$n=[int]$env:LB_DOC_BYTES;$b=[IO.File]::ReadAllBytes($env:LB_SELF);$o=$b.Length-$n;$h=-join((New-Object Security.Cryptography.SHA512Managed).ComputeHash($b,$o,$n)|%%{$_.ToString('x2')});if($h -ne $env:LB_DOC_SHA512){[Console]::Error.WriteLine('LB-DOC/1: the SHA-512 of '+$env:LB_DOC+' differs from LB_DOC_SHA512');exit 1};if($env:LB_ARG -eq '/check'){'ok: '+$env:LB_DOC;exit 0};if($env:LB_ARG -eq '/extract'){$d=New-Object byte[] $n;[Array]::Copy($b,$o,$d,0,$n);[IO.File]::WriteAllBytes($env:LB_OUT,$d);'written: '+$env:LB_OUT;exit 0};[Console]::OutputEncoding=New-Object Text.UTF8Encoding $false;[Console]::Out.Write([Text.Encoding]::UTF8.GetString($b,$o,$n));exit 0"
set "LB_RC=%errorlevel%"
if "%LB_ARG%"=="" pause
exit /b %LB_RC%
rem ---- document ----
{
 "format": "LB-CMD/1 combined manifest",
 "sets": [
  {
   "folder": "model1-untrained/exact",
   "model": "KGD-IMQ-5DLLM-M1",
   "tier": "EXACT-BF16",
   "set_sha512": "2824a03df39ab370306ebf0f04f9d72afccb7a171f06997c58eddfac420e697e235b83ae32f9a89b5aa956c7aef785b0920aacbd6ea95eacb74fbb7eae3fb627",
   "shards": 5,
   "total_bytes": 54525494,
   "nominal_parameters": 2951944,
   "trained": false
  },
  {
   "folder": "model1-untrained/tier2",
   "model": "KGD-IMQ-5DLLM-M1",
   "tier": "TIER-2",
   "set_sha512": "555eb9eb9d0c1de18e04a22fc1517d66516c673d8116b14edba6076655883966d2ba27ca72f958c3da3bda0eb33ce9aced61128480f10f9c07881f2a2c157499",
   "shards": 5,
   "total_bytes": 3797790,
   "nominal_parameters": 2951944,
   "trained": false
  },
  {
   "folder": "model2-tier1",
   "model": "KGD-IMQ-5DLLM-M2",
   "tier": "TIER-1",
   "set_sha512": "89485985ebb6d0b46ce5fb2cb492d897b53f073b95943cea8b73cd589a8b1f3f49c3cb917a26e7e9329fbfe777f3a094ead282445a4b7bf858f2299c64d0cb77",
   "shards": 70,
   "total_bytes": 874173645,
   "nominal_parameters": 1022597991748,
   "trained": false
  }
 ],
 "combined_rule": "combined_sha512 = SHA-512 of the lines '<set folder> <set_sha512>\\n' in the listed order",
 "combined_sha512": "eae0ff8cd1d8412a7d79e820cff3efaf065c38cf0abe38fd5fe45def437e0857f395bf55aa30cfd406a36a5714a245895f7d98bba804db75b10999e8eef054a6",
 "caps": {
  "shard_bytes": 24000000,
  "all_files_bytes": 1000000000,
  "applies_to": "the files now, and the bound any values can reach (tools\\LB_CMD.cmd combined): training changes values, never the number of words"
 },
 "nominal_parameters_total": 1022600943692,
 "note": "model 1's two sets are two encodings of one untrained model (its seed-0 initialization), so its parameters are counted once; neither model is trained"
}