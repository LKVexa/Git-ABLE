@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): SPEC-LB-CMD-1.md. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to print the document, with /check to check its SHA-512, or with /extract FILE to write it out.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=SPEC-LB-CMD-1.md"
set "LB_DOC_TYPE=markdown"
set "LB_DOC_BYTES=13627"
set "LB_DOC_SHA512=3b1bb8f66fca7f5db1c7c42f4210d06400b6f14ca1aedb1ddb24135c0ee7e97fad0eb3ff0b0ea05240add58438cba9e4daae44ea6f17ef8b62a9b0caefdeae84"
set "LB_SELF=%~f0"
set "LB_ARG=%~1"
set "LB_OUT=%~f2"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$n=[int]$env:LB_DOC_BYTES;$b=[IO.File]::ReadAllBytes($env:LB_SELF);$o=$b.Length-$n;$h=-join((New-Object Security.Cryptography.SHA512Managed).ComputeHash($b,$o,$n)|%%{$_.ToString('x2')});if($h -ne $env:LB_DOC_SHA512){[Console]::Error.WriteLine('LB-DOC/1: the SHA-512 of '+$env:LB_DOC+' differs from LB_DOC_SHA512');exit 1};if($env:LB_ARG -eq '/check'){'ok: '+$env:LB_DOC;exit 0};if($env:LB_ARG -eq '/extract'){$d=New-Object byte[] $n;[Array]::Copy($b,$o,$d,0,$n);[IO.File]::WriteAllBytes($env:LB_OUT,$d);'written: '+$env:LB_OUT;exit 0};[Console]::OutputEncoding=New-Object Text.UTF8Encoding $false;[Console]::Out.Write([Text.Encoding]::UTF8.GetString($b,$o,$n));exit 0"
set "LB_RC=%errorlevel%"
if "%LB_ARG%"=="" pause
exit /b %LB_RC%
rem ---- document ----
# LB-CMD/1 and LB-DOC/1: the file formats of this package

This package is `.cmd` only: every file is a Windows command script except `README.md` and `.gitattributes`, and no file
is larger than 24,000,000 bytes. There are three kinds of `.cmd` file:

- **shards** (LB-CMD/1, sections 1 to 6): weights and the training text as `set "NAME=VALUE"` lines;
- **documents** (LB-DOC/1, section 7): JSON, text, Markdown, SHA512SUMS lists and LCUF-X programs, each stored after a
  short cmd header;
- **tools**: cmd scripts. `tools\KGD_ENGINE.cmd` is also the C# source of the package's engine (section 9), which
  includes the reasoning layer RAILS-8S/1 (`REASONING-RAILS-8S.cmd`).

`tools\KGD_ENGINE.cmd` writes and reads all of them. The weight format follows TN-2026-LB-CMD-WEIGHTS-5DLLM-8S
("LittleBit .cmd Weights for SHEP:00012"); section 10 lists the interpretations made where the note leaves a choice
open.

## 1. Shard file

- **Encoding and size.** The file is ASCII with CRLF line endings, and every file is at most 24,000,000 bytes.
- **Line order:**
  1. `@echo off`, followed by two `rem` lines. In a weight shard they read
     `rem LK/Vexa LittleBit .cmd weight shard, LB-CMD/1 (TN-2026-LB-CMD-WEIGHTS-5DLLM-8S namespace)` and
     `rem Do not run it: it only sets variables. tools\LB_CMD.cmd and tools\VERIFY_WEIGHTS.cmd read it as text.`
  2. A header of `set "KEY=VALUE"` lines. It starts with `LB_FORMAT=LB-CMD/1`, `LB_MODEL`, `LB_SHARD` and `LB_TIER`
     (`EXACT-BF16`, `TIER-2`, `TIER-1` or `BYTES`).
     - A weight shard continues with `LB_RMSNORM_EPS_Q16`, which follows the note: 512 for a model trained in bfloat16
       (2⁻⁷), 0 for float32 (1.19 × 10⁻⁷ rounds to 0 in Q16.16). Both models here are initialized in float32, so every
       weight shard carries 0. Next comes `LB_PIN`, the pinned 5-dollar-llm commit, then the tier extras:
       `LB_G_BLOCK=256` for Tier-2, and `LB_TIER0_SUBSET` and `LB_DICT_RANK=8` for Tier-1.
     - A BYTES shard continues with its `LB_DATA_*` fields (section 5).
     - Every shard ends its header with `LB_PAYLOAD_LINES`, `LB_PAYLOAD_SHA512` and `LB_L1_CHECKSUM`.
  3. `rem ---- payload ----`.
  4. The payload. It holds only `set "NAME_i=V"` lines (a family, with indices 0, 1, 2, … consecutive) and
     `set "NAME=V"` lines (a scalar). V is a signed 32-bit decimal integer.
  5. `rem ---- end of payload ----`, then `exit /b 0`.
