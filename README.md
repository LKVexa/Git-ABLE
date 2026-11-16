# LK/Vexa KGD-IMQ 5-Dollar LLM, `.cmd` edition: an LCUF-X/0.2 build with SHA-512 LittleBit `.cmd` weights

> **Both models in this repository are untrained.** Model 1's weights are its seed-0 initialization and model 2's are
> its seed-2026 initialization. Neither has taken a training step, so what they compute is the output of random
> weights: model 1's cross-entropy on held-out text is 5.60 nats per byte, close to the 5.55 of a uniform guess, and its
> greedy continuation of a prompt is 64 spaces. No training run, trained weights or training results are included.

This package was built on 2026-11-15 for P00012. It contains:

- two models of the 5-dollar-llm architecture (pinned at `7eaa920315a7ef513f9b0ef3be99cdcfa6cf5d88`), each with a
  Kernel Geometric Diffusion step (KGD-IMQ) in every block;
- their weights as LittleBit `.cmd` shards, laid out by the technical note TN-2026-LB-CMD-WEIGHTS-5DLLM-8S, with SHA-512
  at the shard, set and payload levels;
- programs that run both models, written in LCUF-X/0.2 and in a profile extension of it;
- **a four-rail reasoning layer, RAILS-8S/1**, built from MacKay's *Information Theory, Inference, and Learning
  Algorithms* and the four-rail 8S apparatus of the *Corpus Compendium on Rails* (see "The reasoning layer" below);
- the engine that writes, checks and runs all of it, as a `.cmd` file.

**Everything is `.cmd`.** Every file is a Windows command script except this `README.md` and `.gitattributes`, and no
file is larger than 24,000,000 bytes (the largest is 17,765,711). The files are of three kinds:

- **shards**: the weights and the training text as `set "NAME=VALUE"` lines;
- **documents**: JSON, Markdown, SHA512SUMS lists, LCUF-X programs and reasoning specs, each stored after a short cmd
  header. Running a document prints it; running a program or a reasoning spec runs it;
- **tools**: cmd scripts. `tools\KGD_ENGINE.cmd` is also the C# source of the engine, which Windows' own C# compiler
  builds on first use.

Nothing else is needed on Windows 10 or 11: no Python, numpy or PyTorch. The one exception is the four `core` programs,
which run on your own LCUF-X/0.2 compiler (`lcuf_x.py`), a Python program.

**Combined weight set.** The three sets together are 1,022,600,943,692 nominal parameters in 932,564,172 bytes
(shards, manifests and checksum lists):

- model 1's exact and Tier-2 sets, two encodings of the same untrained model;
- model 2's Tier-1 set, with 1.02 trillion nominal parameters.

`weights\COMBINED-MANIFEST.cmd` pins all three with one SHA-512, `eae0ff8c…f054a6`. All weight files together stay under
1,000,000,000 bytes, and every file stays under 24,000,000 bytes, for any values training could produce. The bound is
989,174,756 bytes in total, and the largest file's bound is 17,960,298. See "Will the files grow if the weights are
trained?" below.

## The two models

