# Prompts That Execute

Natural language prompts cannot be mechanically verified.

```text
"Reject proposals with unresolved dependencies."
```

Model output: `APPROVE`

Nothing caught it. The model simply skipped the constraint.

---

## A Complete Executable Prompt

An executable prompt has three layers.

```lisp
(review-proposal project-alpha

  ; Layer 1 — Knowledge: rules and constraints
  (requires  budget-within-limit)
  (requires  timeline-has-milestones)
  (prevents  unresolved-dependencies)
  (flag      novel-technology)

  ; Layer 2 — Input: data for this execution
  (input
    (budget       "1.8M, ceiling 2.0M")
    (timeline     "Q1/Q2/Q3 milestones defined")
    (dependencies "depends on project-beta API, not yet complete")
    (query        "approve or reject"))

  ; Layer 3 — Output contract: what valid responses look like
  (output-contract
    (format          s-expression)
    (must-address    prevents-nodes)
    (verdict-required approve/reject/revise)))
```

**Verifier output** (before the LLM sees it):

```
▶ [review-proposal] project-alpha

  (requires budget-within-limit)      registered
  (requires timeline-has-milestones)  registered
  (prevents unresolved-dependencies)  registered
  (flag novel-technology)             registered

── Consistency ──
  Result: PASSED ✓

── Output contract ──
  format: s-expression
  must-address: prevents-nodes
  verdict-required: approve/reject/revise
```

**LLM output** (DeepSeek, same input):

```lisp
(decide project-alpha
  (verdict revise)
  (reason
    "Prevents condition triggered: unresolved-dependencies. "
    "Project-beta API not yet complete blocks core path. "
    "Budget (1.8M ≤ 2.0M) OK. "
    "Timeline milestones present but risk due to dependency.")
  (conditions
    (budget-within-limit     satisfied)
    (timeline-has-milestones satisfied)
    (unresolved-dependencies triggered)
    (novel-technology        flagged))
  (recommendation
    "Revise: a) secure completion date for project-beta API, "
    "b) add buffer to Q2/Q3 milestones, "
    "c) then resubmit for approve/reject."))
```

The `conditions` block maps every input node to its status — `satisfied`, `triggered`, or `flagged`.
A verifier can scan this block automatically: `unresolved-dependencies` is `triggered`, so `verdict` must not be `approve`. It isn't.

The omission that caused the `APPROVE` failure cannot happen.

---

## Another Example: Conditional Conflict Detection

```lisp
(diagnose streptococcal-pneumonia

  ; Layer 1 — Knowledge
  (requires      antibiotics)
  (first-line    penicillin)
  (contraindicated penicillin penicillin-allergy)

  ; Layer 2 — Input
  (input
    (symptoms  "fever 39°C, productive cough")
    (history   "penicillin allergy confirmed")
    (query     "how to treat"))

  ; Layer 3 — Output contract
  (output-contract
    (format        s-expression)
    (must-address  contraindicated-nodes)
    (must-include  treatment-alternative when first-line-blocked)))
```

**Verifier output:**

```
── Consistency ──
  ⚠ first-line(penicillin) + contraindicated(penicillin, penicillin-allergy)
    condition: penicillin-allergy → confirm before prescribing
  Result: PASSED ✓
```

**LLM output:**

```lisp
(treatment-plan
  (contraindicated-triggered penicillin penicillin-allergy)
  (treatment-alternative
    (first-choice  azithromycin)
    (second-choice levofloxacin))
  (supportive-care
    (antipyretic for-fever)
    (hydration   required)))
```

The verifier catches the conditional conflict. The LLM is required to provide `treatment-alternative` because `first-line` was blocked. Both constraints are satisfied.

---

## What the Three Layers Do

```
Layer 1 — Knowledge
  Domain rules: what must hold, what is excluded, what needs review.
  This is where your expertise lives.
  Verified for internal consistency before the LLM sees it.

Layer 2 — Input
  The data for this specific execution.
  Fills the blank fields when you use the prompt.
  Tells the LLM what to reason about.

Layer 3 — Output contract
  What valid responses look like: format, required nodes, verdict structure.
  The verifier checks the LLM's output against this contract.
  Drift is caught automatically.
```

---

## What This Is Not

- Not prompt formatting
- Not XML with parentheses
- Not chain-of-thought prompting
- Not a claim that LLMs execute symbolic logic internally

The model is not the verifier.
The verifier handles structure. The LLM handles semantics.
Both operate over the same representation.

---

## Why S-Expressions

S-expressions are homoiconic: written form, parse tree, and executable structure are identical.

```
T(P)  ≅  D(P)  ≅  V(P)
```

The same structure that the verifier traverses is the same structure the LLM reads. No translation layer between them.

---

## Quick Start

No dependencies. Python 3.6+.

```bash
git clone https://github.com/[repo]

# verify any .lisp file
python interpreter.py examples/medical.lisp

# see contradiction detection
python interpreter.py examples/conflict.lisp

# run built-in sample (no arguments)
python interpreter.py
```

Output for `conflict.lisp`:

```
Bracket check: Brackets balanced
--- Expression #1 ---
Parsed predicates (3): diagnose, requires, prevents
Consistency: FAILED ✗
 - Conflict: both requires(adequate-sleep-opportunity)
             and prevents(adequate-sleep-opportunity)
```

Output for `medical.lisp`:

```
Bracket check: Brackets balanced
--- Expression #1 ---
Parsed predicates (6): diagnose, caused-by, requires, first-line, contraindicated, ...
 - Warning: first-line(penicillin) and contraindicated(penicillin) — verify condition
Consistency: PASSED ✓
```

---

## Structural Primitives

**Nesting** — dependency: inner results feed outer determination

```lisp
(approve project
  (check-budget)
  (check-team)
  (check-timeline))
```

**progn** — sequence: each step modifies state the next requires

```lisp
(progn
  (research)
  (evaluate)
  (compare)
  (decide))
```

**let** — binding: multiple things in scope simultaneously

```lisp
(let ((offer-A company-a)
      (offer-B company-b))
  (compare-salary offer-A offer-B)
  (recommend      offer-A offer-B))
```

---

## Repository

```
interpreter.py    parser + verifier, reads .lisp files directly
examples/
  medical.lisp    diagnosis with contraindication handling
  project.lisp    proposal review with dependency check
  offer.lisp      job offer evaluation
  geometry.lisp   Euclidean geometry proof
  conflict.lisp   contradiction detection demo
tutorial/
  Prompts_That_Execute.md   English tutorial 
  提示词即程序.md             Chinese tutorial 
```

---



*Experimental. The goal is not to replace natural language prompting.*
*The goal is to explore whether prompts can function as executable intermediate representations —*
*verifiable before generation, checkable after.*