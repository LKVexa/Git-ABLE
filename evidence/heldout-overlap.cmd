@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): heldout-overlap.json. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to print the document, with /check to check its SHA-512, or with /extract FILE to write it out.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=heldout-overlap.json"
set "LB_DOC_TYPE=json"
set "LB_DOC_BYTES=3065"
set "LB_DOC_SHA512=0897c19a81447550348b479a5e0977d888f6f217e3f06a748731324740705c7a93aebe4d0505c516489febec20b584c0293ba5660fa7fa09cfc109236dd7c208"
set "LB_SELF=%~f0"
set "LB_ARG=%~1"
set "LB_OUT=%~f2"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$n=[int]$env:LB_DOC_BYTES;$b=[IO.File]::ReadAllBytes($env:LB_SELF);$o=$b.Length-$n;$h=-join((New-Object Security.Cryptography.SHA512Managed).ComputeHash($b,$o,$n)|%%{$_.ToString('x2')});if($h -ne $env:LB_DOC_SHA512){[Console]::Error.WriteLine('LB-DOC/1: the SHA-512 of '+$env:LB_DOC+' differs from LB_DOC_SHA512');exit 1};if($env:LB_ARG -eq '/check'){'ok: '+$env:LB_DOC;exit 0};if($env:LB_ARG -eq '/extract'){$d=New-Object byte[] $n;[Array]::Copy($b,$o,$d,0,$n);[IO.File]::WriteAllBytes($env:LB_OUT,$d);'written: '+$env:LB_OUT;exit 0};[Console]::OutputEncoding=New-Object Text.UTF8Encoding $false;[Console]::Out.Write([Text.Encoding]::UTF8.GetString($b,$o,$n));exit 0"
set "LB_RC=%errorlevel%"
if "%LB_ARG%"=="" pause
exit /b %LB_RC%
rem ---- document ----
{
 "about": "How much of the held-out text also occurs verbatim in the training text. Computed with CPython 3.13 and numpy 2.5 from the original files that data\\train_bytes_00.cmd, data\\train_bytes_01.cmd and data\\heldout_bytes_00.cmd hold (their SHA-512 below is the shards' LB_DATA_SHA512). A held-out window counts when the same bytes occur anywhere in the training text; rolling-hash candidates are each confirmed byte for byte.",
 "training_text": {
  "file": "train.bin",
  "bytes": 3728629,
  "sha512": "c17ea34319bad060391761fa490efc01bb51cefdfb44fc200fe90015e4c76942e1be8128dd7be260f3295335c218990c56ef67321fbb41279a1782ccd1787767"
 },
 "heldout_text": {
  "file": "heldout.bin",
  "bytes": 381629,
  "sha512": "36235c2d06bd5dbff8c1a22b3e61dadcfcccce9a4b06b10e4163f616d43884d6d01567bbcbb82bffa0f072b6c62837c1f91f16f16096489eaa430fb961f3b9d8"
 },
 "overlap": [
  {
   "window_bytes": 48,
   "heldout_windows": 381582,
   "also_in_training_text": 269043,
   "fraction_of_windows": 0.7050725663160212,
   "heldout_bytes_inside_such_a_window": 291954,
   "fraction_of_heldout_bytes": 0.765020478003506,
   "hash_candidates": 269043,
   "hash_collisions_rejected": 0
  },
  {
   "window_bytes": 96,
   "heldout_windows": 381534,
   "also_in_training_text": 250171,
   "fraction_of_windows": 0.6556977884015579,
   "heldout_bytes_inside_such_a_window": 280678,
   "fraction_of_heldout_bytes": 0.7354734572058204,
   "hash_candidates": 250171,
   "hash_collisions_rejected": 0
  }
 ],
 "program_windows": [
  {
   "heldout_offset": 1000,
   "bytes": 96,
   "role": "scored text",
   "used_by": [
    "kgd/accept_m1_exact_forward",
    "kgd/accept_m1_tier2_forward"
   ],
   "occurs_in_training_text": true,
   "times_in_training_text": 7,
   "longest_piece_in_training_text_bytes": 96
  },
  {
   "heldout_offset": 2000,
   "bytes": 64,
   "role": "calibration text of the witness gate",
   "used_by": [
    "kgd/accept_rails_witness_m1_abstains",
    "kgd/accept_rails_witness_unigram",
    "examples/rails-witness-model1",
    "examples/rails-witness-unigram"
   ],
   "occurs_in_training_text": false,
   "times_in_training_text": 0,
   "longest_piece_in_training_text_bytes": 32
  },
  {
   "heldout_offset": 3000,
   "bytes": 48,
   "role": "scored text",
   "used_by": [
    "kgd/accept_rails_parity_m1",
    "kgd/reject_rails_parity_no_majority",
    "kgd/accept_rails_codelen_unigram",
    "examples/rails-codelen-model1"
   ],
   "occurs_in_training_text": true,
   "times_in_training_text": 9,
   "longest_piece_in_training_text_bytes": 48
  }
 ],
 "conclusion": "The split is by document, but much of the material recurs across documents, so most held-out windows also occur in the training text. The windows scored by the forward, parity and code-length programs do; the calibration text of the witness gate does not. No conclusion of this package depends on it: the models are untrained, and the witness gate is calibrated on text that does not occur in the training text. Held-out measurements after training need a split without such repeats."
}