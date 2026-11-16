@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem LK/Vexa .cmd document (LB-DOC/1): REASONING-RAILS-8S.md. The document is the last LB_DOC_BYTES bytes of this file.
rem Run it to print the document, with /check to check its SHA-512, or with /extract FILE to write it out.
set "LB_FORMAT=LB-DOC/1"
set "LB_DOC=REASONING-RAILS-8S.md"
set "LB_DOC_TYPE=markdown"
set "LB_DOC_BYTES=18649"
set "LB_DOC_SHA512=29666e7412aaa271f40db792de76abdcbdb3143829bd1c7dc25ec7e8ef69584dc260c957ff04b327b106630128d4e67a69fc8c68766298d363a7b15dcc0d05e8"
set "LB_SELF=%~f0"
set "LB_ARG=%~1"
set "LB_OUT=%~f2"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$n=[int]$env:LB_DOC_BYTES;$b=[IO.File]::ReadAllBytes($env:LB_SELF);$o=$b.Length-$n;$h=-join((New-Object Security.Cryptography.SHA512Managed).ComputeHash($b,$o,$n)|%%{$_.ToString('x2')});if($h -ne $env:LB_DOC_SHA512){[Console]::Error.WriteLine('LB-DOC/1: the SHA-512 of '+$env:LB_DOC+' differs from LB_DOC_SHA512');exit 1};if($env:LB_ARG -eq '/check'){'ok: '+$env:LB_DOC;exit 0};if($env:LB_ARG -eq '/extract'){$d=New-Object byte[] $n;[Array]::Copy($b,$o,$d,0,$n);[IO.File]::WriteAllBytes($env:LB_OUT,$d);'written: '+$env:LB_OUT;exit 0};[Console]::OutputEncoding=New-Object Text.UTF8Encoding $false;[Console]::Out.Write([Text.Encoding]::UTF8.GetString($b,$o,$n));exit 0"
set "LB_RC=%errorlevel%"
if "%LB_ARG%"=="" pause
exit /b %LB_RC%
rem ---- document ----
# RAILS-8S/1: a four-rail reasoning layer for the KGD-IMQ `.cmd` LLM

RAILS-8S/1 is the reasoning layer of this package. It sits on top of the two models and does not change them: their
weights stay exactly as committed, and both models stay untrained. What it adds is a disciplined way to draw
conclusions from numbers, whether those numbers come from a model, from the training text or from a worked example.

It is built from two sources:

- **David J. C. MacKay, *Information Theory, Inference, and Learning Algorithms*** (Cambridge University Press, 2003).
  The layer's arithmetic is MacKay's: Bayes' theorem in the log domain, likelihood ratios as weighted votes, the
  evidence of a model and its Occam factor, code lengths and arithmetic coding, repetition codes and parity checks,
  mean-field approximations checked against exact enumeration, and decision theory with a utility for abstaining.
  Equations are cited by MacKay's numbers, for example (2.16).
- **The *Corpus Compendium on Rails: A Unified Four-Rail Parallel-Theory and 8S Penteract–S³ Coupled-Mechanics
  Redesign of David J. C. MacKay's Information Theory, Inference, and Learning Algorithms*** (first and revised
  editions, 2026), which carries all 1,486 of MacKay's numbered equations on four rails. From it the layer takes
  the four rails on which every entry is written, the status taxonomy of Rail II, the 8S admission law (an
  independence gate and a gain gate), the gate layer with its contraction bound, the retraction to the identity, and,
  from the revised edition's review, the rule that an identity which holds by construction is never evidence.

Everything is in the package's engine (`tools\KGD_ENGINE.cmd`), reached through the LCUF-X host
(`lcufx\LCUFX_KGD.cmd`, profile `lkvexa.kgd_imq/0.2`) or the command line (`tools\REASON.cmd`).

## 1. A reasoning entry on four rails

Every operation of the layer returns one JSON report. Its parts follow the compendium's rails:

| rail | in the compendium | in the layer |
|---|---|---|
| I | the classical statement of an equation | the statement being made: the question, the hypotheses or candidates, the answer or an abstention |
| II | a linear-algebraic form with a status line | the computation in the domain where it is exact (log probabilities, log-odds, code lengths, checks over F2), with its status |
| III | the 8S image: independence gate, gain gate, coupling | the admission of evidence, reasoning steps, witnesses and coupled claims |
| IV | the continuum image | robustness: decision margins, agreement of independent routes, error bounds, exact checks of approximations |
| retraction | switching the transforms off returns the Rail II input (Theorems J and Θ-J) | every gate switched off: what an ungated system would report. It holds by construction, so the report marks it `by_construction: true` and `counts_as_evidence: false` |

The top of every report repeats the result: `statement`, `decision` and `answer`, plus the operation's own summary
fields (for example `posterior`, `admitted`, `rejected`).

## 2. Status of a result (Rail II)

The layer uses the compendium's taxonomy, and each operation assigns the status of its own computation. A caller
cannot raise it.

| status | meaning | where the layer uses it |
|---|---|---|
| exact linear | linear in the stated objects | the independence gate (a projection residual) |
| exact linear over F2 | linear over the field with two elements | the syndrome of three routes treated as a repetition code |
| exact in logs | exactly linear after taking logarithms | posteriors (log prior + log likelihoods − log Z), candidate log likelihoods, ideal code lengths, Boltzmann weights |
| linearised | an approximation with a stated or measured remainder | the mean-field gate (its error against exact enumeration is measured), the arithmetic coder (its length exceeds the quantised ideal by at most 2 bits) |
| structural analogue | no exact linear form, but a linear object carries the structure | decisions: argmax and thresholds are piecewise linear |
| no faithful linear form | the relation resists translation | refused, for example an asymmetric coupling matrix |

The layer itself computes in IEEE double precision. A model witness's logits come from the host's forward pass, which
rounds the hidden state after every step, and the logits, to float32. "Exact" describes the form of the computation,
not the absence of rounding.

## 3. Admission (Rail III): the 8S law

The compendium's master law admits an entry when it is independent of what is already admitted and when admitting
it gains something: Admit(8S) ⟺ η_ind ≥ ε_ind ∧ Δ_8S > ε_gain. The layer applies that law in three places.

### 3.1 The independence gate

η_ind(e) = ‖(I − C C⁺) e‖² / (‖e‖² + 10⁻¹²), where C holds the codes already admitted. This is the compendium's
Theorem A: the gate is a rank-increment test, and rank(C) grows by one exactly when an entry is admitted. The layer
computes η_ind by Gram–Schmidt with a second orthogonalisation pass.

What the code of an entry is matters. For **evidence** about hypotheses the code is the entry's **provenance**: the
set of tags the caller attaches (which test, which sample, which received bit), as a 0/1 vector. Two entries with the
same provenance are the same observation, and the second one is not admitted. The likelihood vector itself cannot
serve as the code: with two hypotheses every centred log-likelihood vector lies on one line, so a likelihood-based
gate would refuse the second of three independent received bits of a repetition code (MacKay (1.18)–(1.23)), whose
three votes the decoder needs. Conditional independence of observations is a property of how they were gathered, which
only the provenance records. The gate therefore guards against counting one observation twice; it cannot detect a
dependence that the tags do not declare.

For **reasoning steps** (`rails_admit`) the code is whatever vector the caller gives, or a tag set. A step that lies
in the span of admitted steps restates them and is not admitted.

### 3.2 The gain gate

Gains are in bits, and an entry is admitted only if its gain exceeds ε_gain (0 by default):

- **evidence**: the information it adds, KL(posterior with it ‖ posterior without it). Evidence that leaves the
  posterior unchanged gains nothing.