- **Payload checks:**
  - `LB_PAYLOAD_SHA512` is the SHA-512 of the payload bytes between the two markers.
  - `LB_PAYLOAD_LINES` is the number of payload lines.
  - `LB_L1_CHECKSUM` is the sum of |V| over every payload line.
- **Running a shard.** A shard only sets environment variables. Model 2's Tier-1 shards hold up to 476,564 `set`
  lines each, so running one in cmd.exe is slow and fills the environment. The package reads shards as text and never
  runs them; `tools\VERIFY_WEIGHTS.cmd` hashes them with certutil.

## 2. Word encodings

| encoding | content of one INT32 word |
|---|---|
| bf16 pair | two bfloat16 bit patterns, element 2k in the low 16 bits and 2k+1 in the high 16 bits (note eq. 9 packing) |
| sign word | 32 signs, bit b = element 32k+b; 1 means +1 and 0 means −1 |
| U0.16 pair | two unsigned 0.16 fixed-point values (low half = even index); the value is u / 65536 × 2^SHIFT, with `NAME_SHIFT` a scalar |
| Q16.16 | one signed 16.16 fixed-point value per word (v / 65536) |
| byte word | four bytes of a file, the first in the lowest 8 bits (little-endian) |

bfloat16 rounding is round-to-nearest-even on the float32 bit pattern. U0.16 and Q16.16 values are rounded half to
even.

## 3. Weight families

### EXACT-BF16 (model 1, `weights/model1-untrained/exact/`)

The shards are `shard_L00` … `shard_L03`, one per block, and `shard_EMB`.

- `LB_L{ll}_QKVO_W`, `LB_L{ll}_UP_W` and `LB_L{ll}_DN_W`: bf16 pairs of the merged q/k/v/o projection
  ((2d + 2·kv) × d), the up projection (d_ff × d) and the down projection (d × d_ff), row-major.
- `LB_L{ll}_N1_W`, `_N2_W`, `_QN_W` and `_KN_W`: bf16 pairs of the RMSNorm weights.
- `LB_L{ll}_KGD_W`: bf16 pair of the raw KGD-IMQ parameters (a, b).
- `LB_L{ll}_KGD_ALPHA` and `LB_L{ll}_KGD_C`: Q16.16 scalars of α = sigmoid(a)/2 and c = softplus(b), computed from
  the bf16-rounded (a, b).
- `LB_EMB_W`: the tied embedding (vocab × d). `LB_FN_W`: the final norm.

### TIER-2 (model 1, `weights/model1-untrained/tier2/`)

For each matrix with prefix `P` (for example `LB_L00_QKVO`, or `LB_EMB`):

- `P_S`: a dense sign bitplane (a value ≥ 0 counts as +1).
- `P_B` with `P_B_SHIFT`: U0.16 block scales, one per g = 256 consecutive elements. Each scale is mean |W| over its
  block.
- `P_U1`, `P_V1`, `P_U2`, `P_V2`: the Dual-SVID sign factors.
- `P_SR`, `P_SC` with their `_SHIFT` scalars: the shared row and column scales, fitted with the note's C11 listing
  (rank-1 sign/value iteration, 12 iterations, shared scales 0.5(s₁+s₂)).

The norms are Q16.16 vectors (`LB_L{ll}_N1` …, `LB_FN`), and the KGD scalars are as in the exact set. Section 6 gives
the arithmetic of the block scales and the Dual-SVID fit.

### TIER-1 with its Tier-0 subset (model 2, `weights/model2-tier1/`)

Each block is in two layer-scoped shards. `shard_L{ll}_ATTN` holds QKVO, the norms N1, QN and KN, and
`_KGD_ALPHA`/`_KGD_C`. `shard_L{ll}_FFN` holds UP, DN and the norm N2. They run from `shard_L00_ATTN` to
`shard_L33_FFN`, after `shard_EMB0` and `shard_EMB1`, and the `LB_SHARD` header is `L{ll}_ATTN` or `L{ll}_FFN`. The
embedding is 16 clusters of 3,072 rows, `LB_E00` … `LB_E15`, eight per EMB shard; `LB_FN` is in `shard_EMB1`.

For each matrix prefix `P`:

- `P_U1`, `P_V1`, `P_U2`, `P_V2`, `P_SR`, `P_SC`: the Tier-0 subset.
- `P_D03U`/`P_D03V` … `P_D10U`/`P_D10V`: eight binary residual planes.
- `P_A03` … `P_A10`: their Q16.16 weights.

