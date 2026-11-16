@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): PROFILE-lkvexa.kgd_imq-0.2.md. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to print the document, with /check to check its SHA-512, or with /extract FILE to write it out.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=PROFILE-lkvexa.kgd_imq-0.2.md"
set "LB_DOC_TYPE=markdown"
set "LB_DOC_BYTES=10449"
set "LB_DOC_SHA512=9e345f3917f0c87800f772a606af9f509bf18ab48dc05fdbdc0b2ed08dde3c8a06f23c2a6bacf6c0d509525764bfde60ff644e423e0e623ad3205fc667930c19"
set "LB_SELF=%~f0"
set "LB_ARG=%~1"
set "LB_OUT=%~f2"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$n=[int]$env:LB_DOC_BYTES;$b=[IO.File]::ReadAllBytes($env:LB_SELF);$o=$b.Length-$n;$h=-join((New-Object Security.Cryptography.SHA512Managed).ComputeHash($b,$o,$n)|%%{$_.ToString('x2')});if($h -ne $env:LB_DOC_SHA512){[Console]::Error.WriteLine('LB-DOC/1: the SHA-512 of '+$env:LB_DOC+' differs from LB_DOC_SHA512');exit 1};if($env:LB_ARG -eq '/check'){'ok: '+$env:LB_DOC;exit 0};if($env:LB_ARG -eq '/extract'){$d=New-Object byte[] $n;[Array]::Copy($b,$o,$d,0,$n);[IO.File]::WriteAllBytes($env:LB_OUT,$d);'written: '+$env:LB_OUT;exit 0};[Console]::OutputEncoding=New-Object Text.UTF8Encoding $false;[Console]::Out.Write([Text.Encoding]::UTF8.GetString($b,$o,$n));exit 0"
set "LB_RC=%errorlevel%"
if "%LB_ARG%"=="" pause
exit /b %LB_RC%
rem ---- document ----
# LCUF-X/0.2 profile extension `lkvexa.kgd_imq/0.2`

Header line: `LCUF-X/0.2+lkvexa.kgd_imq/0.2`. Host reference: `lcufx\LCUFX_KGD.cmd` (version 0.3.0), which runs
`tools\KGD_ENGINE.cmd host`.

Version 0.2 of the profile is version 0.1 plus the reasoning layer RAILS-8S/1 (`REASONING-RAILS-8S.cmd`): eight
operations in the profile column `lkvexa.rails8s`, and dotted keys in `assert_json`. The host of 0.1 was a Python
script (version 0.1.0) and then its port to the package's engine (0.2.0); version 0.3.0 adds the reasoning layer and
keeps the language rules, the modeled costs of the 0.1 operations and the receipt scheme. The host accepts only the
0.2 header.

LCUF-X/0.2 closes its operation set at 21 operations, and none of them loads weights or runs a transformer block. So this
profile has its own header and its own host. The user's compiler (`lcuf_x.py`) refuses these programs (wrong language
header), and this host refuses programs with the core header. Both refusals are recorded as reject programs.

## Program files

A program is LCUF-X source stored in an LB-DOC/1 `.cmd` file (`SPEC-LB-CMD-1.cmd`, section 7): the source is the last
`LB_DOC_BYTES` bytes of the file, and `LB_DOC_SHA512` is its SHA-512. The host checks that hash, then reads the source; a
file with no LB-DOC/1 marker line is read as plain source. Running a program file in `lcufx\programs\kgd\` runs it on this
host (`run --twice`).

## What is kept from LCUF-X/0.2

- **Source shape.** The source is UTF-8 (a BOM is allowed), at most 1 MiB, and `#` lines are comments. The order is: the
  `module` line first, then `site NAME trust= memory= steps=` and `grant NAME caps=` declarations, then the twelve-column
  header (`id | site | profile | op | inputs | output | type | effects | caps | after | budget | evidence`). After that
  come at most 1,024 rows and a final `end`.
- **Dataflow.** Each output has one writer, and every producer is typed. Inputs and `after` define the dependency DAG,
  which must be acyclic. Rows are scheduled lexically-first among the ready rows.
- **Effects and capabilities.** These are checked exactly per operation, and every capability must be granted to the
  row's site. `emit` needs `evidence.emit` / `evidence.write` and `evidence=receipt`.
- **Work reservations.** Each row's `budget` must be at least the host's modeled minimum work for that row. A site's
  `steps` must be at least the sum of its rows' budgets. A site's `memory` must be at least its retained payload plus its
  peak modeled scratch.
- **Receipts.** Rows marked `receipt` extend a hash chain: each receipt holds the previous receipt's hash and the
  digest of the row's result.

