@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): grad_check.json. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to print the document, with /check to check its SHA-512, or with /extract FILE to write it out.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=grad_check.json"
set "LB_DOC_TYPE=json"
set "LB_DOC_BYTES=1200"
set "LB_DOC_SHA512=1310fba5782c69616c807f22cc7b9b463f45861ea9a5f4b46019246666dfdc88cbdd2a038972abd441ad42b29381200ed7faaed28be85e01205ecbf37ef93caa"
set "LB_SELF=%~f0"
set "LB_ARG=%~1"
set "LB_OUT=%~f2"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$n=[int]$env:LB_DOC_BYTES;$b=[IO.File]::ReadAllBytes($env:LB_SELF);$o=$b.Length-$n;$h=-join((New-Object Security.Cryptography.SHA512Managed).ComputeHash($b,$o,$n)|%%{$_.ToString('x2')});if($h -ne $env:LB_DOC_SHA512){[Console]::Error.WriteLine('LB-DOC/1: the SHA-512 of '+$env:LB_DOC+' differs from LB_DOC_SHA512');exit 1};if($env:LB_ARG -eq '/check'){'ok: '+$env:LB_DOC;exit 0};if($env:LB_ARG -eq '/extract'){$d=New-Object byte[] $n;[Array]::Copy($b,$o,$d,0,$n);[IO.File]::WriteAllBytes($env:LB_OUT,$d);'written: '+$env:LB_OUT;exit 0};[Console]::OutputEncoding=New-Object Text.UTF8Encoding $false;[Console]::Out.Write([Text.Encoding]::UTF8.GetString($b,$o,$n));exit 0"
set "LB_RC=%errorlevel%"
if "%LB_ARG%"=="" pause
exit /b %LB_RC%
rem ---- document ----
{
 "config": {
  "vocab": 17,
  "d": 16,
  "n_layers": 2,
  "n_heads": 4,
  "n_kv": 2,
  "d_k": 4,
  "d_ff": 24,
  "seq_len": 6,
  "rope_base": 10000.0,
  "alpha_init": 0.2,
  "c_init": 0.7,
  "kgd": true
 },
 "loss": 3.537255874283629,
 "method": "central differences with steps of 1e-6 (the float32-representable step actually taken), double arithmetic, against the backward pass",
 "max_relative_error_per_tensor": {
  "emb": 1.92008022929884e-08,
  "L00.n1": 2.678343745439283e-08,
  "L00.qkvo": 2.9523089256361464e-08,
  "L00.qn": 3.5165679779097416e-08,
  "L00.kn": 4.887345980011996e-08,
  "L00.n2": 2.7936979364313017e-08,
  "L00.up": 1.3454208998145583e-08,
  "L00.down": 2.358831260849055e-06,
  "L00.ka": 5.5653213018164146e-08,
  "L00.kb": 1.240602489831461e-07,
  "L01.n1": 9.716554502000347e-08,
  "L01.qkvo": 4.000775350728633e-08,
  "L01.qn": 3.2405972692977483e-08,
  "L01.kn": 6.641572743501094e-08,
  "L01.n2": 2.9611425037952945e-07,
  "L01.up": 4.6334440457312876e-07,
  "L01.down": 3.455539525709975e-08,
  "L01.ka": 2.666232858591095e-08,
  "L01.kb": 9.689374189518392e-08,
  "fn": 1.650397143316582e-07
 },
 "worst": 2.358831260849055e-06,
 "pass": true,
 "threshold": 1e-05
}