The matrix is

  W = diag(s_row) (U1 V1ᵀ + U2 V2ᵀ) diag(s_col) + Σ_p a_p u_p v_pᵀ.

Tier-0 uses the first term alone. The rank is at most 2 for Tier-0 and at most 10 for Tier-1.

## 4. Size bound

Training changes values; it never changes the families, their lengths or the header fields. So each shard has a
largest possible size, its **bound**: every payload value at 11 characters (`-2147483648`, the longest INT32 in
decimal) and `LB_L1_CHECKSUM` at lines × 2³¹. The engine computes it from the file itself (`tools\LB_CMD.cmd bound`,
and `verify --bound` / `combined` for whole sets); model 2's manifest records it as `bytes_bound_any_values` per shard
and `total_bytes_bound_any_values`. Writing a shard with every value set to `-2147483648` gives a file of exactly the
computed bound (`evidence/size-bound-test.cmd`).

## 5. BYTES shards (the training text)

`data/train_bytes_NN.cmd` and `data/heldout_bytes_NN.cmd` hold the bytes of `train.bin` and `heldout.bin`:

- the comment lines read `rem LK/Vexa LB-CMD/1 data shard: 4 bytes per word, little-endian; the last word of a file is
  zero-padded.` and `rem Do not run it: it only sets variables. tools\MAKE_DATA.cmd unpack writes the original file back.`;