## What differs

- **Receipt hash.** Receipts use SHA-512, where the core host uses SHA-256. The scope is `LCUF_X_KGD_HOST_RESEARCH`.
- **One site only.** A value cannot cross sites, because this profile has no fabric or link transfer.
- **Types:** `i64`, `f64`, `text`, `unit`, `Tokens[T]`, `Hidden[T,d]`, `Logits[T,V]`, `WeightSet[label]`, `Port[label]`.
- **Weight-set pinning.** `lb_load` checks the pin twice:
  - at admission, it reads the set's `manifest.cmd` and requires its `set_sha512` to equal the pinned hash;
  - at load, it checks every shard's SHA-512 again.
- **Host pinning.** The compiled program (its IR) records the host version and the SHA-512 of `tools\KGD_ENGINE.cmd`, so
  the semantic hash of a program, and with it every receipt, changes when the engine changes.

## Operations

| op | profile | inputs | output | effects / caps |
|---|---|---|---|---|
| `const` | lcuf.scalar | a JSON literal in the inputs cell | i64, f64 or text | - |
| `emit` | lcuf.evidence | any value | unit (`-`) | evidence.emit / evidence.write |
| `assert_eq` | lcuf.test | two values of one type | unit | - |
| `assert_close` | lkvexa.test | f64, f64, f64 tolerance | unit | - |
| `assert_le` | lkvexa.test | f64, f64 | unit | - |
| `assert_json` | lkvexa.test | text report, const text of expected keys (a `{"center","tolerance"}` object for a range; a key may be a dotted path such as `rail_III.admitted`) | unit | - |
| `lb_load` | lkvexa.weights.cmd | const text manifest path (relative to the program), const text set SHA-512, const text tier `exact`, `tier2`, `tier1` or `tier0` | WeightSet | weights.read / weights.read |
| `tokens_utf8` | lkvexa.bytes | const text | Tokens[byte length] | - |
| `embed` | lkvexa.llm | Tokens[T], WeightSet | Hidden[T,d] (embedding × √d) | - |
| `attn_block` | lkvexa.llm | Hidden, WeightSet, const i64 layer | the same Hidden type | - |
| `kgd_imq_step` | lkvexa.kgd_imq | Hidden, WeightSet, const i64 layer | the same Hidden type | - |
| `ffn_block` | lkvexa.llm | Hidden, WeightSet, const i64 layer | the same Hidden type | - |
| `head` | lkvexa.llm | Hidden[T,d], WeightSet | Logits[T,V] | - |
| `next_token_ce` | lkvexa.llm | Logits[T,V], Tokens[T] | f64 (mean over T−1 positions) | - |
| `greedy_bytes` | lkvexa.llm.decode | Tokens, WeightSet, const i64 n | text | - |
| `port_build` | lkvexa.port | const text `default` (MinimalLLM's shape at the pin) or JSON overrides, const i64 seed | Port | - |
| `port_count` | lkvexa.port | Port, const text `all`, `muon` or `adamw` | i64 | - |
| `port_forward_report` | lkvexa.port | Port, const text `{"ids": [[...]]}` | text (JSON) | - |
| `port_first_update` | lkvexa.port | Port, const text `{"ids": [[...]]}` | text (JSON) | - |
| `port_loop_probe` | lkvexa.port | const text config, const i64 train_tokens, const i64 nan_step | text (JSON) | - |
| `port_step_account` | lkvexa.port | const i64 train_tokens, const i64 batch_size, const i64 max_seq_len | text (JSON) | - |
| `rails_bayes` | lkvexa.rails8s | const text spec | text (JSON report) | - |
| `rails_admit` | lkvexa.rails8s | const text spec | text (JSON report) | - |
| `rails_meanfield` | lkvexa.rails8s | const text spec | text (JSON report) | - |
| `rails_parity` | lkvexa.rails8s | const text spec, f64, f64, f64 | text (JSON report) | - |
| `rails_witness` | lkvexa.rails8s | WeightSet (from `lb_load` or `bytes_unigram`), const text spec | text (JSON report) | - |
| `rails_codelen` | lkvexa.rails8s | WeightSet with V = 256 (from `lb_load`) or from `bytes_unigram`, const text | text (JSON report) | - |
| `bytes_unigram` | lkvexa.rails8s | const text JSON list of BYTES shard paths (relative to the program), const text SHA-512 of the original file, const f64 α > 0 | WeightSet | weights.read / weights.read |
| `json_f64` | lkvexa.rails8s | text report, const text key (dotted path) | f64 | - |

`kgd_imq_step` applies, with z = h / rms(h):

- the causal kernel K_ij = (c² + ‖z_i − z_j‖² / d)^(−1/2) for j ≤ i;
- the row-normalized operator P = D⁻¹K;
- the update h ← (1 − α)h + αPh.

It refuses a block whose stored α is outside [0, 1/2] or whose c is not positive. The bound is the same [0, 1/2]
stability gate that LCUF-X/0.2 applies to `diffuse_step`. The core program `accept_kgd_alpha_gate` passes the stored α
values to the user's own compiler.

The `rails_*` operations are specified in `REASONING-RAILS-8S.cmd`: what each spec holds, how the reports are laid
out on four rails, and when an operation refuses. A refusal (for example `rails_meanfield` without a contraction
certificate, or `rails_parity` without a majority) rejects the program at evaluation, like a failed assertion.
`bytes_unigram` is pinned like `lb_load`: at admission the host reads each shard's header and requires its
`LB_DATA_SHA512` to be the pinned hash; at load it rebuilds the original file and hashes it again. A WeightSet from
`bytes_unigram` has no layers, so `embed`, `attn_block`, `kgd_imq_step`, `ffn_block`, `head` and `greedy_bytes`
refuse it.

## Modeled work (abstract units, as in the core host)

The table uses this notation:

- T is the number of positions;
- m(r,c) is the cost of applying one matrix: r·c for the exact and Tier-2 views, rank·(r+c) for Tier-0 (rank 2) and
  Tier-1 (rank ≤ 10);
- V is the vocabulary;
- n is the parameter count of a port;
- w is the work of one position through the whole model: layers·(m(2d+2kv, d) + m(d_ff, d) + m(d, d_ff)) + the embedding operator cost.

| op | minimum work | peak scratch (bytes) |
|---|---|---|
| lb_load | the set's total bytes | 0 |
| embed | T·d (exact, Tier-2), T·d·rank (factored) | 4Td |
| attn_block | T·m(2d+2kv, d) + 2·H·T²·d_k | 4HT² + 12Td |
| kgd_imq_step | 3·T²·d | 8T² + 8Td |
| ffn_block | T·(m(d_ff,d) + m(d,d_ff)) | 8T·d_ff |
| head | T·(embedding operator cost) | 4TV |
| next_token_ce | T·V | 8TV |
| greedy_bytes | n × (one full forward pass at the grown length) | 4(T+n)V + 4H(T+n)² |
| port_* | n (build), 2n·tokens (forward), 6n·tokens (first update), 6n·tokens·steps (loop), steps (account) | 4n (build), 16n (first update) |
| const, emit, assertions, tokens_utf8, port_count, json_f64 | 1 | 0 |
| rails_bayes | K·(E + 1) + E²·D + 1, for K hypotheses, E evidence items and D distinct tags (at least 1) | 8(K + E·D) + 64 |
| rails_admit | n²·D + n, for n items with codes of dimension D (at least 1) | 8n·D |
| rails_meanfield | I·n² + 2ⁿ·n², for n claims and I = max_iters (default 10,000) | 8(2ⁿ + n²) |
| rails_parity | 3 | 0 |
| rails_witness | model: (Σₖ (P + Lₖ) + C)·w; unigram: Σₖ Lₖ + C + 1 (prompt P, candidates Lₖ, calibration C bytes) | model: 4·T·V + 4H·T², T the longest sequence; unigram: 2,048 |
| rails_codelen | model: (n + n(n − 1)/2)·w + 512n; unigram: 512n + 1 (n bytes) | model: 4n·V + 4H·n²; unigram: 2,048 |
| bytes_unigram | the shards' total bytes | the original file's bytes + 2,048 |

The accept programs in `lcufx\programs\kgd\` (written by `tools\MAKE_PROGRAMS.cmd`) reserve exactly these minimums, and
each site reserves exactly the sum of its rows' work and its payload plus peak scratch. A `rails_*` report counts as
4,096 bytes of retained payload, and a unigram WeightSet as 2,048. `reject_m1_work_underreserve`
lowers one reservation by one unit and is refused.

## CLI

```
lcufx\LCUFX_KGD.cmd check PROGRAM.cmd    (static admission only: reads manifests, computes no tensor)
lcufx\LCUFX_KGD.cmd run PROGRAM.cmd [--twice]
```

The exit code is 0 when the program is admitted and every assertion passes, and 2 when it is rejected. With `--twice`
the host evaluates the program a second time and requires the same receipt chain head. `run` never executes a weight
shard: shards are read as text.