- **a witness** (a model, or the unigram of the training text): the evidence ratio of MacKay chapter 28 against a
  baseline. The witness must code a calibration text in fewer bits than the uniform byte code, 8 bits per byte; the
  gain is the number of bits it saves. A witness that predicts text no better than chance is not admitted, and its
  preferences among the candidates are then ignored. This is the gate that keeps the layer from acting on an
  untrained model.
- **a compressor** (`rails_codelen`): the bits saved against the same uniform code.
- **reasoning steps**: the gain the caller states.

### 3.3 The gate layer: coupled claims

The 8S law has a gate layer, p_i = σ(h_i) with fields that include couplings to the other gates. For claims that
support or contradict one another the layer uses p = σ(h + J(2p − 1)), the mean-field equations of the Ising-type
model P(s) ∝ exp(Σ_i h_i s_i / 2 + Σ_{i<j} J_ij s_i s_j / 2) with s_i = +1 when claim i holds (MacKay chapters 31 and 33).

- **Certificate.** The update has Lipschitz constant κ = max_i Σ_j |J_ij| / 2 in the maximum norm, because σ′ ≤ 1/4.
  If κ < 1 the fixed point is unique and the iteration converges to it (the compendium's Theorem H). If κ ≥ 1 the gate
  may have several fixed points, so its answer is not unique, and the layer refuses.
- **Exact check.** The layer takes 1 to 16 claims and enumerates all 2ⁿ states (MacKay chapter 21), so each claim is
  decided from its exact marginal. The mean-field result is reported beside them with its measured error.

## 4. Robustness (Rail IV)

- **Decision margins.** For a decision the layer reports the log-odds margin between the two most probable
  hypotheses and the flip factor, the factor by which their likelihood ratio would have to be wrong to reverse the
  ranking. It also reports the margin to the decision threshold.
- **Three routes, one number.** When a quantity can be computed in three ways, the layer treats the three results as
  a repetition code R3 (MacKay (1.18)–(1.23)). It forms the checks z_ab, z_bc and z_ac, each 1 when two routes differ
  by more than the tolerance. (z_ab, z_bc) is the syndrome; z_ac is a redundant check that must equal z_ab ⊕ z_bc, as
  with the redundant parity check of (1.51)–(1.52). When one route disagrees with the other two and they agree, the
  majority outvotes it and the report names it. When no two routes agree, or the checks are inconsistent (for
  example a ≈ b and b ≈ c within the tolerance while a and c differ by more), the layer refuses the value. The
  routes should be as independent as the caller can make them: two routes that are wrong in the same way outvote the
  right one.
- **Code length.** The arithmetic coder's output must decode back to the text, with each step's probabilities
  recomputed from the decoded prefix alone, and its length must not exceed the quantised ideal length by more than
  2 bits. For a model witness the report also gives the largest difference between the logits of the prefix
  computations and of one forward pass over the whole text, which is a check that the model is causal.
- **Length normalisation.** Candidates of different byte lengths have likelihoods of different scales. If ranking
  by likelihood per byte would change the answer, the layer abstains.

## 5. Decisions with abstention

MacKay's decision theory (chapter 36) with three utilities: +1 for a right answer, −λ for a wrong one and 0 for
abstaining. The expected utility of answering h is P(h)(1 + λ) − λ, so the layer answers the most probable hypothesis
only if its posterior exceeds τ = λ / (1 + λ); otherwise it abstains. With λ = 1, the default, τ = 1/2. Ties abstain.
For coupled claims the same threshold accepts a claim above τ, rejects it below 1 − τ, and leaves it undecided in
between.

## 6. Evidence rules

The revised edition of the compendium lists seven problems that its review found in the first edition. The layer is
built so that it cannot make the same kind of mistake:

1. **One form per entry, not a template.** Every report is computed from its own inputs; nothing is filled in
   from a pattern.
2. **Faithful inputs.** The inputs of a program are constants in its source, and the source is pinned by its
   SHA-512 in every receipt. Weight sets are pinned by their set SHA-512, and the training text used by the unigram
   witness by the SHA-512 of the original file.
3. **No overclaimed exactness.** The status of every result is assigned by the operation (section 2).
4. **Classification by content.** A decision is a structural analogue even when the posterior behind it is exact;
   a mean-field marginal is linearised even when it happens to be close.
5. **Properties computed, not guessed.** Error bounds are measured: the mean-field error against enumeration, the
   coder's remainder against the quantised ideal, the agreement of routes against a tolerance.
6. **Sources cited.** Every worked example names MacKay's equations, and `lcufx\programs\programs-made.cmd` records,
   for each program, where its expected values come from and whether they are independent of the engine.
7. **Nothing verified by construction.** The retraction is reported, marked as holding by construction, and
   excluded from evidence. A program's expected values are either MacKay's printed numbers, values computed
   independently of the engine, or explicitly marked as consistency checks between the engine's own routes.

## 7. Operations

The operations belong to the profile column `lkvexa.rails8s` of `LCUF-X/0.2+lkvexa.kgd_imq/0.2`. Their modeled work
is given in `PROFILE-lkvexa.kgd_imq-0.2.cmd`.

| operation | inputs → output | MacKay | what it does |
|---|---|---|---|
| `rails_bayes` | const text spec → text | (2.10), (1.18)–(1.23), (3.24)–(3.27), ch. 36 | Bayes over named hypotheses with provenance-gated evidence; decision with abstention |
| `rails_admit` | const text spec → text | — (8S Theorem A) | the admission law on reasoning steps with codes and gains |
| `rails_meanfield` | const text spec → text | ch. 21, 31, 33 | coupled claims: certificate, mean field, exact enumeration, decisions |
| `rails_parity` | const text spec, f64, f64, f64 → text | (1.18)–(1.23), (1.51)–(1.52) | three routes to one number as R3: syndrome, majority, refusal |
| `rails_witness` | WeightSet, const text spec → text | ch. 21, 28, 36 | a model or the unigram as a witness for a multiple-choice question |
| `rails_codelen` | WeightSet, const text → text | ch. 4–6 | arithmetic coding of a text with the witness, decoded back |
| `bytes_unigram` | const text shard list, const text data SHA-512, const f64 α → WeightSet | (3.16), ch. 23 | the byte unigram of the training text with Laplace smoothing |
| `json_f64` | text report, const text key → f64 | — | reads a number from a report, for `rails_parity` and the assertions |

`assert_json` in profile 0.2 also accepts dotted keys, such as `rail_III.admitted`, to reach inside a report.

### Spec fields

- **`rails_bayes`**: `hypotheses` (names); `prior` (optional, sums to 1; uniform if absent); `evidence`, a list of
  `{name, tags, likelihood}` or `{name, tags, log_likelihood}`; `eps_ind` (default 0.5); `eps_gain_bits` (default 0);
  `lambda` (default 1); `question` (optional text).
- **`rails_admit`**: `items`, a list of `{name, code}` or `{name, tags}` with `gain_bits`; `eps_ind` (default 0.01);
  `eps_gain_bits` (default 0).
- **`rails_meanfield`**: `claims` (1 to 16 names); `h`; `J` (symmetric, zero diagonal); `lambda`; `max_iters`
  (default 10,000); `tol` (default 10⁻¹²).
- **`rails_parity`**: `routes` (three names); `tolerance`; `relative` (default false). On the command line, also
  `values` (three numbers).
- **`rails_witness`**: `prompt`; `candidates`; `calibration` (default: the prompt); `prior`; `lambda`;
  `eps_gain_bits`. On the command line, also `witness`: `{"manifest": path, "tier": "exact", "pin": hash}` or
  `{"unigram": [shard paths], "data_sha512": hash, "alpha": 1}`, with paths relative to the spec file.
- **`rails_codelen`**: the text. On the command line, a spec with `witness` and `text`.

## 8. What the layer shows on this package

`evidence\programs-summary.cmd` and `evidence\rails-selftest.cmd` hold the runs.

- **MacKay's worked examples** are reproduced: Jo's posterior 19/118 ≈ 0.16 (2.18); P(s = 1 | 011) = 0.9 for
  R3 with f = 0.1 (1.23); the bit error 3f² − 2f³ = 0.028 of R3 (1.36), here as the Bayes risk of the layer's own
  decisions; the capacity 1 − H₂(0.1) = 0.531 (1.35); Oliver's likelihood ratios 0.83 and 50 (3.26)–(3.27);
  Laplace's rule (3.16); and the single-error correction of the (7,4) Hamming code (1.25)–(1.34).
- **The gates.** A positive test entered twice is admitted once: the posterior stays at 0.16, where the ungated
  product gives 0.78. A reasoning step that restates two earlier ones is not admitted.
- **The untrained models.** Model 1, asked which word continues a prompt, codes held-out text in more than
  8 bits per byte, so it is not admitted as a witness, and the layer abstains. The unigram of the training text is
  admitted and answers; it ignores the prompt, so it is a positive control for the gate, not a reasoner.
- **Three routes.** Model 1's cross-entropy computed by the host's forward pass, by the engine's dense reference (a
  separate implementation) and by the arithmetic coder agree within 10⁻⁴. The coder reuses the host's kernels on each
  decoded prefix and matched the forward pass bit for bit. The coder run on the Tier-2 view, a different model, is
  outvoted.

