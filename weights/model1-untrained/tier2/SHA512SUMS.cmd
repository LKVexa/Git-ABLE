@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): SHA512SUMS.txt. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to print the document, with /check to check its SHA-512, or with /extract FILE to write it out.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=SHA512SUMS.txt"
set "LB_DOC_TYPE=sha512sums"
set "LB_DOC_BYTES=720"
set "LB_DOC_SHA512=0d91f885c2dade39ccf0d79e7475466896ce3c843d1d284b34f36330f951dada66d2ed702907f3aef57c105816633d33a85386837da590f6910eed6ae77535c1"
set "LB_SELF=%~f0"
set "LB_ARG=%~1"
set "LB_OUT=%~f2"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$n=[int]$env:LB_DOC_BYTES;$b=[IO.File]::ReadAllBytes($env:LB_SELF);$o=$b.Length-$n;$h=-join((New-Object Security.Cryptography.SHA512Managed).ComputeHash($b,$o,$n)|%%{$_.ToString('x2')});if($h -ne $env:LB_DOC_SHA512){[Console]::Error.WriteLine('LB-DOC/1: the SHA-512 of '+$env:LB_DOC+' differs from LB_DOC_SHA512');exit 1};if($env:LB_ARG -eq '/check'){'ok: '+$env:LB_DOC;exit 0};if($env:LB_ARG -eq '/extract'){$d=New-Object byte[] $n;[Array]::Copy($b,$o,$d,0,$n);[IO.File]::WriteAllBytes($env:LB_OUT,$d);'written: '+$env:LB_OUT;exit 0};[Console]::OutputEncoding=New-Object Text.UTF8Encoding $false;[Console]::Out.Write([Text.Encoding]::UTF8.GetString($b,$o,$n));exit 0"
set "LB_RC=%errorlevel%"
if "%LB_ARG%"=="" pause
exit /b %LB_RC%
rem ---- document ----
cde2aaf16fe121e92631e7bc8c299b4921abd7418e227b815e0d08e304793691031271eb724b555fe57b82caf4ec0393d17963a3a8503ad7469a4a46ecc63231  shard_L00.cmd
02cb40be5a802734a73934a986b5dc8166d998d8a58a19544327caf601842c37bc47127eb308758aace0273ca45fcd74ddfbf9fe202cc4bbcf967c2343e10acb  shard_L01.cmd
1126d2ba801354fae1f30baccc562e8d851f8247524835a507d37d66d07389d3e219bb464226e85d8573a6567a2df67fd7245d962d340d6cf0518ce7f409d384  shard_L02.cmd
2007fb44290800b96cb4ab6c5542d6c5d4adc338e70ec1fa8afac323aeeec535a99d7a0c0ecb462b8d8f0ab3a86a46bf878d60bf82b792232a9c914a3423588f  shard_L03.cmd
666b970161ed258d322142c8fbe865b39e76b1644a8aa6804f5295300b09158f53bfd30635dea7203b5c3e530423a54ddeeb6eb5b7c3a01f2100571f54f170aa  shard_EMB.cmd