- the header is `LB_FORMAT`, `LB_MODEL=KGD-IMQ-5DLLM-CORPUS`, `LB_SHARD` (`TRAIN00`, `TRAIN01`, `HELDOUT00`),
  `LB_TIER=BYTES`, `LB_DATA_FILE`, `LB_DATA_TOTAL_BYTES`, `LB_DATA_SHA512` (of the whole original file),
  `LB_DATA_OFFSET` and `LB_DATA_BYTES` (this shard's part), then the payload fields of section 1;
- the payload is one family, `LB_BYTES_W`, of byte words, at most 500,000 per shard.

`tools\MAKE_DATA.cmd unpack OUT_FILE SHARD.cmd...` rebuilds a file and checks `LB_DATA_SHA512`.

## 6. Model 1's Tier-2 arithmetic

Model 1's Tier-2 set is computed in float64 with every sum taken in index order, so that any implementation writes the
same words:

- **Block scale.** b_k = (Σ_{j=0..255} |W_{256k+j}|) / 256, the sum taken for j = 0, 1, … from 0.
- **Dual-SVID rank-1 fit** of an r × c matrix R (12 iterations):
  - s_c,j = √(Σ_i |R_ij| / r + 10⁻¹²) with the sum over i = 0, 1, …; v = 1.
  - Each iteration: vs = v ⊙ s_c; d_i = Σ_j R_ij·vs_j (j ascending); u_i = +1 if d_i ≥ 0 else −1;
    s_r,i = |d_i| / (Σ_j vs_j² + 10⁻¹²); us = u ⊙ s_r; e_j = Σ_i us_i·R_ij (i ascending); v_j = +1 if e_j ≥ 0 else −1;
    s_c,j = |e_j| / (Σ_i us_i² + 10⁻¹²).
- **Dual-SVID.** Fit W; take R₂ = W − (s_r ⊙ u)(v ⊙ s_c)ᵀ, element by element; fit R₂; the shared scales are
  0.5(s_r¹ + s_r²) and 0.5(s_c¹ + s_c²).
- Products are rounded before they are added (no fused multiply-add).

## 7. LB-DOC/1 documents

A document is stored after a short cmd header, as the last `LB_DOC_BYTES` bytes of the file:

1. `@echo off`, `setlocal EnableExtensions DisableDelayedExpansion`, and two `rem` lines naming the document and
   saying how to use it.
2. `set "LB_FORMAT=LB-DOC/1"`, `set "LB_DOC=<original file name>"`, `set "LB_DOC_TYPE=<json|text|markdown|sha512sums|lcufx>"`,
   `set "LB_DOC_BYTES=<n>"` and `set "LB_DOC_SHA512=<SHA-512 of the document>"`.
3. A few action lines, then `exit /b %LB_RC%`. cmd.exe stops there, so it never reads the document.
4. `rem ---- document ----`, then the document's bytes exactly (any line endings, UTF-8).

What running the file does depends on the document:

- **JSON, text, Markdown and SHA512SUMS lists** print themselves (Windows PowerShell does the reading). `/check`
  compares the document with `LB_DOC_SHA512`, and `/extract FILE` writes it out byte for byte. Without arguments the
  window waits for a key, so a double-click shows the document.
- **LCUF-X programs** in `lcufx/programs/kgd/` run on the package's host: no argument runs
  `lcufx\LCUFX_KGD.cmd run <program> --twice`, and `check` or `run` can be passed instead.
- **Core LCUF-X/0.2 programs** in `lcufx/programs/core/` run through `tools\RUN_CORE.cmd` on your own compiler
  (`lcuf_x.py`).
- **Reasoning specs** in `examples/` are JSON documents for the reasoning layer (`REASONING-RAILS-8S.cmd`). Running
  one runs `tools\REASON.cmd <operation> <the file>`, the operation being named in its header; up to two arguments,
  such as `--out FILE.cmd`, are passed on.

`tools\DOC.cmd` prints, checks, extracts and packs documents without PowerShell. A `SHA512SUMS.cmd` keeps the
`sha512sum` line format, so `sha512sum -c SHA512SUMS.cmd` works on Linux (it warns about the header lines).

## 8. Set files

- **`manifest.cmd`** (LB-DOC/1, `manifest.json`). It holds the model, tier, config, encoding and the shard list (file,
  bytes, sha512, payload_sha512, payload_lines, l1_checksum). It also holds:
  - `set_sha512`: the SHA-512 of the lines `<file> <sha512>\n` in shard order. This is the value an `lb_load` row pins.
  - `concatenated_sha512`: the SHA-512 of the shards concatenated in that order.
  - `total_bytes`.
- **`SHA512SUMS.cmd`** (LB-DOC/1, `SHA512SUMS.txt`). One `<sha512>  <file>` line per shard.
- **`weights/COMBINED-MANIFEST.cmd`** pins the three sets: `combined_sha512` is the SHA-512 of the lines
  `<set folder> <set_sha512>\n` in the listed order.
- **`PACKAGE-MANIFEST.cmd`** lists the SHA-512 of every file of the repository except itself.

## 9. The engine

`tools\KGD_ENGINE.cmd` is both a cmd script and C# source. Its first line, `// 2>nul & @goto :kgd_engine_cmd`, is a
failed command plus a jump for cmd.exe and a comment for C#; the cmd part sits inside a C# block comment. On first
use the script compiles the file with the C# compiler that comes with Windows
(`%WINDIR%\Microsoft.NET\Framework64\v4.0.30319\csc.exe`, .NET Framework 4, C# 5) into
`%LOCALAPPDATA%\LKVexa\kgd-imq-engine\<SHA-256 of the file>\kgd_engine.exe`, and later runs reuse it. Changing the
file changes its hash, so the next run compiles again. The engine reproduces numpy's random numbers (SeedSequence,
PCG64, bounded integers and the ziggurat normal, with fdlibm's log1p), so `tools\GEN_MODEL1.cmd` and
`tools\GEN_MODEL2.cmd` rewrite the weight sets bit for bit.

## 10. Interpretations made where the note leaves a choice

1. **Scale indices.** SR and SC are separate families, each with its own index space and `_SHIFT` scalar. They are not
   one interleaved scale stream.
2. **Norm vectors.** In Tier-1 and Tier-2 they are Q16.16, one value per word, rather than packed pairs.
3. **Tier-2 reconstruction.** Tier-2 is reconstructed as sign × block scale alone. The Dual-SVID factors travel in the
   same shard, but they are not added into that reconstruction.
4. **Scale range.** U0.16 covers [0, 1), so scales carry a power-of-two `_SHIFT`. That shift is 0 for every scale
   written here.
5. **KGD scalars.** The KGD-IMQ scalars (`_KGD_ALPHA`, `_KGD_C`, `_KGD_W`) are this package's addition; the note has no
   diffusion step. A reader refuses a set whose stored α is outside [0, 1/2] or whose c is not positive.
6. **Model 2's initial scales.** They follow the note's eq. 18. Each row and column scale is √(0.02·√(2/π)) =
   0.12632376, stored as U0.16 8,279, so that their product is E|W| = 0.01595769 for W ~ N(0, 0.02²). The dictionary
   weights are 0, so Tier-1 and Tier-0 compute the same function at initialization.
7. **Two files per block (model 2).** The note writes one `shard_L{ll}.cmd` per layer. Model 2 splits each layer into
   `_ATTN` and `_FFN` files, both still scoped to that layer, so that every file's bound stays under the cap at
   d = 52,224 (largest bound 17,960,298 bytes against 24,000,000).
8. **Model 1 untrained.** Model 1's sets hold its seed-0 initialization (kgd_model.init_params with seed 0: N(0, 0.02²)
   per tensor from numpy's PCG64 seeded by SHA-512("0:name"), norms 1, α = 0.05 and c = 1 before bf16 rounding).
   Nothing has been trained.