## 9. Which parts of the 8S law are used

The compendium lists seven pieces of machinery in the master law: the independence gate, the quantised base 𝒞_M, the
coupling matrix W, two dynamical layers (a Kuramoto phase field and a mean-field Ising gate), the radius map, the S³
fibre, and the projection Π(τ) with its gap functions and admission rule. Of these, and of the retraction of the tower
of rails, the layer uses those that have a meaning for reasoning and leaves the others out:

| 8S component | in the layer |
|---|---|
| independence gate η_ind, Theorem A | used: evidence (provenance codes) and reasoning steps |
| admission rule Admit(8S) with the gain Δ_8S | used, with the gain measured in bits instead of the compendium's Score |
| mean-field Ising gate p = σ(h), Theorem H | used: `rails_meanfield`, with the contraction certificate |
| retraction to the identity, Theorems J and Θ-J | used: reported, never counted as evidence |
| coupling matrix W = A ⊙ K_c ⊙ K_J | not computed: the couplings J of coupled claims are given by the caller |
| quantised base 𝒞_M, Kuramoto phase field, radius map, S³ fibre, projection Π(τ) and its gap functions | not used: they have no reasoning counterpart here |

## 10. Limits

- **The models are untrained.** Every model witness is rejected, so the layer's answers on this package come from
  worked examples and from the unigram positive control, not from the LLM.
- **Inputs are trusted for what they are.** The layer checks the shape of likelihoods and provenance tags, not their
  truth. A wrong likelihood gives a wrong posterior, exactly computed.
- **Provenance is declared.** The independence gate sees only the tags it is given.
- **Routes can fail together.** Three routes protect against one wrong route, not against two that are wrong in the
  same way.
- **Calibration must be unseen.** The witness gate measures a witness on its calibration text, so that text must not
  be in the witness's training text, or memorisation passes for prediction. This package's held-out split mostly
  repeats its training text (`evidence\heldout-overlap.cmd`); the calibration text of the witness programs does not
  occur there.
- **Coupled claims are few.** At most 16, so that enumeration can check every mean-field answer.
- **Tolerances are choices.** The parity tolerance and the thresholds ε_ind, ε_gain and λ are inputs, and the report
  shows each of them.
- **One test machine.** Receipts hash exact bits, and another runtime may compute exp and log differently in the
  last bit; the assertions themselves have tolerances.