| | model 1 (untrained) | model 2 (capacity build, untrained) |
|---|---|---|
| shape | vocabulary 256 (bytes), d 256, 4 blocks, 4 heads, 2 KV heads, d_ff 1,024, context 128 | vocabulary 49,152 (16 clusters of 3,072 rows), d 52,224, 34 blocks, 816 heads, 408 KV heads, d_ff 208,896 |
| parameters | 2,951,944 (8 of them KGD scalars) | 1,022,597,991,748 nominal |
| weights now | seed 0: N(0, 0.02²) per tensor, norms 1, KGD α = 0.05 and c = 1 before bfloat16 rounding | seed 2026: random sign factors, the note's eq. 18 scales, dictionary weights 0, norms 1, KGD α = 0.05 and c = 1 |
| encodings | exact bfloat16 (`exact\`) and a Tier-2 view (`tier2\`) | Tier-1, which contains the Tier-0 subset |
| `.cmd` bytes now | 54,525,494 in 5 shards, largest 13,359,681 (exact); 3,797,790 (Tier-2) | 874,173,645 in 70 shards (two per block, plus two for the embedding), largest 16,959,468 |
| `.cmd` bytes, bound for any values | 55,402,282, largest 13,573,684 (exact); 3,944,956 (Tier-2) | 929,758,995, largest 17,960,298 |
| set SHA-512 | `2824a03d…3fb627` (exact), `555eb9eb…157499` (Tier-2) | `89485985…d0cb77` |

The full set hashes are in each set's `manifest.cmd` (`set_sha512`) and in `weights\COMBINED-MANIFEST.cmd`.

**KGD-IMQ step.** After the attention residual of each block, the hidden state is updated as

  h ← (1 − α)h + α·D⁻¹K h,  with K_ij = (c² + ‖z_i − z_j‖²/d)^(−1/2) for j ≤ i and z = h / rms(h).

α = sigmoid(a)/2 always lies in [0, 1/2], which is LCUF-X/0.2's stability gate for diffusion steps. c = softplus(b). In
model 1 the stored values are α = 3,259/65,536 ≈ 0.0497 and c = 65,604/65,536 ≈ 1.0010 in every block (0.05 and 1
before the raw a and b are rounded to bfloat16). Everything else follows MinimalLLM at the pin:

- embedding × √d, pre-norm blocks;
- merged qkvo, per-head q/k RMSNorm, interleaved RoPE (base 10,000), GQA, causal attention;
- squared-ReLU FFN, final RMSNorm, tied head;
- initialization N(0, 0.02²).

**Model 2** keeps at least 10¹² nominal parameters while the combined set stays under 1 GB for any values training could
produce. Its parameters are nominal: each matrix stores 26(r + c) bits, not r·c values. The whole set holds 24,525,536
words, or 784,817,152 bits, about 98 MB if packed in binary; the decimal `set` lines account for the rest of the
874 MB. Every matrix has rank ≤ 10 (Tier-1) or ≤ 2 (Tier-0). At initialization the dictionary weights are 0, so both
tiers compute the same rank-2 function.

Each block is stored as two layer-scoped files: `shard_L{ll}_ATTN.cmd` (qkvo, the attention norms and the KGD scalars)
and `shard_L{ll}_FFN.cmd` (up, down and the FFN norm). That split is what keeps d at 52,224 under the per-file cap for
any values. With one file per block, the width would have to drop to about 49,000, and 1 GB would then hold only about
0.96 trillion parameters.

**Training text.** `data\` holds the text these models were meant to be trained on, as LB-CMD/1 BYTES shards: this
project's own material (`data\corpus-manifest.cmd`), the deliverables' Markdown, the pair files, the language documents
and the technical note's text. Neither model has been trained on it. The split is by document: 3,728,629 bytes for
training (`train_bytes_00.cmd`, `train_bytes_01.cmd`) and 381,629 held out (`heldout_bytes_00.cmd`). Much of the
material recurs from document to document, so the held-out text is mostly not new: 269,043 of its 381,582 48-byte
windows (70.5%) also occur verbatim in the training text (`evidence\heldout-overlap.cmd`). The 96-byte window of the
forward programs and the 48-byte window of the parity and code-length programs are among them; the 64-byte
calibration text of the witness gate is not. With untrained models no conclusion here depends on this, but measuring
a trained model needs a split without such repeats.

## The reasoning layer (RAILS-8S/1)

`REASONING-RAILS-8S.cmd` specifies it in full. The layer draws conclusions from numbers, whether they come from a
model, from the training text or from a worked example, and reports each conclusion on the compendium's four rails:

- **Rail I, the statement**: the question, the hypotheses or candidates, and the answer, or an abstention;
- **Rail II, the computation** in the domain where it is exact (log probabilities, log-odds, code lengths, checks
  over F2), with a status from the compendium's taxonomy: exact linear, exact linear over F2, exact in logs,
  linearised, structural analogue, or no faithful linear form;
- **Rail III, admission by the 8S law**: an entry is admitted only if it is independent of what is already admitted
  (a rank-increment test) and if it gains information, in bits;
- **Rail IV, robustness**: decision margins, three routes to one number checked like a repetition code, error
  bounds measured against exact computations;
- **the retraction**: what the report would say with every gate off. It holds by construction, so it is reported
  but never counted as evidence, as the compendium's revised edition insists.

Decisions follow MacKay's decision theory with a cost for wrong answers: the layer answers only when the posterior
of the best hypothesis exceeds λ/(1 + λ), and abstains otherwise.

What this does on this package, with untrained models:

- **The gate stops an untrained model from answering.** Asked whether "Information theory and " continues with
  "inference" or "qzxjvkwbp", model 1 codes held-out text at 8.11 bits per byte, worse than the 8 of a uniform guess.
  It is not admitted as a witness, and the layer abstains. Without the gate, its likelihoods alone would have given
  "qzxjvkwbp" a posterior of 0.92. The byte unigram of the training text, admitted as a positive control (5.37 bits
  per byte), answers "inference".
- **Evidence is not counted twice.** Jo's positive test (MacKay (2.16)–(2.18)) entered twice with the same
  provenance is admitted once: the posterior stays at 19/118 ≈ 0.16, where the plain product gives 0.78.
- **Three routes to one number.** Model 1's cross-entropy from the host's forward pass, from the engine's dense
  reference (a separate implementation) and from an arithmetic coder agree within 10⁻⁴. The coder reuses the host's
  kernels on every decoded prefix and matched the forward pass bit for bit. The coder run on the Tier-2 view, a
  different model, is outvoted, and when no two routes agree the layer refuses the value.
- **Approximations come with a certificate.** Coupled claims are combined by the 8S gate layer only when a
  contraction bound guarantees one fixed point, and the result is checked against exact enumeration.
- **MacKay's worked numbers are reproduced** (`tools\REASON.cmd selftest`, 20 checks): Jo's 0.16 as printed in
  (2.18), the repetition code's posterior 0.9 and its bit error 3f² − 2f³ = 0.028 at f = 0.1, the capacity
  1 − H₂(0.1) = 0.531, Oliver's likelihood ratios 0.83 and 50 as printed in (3.26)–(3.27), Laplace's rule (3.16), and
  the (7,4) Hamming code correcting all 112 single-bit errors.

## Repository

| path | contents |
|---|---|
| `README.md`, `.gitattributes` | this file; no end-of-line conversion, so that every SHA-512 holds after a checkout on Windows |
| `PACKAGE-MANIFEST.cmd` | the SHA-512 of every other file |
| `SPEC-LB-CMD-1.cmd` | the file formats: LB-CMD/1 shards, LB-DOC/1 documents, the engine |
| `PROFILE-lkvexa.kgd_imq-0.2.cmd` | the LCUF-X/0.2 profile extension and its host, including the reasoning operations |
| `REASONING-RAILS-8S.cmd` | the reasoning layer: rails, statuses, gates, decisions, evidence rules, operations, limits |
| `tools\` | `KGD_ENGINE.cmd` (the engine) and the scripts that call it, among them `REASON.cmd`; `VERIFY_WEIGHTS.cmd` (certutil only); `ENGINE-SELFTEST.cmd` |
| `lcufx\LCUFX_KGD.cmd` | the host of the profile |
| `lcufx\programs\kgd\`, `lcufx\programs\core\` | 22 programs for the host (11 of them for the reasoning layer), 4 for your `lcuf_x.py`; `programs-made.cmd` records how they were made and where their expected values come from |
| `examples\` | six reasoning specs; running one runs the reasoning layer on it |
| `weights\` | `COMBINED-MANIFEST.cmd`; `model1-untrained\exact\`, `model1-untrained\tier2\` (with `export_report.cmd`); `model2-tier1\` |
| `data\` | the training text as BYTES shards, and `corpus-manifest.cmd` |
| `evidence\` | the verification, the checks, the program runs and the held-out overlap behind the results in this file |

Each weight set folder has its shards, a `manifest.cmd` and a `SHA512SUMS.cmd`. Every file is under 24,000,000 bytes,
well below GitHub's 100 MB per-file limit.

## Use

Run these from the repository folder in a Command Prompt, on 64-bit Windows 10 or 11. The engine needs the C# compiler
of .NET Framework 4, `%WINDIR%\Microsoft.NET\Framework64\v4.0.30319\csc.exe`, which is part of both. The first command
compiles `tools\KGD_ENGINE.cmd` (a few seconds) into
`%LOCALAPPDATA%\LKVexa\kgd-imq-engine\<SHA-256 of the file>\kgd_engine.exe`, and later commands reuse it; delete that
folder to remove it. `tools\VERIFY_WEIGHTS.cmd` needs only certutil.

```
tools\VERIFY_WEIGHTS.cmd weights\model2-tier1 <SHA-512 of its SHA512SUMS.cmd, from the table at the end>
tools\LB_CMD.cmd combined weights\COMBINED-MANIFEST.cmd --cap 24000000 --total-cap 1000000000
tools\LB_CMD.cmd verify weights\model2-tier1\manifest.cmd --cap 24000000 --bound
tools\PACKAGE.cmd verify .
tools\KGD_ENGINE.cmd selftest tools\ENGINE-SELFTEST.cmd
lcufx\LCUFX_KGD.cmd run lcufx\programs\kgd\accept_m1_exact_decode.cmd --twice
tools\REASON.cmd selftest
tools\REASON.cmd witness examples\rails-witness-model1.cmd
tools\RUN_ALL.cmd . %TEMP%\kgd-rerun
tools\RUN_ALL.cmd . %TEMP%\kgd-rerun --only accept_kgd_alpha_gate --core <your LCUF_RESEARCH_CORPUS_0.2.0>\extensions
```

`tools\RUN_ALL.cmd` took 3 to 6 minutes on the test PC, most of it in the port source checks and the two model 2
programs. Write reruns outside the repository folder, as above: `tools\PACKAGE.cmd verify` reports any file that is
not in `PACKAGE-MANIFEST.cmd`.

- **Weight shards.** Do not run them: each one only sets environment variables (up to 476,564 `set` lines in a model 2
  shard). The tools read them as text.
- **Documents.** Run one to read it: `SPEC-LB-CMD-1.cmd` prints the format specification, and
  `weights\model2-tier1\manifest.cmd` prints that manifest (Windows PowerShell does the printing). `/check` checks a
  document against its SHA-512, and `/extract FILE` writes it out. `tools\DOC.cmd print FILE.cmd` and
  `tools\DOC.cmd extract FILE.cmd OUT` do the same through the engine.
- **Programs.** Running a program in `lcufx\programs\kgd\` runs it on the host twice and prints the result. A program
  in `lcufx\programs\core\` runs on your own compiler: set `LCUF_X_DIR` to the folder of your `lcuf_x.py` (your
  `LCUF_RESEARCH_CORPUS_0.2.0\extensions`), or pass it, as in
  `tools\RUN_CORE.cmd run lcufx\programs\core\accept_kgd_alpha_gate.cmd <folder>`. That compiler needs Python
  (`python` on PATH, or `LCUF_PYTHON`).
- **Reasoning.** `tools\REASON.cmd bayes|admit|meanfield|parity|witness|codelen SPEC` runs one operation of the
  reasoning layer on a spec, given as a JSON file or as a `.cmd` document like those in `examples\`; the fields are
  listed in `REASONING-RAILS-8S.cmd`. Running a file in `examples\` does the same for that example.
- **Training text.** `tools\MAKE_DATA.cmd unpack %TEMP%\train.bin data\train_bytes_00.cmd data\train_bytes_01.cmd`
  writes the original `train.bin` back and checks its SHA-512.

To rebuild everything from the seeds, run:

1. `tools\GEN_MODEL1.cmd weights\model1-untrained` (seed 0);
2. `tools\GEN_MODEL2.cmd weights\model2-tier1 --d 52224 --layers 34 --seed 2026 --split`;
3. `tools\MAKE_COMBINED.cmd weights`;
4. `tools\MAKE_PROGRAMS.cmd .`;
5. `tools\RUN_ALL.cmd . evidence`, then `tools\CHECKS.cmd` and `tools\LB_CMD.cmd verify ... --out` for the rest of
   `evidence\` (`evidence\heldout-overlap.cmd`, computed in Python, and `evidence\superseded\` are records, not
   rebuilt);
6. `tools\PACKAGE.cmd write .`.

Steps 1 to 4 rewrite the committed files bit for bit; step 2 took about 100 s on the PC this edition was tested on.
The records of step 5 include run times, so they differ from run to run.

## Will the files grow if the weights are trained?

The number of weights never changes: it is set by the shapes and the tier, and training only changes values. A `.cmd`
line writes each 32-bit word as decimal text, from 1 character (`0`) to 11 (`-2147483648`), so a file's size moves
with its values.

- **Model 1's exact set** holds bfloat16 pairs, whose words already have 10 or 11 characters, so its files are within
  2% of their bound now.
- **Model 2** starts at short values:
  - every scale word is `542580823`, 9 characters;
  - every norm is `65536`, 5 characters;
  - every dictionary weight is `0`.

The bound used here is each file's size with every value at 11 characters and its L1 checksum at its maximum. It is
the most any training could add. `tools\LB_CMD.cmd verify --bound` and `tools\LB_CMD.cmd combined` compute it from the
files themselves. Writing one worst-case shard and measuring it reproduced the computed bound exactly (87,800 bytes for
model 1's Tier-2 embedding shard, `evidence\size-bound-test.cmd`). The combined bound fits under 1,000,000,000 bytes with
10,825,244 to spare (`evidence\verify-combined.cmd`, `evidence\size-drift.cmd`).

## Results

### Programs

`evidence\programs-summary.cmd`. All 22 programs on this package's host behaved as expected: 16 were accepted with
every assertion passing, and 6 were refused. The 4 core programs were not run for this edition: they need your
`lcuf_x.py`.

| program | result |
|---|---|
| kgd/accept_m1_exact_forward | cross-entropy 5.5983 on a 96-byte held-out window, against ln 256 = 5.5452 for a uniform guess; matches the engine's dense forward within 10⁻⁴ |
| kgd/accept_m1_tier2_forward | 5.5480 on the same window; matches within 10⁻⁴ |
| kgd/accept_m1_exact_decode | the greedy continuation of "LCUF-X/0.2 admits " is 64 spaces: the untrained model picks the same byte at every step |
| kgd/accept_m2_tier1_forward, accept_m2_tier0_forward | 17.0703 on 8 bytes, the same for both tiers (a_p = 0); ln 49,152 = 10.8027. 20 to 65 s per program on the test PC for its two evaluations (`--twice`), mostly reading 874 MB of text |
| kgd/accept_port_source_checks, accept_port_loop | see "Getting around PyTorch" below. The source checks took 1.8 to 3.4 minutes on the test PC: two evaluations of an 88.6M-parameter forward pass and first update |
| kgd/reject_m1_work_underreserve | refused: "kernel work reservation below modeled minimum (23592959 < 23592960)" |
| kgd/reject_m1_wrong_pin | refused: "weight set SHA-512 is not the pinned one" |
| kgd/reject_m2_tier2_unavailable | refused: "tier TIER-2 is not available in a TIER-1 set" |
| kgd/reject_core_header_at_kgd_host | refused: "required header LCUF-X/0.2+lkvexa.kgd_imq/0.2" |
| kgd/accept_rails_bayes_disease | Jo's test (2.16)–(2.18): posterior 19/118, within 0.005 of the printed 0.16; the same result entered again is not admitted (the ungated posterior would be 0.785) |
| kgd/accept_rails_bayes_r3 | the repetition code (1.18)–(1.23), f = 0.1, received 011: P(s = 1) = 0.9, likelihood ratio 9; all three bits admitted |
| kgd/accept_rails_bayes_oliver | Oliver's blood (3.24)–(3.27): posterior 0.4545 and the answer "absent" with a flip factor of 1.2; the same evidence with λ = 4 abstains; a suspect of type AB gets 50/51 |
| kgd/accept_rails_admit_steps | six reasoning steps: a step that restates two others and a near-duplicate fail the independence gate, a step without gain fails the gain gate; rank 3 |
| kgd/accept_rails_meanfield_certified | three coupled claims: κ = 0.45 < 1, exact marginals 0.748, 0.452 and 0.581 by enumeration, mean field within 0.011 of them |
| kgd/reject_rails_meanfield_uncertified | refused: "no contraction certificate: kappa = 1.25 >= 1 ..." |
| kgd/accept_rails_witness_m1_abstains | model 1 is not admitted as a witness (8.11 bits per byte on held-out text) and the layer abstains |
| kgd/accept_rails_witness_unigram | the unigram of the training text is admitted (5.37 bits per byte) and answers "inference" |
| kgd/accept_rails_parity_m1 | three routes to model 1's cross-entropy agree (syndrome 000); the Tier-2 route is outvoted (syndrome 011); the arithmetic coder decodes the text back, with a code 0.58 bits longer than the quantised ideal (the bound is 2 bits) |
| kgd/reject_rails_parity_no_majority | refused: "no majority among the three routes (pairwise checks ab, bc, ac = 111)" |
| kgd/accept_rails_codelen_unigram | the unigram codes the same 48 bytes in 218 bits (4.54 bits per byte, against 384 bits for the uniform code) and decodes them back |
| core/accept_kgd_alpha_gate | for your `lcuf_x.py`: the stored α of model 1's four blocks (3,259/65,536) and of model 2 (3,277/65,536) against `diffuse_step`'s [0, 1/2] gate |
| core/reject_kgd_alpha_q16_step_above_half | for your `lcuf_x.py`: α = 32,769/65,536, the first Q16.16 value above 1/2, should be refused |
| core/accept_littlebit_block_sign | for your `lcuf_x.py`: your sign codec on 256 weights of model 1 (L00.qkvo row 0, columns 0–255, one Tier-2 block of g = 256) |
| core/reject_kgd_imq_profile_at_core_compiler | for your `lcuf_x.py`: the extension program should be refused for its header |

### Checks

- **Reasoning layer.** `tools\REASON.cmd selftest` reproduces MacKay's worked numbers and checks the gates, the
  coder and the mean field against independent values: 20 checks, all passing (`evidence\rails-selftest.cmd`).
- **Engine.** `tools\KGD_ENGINE.cmd selftest` reproduces numpy's SeedSequence, PCG64, bounded integers and ziggurat
  normals, and CPython's float repr and JSON output, value for value (`tools\ENGINE-SELFTEST.cmd`,
  `evidence\engine-selftest.cmd`). `tools\GEN_MODEL1.cmd`, `tools\GEN_MODEL2.cmd` and `tools\MAKE_DATA.cmd` rewrote all
  83 shard files (10 for model 1, 70 for model 2, 3 of text) bit for bit against a numpy reference build.
- **Weights.** Every set passes `tools\LB_CMD.cmd verify`: the SHA-512 of every shard, its payload hash, line count
  and L1 checksum, and every payload line read as a 32-bit word in index order. Every shard also matches its
  `SHA512SUMS.cmd` line under `tools\VERIFY_WEIGHTS.cmd`, which uses certutil alone (`evidence\verify-*.cmd`).
- **Gradients.** The backward pass agrees with central differences within a relative error of 2.4 × 10⁻⁶ on a small
  model with the KGD step (`evidence\grad_check.cmd`; threshold 10⁻⁵).
- **Factored path.** The path that model 2's programs use agrees with dense expansions within 1.9 × 10⁻⁷ with non-zero
  dictionary weights. A small set written in model 2's format agrees with the dense forward within 4.8 × 10⁻⁷ on every
  logit, for Tier-1 and Tier-0 (`evidence\validate-factored.cmd`).

## Getting around PyTorch with LCUF: what the port-level checks show

The `port_*` operations run the engine's port of MinimalLLM (with the KGD step switched off) at the source's own
configuration. They cover these checks that the workspace's validation plan (C089) could not run without PyTorch:

| check | expected | port result |
|---|---|---|
| C2 parameter count: all / Muon / AdamW | 88,630,528 / 63,438,848 / 25,191,680 | the same three numbers |
| C3 forward on the 2 × 16 fixture ids | logits (2, 16, 49,152); 30 scored positions; loss 10.905 ± 0.25 | (2, 16, 49,152); 30; 10.9579 |
| C4 first update with warm-up 1 | every weight unchanged | largest change 0.0 over 156 tensors (66 Muon, 90 AdamW) |
| step and token account, 8 × 2,048 per batch | not stated in C089 | 489 updates over 8,011,776 tokens for an 8M budget, against an estimate of 488. Likewise 1,221 / 1,220 for 20M, 6,104 / 6,103 for 100M and 61,036 / 61,035 for 1B |
| a NaN loss at step 50 of a 151-step tiny run | not stated in C089 | the loop ran to its token budget, with no check stopping it. The weights were non-finite from then on, the step-100 loss read is NaN, and 101 of the 151 losses are non-finite |

The C3 loss, 10.95789334, agrees with that of the numpy port in the package's earlier Python edition, 10.95789338,
within 4 × 10⁻⁹ relative. These are port-level results. They show that the architecture and the training recipe, as reimplemented from the
pinned code, give the expected numbers. They are not runs of the PyTorch code. In the NaN probe, every gradient is set
to NaN, so `torch.nn.utils.clip_grad_norm_`'s own NaN handling is not exercised. The following remain open and need
PyTorch:

- C1 (import);
- C5 (seeded DataLoader order);
- C6 (the `benchmarks` import failure);
- C7 (the over-length rotary error, which is torchtune's behaviour);
- the `_orig_mod.` prefix of compiled checkpoints;
- anything at the source's GPU scale.

## Limits

- **Both models are untrained.** Their outputs carry no meaning. Training model 2 would need a GPU-scale run and
  probably a width-aware initialization: at this width its eq. 18 scales (8,279 in U0.16) give a starting loss of 17.07
  rather than ln V = 10.80.
- **Model 2's parameter count is nominal.** Every matrix is rank ≤ 2 at initialization (≤ 10 once the dictionary
  weights become non-zero), and each cluster's 3,072 embedding rows span only two directions.
- **The extension profile** (`LCUF-X/0.2+lkvexa.kgd_imq/0.2`) is my addition. Your compiler refuses it by design. Only
  the four `core\` programs run on your `lcuf_x.py`, and they were not run for this edition.
- **The reasoning layer** cannot make an untrained model useful: on this package every model witness is rejected, so
  its answers come from worked examples and from the unigram positive control, which ignores the prompt. It trusts
  the likelihoods it is given and sees only the provenance it is told about. It takes at most 16 coupled claims, so
  that every mean-field answer is checked exactly. Like any repetition code, it cannot tell two routes that are
  wrong in the same way from two right ones. Its witness gate is only as good as its calibration text, which must
  not be in the witness's training text. Of the compendium's 8S apparatus it uses the independence gate, the admission
  rule with its gain, the mean-field gate layer with its contraction bound, and the retraction; the couplings of claims
  are given by the caller rather than computed with the 8S kernels, and the quantised base, the phase layer, the
  radius map, the S³ fibre and the projection have no counterpart in it.
- **The held-out text is mostly not new.** 70.5% of its 48-byte windows also occur in the training text (see
  "Training text"); a trained model would need a deduplicated split before its held-out numbers could measure
  generalisation.
- **One test machine.** The engine and the scripts were run on one Windows PC. Receipts hash the exact bits of each
  result, and .NET may compute `exp` and `log` differently in the last bit on another CPU or runtime. A rerun elsewhere
  can therefore give other receipt hashes; the assertions themselves have tolerances.
- **The `.cmd` format** follows the note, with the interpretations listed in `SPEC-LB-CMD-1.cmd`. The two-file split
  of each block is a departure from the note's one `shard_L{ll}.cmd` per layer.
- **Superseded model 2 builds.** Records from the package's earlier Python edition are kept as documents in
  `evidence\superseded\`; the tools they name are not part of this edition.
  - The first build used E|W| itself as each row and column scale, where the note's eq. 18 takes its square root.
  - The second (37 blocks, one file each) fitted the caps only at its initial values.

## SHA-512 of each set's `SHA512SUMS.cmd` (for `VERIFY_WEIGHTS.cmd`)

| file | SHA-512 |
|---|---|
| `weights\model1-untrained\exact\SHA512SUMS.cmd` | `9f315674d7264f8daba1e8eb0f83d43de54f12ee559e9978d7e7ecefcaf79722c09be281f14dcf9a92f0cfea5fed11039a0434bfa260277d8bb7356dba12c54d` |
| `weights\model1-untrained\tier2\SHA512SUMS.cmd` | `dd58bb438a1c15d413ac798287d2f09c5bef01f0b1f8c8d613410d7aa1d796135bf2b59940b598015f9d6e771aa7532c7532e235d300a097b2d5785ccdf16ed4` |
| `weights\model2-tier1\SHA512SUMS.cmd` | `80f9bb76ba32bb4a8a8f6652f0553e77162827e2945774da072019d37f3a18312514ae6d8487af5775342cc56e077e7bfab815ac524163fcb5898bfa60230149` |
