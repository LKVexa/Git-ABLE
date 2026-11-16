@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): SHA512SUMS.txt. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to print the document, with /check to check its SHA-512, or with /extract FILE to write it out.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=SHA512SUMS.txt"
set "LB_DOC_TYPE=sha512sums"
set "LB_DOC_BYTES=720"
set "LB_DOC_SHA512=8f73bed0fa8ec69ccbdee18bad8ef816f77513f96c3c56d0fbd9e6af5c0549b64e2692df1073e0f99a5ffeb4b63e61f78b4b9b2723f36e860283ab72d0085708"
set "LB_SELF=%~f0"
set "LB_ARG=%~1"
set "LB_OUT=%~f2"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$n=[int]$env:LB_DOC_BYTES;$b=[IO.File]::ReadAllBytes($env:LB_SELF);$o=$b.Length-$n;$h=-join((New-Object Security.Cryptography.SHA512Managed).ComputeHash($b,$o,$n)|%%{$_.ToString('x2')});if($h -ne $env:LB_DOC_SHA512){[Console]::Error.WriteLine('LB-DOC/1: the SHA-512 of '+$env:LB_DOC+' differs from LB_DOC_SHA512');exit 1};if($env:LB_ARG -eq '/check'){'ok: '+$env:LB_DOC;exit 0};if($env:LB_ARG -eq '/extract'){$d=New-Object byte[] $n;[Array]::Copy($b,$o,$d,0,$n);[IO.File]::WriteAllBytes($env:LB_OUT,$d);'written: '+$env:LB_OUT;exit 0};[Console]::OutputEncoding=New-Object Text.UTF8Encoding $false;[Console]::Out.Write([Text.Encoding]::UTF8.GetString($b,$o,$n));exit 0"
set "LB_RC=%errorlevel%"
if "%LB_ARG%"=="" pause
exit /b %LB_RC%
rem ---- document ----
1d069eedf6617d37cfadcd36b5e026dc4296abb928055549d23495a5c9b888e9d3d6289f366b1fd3243f4cf49e5df5ec9ecd98c80a013faad3429a32f72ffca3  shard_L00.cmd
551ef103bb600961ac070858ad034a071ba993818df3d9be26d14f99912053497dc3a7fa398ff2bd0e915edd07325aae49724dfd830816d0fe257bb07412ce2b  shard_L01.cmd
77fc5d7b9681725f76ac37a2b2be997dbd82d330616b8fd2d93e1230dce63292c60075a40784637bf7d55bb94a67e242b921b4501ebb646941a9677516da4b10  shard_L02.cmd
26870b910d7dd7d2c202253554d4a159f79c6ab7323d37b9486a8d6fc114fae1c8063e5f3bb36ca1e84076917acf834a023bb1ac628837c683a78a7e04ed315b  shard_L03.cmd
a7747f3e8e50e3a5d32349ee8203d2a43bb3099886cf52c2f3fbdf308390cdd95a4eb72d49b75687cad6ee94d9ebbf445d713b9a36d74166d39e4b89b6616f4a  shard_EMB.cmd
