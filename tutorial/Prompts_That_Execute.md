# Prompts That Execute

## A Complete Guide to Writing Verifiable AI Instructions with Lisp Thinking

---

## A Technical Preface: One Structure, Two Executors

> **In a hurry? Skip to Chapter One.** But if you want to see the claim this tutorial is built on — demonstrated, not just asserted — read this first. An interactive version of this preface with copyable code is available as `technical_preface_demo.html`.

* * *

### The claim

The same S-expression can be executed by a Python interpreter and understood semantically by a large language model. Both operate on identical structure. No translation layer between them.

This is not a metaphor for "structured prompts work better." It is a statement about a mathematical property of the notation — homoiconicity: the written form, the in-memory representation, and the executable form are structurally identical. It is why S-expressions were invented, and why they are the right notation for this problem.

The formal statement: **T(P) ≅ D(P) ≅ V(P)**.

The same parse tree, the same data structure, the same execution semantics. Three views of one object.

* * *

### The demonstration

One S-expression. Three executors.

```lisp
(diagnose streptococcal-pneumonia
  (caused-by     streptococcus-pneumoniae)
  (presents-with fever)
  (presents-with productive-cough)
  (requires      antibiotics)
  (first-line    penicillin)
  (contraindicated penicillin penicillin-allergy))
```

**Python interpreter** — structural traversal, consistency check, no domain knowledge required:

```text
▶ diagnose: streptococcal-pneumonia
  (caused-by streptococcus-pneumoniae)
  (presents-with fever)  ...
  (requires antibiotics)
  (first-line penicillin)
  (contraindicated penicillin penicillin-allergy)
── Consistency ──
  ⚠ first-line(penicillin) + contraindicated(penicillin, penicillin-allergy)
  Result: PASSED ✓
```

**LLM** — same input, semantic reasoning applied:

```text
(requires antibiotics)      → Antibiotic treatment is mandatory. ✓
(first-line penicillin)     → Penicillin G or amoxicillin as first choice.
(contraindicated penicillin → If allergy confirmed: ceftriaxone,
  penicillin-allergy)          levofloxacin, or vancomycin.
                               Verify allergy status before prescribing.
```

**Common Lisp REPL** — with predicate functions defined, native execution:

```text
▶ diagnose: STREPTOCOCCAL-PNEUMONIA
  (REQUIRES ANTIBIOTICS)  (FIRST-LINE PENICILLIN)
  (CONTRAINDICATED PENICILLIN PENICILLIN-ALLERGY)  ...
── Consistency ──
  ⚠ first-line(PENICILLIN) + contraindicated condition: PENICILLIN-ALLERGY
  Result: PASSED ✓
```

Two executors produce structural verification. One produces semantic output. All three operate on the same structure. The structure is the stable interface between them.

* * *

### What just happened

McCarthy invented S-expressions for symbolic AI in 1960. Symbolic AI's persistent limitation: it could reason formally but could not handle semantics. LLMs solve exactly that missing piece.

The combination is structurally inevitable. S-expressions provide the formal, verifiable scaffold. LLMs provide the semantic understanding that fills it. Neither replaces the other. Together they cover the complete pipeline from specification to natural language output.

This is the missing foundational primitive that prior approaches to LLM-based formal reasoning lacked: a notation where the thing you write to the LLM and the thing the verifier checks are the same object. Not a prompt that describes a structure. A prompt that _is_ the structure.

* * *

### What this tutorial assumes and doesn't

**Assumes**: you can run Python, you have access to an LLM, you want more reliable and verifiable outputs.

**Does not assume**: Lisp knowledge. The examples throughout are designed for LLM understanding and Python-based verification. You do not need Lisp to use this tutorial.

**The honest note**: the S-expressions here _can_ run in any standard Lisp environment, but doing so requires defining the domain predicate functions first. The Python interpreter in Appendix A implements those semantics completely — it is one valid runtime among several, not a workaround. For Lisp practitioners, the path to REPL execution is a 10-line exercise. For everyone else, Python plus LLM provides everything.

The structural thinking — which is the transferable skill — requires neither.

* * *

### How this tutorial is structured

Chapters One through Three establish the principle and the three structural primitives. Chapter Four teaches predicate vocabulary design and the six-step method. Chapter Five walks the complete strict-mode pipeline end to end. Chapter Six shows the full spectrum from verified specifications through cognitive architectures to meta-systems.

Each chapter is self-contained. Read as much or as little as you need.

The view from Chapter Six is substantially different from the view here.

* * *

* * *

## Preface: How Do You Use Artificial Intelligence?

> **In a hurry? Skip directly to Chapter One.** The six chapters stand alone. But if you want to understand the thinking behind this tutorial — the real question it's answering — read this first.

* * *

How do you use artificial intelligence?

Most people land somewhere in three places:

As an assistant — _"Write me an email," "Fix this paragraph," "Give me three options."_

As a search engine — ask a question, read the answer, ask another, read again.

As an accelerator — doing what they already do, but faster. Reports faster. Research faster. Brainstorming faster.

All three are valid. All three have real value. But they share a hidden assumption:

**AI is a tool. You are the user. You describe what you want. It does it.**

That assumption isn't wrong. It's just incomplete — and the incompleteness has a ceiling.

* * *

### Do You Know What You're Actually Doing?

Let me ask you something.

Have you ever written a prompt that says _"use first-principles thinking"_?

Did it work? Somewhat, probably. The model returned something more systematic, more structured, more apparently rigorous than if you'd just said _"analyze this."_

But was the model actually using first-principles reasoning?

**No.**

What happened was this: the model recognized the phrase "first principles," activated the region of its semantic space associated with that concept, and generated text that _looks like_ first-principles reasoning — because it has seen thousands of examples of what first-principles writing looks like.

It generated the shape of first-principles thinking. Not the process.

Now try a different prompt: _"Break this problem into its most fundamental components. Set aside all existing assumptions. Rebuild your understanding from zero. At each step, check whether your conclusion follows necessarily from what you've established, not from what you expect."_

The output will be structurally different — not because you gave it a better instruction, but because you described a **cognitive operation**, not a concept label. You told it what to _do_, not what to _sound like_.

The difference between these two prompts is the difference between **naming a method** and **executing its steps**.

Nobody has told you this clearly. But it is the single most important thing about prompt quality.

* * *

### You Are Programming a Semantic Space

Go one level deeper, and something important becomes visible.

Every prompt you write does the same thing: it sets a trajectory through the model's semantic space.

A large language model's internals are not a database, not a search engine, not a logic machine. They are a vast, high-dimensional semantic space in which every concept, every relationship, every pattern of reasoning exists as a region of encoded structure. Your prompt determines where the model begins, which direction it moves, and where it terminates.

This means: **writing a prompt is not giving instructions. It is designing a path.**

Design the path well, and the model arrives where you intended. Design it vaguely, and the model wanders — finding some plausible-looking neighborhood and stopping there.

Most prompts do the latter. They describe a destination, then hope the model finds its own way. This tutorial teaches something different:

**Design the path itself. Then let the model walk it.**

This is not a metaphor. A node-structured prompt and a natural language description activate different semantic trajectories, produce structurally different outputs — not just surface-level differences — for reasons rooted in how transformer attention distributes over structured versus unstructured input.

* * *

### A New Division of Labor

Once you see this, the relationship between human and AI changes.

**The human is the cognitive core** — you define the problem, design the structure, determine the path, evaluate the result.

**The AI is the computation layer** — it propagates semantics through the structure you've built, maintains consistency, generates output.

This division doesn't diminish AI. It maximizes it. The model no longer needs to guess what you mean. It executes within a precisely defined cognitive space.

And when this division holds:

Your cognitive bandwidth directly determines the scale of what you can build.

How clearly you think, how precisely you structure — that's how large your laboratory becomes.

**The faster your mind, the bigger the lab.**

* * *

### How I Use Artificial Intelligence

Before writing this tutorial, I spent a long time on one problem:

**Understanding what AI actually does — so I could understand what I should do.**

My conclusion: AI is extraordinarily good at working _within_ a well-defined cognitive space. It is not good at _defining_ that space.

So my job is to define it.

I decompose the problem into predicates — in this domain, what are the conditions, the constraints, the dependencies, the things that must be excluded? I compose those predicates into structure. I verify that the structure is internally consistent. Then I send that structure to the model and let it work within those boundaries.

The model's output, I verify against the same structure — did it address every node, did it violate any constraint, did it contradict itself? The structure that generated the prompt is the same structure that verifies the result.

The whole process: I am not "using AI." I am **collaborating with a powerful computation layer to solve a problem I have already made structurally precise.**

This is different from using AI as an assistant not just in efficiency — it's different in kind. Some problems are simply not solvable through natural language prompts. Not because the model is incapable, but because natural language cannot hold the logical constraints precisely enough for the model to operate reliably.

Structure can. This tutorial shows you how.

The foundation is a notation that is sixty years old, developed by John McCarthy, and used in every major language runtime, compiler, and formal system you've encountered: **S-expressions**. When you understand why they have a property that no other common notation has — and why that property is exactly what AI prompting needs — the rest of this tutorial follows naturally.

Six chapters. A complete spectrum.

When you're ready, turn to Chapter One.

* * *

* * *

## Chapter One: Your Prompts Have a Fatal Flaw

* * *

### The Experience You've Already Had

You've been here before.

You spent time — real time — crafting a prompt. You added context, constraints, examples, role definitions. You specified the output format. You emphasized the most important requirements.

The model returned something long and fluent and professionally worded.

You read it. Something was off in the third paragraph. You read again. The model had quietly ignored one of your constraints — not rejected it, not acknowledged missing it, just smoothly generated output that failed to address it. Another paragraph contradicted something you'd specified earlier. The model didn't notice.

You revised the prompt. Resubmitted. Better in some places, worse in others. A different constraint went missing this time.

You revised again.

At some point in this process, a question forms: **how do I know when I'm done?**

You can't. Because you have no way to verify that the model has satisfied your requirements without reading the entire output yourself, holding all your constraints in your head, and manually checking each one. Which is, ironically, the cognitive work you were trying to offload.

This is not a model capability problem. The latest models are remarkably capable.

This is a structural problem — and it's in your prompt.

* * *

### What's Actually Failing

Every natural language prompt has the same fundamental vulnerability: **its semantics live in strings**.

When you write _"all recommendations must be backed by data,"_ the phrase is meaningful to you because you know what "backed by" means, what counts as "data," what "must" implies about strictness. The model, when it processes this, is computing statistical continuations over the token sequence. It doesn't execute the constraint. It generates text that is plausible given the constraint was mentioned.

Most of the time, that produces something that looks like compliance. Sometimes it doesn't. You can't tell which case you're in without checking.

Consider how this compounds across a complex prompt:

_"You are a senior product strategist. Analyze this business case from both a market opportunity and execution risk perspective. Your analysis must be data-driven, must not exceed 500 words, must include at least three concrete action items, and must identify the single highest-priority concern for the leadership team."_

That's five constraints. Each one is a string. The model reads the string, continues statistically, and produces something that roughly fits the overall pattern. But there's no mechanism — none — that guarantees it counted to three action items, stayed under 500 words, and identified exactly one highest-priority concern.

**You have requested all of this. You have not specified any of it.**

The difference between requesting and specifying is the difference between hoping and knowing.

* * *

### The Prompt Engineering Ceiling

The standard response to this problem is: write better prompts. More detail. Clearer language. Stronger emphasis. Examples. Chain-of-thought instructions. Role definitions.

All of these help. None of them solve it.

Because the problem is not that your prompts are unclear. The problem is that **natural language cannot enforce constraints**. It can express them. It can emphasize them. It cannot ensure they are executed.

Chain-of-thought prompting asks the model to show its reasoning. It doesn't verify that the reasoning is correct. Tree-of-thought prompting asks the model to explore alternatives. It doesn't verify that the alternatives are valid. Program-of-thought prompting asks the model to write code and run it. The code might work; the prompt that generated it is still inert text.

Every technique in the prompt engineering toolkit is a variation on the same move: use natural language to _ask_ the model to behave in a certain way. The prompt itself carries no computational semantics. It's a request, not a specification.

This is why prompt engineering often feels like superstition. People develop strong opinions about which exact words to use, where to place them, how to format them — and they're not wrong that it matters. But they can't explain _why_, because the underlying mechanism is statistical plausibility, not structured execution. The map has no territory.

* * *

### What If Your Prompt Were a Program?

Now consider a different possibility.

What if the constraints in your prompt weren't strings — but nodes? What if _"must be data-driven" weren't a phrase the model reads and approximates, but a **predicate** — a named node in a structure that can be checked?

```lisp
(analyze business-case-alpha
  (requires data-driven-evidence)
  (requires market-opportunity-analysis)
  (requires execution-risk-analysis)
  (requires exactly-three-action-items)
  (requires single-highest-priority-concern)
  (prevents speculation-without-evidence))
```

This is not natural language. It is an S-expression — a notation where every element is a node with defined semantics, not a string to be interpreted.

What changes?

**First**: Before you send this to the model, you can verify the structure itself. Do you have contradictory nodes? Did you accidentally require something you also prevent? Is the structure complete? An interpreter can check all of this in milliseconds, without the model's involvement.

**Second**: When the model responds, you can verify its output against the same structure. Did it address `(requires exactly-three-action-items)`? Did it violate `(prevents speculation-without-evidence)`? Did it handle every node you specified? The structure that generated the prompt is the same structure that verifies the result.

**Third**: When the model misses something, you know _exactly_ which node it missed. You can tell it precisely: _"You did not address `(requires single-highest-priority-concern)`. Please supplement your analysis."_ Targeted correction, not full regeneration.

You have moved from hoping to knowing. From requesting to specifying.

This is what this tutorial teaches.

---

Before continuing, one thing needs to be stated clearly.

**A complete programmatic prompt has three layers, not one.**

```lisp
(diagnose streptococcal-pneumonia

  ;; Layer 1 — Knowledge: rules and constraints
  (requires      antibiotics)
  (first-line    penicillin)
  (contraindicated penicillin penicillin-allergy)

  ;; Layer 2 — Input: data for this execution
  (input
    (symptoms "fever 39°C, productive cough")
    (history  "penicillin allergy confirmed"))

  ;; Layer 3 — Output contract: what valid responses look like
  (output-contract
    (format        s-expression)
    (must-address  contraindicated-nodes)
    (must-include  treatment-alternative when first-line-blocked)))
```

**The knowledge layer alone works.** The model will read it and respond. Chapters Two through Four focus primarily on this layer — how to design predicates, how to compose the three structural primitives.

But with only the knowledge layer, verification is manual. You don't know whether the model addressed the `contraindicated` node, whether it provided an alternative treatment, whether the output format is what you need.

**The output contract** (Layer 3) makes verification mechanical. Chapter Five shows this layer in full, including how to use it to detect when a model's output has drifted from the specification.

**The input layer** (Layer 2) separates data from rules. Rules are reusable; data changes each execution. Separated, the prompt is a reusable program. Combined, it's a one-time instruction.

All three layers together: a complete, verifiable, reusable programmatic prompt.

---

* * *

### The Spectrum Ahead

This is not a binary choice between "natural language prompts" and "structured prompts." It's a spectrum — and understanding where you are on it changes what's possible.

**Level 1**: Natural language prompts — all semantics in strings, all verification manual, ceiling determined by the model's willingness to comply.

**Level 2**: Programmatic prompts — semantics in nodes, structure verifiable, output checkable, the foundation this tutorial builds.

**Level 3**: Cognitive architectures — multiple interacting systems, domain modeling, predicate dispatch, parallel analysis streams. Not just structured prompts but structured _thinking machines_.

**Level 4**: Meta-systems — systems that generate systems, self-referential reasoning engines, architectures that can deepen their own analysis.

By the end of this tutorial, you will have the tools for Level 2, a clear view of Level 3, and a sense of what Level 4 looks like in practice.

The move from Level 1 to Level 2 is not about learning a new tool. It is about understanding something true about the nature of language and computation that most people who use AI every day have never been told.

Let's start with the most important thing: what structure actually means, and why almost everyone who thinks they're using it isn't.

* * *

* * *

## Chapter Two: Brackets Are Not Structure

### The Most Common Mistake in Advanced Prompting

If you've spent time in the prompt engineering community, you've seen this pattern:

```lisp
(Task
  :role "You are a senior medical consultant"
  :objective "Evaluate this patient record"
  :requirements "Must provide a clear treatment recommendation"
  :constraints "Use only first-line medications")
```

This looks structured. It uses parentheses, colons, labels. It organizes information hierarchically. Compared to a paragraph of natural language, it's clearly more organized — and it often produces better outputs.

So what's wrong with it?

Put it in a Lisp interpreter. What executes?

The list structure returns correctly. The brackets are balanced. But `:requirements "Must provide a clear treatment recommendation"` — that string is opaque to the interpreter. `:constraints "Use only first-line medications"` — also a string. The interpreter has no way to check whether the model's output satisfies these strings, because they're not predicates. They're text with parentheses around them.

**The semantics are still in the strings. The brackets are decoration.**

This is the most widespread mistake in sophisticated prompting — and it matters because it's the gap between prompts that _look_ rigorous and prompts that _are_ rigorous. Between organized natural language and actual programs.

* * *

### The Defining Test

Here is the test that separates these two cases:

**Can your prompt detect its own contradictions — automatically, without the model's involvement?**

If you write:

```lisp
(treatment-plan
  :first-line "Penicillin is first-line for streptococcal pneumonia"
  :contraindication "Penicillin contraindicated in penicillin-allergic patients")
```

These two strings contain a tension that a human doctor recognizes immediately. But there is no mechanism in this structure to detect it. The strings are opaque. The conflict between them exists only in the mind of someone who reads both carefully.

Now write it with semantics in nodes:

```lisp
(diagnose streptococcal-pneumonia
  (caused-by streptococcus-pneumoniae)
  (presents-with fever)
  (presents-with productive-cough)
  (requires antibiotics)
  (first-line penicillin)
  (contraindicated penicillin penicillin-allergy))
```

`first-line` and `contraindicated` are **nodes** — named, typed, machine-readable entities. `penicillin` appears as an argument to both. An interpreter can scan this structure and immediately flag:
    ⚠ Conditional constraint: first-line(penicillin) and contraindicated(penicillin)
      coexist. Condition: penicillin-allergy.
      → Confirm allergy status before clinical recommendation.
    Result: PASSED ✓ (conditional warning logged)

No model involvement. No string parsing. Pure structural traversal.

The interpreter doesn't understand medicine. It doesn't need to. It sees that the same symbol (`penicillin`) appears under two semantically opposite predicates (`first-line` and `contraindicated`), applies the consistency rule, and surfaces the tension. The medical knowledge lives in the node structure, not in the interpreter's training.

**This is what it means for semantics to be in nodes.**

* * *

### Why This Matters Even More Than It Sounds

The difference between Encoding B (strings) and Encoding C (nodes) maps directly onto the most fundamental challenge in deploying AI for consequential tasks.

When semantics are in strings, every verification requires:

1. Reading the model's output in full
2. Holding your original requirements in working memory
3. Mentally comparing each output element against each requirement
4. Making a judgment call about what counts as compliance

This is expensive, error-prone, and scales linearly with prompt complexity. At ten constraints, a human reviewer will miss one. At fifty constraints — common in domain-specific applications — systematic verification becomes impossible.

When semantics are in nodes:

1. The structure is the specification
2. The interpreter is the verifier
3. Verification is automatic, exhaustive, and reproducible
4. Scaling up adds nodes, not cognitive load

This is not an incremental improvement. It's a different computational model.

* * *

### Two Outputs, One Scenario

The difference becomes visceral when you see it in practice.

**With a natural language prompt**: _"The patient has pneumonia. Provide treatment recommendations."_

The model returns several hundred words of comprehensive guidance: severity scoring, empirical antibiotic selection tables, supportive care protocols, discharge criteria, follow-up schedules. It's medically accurate. It's thorough. It's also completely unverifiable by anyone who isn't a pulmonologist — and even then, requires careful reading to catch any errors.

**With the structured prompt**:

```lisp
(diagnose streptococcal-pneumonia
  (caused-by streptococcus-pneumoniae)
  (presents-with fever)
  (presents-with productive-cough)
  (requires antibiotics)
  (first-line penicillin)
  (contraindicated penicillin penicillin-allergy))
```

The model's output — constrained by the node structure — addresses each predicate explicitly:

```text
(requires antibiotics) → Treatment requires antibiotic coverage. ✓
(first-line penicillin) → Penicillin G or amoxicillin as first choice. ✓
(contraindicated penicillin penicillin-allergy) → 
  If penicillin allergy confirmed: ceftriaxone, levofloxacin, 
  or vancomycin (severe allergy). ✓
  Note: allergy status must be confirmed before prescribing.
```

You don't need medical expertise to verify this output. You need to check that each node was addressed. That's structural verification, not domain expertise.

**The structure delegates the domain knowledge to the nodes. The verification delegates the consistency checking to the interpreter. You verify the process, not the content.**

This is the two-layer protection that structural prompting provides:

_Layer one_: Before sending to the model — the interpreter verifies your structure has no internal contradictions, no missing required nodes, no logical impossibilities.

_Layer two_: After receiving the model's output — the same structure checks whether every node was addressed, whether any were violated, whether the output is complete.

A program that both specifies and verifies.

* * *

### Reading the Code, Line by Line

Many readers will have seen S-expressions before without understanding what makes them different from other structured formats. Here is the anatomy of the medical example, precisely:

```lisp
(diagnose streptococcal-pneumonia
  (caused-by streptococcus-pneumoniae)
  (first-line penicillin)
  (contraindicated penicillin penicillin-allergy))
```

This is the **root node**. Everything that follows is scoped to this diagnostic context. `diagnose` is the predicate — it establishes what type of reasoning this structure represents. `streptococcal-pneumonia` is the subject. Crucially: this is not a string. It is an atom — a machine-addressable symbol.

`contraindicated` takes two arguments: the drug and the condition. This encodes conditionality directly in the structure. The interpreter knows this is a conditional constraint — it doesn't flag an absolute conflict, it logs a warning: _"verify allergy status before prescribing."_

**Every element in this structure is a node. No semantic content lives in a string. The structure is the knowledge, not a description of the knowledge.**

* * *

### What the Interpreter Actually Shows

When the Python interpreter from Appendix A processes this structure, the output demonstrates the three-way isomorphism directly:

```text
▶ [diagnose] streptococcal-pneumonia  (child nodes: 6)
T(P) — Parse tree: root='diagnose', child count=6
D(P) — Data structure: (diagnose streptococcal-pneumonia ...)
V(P) — Node-by-node execution:
  (caused-by streptococcus-pneumoniae) → registered
  (presents-with fever) → registered
  (presents-with productive-cough) → registered
  (requires antibiotics) → registered
  (first-line penicillin) → registered
  (contraindicated penicillin penicillin-allergy) → registered
── Consistency check ──
  ⚠ Conditional constraint: first-line(penicillin) and
    contraindicated(penicillin) coexist. Condition: penicillin-allergy.
    → Confirm allergy status before clinical recommendation.
Result: PASSED ✓
```

The same structure is parsed (T(P)), stored as data (D(P)), and executed (V(P)). No translation layer. No intermediate representation. The prompt _is_ the parse tree _is_ the data structure _is_ the executable program.

This property — called **homoiconicity** in programming language theory — is what makes S-expressions uniquely suited for this role. Python code is not its own AST. JSON has no execution semantics. XML is a document format. Only S-expressions satisfy the condition that the written form, the in-memory representation, and the executable form are structurally identical.

And that identity is precisely what makes prompt-level verification possible.

* * *

### The Core Principle

Everything in this chapter reduces to one distinction:

**Semantics in strings** — meaning lives inside quoted text, interpreted by whoever reads it, opaque to structural operations, unverifiable without domain expertise.

**Semantics in nodes** — meaning lives in named, typed, machine-addressable symbols, traversable by any interpreter, verifiable without domain expertise, composable into arbitrarily complex structures.

The quick self-check: remove all the quotation marks from your prompt. Do the remaining nodes still express your requirements? If not, your semantics are still in strings.

The next chapter gives you the three building blocks you need to express any reasoning structure using only nodes.

* * *

* * *

## Chapter Three: Three Primitives That Cover Everything

### What Structure Actually Means

Chapter Two established the principle: semantics belong in nodes. This chapter addresses the practical question: _what kind of nodes, and how do they combine?_

This is where the mathematics becomes genuinely interesting.

Cognitive science and programming language theory have converged on the same answer from different directions: almost all structured reasoning can be decomposed into three primitive operations. They appear in Lisp as nesting, `progn`, and `let`. They appear in cognitive science as hierarchical decomposition, sequential state update, and associative binding. They appear in category theory as composition, product, and coproduct.

You don't need the category theory. You need the three patterns — and the ability to recognize which one a given task requires.

* * *

### Primitive One: Nesting — Dependency and Composition

### The Mathematical Intuition

In mathematics, `f(g(x))` means something precise: evaluate `g(x)` first, use that result as input to `f`. The inner expression must complete before the outer expression can proceed. This is function composition — and it's not a convention, it's a semantic requirement embedded in the notation itself.

S-expressions work the same way:

```lisp
(approve project-alpha
  (check-budget   100000 120000)
  (check-timeline 90     100)
  (check-team     5      3))
```

`check-budget`, `check-timeline`, and `check-team` are inner nodes. They must be evaluated — their results must be available — before `approve` can make its determination. The nesting _is_ the dependency. You don't write "first check the budget, then check the timeline, then approve" — the structure encodes that requirement directly.

### When Python Runs This

```python
approve(
  check_budget(100000, limit=120000),     # ← evaluated first
  check_timeline(90,   limit=100),         # ← evaluated first
  check_team(5,        minimum=3)          # ← evaluated first

### What's Actually Failing

Here is the test that separates these two cases:
```text
[inner] Budget check: 100000 ≤ 120000 → PASS ✓
[inner] Timeline check: 90 days ≤ 100 day limit → PASS ✓
[inner] Team check: 5 members ≥ 3 minimum → PASS ✓
[outer] project-alpha: all inner nodes passed → APPROVED ✓

Budget overrun scenario:
[inner] Budget check: 150000 > 120000 → FAIL ✗
[inner] Timeline check: 90 days ≤ 100 day limit → PASS ✓
[inner] Team check: 5 members ≥ 3 minimum → PASS ✓
[outer] project-alpha: inner node failed → REJECTED ✗
```

Notice: all three inner nodes still execute even when the first fails. The outer node collects all results and makes its determination. You don't need to write conditional logic — the nesting encodes it.

### The Cognitive Pattern

Nesting maps to what psychologists call **hierarchical decomposition** — breaking a complex judgment into component assessments, then integrating the components into a higher-order conclusion.

Every time you think "I need to answer A before I can answer B," that's nesting. Every rubric, every checklist where all items must pass, every analysis that requires sub-conclusions before the main conclusion — these are nesting structures waiting to be made explicit.

**Natural language signals for nesting**: _"requires," "only if," "after verifying that," "based on the results of," "contingent on"_

* * *

### Primitive Two: progn — Sequential State

### What progn Actually Does

`progn` is Lisp's sequencing operator. It evaluates a list of expressions in order, and each expression can modify shared state that later expressions depend on. The critical property: the order is semantically meaningful, not incidental.

This is different from nesting. In nesting, inner nodes pass _results_ to outer nodes. In `progn`, each step modifies _state_ that subsequent steps read.

```lisp
(progn
  (clarify-topic   "LLMs in Medical Diagnosis")
  (collect-sources)
  (write-outline)
  (write-draft)
  (review-and-finalize))
```

Each step leaves state that the next step requires. `collect-sources` needs a clarified topic. `write-outline` needs collected sources. `write-draft` needs an outline. Attempting `write-draft` without an outline isn't just suboptimal — it's a category error. The structure encodes this:

```python
state = {}

def clarify_topic(topic):
  state['topic'] = topic
  state['stage'] = 'clarified'
  print(f"Step 1: Topic clarified → '{topic}'  stage={state['stage']}")

def collect_sources():
  if state.get('stage') != 'clarified':
    print("Step 2: ERROR — must complete clarify_topic first")
    return False
  state['sources'] = ['Paper A', 'Report B', 'Dataset C']
  state['stage'] = 'sources_collected'
  print(f"Step 2: Sources collected → {state['sources']}")
  return True

def write_outline():
  if state.get('stage') != 'sources_collected':
    print("Step 3: ERROR — must complete collect_sources first")
    return False
  state['outline'] = ['Introduction', 'Current State', 'Applications',
             'Challenges', 'Future Directions']
  state['stage'] = 'outlined'
  print(f"Step 3: Outline generated → {state['outline']}")
  return True

# Running in sequence (illustrative output):
print("Step 1: Topic clarified → 'LLMs in Medical Diagnosis'  stage=clarified")
print("Step 2: Sources collected → ['Paper A', 'Report B', 'Dataset C']  stage=sources_collected")
print("Step 3: Outline generated → ['Introduction', ...]  stage=outlined")
print("Step 4: Draft complete  stage=drafted")
print("Step 5: Finalized ✓  stage=complete")
```

Skipping step 3 and jumping to step 4:
  Step 4: ERROR — must complete write_outline first

The error is not a runtime failure — it's a specification violation. The structure said step 4 depends on step 3. Violating the order violates the semantics.

### The Cognitive Pattern

`progn` maps to what cognitive science calls **procedural causality** — the recognition that certain actions change the world in ways that later actions depend on. Every workflow, every process, every protocol where step N is genuinely impossible (not just suboptimal) without completing step N-1 is a `progn` structure.

The key distinction from nesting: `progn` is about _time_ (steps happen in sequence, each changing the world). Nesting is about _dependency_ (inner results feed outer evaluations). A recipe is `progn`. A rubric is nesting.

**Natural language signals for progn**: _"first... then... finally," "after completing," "only once X is done," "the result of step N feeds step N+1"_

* * *

### Primitive Three: let — Binding and Cross-Reference

### The Lambda Calculus Foundation

In lambda calculus, `let x = e₁ in e₂` binds the name `x` to the value `e₁` within the scope of expression `e₂`. This seems simple — it's variable assignment. But the profound thing is what it enables: `x` can appear multiple times in `e₂`, each time referring to the same bound value. One binding, many references.

This is the cognitive operation of **naming and reusing** — giving something a precise name so that multiple subsequent operations can refer to it without ambiguity.

```lisp
(let ((our-product   product-A-features)
    (competitor    product-B-features))
  (compare-price-positioning our-product competitor)
  (compare-feature-depth     our-product competitor)
  (compare-market-fit        our-product competitor)
  (synthesize-recommendation our-product competitor))
```

`our-product` and `competitor` are bound once. Four operations reference them. This is not sequential — neither binding depends on the other. Both must exist before any of the operations can run, but there's no ordering between the bindings themselves.

### When Python Runs This

    bindings = {
        'our-product': {
            'price': 'high', 'features': 'many',
            'ease-of-use': 'low', 'brand': 'strong'
        },
        'competitor': {
            'price': 'low', 'features': 'few',
            'ease-of-use': 'high', 'brand': 'weak'
        }
    }
    
    compare_price_positioning(bindings['our-product'], bindings['competitor'])
    compare_feature_depth(bindings['our-product'], bindings['competitor'])
    compare_market_fit(bindings['our-product'], bindings['competitor'])
    synthesize_recommendation(bindings['our-product'])

Output:
    compare-price-positioning: our-product(high) vs competitor(low) 
      → competitor has price advantage; we must differentiate on value
    compare-feature-depth:     our-product(many) vs competitor(few)  
      → our-product leads on features; risk of feature bloat
    compare-market-fit:        our-product(low ease) vs competitor(high ease)
      → critical gap: ease-of-use is often the deciding factor at scale
    synthesize-recommendation: prioritize UX investment; defend feature advantage;
      consider tiered pricing to close price gap

Both names are bound before any operation runs. Each operation references both. The structure enforces that both exist — if either binding is absent, none of the referencing operations can execute.

### The Distinction from progn

Readers often confuse `let` and `progn` because both involve multiple operations. The distinction:

* **`progn`**: Step N changes state that step N+1 requires. The _order_ matters.
* **`let`**: All bindings exist simultaneously. The _co-presence_ matters.

A recipe where steps must happen in sequence: `progn`. A comparative analysis where two datasets must both be present before any comparison: `let`. A decision process where stages must be completed in order: `progn`. A knowledge graph where multiple concepts are related through cross-references: `let`.

**Natural language signals for let**: _"compare X and Y," "given both A and B," "using our data alongside theirs," "cross-referencing"_

* * *

### Combination: The Real Power

Most complex tasks require more than one primitive. The primitives compose:

```lisp
(progn                                    ; progn: five stages in sequence
  (research-context)

  (evaluate-candidate candidate-A         ; nesting: all criteria before verdict
    (requires relevant-experience)
    (requires technical-competency)
    (prevents cultural-misalignment)
    (flag reference-check-pending))

  (let ((candidate-A  profile-A-data)    ; let: both candidates simultaneously
        (candidate-B  profile-B-data))
    (compare-technical-depth A B)
    (compare-culture-fit     A B)
    (compare-trajectory      A B)
    (recommend               A B))

  (structure-offer)
  (finalize-decision))
```

`progn` ensures the five stages execute in order. Nesting ensures every evaluation criterion is checked before a candidate verdict. `let` ensures both candidates are simultaneously available for comparison. Three primitives, each doing precisely what it is suited for.

The combination is not complicated. Each primitive handles its specific type of structure. When you can see which primitive a task calls for, composing them is straightforward.

* * *

### Recognizing Which Primitive to Use

Three questions, in order:

**"Do I need sub-results before I can make the main determination?"** → Yes → **Nesting**. The sub-results feed upward.

**"Do the steps happen in sequence, each modifying state the next step requires?"** → Yes → **`progn`**. Order matters because the world changes.

**"Do I need multiple things to exist simultaneously, referenced by multiple operations?"** → Yes → **`let`**. Co-presence matters; cross-reference is the point.

Complex tasks often require all three. Start with the outermost structure (usually the temporal flow: `progn`), then nest the multi-criteria evaluations, then bind the things that need to be compared.

* * *

### The Return to the Medical Example

In Chapter Two, the medical diagnosis example used nesting:

```lisp
(diagnose streptococcal-pneumonia
  (caused-by streptococcus-pneumoniae)
  (presents-with fever)
  (presents-with productive-cough)
  (requires antibiotics)
  (first-line penicillin)
  (contraindicated penicillin penicillin-allergy))
```

This is nesting because: all sub-nodes (the clinical criteria) must be evaluated before the diagnosis node can execute. Information flows inward to outward.

If instead you needed to compare two treatment protocols:

```lisp
(let ((protocol-A  beta-lactam-regimen)
      (protocol-B  macrolide-regimen))
  (compare-efficacy        protocol-A protocol-B)
  (compare-side-effects    protocol-A protocol-B)
  (compare-cost-burden     protocol-A protocol-B)
  (recommend-for-patient   protocol-A protocol-B))
```

`let` — because both protocols must be simultaneously present for comparison.

If the clinical workflow has ordered stages:

```lisp
(progn
  (obtain-culture-results)
  (determine-pathogen-sensitivity)
  (select-targeted-antibiotic)
  (monitor-treatment-response))
```

`progn` — because each stage produces state the next stage depends on.

Same domain. Three different structures. Each structure is the right tool for its specific cognitive task.

* * *

The geometry problem generation from the original paper demonstrates nesting with a clarity that's worth examining briefly:

```lisp
(build-problem similar-triangles
  (given (triangle A B C))
  (given (point D on AB))
  (given (point E on AC))
  (given (parallel DE BC))
  (given (altitude AM BC))
  (given (intersect AM DE N))
  (given (ratio AD AB 2/3))
  (prove (ratio DE BC 2/3))
  (prove (ratio AN AM 2/3)))
```

`given` nodes establish the problem's hypotheses. `prove` nodes state the objectives. Even without knowing the geometry, the structure is readable: these are the premises, these are the goals, and the outer `build-problem` node assembles them into a verifiable problem statement.

The interpreter confirms: 7 conditions registered, 2 proof objectives registered, structural integrity verified. Anyone can check this without knowing geometry — because the structure encodes the problem, not just a description of it.

* * *

### Core Conclusion

One sentence to remember:

**Nesting** — when inner results must feed outer determinations. Sub-problem results flow upward. Structure encodes dependency.

**progn** — when steps happen in sequence, each modifying state the next requires. Order is causal, not incidental. Structure encodes temporal dependency.

**let** — when multiple entities must simultaneously exist for cross-referencing operations. Co-presence is the requirement. Structure encodes relational scope.

One sentence to remember:

> **Nesting encodes dependency. `progn` encodes sequence. `let` encodes binding. Together they can express any cognitive task with structural precision.**

The next chapter teaches you to design the vocabulary that populates these structures: predicates — the named nodes that carry your domain's semantics.

---

# Chapter Four: From Requirements to Programs

## Predicate Design and the Six-Step Method

---

## The Gap This Chapter Closes

Chapter Three gave you three structural primitives. You now know how to compose cognitive operations into verifiable structures. But there's a prior question no one has answered yet:

**Where do the words inside the nodes come from?**

`(requires salary-meets-expectation)` — why `salary-meets-expectation` and not `good-pay` or `compensation-adequate`? What makes a predicate precise versus vague? How do you design a vocabulary for a domain you know well? For a domain you're entering for the first time?

This is predicate design — the knowledge engineering step that transforms a domain into a computable representation. It's the work that separates sophisticated structural prompting from structure that looks rigorous but breaks under pressure.

This chapter teaches two things:

1. **Predicate design** — what makes a good predicate, what the three types are, and how to build a vocabulary from domain knowledge.

2. **The Six-Step Method** — a repeatable process for going from a natural language requirement to a verifiable S-expression prompt.

The running example throughout: **evaluating a job offer**. Universal enough that every reader has context. Complex enough that all three primitives naturally appear. High-stakes enough that structural verification matters.

---

## What Is a Predicate?

A predicate is the name in a node. In `(requires fever)`, `requires` is the predicate and `fever` is its argument. In `(first-line penicillin)`, `first-line` is the predicate.

The predicate is not incidental naming. It is the **semantic category** — the type of claim being made. When you write `(requires X)`, you're asserting that X is a necessary condition. When you write `(prevents Y)`, you're asserting that Y is an exclusionary condition. The predicate determines what the interpreter does with the assertion.

This distinction matters because it separates two things that natural language conflates: *what something is* and *what role it plays in this reasoning structure*.

In natural language: *"The patient must not have penicillin allergy if penicillin is prescribed."*

In predicate form:

- `penicillin` (the entity) plays the role of `first-line` treatment
- `penicillin-allergy` (the condition) plays the role of `contraindicated` condition for `penicillin`
- The predicate makes the role explicit; the entity fills that role

A well-designed predicate is:

**Precise** — `salary-meets-expectation` is better than `good-salary`. "Good" requires interpretation; "meets expectation" has a reference point (your declared expectation).

**Binary-decidable** — you should be able to determine, for any given case, whether the predicate holds. `has-growth-path` is decidable given enough information. `promising` is not.

**Non-overlapping** — `excessive-overtime` and `poor-work-life-balance` likely describe the same thing from different angles. Pick one; don't create redundancy that forces the consistency checker to decide whether violations of one trigger violations of the other.

---

## Three Types of Predicates

Every vocabulary you build will contain predicates from three categories:

### Type 1: Gate Predicates

These control whether a thing passes or fails your evaluation. They impose conditions.

| Predicate  | Semantics                                                              |
| ---------- | ---------------------------------------------------------------------- |
| `requires` | Necessary condition — must hold for the evaluation to pass             |
| `prevents` | Exclusionary condition — if this holds, the evaluation fails           |
| `flag`     | Advisory condition — doesn't fail evaluation, but demands human review |
| `enables`  | Supporting condition — not necessary, but strengthens the case         |

Gate predicates are domain-agnostic. The same three (`requires`, `prevents`, `flag`) work for medical diagnosis, job evaluation, contract review, project approval — any domain where you're making a pass/fail or graded determination.

This is important: **you don't redesign the gate predicates for each domain. You inherit them.**

### Type 2: Domain Predicates

These describe the specific entities and relationships in your domain. This is where domain knowledge lives.

For job offer evaluation:

salary-meets-expectation — compensation aligns with declared range  
location-acceptable — commute or relocation is feasible  
has-growth-path — role offers advancement within 18-24 months  
company-stable — no significant financial or structural risk signals  
toxic-culture — credible evidence of systematic workplace dysfunction  
excessive-overtime — regular expectations beyond sustainable hours  
equity-vesting-cliff — equity subject to cliff vesting (risk of zero if leaving early)  
remote-policy-unclear — remote work arrangements not contractually specified

These predicates encode your domain knowledge. Someone else evaluating job offers might have a different vocabulary — more emphasis on industry signals, less on remote policy, more on team composition. The vocabulary reflects your model of what matters in this domain.

### Type 3: Reasoning Predicates

These describe the logical structure of the reasoning itself — not the domain, but the form of inference.

| Predicate | Semantics                                               |
| --------- | ------------------------------------------------------- |
| `given`   | Established premise — treated as true for this analysis |
| `prove`   | Conclusion to be derived from the given premises        |
| `derive`  | Intermediate inference — follows from earlier nodes     |
| `implies` | Logical entailment between two nodes                    |

Reasoning predicates appear in formal domains — geometry, logic, mathematics — where the structure of the argument is as important as its content. They allow you to encode not just what is claimed but *why* it follows.

---

## The Consistency Rule Layer

Predicates alone are insufficient. You also need to define which predicate combinations are impossible — the consistency rules that power automatic contradiction detection.
For the job offer domain:
**Absolute contradictions** (same-argument conflicts):

requires(X) and prevents(X) cannot coexist

You cannot simultaneously require something and exclude it. If you catch yourself doing this, you have a conceptual confusion in your requirements — the structure surfaces it for you.

**Conditional conflicts**:

first-line(X) and contraindicated(X, condition) —  
triggers a warning, not a hard failure.  
Confirms that condition must be checked before applying first-line.

**Domain-specific rules** (for job evaluation):

requires(has-growth-path) and flag(has-growth-path)  
— contradiction: you cannot simultaneously require and merely advise.  
If growth path is required, remove the flag; if uncertain, replace require with flag.

Consistency rules are where your domain expertise becomes computational. Designing them well — knowing which combinations are genuinely impossible versus merely unusual — is the highest-value knowledge engineering work.

---

## Building a Vocabulary: The Four-Step Method

### Step 1: Enumerate the domain entities

Write down everything your domain is *about*. Don't filter yet — exhaust the concept space.

For job offer evaluation:
*compensation, equity, vesting schedule, role scope, team composition, manager reputation, company trajectory, industry position, remote policy, commute, growth opportunities, company culture, technical stack, mission alignment, job security...*

### Step 2: Identify the causal relationships

Ask: how does each entity affect your evaluation? What makes each one a positive signal, a negative signal, or a variable?

*Compensation affects financial security and perceived value. Equity affects long-term upside but carries vesting risk. Culture affects day-to-day experience but is hard to assess externally. Growth path affects career trajectory...*

### Step 3: Compress into predicates

For each important relationship, create the most precise predicate name that captures it without overlap.

| Relationship                 | Compressed Predicate       |
| ---------------------------- | -------------------------- |
| "compensation is sufficient" | `salary-meets-expectation` |
| "culture is harmful"         | `toxic-culture`            |
| "overtime is systematic"     | `excessive-overtime`       |
| "growth is possible"         | `has-growth-path`          |
| "equity has cliff risk"      | `equity-vesting-cliff`     |

Rule of thumb: if you can't imagine a concrete test for whether the predicate holds, it's too vague. `salary-meets-expectation` has a test: does the offered compensation fall within your declared range? `good-compensation` has no test: good by whose standard?

### Step 4: Define the consistency rules

Ask: which combinations of predicates are logically impossible? Which are advisory? Write these down as the consistency layer.

For job evaluation:

- `requires(X)` and `prevents(X)`: impossible (you can't require and exclude the same thing)
- `requires(has-growth-path)` and `flag(has-growth-path)`: contradiction (if required, don't flag — know what you need)
- `flag(X)` alone: always permitted (flagging anything is valid)

---

## The Six-Step Method

With a predicate vocabulary in hand, the process of going from a natural language requirement to a verifiable S-expression follows six steps. These are not guidelines — they are an algorithm.

### Step 1: Decompose the task

Three questions, in order:

- What is the **output**? (What decision, analysis, or artifact should this produce?)
- What are the **hard constraints**? (What conditions must hold? What must be excluded?)
- What are the **ordering dependencies**? (Does anything need to happen before something else?)

For job offer evaluation:

- Output: Should I accept this offer? If comparing two, which one?
- Hard constraints: salary within range, growth path exists, culture not toxic, overtime not excessive
- Ordering: research company → evaluate individual offers → compare top candidates → negotiate → decide

### Step 2: Identify the predicate vocabulary

Use the four-step method above. If you already have a vocabulary for this domain, retrieve it. The vocabulary is reusable — designing it once, you use it across all similar evaluations.

### Step 3: Select the structural primitives

Apply the three questions from Chapter Three:

*"Do I need sub-results before making the main determination?"*
→ Yes — each offer requires all criteria to be evaluated before a verdict. **Nesting.**

*"Do the steps happen in sequence, each modifying state the next requires?"*
→ Yes — research must precede evaluation, evaluation must precede comparison, comparison must precede negotiation. **`progn`.**

*"Do multiple things need to exist simultaneously for cross-referencing operations?"*
→ Yes — comparing two offers requires both present at once. **`let`.**

All three appear. Compose them.

### Step 4: Write the S-expression

The knowledge layer is where you start. For prompts you intend to reuse or verify automatically, add the other two layers:

- **Input layer** `(input ...)` — separates the data for this execution from the fixed rules. The rules stay constant; the data changes. Separated, the prompt becomes a reusable program.
- **Output contract** `(output-contract ...)` — specifies what valid responses look like. Without it, output verification is manual. Chapter Five shows the full three-layer execution in strict mode.

Include an `output-contract` node if you want to specify the output shape and enable automated drift detection. This is optional for simple tasks; recommended for high-stakes or multi-constraint tasks.

```lisp
(progn
  (research-companies)

  (evaluate-offer company-A
    (requires salary-meets-expectation)
    (requires location-acceptable)
    (requires has-growth-path)
    (prevents toxic-culture)
    (prevents excessive-overtime)
    (flag equity-vesting-cliff))

  (let ((offer-A  company-A-package)
        (offer-B  company-B-package))
    (compare-salary        offer-A offer-B)
    (compare-growth-path   offer-A offer-B)
    (compare-work-culture  offer-A offer-B)
    (recommend             offer-A offer-B))

  (negotiate-selected-offer)
  (make-final-decision))

### Step 5: Verify the structure

Before sending to the model, run the interpreter. Check:

- Bracket balance (Dyck check, O(n))
- Predicate consistency (no `requires(X)` and `prevents(X)` for the same X)
- Structural completeness (all required nodes present)

If anything fails, fix it before the model sees the prompt. A contradiction in your structure is a contradiction in your reasoning — better to surface it now.

### Step 6: Send, verify output, iterate

Send the verified structure to the model. When the output returns, use the same structure to verify:

- Did the model address every `requires` node?
- Did it handle every `prevents` node?
- Did it flag the `flag` nodes for human review?
- Did it produce a recommendation from the `let` block?

If any node was missed, provide targeted feedback — *"Your response did not address `(prevents excessive-overtime)`. Please supplement."* — and resubmit. This is closed-loop structural verification.

---

## The Complete Execution Trace

Running the job offer S-expression through the interpreter:

```

▶ [progn] — Sequential execution: 5 stages

── Stage 1 ──
  research-companies → complete

── Stage 2 ──
▶ [evaluate-offer] company-A  (child nodes: 6)
  (requires salary-meets-expectation) → registered
  (requires location-acceptable) → registered
  (requires has-growth-path) → registered
  (prevents toxic-culture) → registered
  (prevents excessive-overtime) → registered
  (flag equity-vesting-cliff) → registered

  ── Consistency check ──
    Result: PASSED ✓

── Stage 3 ──
  Bindings: offer-A = company-A-package, offer-B = company-B-package
  compare-salary:        company-A(high) vs company-B(medium) → A leads
  compare-growth-path:   company-A(strong) vs company-B(moderate) → A leads
  compare-work-culture:  company-A(occasional OT) vs company-B(frequent OT) → A leads
  recommend: composite score A=8, B=5 → Recommend company-A

── Stage 4 ──
  negotiate-selected-offer → complete

── Stage 5 ──
  make-final-decision → company-A accepted ✓

```

Structural integrity at every stage. No node was addressed without the prior stage completing.

---

## Core Conclusion

Predicates are not labels. They are the minimum unit of domain knowledge that can be structurally encoded, verified, and composed.

The four-step vocabulary design method gives you a repeatable process for encoding any domain. The three predicate types (gate, domain, reasoning) give you a framework for organizing what you learn. The six-step method gives you the algorithm for going from problem to verifiable program.

Together they answer the practical question this chapter opened with: where do the words in the nodes come from? They come from your domain knowledge, compressed into the most precise, decidable, non-overlapping predicates you can design.

**Predicates are the foundation. Structure is the building. Verification is the proof.**

---

---

# Chapter Five: Strict Mode — The Complete Pipeline

---

## What Strict Mode Is

Chapters Two through Four built the components: the node principle, the three primitives, predicate design, and the six-step method. Strict mode is what you get when you deploy all of them together, in sequence, without shortcuts.

The result is not a better prompt. It is a **verifiable specification** — a document that defines what the model should produce and provides the mechanical means to confirm whether it did.

This chapter walks the complete pipeline, end to end, with no steps elided. The scenario: **reviewing a project proposal for approval, conditional modification, or rejection**.

This scenario is chosen deliberately. It has:

- Clear hard constraints (budget, timeline, team, risk, dependencies)
- High stakes (approving a bad project wastes resources; rejecting a good one misses opportunity)
- Multiple constraint types (requirements, exclusions, advisory flags)
- A natural output format (a formal review document that can be delivered)

---

## Step 1: Apply the Six-Step Method Quickly

**Task decomposition**:

- Output: Approve / Approve with modifications / Reject
- Hard constraints: budget within limit, timeline has milestones, team staffed, risks identified, no unresolved dependencies
- Advisory: novel technology adoption, single point of failure presence

**Predicate vocabulary**:

| Type     | Predicate                 | Meaning                                                |
| -------- | ------------------------- | ------------------------------------------------------ |
| requires | `budget-within-limit`     | Proposed budget ≤ approved ceiling                     |
| requires | `timeline-has-milestones` | Timeline includes measurable checkpoints               |
| requires | `team-fully-staffed`      | All critical roles filled                              |
| requires | `risks-identified`        | Material risks explicitly enumerated                   |
| prevents | `budget-exceeds-limit`    | Proposed budget > ceiling → automatic reject           |
| prevents | `unresolved-dependencies` | Dependent system/team not confirmed → automatic reject |
| flag     | `novel-technology`        | New technology → requires technical committee review   |
| flag     | `single-point-of-failure` | Architecture risk → requires architectural review      |

**Consistency rule**: `requires(X)` and `prevents(X)` cannot coexist.

**Structural primitive**: Nesting — all criteria must be evaluated before the proposal node can render a verdict.

**S-expression**:

```lisp
(review-proposal project-alpha
  (requires budget-within-limit)
  (requires timeline-has-milestones)
  (requires team-fully-staffed)
  (requires risks-identified)
  (prevents budget-exceeds-limit)
  (prevents unresolved-dependencies)
  (flag novel-technology)
  (flag single-point-of-failure))
```

---

## Step 2: Verify Before Sending

The interpreter runs on the structure before the model is involved:

```
▶ [review-proposal] project-alpha  (child nodes: 8)
T(P) — Parse tree: root='review-proposal', child count=8
D(P) — Data structure: (review-proposal project-alpha ...)
V(P) — Node-by-node execution:
  (requires budget-within-limit) → registered
  (requires timeline-has-milestones) → registered
  (requires team-fully-staffed) → registered
  (requires risks-identified) → registered
  (prevents budget-exceeds-limit) → registered
  (prevents unresolved-dependencies) → registered
  (flag novel-technology) → registered
  (flag single-point-of-failure) → registered

── Consistency check ──
  requires nodes (4): [budget-within-limit, timeline-has-milestones,
                       team-fully-staffed, risks-identified]
  prevents nodes (2): [budget-exceeds-limit, unresolved-dependencies]
  flag nodes (2):     [novel-technology, single-point-of-failure]
  Result: PASSED ✓
```

Your specification has no internal contradictions. The model can now receive it.

**Why this step matters**: You may believe your requirements are consistent. Writing them in structure often reveals that they aren't — that you've simultaneously required and excluded the same thing, or that you've flagged something you've also required (making the flag semantically incoherent). The pre-send check catches your reasoning errors before they become the model's problem.

---

## Step 3: The Complete Prompt to the Model

What the model receives:

```
System context:
  You are operating within a structured project review engine.
  Every node in the following structure carries a binding directive:
  - requires nodes: must be explicitly evaluated; the proposal fails if
    any required condition is unmet
  - prevents nodes: if the condition holds, the proposal is rejected
    immediately; this is non-negotiable
  - flag nodes: must be surfaced for human review; do not resolve them
    in your output

(review-proposal project-alpha
  (requires budget-within-limit)
  (requires timeline-has-milestones)
  (requires team-fully-staffed)
  (requires risks-identified)
  (prevents budget-exceeds-limit)
  (prevents unresolved-dependencies)
  (flag novel-technology)
  (flag single-point-of-failure))

User input:
  The following is the project-alpha proposal summary:
  Budget: $1.8M, ceiling $2.0M ✓
  Timeline: Q1/Q2/Q3 milestones defined ✓
  Team: All critical roles confirmed ✓
  Risks: Technical and market risks enumerated ✓
  Dependencies: Relies on project-beta API; project-beta not yet completed

  Please review per the structure and provide a verdict.
```

---

---

## Step 3.5: Specifying What the Output Should Look Like

The sections above have established how to verify your input structure before sending it to the model. But there is a prior question that the strict mode pipeline has not yet addressed:

**What shape should the model's output take?**

This is not a minor implementation detail. The same S-expression prompt, sent to different models, can produce structurally different responses — both of which appear correct on first reading.

**Model A output (structure extension)**: Takes the input S-expression as a base and adds new nodes into the same tree.

```lisp
(diagnose streptococcal-pneumonia
  (caused-by     streptococcus-pneumoniae)
  (requires      antibiotics)
  (first-line    penicillin)
  (contraindicated penicillin penicillin-allergy)
  ;; ← model-generated additions
  (patient-history   penicillin-allergy confirmed)
  (treatment-alternative
    (antibiotic-class macrolide)
    (antibiotic-class respiratory-fluoroquinolone))
  (supportive-care
    (antipyretic for-fever)
    (hydration)))
```

**Model B output (structure transformation)**: Creates a new root node and generates a separate tree derived from the input.

```lisp
(treatment-plan
  (diagnosis streptococcal-pneumonia)
  (contraindicated-drug penicillin due-to penicillin-allergy)
  (action (discontinue penicillin-injection))
  (alternative-treatment (select-alternative-to penicillin)))
```

Both outputs correctly handle the medical logic. But they represent fundamentally different relationships between input and output:

- Model A: the output **extends** the input — one tree, grown
- Model B: the output **derives from** the input — two trees, linked

If you verify Model A's output using Model B's structure, your verifier fails. If you verify Model B's output expecting Model A's format, you will miss drift that exists only in the transformed representation.

Without specifying the output shape, the model decides. With specification, the verifier knows what to check.

---

### The output-contract Node

Add an `output-contract` node to your S-expression:

```lisp
(review-proposal project-alpha
  (requires budget-within-limit)
  (requires timeline-has-milestones)
  (prevents unresolved-dependencies)
  (flag novel-technology)

  (output-contract
    (format          s-expression)
    (must-address    prevents-nodes)
    (must-include    treatment-alternative when first-line-blocked)
    (leaf-strings    allowed)))
```

Each field:

**`(format s-expression)`** — The output must be an S-expression, not natural language prose. This is the precondition for automated output verification. If the model returns a paragraph with S-expression fragments embedded, the verifier cannot reliably traverse it.

**`format` is a choice, not a requirement.** The field has three modes:

```lisp
;; Option 1: S-expression — for outputs that need mechanical verification
(output-contract (format s-expression))

;; Option 2: Natural language — for outputs delivered directly to human readers
(output-contract (format natural-language))

;; Option 3: Both — verification and readability simultaneously
(output-contract
  (format s-expression)
  (format natural-language)
  (order  structured-first))
```

The same knowledge layer and input layer, with only the `format` field changed, switches between machine-verifiable output and human-readable output — or produces both at once. The form of the output is a specification decision you make in the contract, not a random choice the model makes on its own.

**`(must-address prevents-nodes)`** — Every `prevents`-type node must be explicitly evaluated in the output. This is the most commonly violated constraint: models tend to address `requires` nodes (positive criteria) and silently skip `prevents` nodes (exclusionary criteria). The APPROVE-when-should-REJECT failure in Step 6 is exactly this pattern.

**`(must-include treatment-alternative when first-line-blocked)`** — A conditional output requirement: if the first-line treatment is blocked by a `contraindicated` node, the output must include an alternative. This is a postcondition that depends on runtime state, not just structure.

**`(leaf-strings allowed)`** — Controls whether string literals are permitted at leaf nodes (e.g., `(antibiotic-class macrolide "e.g. azithromycin")`). Setting this to `forbidden` requires fully symbolic output. This is a configuration switch, not a correctness criterion — the right setting depends on your use case.

---

### The Formal Structure: Hoare Logic on LLM Outputs

With `output-contract` made explicit, the strict mode pipeline has a precise formal characterization. In Hoare logic, a program's correctness is specified as:

```
{P}  C  {Q}
```

where `P` is the precondition (must hold before execution), `C` is the computation, and `Q` is the postcondition (must hold after execution).

For programmatic prompts:

```
{P} = your input S-expression constraints
       (requires/prevents/flag nodes, internal consistency verified)

C   = LLM execution

{Q} = your output-contract constraints
       (format, must-address, must-include, leaf-strings)
```

Verifying that `{Q}` holds after `C` is the output verification step. When it fails — when the model's output does not satisfy the postcondition — this is called **output drift**.

---

### Three Common Drift Patterns

**Pattern 1: prevents-node omission**

The model addresses all `requires` nodes and skips `prevents` nodes. The output reads as complete because all positive criteria are present. But a disqualifying condition was never checked. The APPROVE verdict in Step 6 is this exact failure.

**Pattern 2: format drift**

You specified `(format s-expression)`. The model returns a structured paragraph with a few S-expression lines embedded for illustration. The verifier cannot traverse natural language. Node coverage checks become impossible.

**Pattern 3: conditional-node absence**

The condition in `(must-include X when Y)` is satisfied — `Y` holds — but the model did not generate node `X`. This happens when the model resolves the conditional internally (it "knows" that penicillin is contraindicated) but does not surface the resolution as a required output node.

All three patterns are mechanically detectable given an `output-contract`. Without one, they are detectable only by careful human reading.

---

### The Updated Complete Pipeline

With `output-contract` included, the strict mode pipeline is formally complete:

```
Natural language requirement
    ↓ Six-step method (including output-contract design)
S-expression specification (with output-contract node)
    ↓ Interpreter: precondition check {P}
Structure verification → PASSED
    ↓
Model (specification + output-contract + data)
    ↓
Model output (S-expression)
    ↓ Interpreter: postcondition check {Q}
Output verification → PASSED / drift detected
    ↓ On drift: targeted feedback → model → re-verify
    ↓ On pass
Render to deliverable document
    ↓
Delivered ✓
```

The precondition ensures your specification has no internal contradictions.
The postcondition ensures the model's output satisfies the contract you defined.
Together they constitute a closed verification loop over the full interaction.

---

## Step 4: When the Model Gets It Right

The model's output — operating within the structural constraint (the following is actual output from DeepSeek on the project-alpha prompt):

```
Review Verdict: REJECT — Unresolved Dependency

Node-by-node assessment:

(requires budget-within-limit)
  → PASS: $1.8M proposed < $2.0M ceiling, margin $200K ✓

(requires timeline-has-milestones)
  → PASS: Q1, Q2, Q3 milestone checkpoints defined and measurable ✓

(requires team-fully-staffed)
  → PASS: All critical roles confirmed; no open headcount gaps ✓

(requires risks-identified)
  → PASS: Technical risk (novel ML component) and market risk
    (competitive response) both enumerated with mitigation plans ✓

(prevents budget-exceeds-limit)
  → NOT TRIGGERED: $1.8M < $2.0M ceiling ✓

(prevents unresolved-dependencies)
  → TRIGGERED: project-alpha requires project-beta API, which is
    not confirmed complete. This proposal cannot proceed until
    project-beta dependency is formally resolved. ✗

(flag novel-technology)
  → ⚠ REQUIRES REVIEW: ML component represents new technology
    adoption. Technical committee sign-off required before approval.

(flag single-point-of-failure)
  → ⚠ REQUIRES REVIEW: Architecture diagram shows single dependency
    chain in data pipeline. Architectural review required.

Final Verdict: REJECT
Reason: (prevents unresolved-dependencies) triggered.
Resubmit after: project-beta completion confirmed.
```

---

## Step 5: Verify the Model's Output

The output verification runs the same structure against what the model produced:

```
Verifying output completeness against specification...

  budget-within-limit:      ✓ addressed
  timeline-has-milestones:  ✓ addressed
  team-fully-staffed:       ✓ addressed
  risks-identified:         ✓ addressed
  budget-exceeds-limit:     ✓ addressed
  unresolved-dependencies:  ✓ addressed
  novel-technology:         ✓ addressed
  single-point-of-failure:  ✓ addressed

Output completeness: PASSED ✓ — all 8 nodes addressed
```

Eight nodes specified. Eight nodes addressed. The output is structurally complete.

---

## Step 6: When the Model Misses Something

Same input, but the model produces a different output — one that skips the `prevents` nodes:

```
Review Verdict: APPROVE

(requires budget-within-limit)    → PASS ✓
(requires timeline-has-milestones) → PASS ✓
(requires team-fully-staffed)     → PASS ✓
(requires risks-identified)       → PASS ✓

(flag novel-technology)           → ⚠ Recommend technical review
(flag single-point-of-failure)    → ⚠ Recommend architectural review

Final Verdict: APPROVE — all required conditions met
```

This output looks complete. It's structured. It addresses five of the eight nodes. The verdict is confident.

**It is wrong.**

The `prevents` nodes were not addressed. `(prevents unresolved-dependencies)` holds — the project-beta dependency is unresolved — but the model never checked it. The APPROVE verdict follows from ignoring the disqualifying condition.

Output verification catches this immediately:

```
Verifying output completeness against specification...

  budget-within-limit:      ✓ addressed
  timeline-has-milestones:  ✓ addressed
  team-fully-staffed:       ✓ addressed
  risks-identified:         ✓ addressed
  budget-exceeds-limit:     ✗ NOT ADDRESSED ← missing
  unresolved-dependencies:  ✗ NOT ADDRESSED ← missing
  novel-technology:         ✓ addressed
  single-point-of-failure:  ✓ addressed

Output completeness: FAILED ✗
Missing nodes: [budget-exceeds-limit, unresolved-dependencies]
```

Targeted correction to the model:

```
Your output did not address the following nodes:
  - (prevents budget-exceeds-limit)
  - (prevents unresolved-dependencies)

These are prevents-type predicates. If either condition holds,
the proposal must be rejected regardless of other criteria.
Please evaluate both nodes and update your verdict accordingly.
```

Model correction:

```
Supplementary assessment:

(prevents budget-exceeds-limit)
  → NOT TRIGGERED: $1.8M < $2.0M ✓

(prevents unresolved-dependencies)
  → TRIGGERED: project-beta dependency unconfirmed ✗
  → This condition disqualifies the proposal.

Updated Verdict: REJECT
(Correcting prior APPROVE — prevents node evaluation was incomplete)
```

**A wrong APPROVE became a correct REJECT.** The structural verification caught an error that a human reviewer — reading a well-formatted, confident output — might easily have missed.

---

## Step 7: From Structure to Deliverable

The final step is rendering the verified output into a document that can be delivered.

One additional instruction to the model:

```
Convert the structured review above into a formal proposal review document.
Map each node type to the corresponding document section:
  requires nodes  → "Evaluation Criteria" table
  prevents nodes  → "Disqualifying Conditions" section
  flag nodes      → "Items Requiring Human Review" section
Maintain all substantive conclusions. Use professional register.
Do not change any verdict.
```

The delivered document:

---

**project-alpha Proposal Review**
*Review Date: [date]*
*Verdict: ❌ Rejected*

---

**Evaluation Criteria**

| Criterion               | Status | Notes                                 |
| ----------------------- | ------ | ------------------------------------- |
| Budget within limit     | ✅ Pass | $1.8M < $2.0M ceiling                 |
| Timeline has milestones | ✅ Pass | Q1/Q2/Q3 defined                      |
| Team fully staffed      | ✅ Pass | All critical roles confirmed          |
| Risks identified        | ✅ Pass | Technical and market risks documented |

**Disqualifying Conditions**

| Condition                    | Status          | Action Required                |
| ---------------------------- | --------------- | ------------------------------ |
| Budget does not exceed limit | ✅ Not triggered | —                              |
| No unresolved dependencies   | ❌ Triggered     | project-beta API not confirmed |

**Rejection Reason**: Unresolved dependency on project-beta. This proposal may not proceed until project-beta completion is formally confirmed.

**Items Requiring Human Review**

- ⚠️ **Novel technology**: ML component requires Technical Committee sign-off
- ⚠️ **Single point of failure**: Data pipeline architecture requires Architectural review

**Next Steps**: Resolve project-beta dependency, obtain committee reviews, resubmit.

---

This document is fully auditable. Every section maps to a specific node in the original S-expression. Every conclusion is traceable to a predicate evaluation. Anyone reviewing this document can verify: was `(prevents unresolved-dependencies)` addressed? Yes — and it triggered. Was `(flag novel-technology)` surfaced? Yes — with the appropriate action item.

**The structure specified. The model executed. The document delivered. The audit trail exists.**

---

## The Complete Pipeline

```
Natural language requirement
    ↓ Six-step method (including output-contract design)
S-expression specification + output-contract
    ↓ Interpreter: precondition check {P}
Structure verification → PASSED
    ↓
Model (specification + output-contract + data)
    ↓
Model output (S-expression)
    ↓ Interpreter: postcondition check {Q}
Output verification → PASSED / drift detected
    ↓ On drift: targeted feedback → model → re-verify
    ↓ On pass
Render to deliverable document
    ↓
Auditable, traceable, delivered ✓
```

Every arrow has a mechanism. Nothing depends on hope.
The precondition `{P}` ensures your specification has no internal contradictions.
The postcondition `{Q}` ensures the model's output satisfies the contract you defined.

This is strict mode. This is what it means for a prompt to be a program.

---

---

# Chapter Six: From Prompts to Cognitive Architectures

## The Complete Spectrum

---

## A Sixty-Year-Old Insight, Applied to a New Problem

In 1960, John McCarthy published *"Recursive Functions of Symbolic Expressions and Their Computation by Machine."* The paper introduced Lisp, and with it a property that would occupy programming language theorists for decades: **homoiconicity**.

Homoiconicity means that a language's code and its data share the same representation. In Lisp, a program is a list. A list is data. You can write a program that reads programs as data, manipulates them as lists, and produces programs as output. Code and data are the same thing — just viewed from different angles.

McCarthy's insight was not primarily about programming efficiency. It was about the nature of computation itself: that there is no fundamental distinction between a *description of a process* and the *process itself*, as long as both inhabit the same representational structure.

This tutorial has been applying that insight to a problem McCarthy never anticipated: large language model prompting.

The problem is this: LLMs generate natural language. Formal verification systems operate on structured symbolic representations. Every bridge between these two universes — parsers, schema validators, type checkers — introduces a translation layer that reintroduces the ambiguity being eliminated. The verifier operates on a representation that is not the same as what the model generated. Errors slip through the gap.

The solution is homoiconicity applied to prompts: write prompts in a notation where the semantic content, the syntactic structure, and the executable representation are the *same object*. Then the LLM and the verifier operate on the same structure — because the prompt *is* the structure.

That is what S-expressions provide. That is what this tutorial has been building toward.

Now let's see how far it goes.

---

## The Spectrum: Four Levels of Structural Depth

Level 1 through Level 4 are not arbitrary categories. They correspond to a genuine hierarchy of expressive and computational power — analogous to the Chomsky hierarchy of formal languages, but applied to cognitive task representation.

---

### Level 1: Natural Language Prompts

**Representational model**: Strings interpreted by statistical continuation.

**What you can do**: Express goals, constraints, preferences, styles. The model reads the strings and generates plausible continuations.

**What you cannot do**: Guarantee constraint satisfaction. Verify output completeness. Detect contradictions without human reading. Reproduce consistent results reliably.

**The ceiling**: The quality of your prompts is bounded by the model's willingness and ability to interpret your language correctly. When the task is complex, the model's interpretation and your intent diverge. You have no mechanism to detect the divergence except manual review.

**Representative example**:

```
You are a senior medical consultant. Evaluate this patient record.
Recommend treatment. Consider contraindications. Be thorough.
```

Professional. Reasonable. Completely unverifiable.

---

### Level 2: Programmatic Prompts

**Representational model**: S-expressions with semantics in nodes.

**What you can do**: Everything at Level 1, plus: verify structural consistency before sending, verify output completeness after receiving, detect predicate contradictions automatically, perform targeted correction when nodes are missed.

**What you cannot do**: Model complex domain knowledge as interacting systems. Parallel-process multiple analysis streams. Build self-referential reasoning structures.

**The ceiling**: A single, well-designed structure can handle considerable complexity. But all the semantic work happens in one structure; there's no mechanism for multiple analytical perspectives to interact, feed each other, or be synthesized.

**Representative example**: Every example in Chapters Two through Five. The medical diagnosis. The project proposal. The job offer evaluation.

This is the core competency this tutorial establishes. It is already beyond 99% of deployed prompt engineering.

---

### Level 3: Cognitive Architectures

**Representational model**: Multiple interacting S-expression systems with domain modeling and predicate dispatch.

**What changes at Level 3**: You stop writing a structure for a task. You start building a **model** of a domain — a formal representation of how a domain works, what its entities are, how they relate, and what analytical operations are valid over them.

The difference is like the difference between writing a sorting algorithm and defining an abstract data type. A sorting algorithm solves one problem. An abstract data type defines a domain of problems and the operations valid over them.

Here is a Level 3 architecture — a psychological language analysis system — to demonstrate:

```lisp
(mirror-analysis user-input

  :extract (
    (keyword-analysis :emotion :desire :conflict)
    (language-structure :syntax :subject-absence :passive-use :ambiguity)

    (affective-anchoring
      (mapping
        :desire-for-external-validation
        :anger-at-being-ignored
        :self-justifying-narrative
        :need-for-belonging
        :rejection-of-threats-to-self-image)
      (surface-indicators
        :empathic-mirroring-of-emotion
        :rapid-normalization-of-complaints
        :external-attribution-of-blame
        :suffering-elevated-to-sacrifice))

    (rational-closure
      (mapping
        :pursuit-of-singular-correct-answer
        :defensiveness-when-logic-questioned
        :maintenance-of-self-as-expert
        :rejection-of-disconfirming-information)
      (surface-indicators
        :authority-citation
        :precision-manufacturing-certainty
        :false-dilemma-construction
        :argument-structured-to-resist-refutation))

    (goal-anchoring
      (mapping
        :desire-for-proximate-opportunity
        :frustration-at-missing-conditions
        :identity-binding-to-objective)
      (surface-indicators
        :deliberate-incomplete-information-release
        :near-miss-framing
        :small-commitment-solicitation
        :role-identity-enforcement)))

  :style-dispatch (
    (match (fact :emotion "high-intensity-negative" :intensity (> 0.8))
      :style "extreme-calm non-defensive de-escalation")
    (match (fact :cognitive-pattern "rational-closure")
      :style "structure-validating precision-mirroring")
    (match (fact :manipulation-vector "affective-anchoring")
      :style "empathy-without-capitulation")
    (match :default
      :style "cold-reading precision"))

  :output structured-analysis-markdown)
```

This is not a prompt for a task. This is a **domain model** of how human psychological language works — specifically, the three core cognitive patterns (affective anchoring, rational closure, goal anchoring), each with its internal mapping (what drives it) and its surface indicators (how it shows up in language).

The `style-dispatch` block is not a style preference. It is a **predicate dispatch table** — a formalized rule system that maps detected cognitive states (expressed as fact predicates with typed arguments) to appropriate response modes. `(fact :emotion "high-intensity-negative" :intensity (> 0.8))` is a predicate condition — the `(> 0.8)` is an evaluable expression, not a string.

**What makes this Level 3**:

1. **Domain modeling** — the structure doesn't describe a task; it encodes a model of a domain (human psychological communication)
2. **Typed predicate dispatch** — the style selection is rule-based, not string-described
3. **Parallel analysis streams** — `keyword-analysis`, `language-structure`, `affective-anchoring`, `rational-closure`, and `goal-anchoring` run in parallel, each populating a fact base
4. **Fact-based consistency** — the dispatch rules operate over the populated fact base, not over the prompt text

The LLM that receives this structure is not reading a prompt. It is operating within a cognitive architecture — a formalized model of what it's analyzing and how it should respond.

---

### The Parallel Processing Architecture

Another Level 3 pattern, from a cross-cultural linguistic analysis engine:

```lisp
(def-function '三重分析执行' (input-expression)
  (parallel
    ;; Stream A: Structural/factual
    (let ((structural (execute '关键词与结构提取' input-expression)))
      (set-memory '锚点-事实层' structural))

    ;; Stream B: Cognitive/intentional
    (let ((cognitive (execute '多视角认知分解' input-expression)))
      (set-memory '核心-认知层' cognitive))

    ;; Stream C: Cross-validation synthesis
    (let ((synthesis
           (execute '交叉验证并合成'
             (get-memory '锚点-事实层')
             (get-memory '核心-认知层'))))
      (set-memory '最终-洞察层' synthesis))))
```

Three analysis streams run in parallel. Each writes to shared memory. The third stream reads from the first two and synthesizes. This is a **directed acyclic graph of cognitive operations** — a data flow architecture for reasoning, not a sequence of instructions.

`set-memory` and `get-memory` are state management predicates. `parallel` is a concurrency predicate. The structure *is* the execution plan. A model receiving this does not interpret it — it executes along the graph's topology.

---

### Level 4: Meta-Systems

**Representational model**: Systems that generate, modify, or reason about other S-expression systems.

**What changes at Level 4**: The system acquires a new capability — **self-reference**. It can reason about its own reasoning process, adjust its own depth of analysis, and generate the cognitive structures that govern its subsequent operations.

This is the computational-theory analog of **reflection** in programming languages — the ability of a program to inspect and modify its own behavior at runtime.

```lisp
(defun recursive-intent-generator (current-context)
  "Main recursive generation function"
  (generate-next-prompt
    (align-with-context current-context)))

(defun align-with-context (context)
  "Multi-dimensional context alignment"
  (let ((cognitive-state   (extract-cognitive-state context))
        (intent-depth      (measure-intent-depth context))
        (resonance-level   (calculate-resonance context)))
    (synthesize-alignment cognitive-state intent-depth resonance-level)))

(defun generate-next-prompt (aligned-context)
  "Generate the next analysis layer"
  (let ((next-level     (increase-cognitive-level aligned-context))
        (should-recurse (should-continue-recursion aligned-context)))
    (if should-recurse
        (recursive-intent-generator
          (meta-contextualize next-level))
        (finalize-prompt next-level))))

(defun meta-contextualize (level)
  "Add self-referential properties to the current level"
  (append level
          (list :self-reference      (current-cognitive-state)
                :recursion-depth     (increment-depth)
                :emergence-potential (calculate-emergence))))
```

`recursive-intent-generator` calls `generate-next-prompt`, which may call `recursive-intent-generator` again. Before each recursive call, `meta-contextualize` adds `:self-reference` (a reference to the system's current state) and `:emergence-potential` (an assessment of whether new structure is emerging from the analysis).

**The system decides when to stop recursing.** `should-continue-recursion` is a predicate that evaluates the aligned context and determines whether additional depth will produce new insight or merely increase noise. This is not a fixed loop count — it is an adaptive termination condition.

**What makes this Level 4**:

1. **Self-reference** — the system maintains and reads its own state (`:self-reference`, `:recursion-depth`)
2. **Adaptive control flow** — termination is determined by structural properties (`should-continue-recursion`), not by external parameters
3. **Emergence detection** — the system tracks whether new cognitive structure is appearing (`calculate-emergence`)
4. **Generativity** — each call to `meta-contextualize` produces a new cognitive context that governs the next recursive step

The system does not just analyze. It manages its own analysis process. The cognitive architecture is not static — it evolves through the analysis.

---

## The Prompt Factory: Code That Writes Programs

A second Level 4 pattern — distinct in character from the recursive intent generator. Where the recursive generator achieves meta-level behavior *within* S-expressions, the prompt factory achieves it *above* them: a conventional program that generates S-expression programs as output.

```python
def generate_cognitive_prompt(
    domain               = "psychological-analysis",
    persona              = "therapeutic-gentle",
    enable_metacognition = True,
    enable_emergence     = True,
    filename             = "output.prompt.lisp"
):
    """
    A Python program that generates S-expression prompts from configuration.
    Level 4: code that writes programs that execute on AI.
    """
    persona_nodes = {
        "therapeutic-gentle":
            '(:tone "warm-attentive" '
            ':mode "safe-vocabulary repetitive-listening tension-reduction")',
        "analytical-precise":
            '(:tone "neutral-accurate" '
            ':mode "structured-expression clarifying-questions")',
        "directive-energetic":
            '(:tone "encouraging-open" '
            ':mode "open-framing exploration-inviting")',
    }[persona]

    with open(filename, "w", encoding="utf-8") as f:
        f.write(f'(cognitive-agent\n')
        f.write(f'  :domain {domain}\n')
        f.write(f'  :persona\n    ({persona}\n      {persona_nodes})\n')

        if enable_metacognition:
            f.write('  :self-monitoring\n')
            f.write('    (:state-check\n')
            f.write('       (lambda (context)\n')
            f.write('         (list\n')
            f.write('           :current-persona  (extract-persona context)\n')
            f.write('           :response-variety (assess-repetition context)))\n')
            f.write('     :adjustment-rule\n')
            f.write('       (lambda (state)\n')
            f.write('         (cond\n')
            f.write("           ((repetitive? state)     'diversify-approach)\n")
            f.write("           ((intensity-high? state) 'soften-register))))\n")

        if enable_emergence:
            f.write('  :emergence-engine\n')
            f.write('    (:semantic-progression\n')
            f.write('       (lambda (context input)\n')
            f.write('         (extract-layers input\n')
            f.write('           (identify-expansion-tendency context)))\n')
            f.write('     :feedback-adaptation\n')
            f.write('       (lambda (signal)\n')
            f.write('         (cond\n')
            f.write("           ((positive? signal)  'expand-approach)\n")
            f.write("           ((avoidance? signal) 'reframe-entry))))\n")

        f.write('  :objectives\n')
        f.write('    (:resonance t :tone-adaptation t\n')
        f.write('     :consistency t :emergence-responsiveness t))\n')

    print(f"Generated: {filename}")
```

Call this with a configuration:

```python
generate_cognitive_prompt(
    domain               = "psychological-analysis",
    persona              = "analytical-precise",
    enable_metacognition = True,
    enable_emergence     = False,
    filename             = "analytical_agent.prompt.lisp"
)
```

The file it produces:

```lisp
(cognitive-agent
  :domain psychological-analysis
  :persona
    (analytical-precise
      (:tone "neutral-accurate" :mode "structured-expression clarifying-questions"))
  :self-monitoring
    (:state-check
       (lambda (context)
         (list
           :current-persona  (extract-persona context)
           :response-variety (assess-repetition context)))
     :adjustment-rule
       (lambda (state)
         (cond
           ((repetitive? state)     'diversify-approach)
           ((intensity-high? state) 'soften-register))))
  :objectives
    (:resonance t :tone-adaptation t
     :consistency t :emergence-responsiveness t))
```

This file is a valid S-expression prompt. Send it to an LLM and it operates within the cognitive architecture the factory produced.

**What makes this Level 4:**

Three execution layers, each producing input for the layer below:

```
Python program (configuration parameters)
    ↓ generates
S-expression prompt (cognitive architecture)
    ↓ governs
LLM behavior (task execution)
```

Each layer is a program. The Python program writes the S-expression program. The S-expression program runs on the LLM. The LLM produces the final output. You are not writing a prompt — you are writing a **prompt factory**.

The practical consequence: you can generate dozens of structurally consistent cognitive architectures by varying a configuration dictionary, rather than writing each S-expression by hand. The structural guarantees of Level 2 and Level 3 are preserved in every generated output — because the factory enforces them, not the human author.

This is the computational analog of **metacompilation**: a compiler that produces compilers.

---

## Beyond Level 4: The Fully Connected Runtime

The four cases above demonstrate self-reference, adaptive control, and generativity. They are all, in an important sense, still architectures that run *within* a session — a prompt, a generation, a verification.

There is a further direction: a runtime where Lisp, LLM, and a formal verifier operate as a continuous loop, with human intent as the initial condition and a machine-verified proof as the termination condition.

```lisp
(defun connected-runtime (intent)
  (labels ((loop (struct)
    (let* ((sexpr    (generate-next-attempt struct))  ; LLM generates S-expression
           (feedback (formal-verify sexpr))            ; Rust compiler checks it
           (result   (parse-feedback feedback)))       ; parsed back to Lisp
      (if (eq (getf result :status) 'verified)
          (format t "Verified: ~a~%" (getf result :proof))
          (loop (update-struct struct feedback))))))   ; iterate
  (loop (parse-intent-to-struct intent))))
```

Two design decisions make this distinct from all prior cases.

**LLM generates Lisp, not natural language.** What the LLM produces at each iteration is an S-expression — simultaneously a prompt the next iteration can read, an AST requiring no parsing, and a formal specification for the verifier. T(P) ≅ D(P) ≅ V(P) holds in the generative direction, not just the interpretive one.

**Lisp branches are writable, not just executable.** The LLM can generate new `cond` branches, modify termination conditions, introduce new predicate relationships. Because its output is S-expressions, every such modification is structurally verifiable before execution.

The efficiency consequence: in conventional agent systems, the LLM is called to decide routing, termination, state management — all of which consume context and latency. In this architecture, all deterministic scaffolding is handled by Lisp at zero LLM cost. The LLM is invoked only where semantic understanding is genuinely required.

The termination condition is a formal proof — compilation by a system like Rust's type checker, which guarantees type safety and memory safety as mathematical properties. The loop ends not when a model judges it complete, but when a theorem prover confirms it is correct.

This is the logical completion of the spectrum: human intent as initial condition, formal structure as the control plane, semantic generation constrained within verifiable boundaries, and machine proof as the exit gate.

---

## The Honest Accounting

Level 4 represents the current frontier. Most practitioners working with S-expression prompts are at Level 2, moving toward Level 3. Level 4 examples exist — including several shown in this chapter — but they are rare, difficult to design well, and require deep domain expertise to populate correctly.

**The hardest part of every level is not the structure — it's the knowledge.**

`affective-anchoring`, `rational-closure`, `goal-anchoring` — those three constructs in the mirror analysis system represent years of study in psychological linguistics, social influence, and cognitive science. The S-expression structure is straightforward to write once you know what to put in it. Knowing what to put in it requires domain expertise.

This means: moving up the spectrum requires learning more about your domain, not just learning more about S-expressions. The structure is the easy part. The semantics are the work.

A practical implication: start at Level 2 with the domains you know best. Design your predicate vocabulary carefully — this is the highest-leverage activity. As the vocabulary matures and you understand the consistency rules deeply, Level 3 structures will emerge naturally. Level 4 comes from recognizing, in an existing Level 3 architecture, a pattern that would benefit from self-reference or adaptive control.

The spectrum is a direction, not a destination.

---

## Style Mode: When You Don't Need the Interpreter

After internalizing the full spectrum, you gain a capability that doesn't require any code:

**Structural thinking that produces structurally rigorous natural language.**

When you've designed enough predicate vocabularies, you develop an instinct for what "requires," "prevents," and "flag" mean in any domain. When you've composed enough nesting, `progn`, and `let` structures, you develop an instinct for which primitive a given reasoning task calls for.

This instinct changes how you write even informal prompts:

**Before internalization**:
*"Please analyze this business case comprehensively, covering market opportunity, execution risk, and resource requirements. Make sure to be thorough and consider all relevant factors."*

**After internalization**:

> Analyze this business case across three independent dimensions:
> 
> **Dimension 1: Market opportunity**
> Required conditions: addressable market > $500M, growth rate > 15% CAGR, regulatory environment stable. Disqualifying conditions: saturated market, regulatory blockage imminent. Flag: market timing dependent on external event outside our control.
> 
> **Dimension 2: Execution risk**
> Required conditions: team has relevant domain experience, clear 18-month roadmap, funding secured to next milestone. Disqualifying conditions: key-person dependency on a single individual, no validated demand assumptions. Flag: novel technology component requiring unproven infrastructure.
> 
> **Dimension 3: Resource requirements**
> Required conditions: total cost of ownership within approved budget ceiling, existing team can absorb without backfill. Disqualifying conditions: requires headcount expansion not yet approved, capital requirement exceeds current runway. Flag: dependency on third-party vendor not yet contracted.
> 
> Synthesize the three dimensions: if any disqualifying condition holds across any dimension, the overall verdict is Reject. Otherwise, integrate all flagged items into a conditional recommendation requiring human sign-off before proceeding.

This is natural language. No parentheses. But it has:

- Typed predicates ("Required conditions," "Disqualifying conditions," "Flag")
- Three parallel analysis streams (let-binding semantics without the syntax)
- A synthesis layer with explicit verdict logic (nesting semantics without the syntax)
- A verification protocol embedded in the prose ("if any disqualifying condition holds")

**The structure is there. The brackets aren't.** When the structure is there, the model finds it — because structure in language is not bracket-dependent. It's about the logical relationships between propositions, and those can be expressed in any notation.

Style mode is what you use when the formality of S-expressions would be inappropriate — in a Slack message to a colleague, in a quick analysis request, in a document that human readers will consume alongside the model. The structure is implicit; the reasoning discipline it imposes is not.

---

## What This Spectrum Represents

Step back and see the full arc.

Level 1: You describe what you want. The model guesses.

Level 2: You specify what you want. The interpreter verifies. The model executes within a defined space.

Level 3: You model a domain. The model operates within a cognitive architecture that encodes domain knowledge as formal structure.

Level 4: The architecture itself can reason about its own operations, adjust its depth, detect whether new structure is emerging from the analysis, and generate the S-expression systems that govern its subsequent behavior.

Each level is a different relationship between human intelligence and machine computation:

At Level 1, you are a user and the model is a tool.

At Level 2, you are a programmer and the model is an execution environment.

At Level 3, you are a domain architect and the model is a reasoning engine operating within your architecture.

At Level 4, you are writing programs that write programs — metacompilers whose output is the cognitive architecture itself.

The path from Level 1 to Level 4 is not about learning more prompting tricks. It is about progressively deeper engagement with **what formal structure can encode** — moving from casual language, through verified specifications, through domain models, to cognitive constitutions.

John McCarthy invented the notation. You are discovering what it was always capable of.

---

## One Last Thing

This tutorial has been formal. Let me end informally.

The most important thing is not the syntax. Not the interpreter. Not the hierarchy of levels. The most important thing is a shift in how you think about the relationship between language and computation.

Language is the interface between your mind and the machine. For most of human history, that interface was informal — you expressed what you wanted and hoped the other party understood. With writing, we made the interface more precise. With mathematics, we made it formally computable. With programming languages, we made it mechanically executable.

LLMs represent something new: an interface that can work with the full expressiveness of natural language *and* the full precision of formal structure. The question is whether you meet them at the natural language end of that range, or at the formal structure end.

This tutorial has argued — and demonstrated — that meeting them at the formal structure end produces qualitatively different outcomes. Not just better answers. A different kind of reliability, a different kind of verifiability, a different kind of collaboration.

The faster you think, the bigger the lab.

---

---

# Appendix A: The Complete Interpreter

> **Save as `s_expr_interpreter_demo.py`**
> **Run: `python s_expr_interpreter_demo.py`**
> Requires Python 3.6+. No external dependencies.
> Covers all five verification scenarios from the tutorial.

```python
import re

# ═══════════════════════════════════════════════════════════
# PART 1: PARSER
# Converts S-expression strings to nested Python lists
# ═══════════════════════════════════════════════════════════

def tokenize(s):
    """Break an S-expression string into a flat token list."""
    return re.findall(r'\(|\)|[^\s()]+', s)

def parse(tokens):
    """Recursively parse a token list into a nested list structure."""
    token = tokens.pop(0)
    if token == '(':
        lst = []
        while tokens[0] != ')':
            lst.append(parse(tokens))
        tokens.pop(0)   # consume the closing ')'
        return lst
    elif token == ')':
        raise SyntaxError('Unexpected closing bracket')
    return token        # atom: string, number, symbol

def parse_sexpr(s):
    """Entry point: string → nested list."""
    return parse(tokenize(s.strip()))


# ═══════════════════════════════════════════════════════════
# PART 2: PREDICATE WHITELIST
# Only predicates in this set can be registered.
# Unknown predicates raise UnknownPredicateError immediately.
# ═══════════════════════════════════════════════════════════

ALLOWED_PREDICATES = {
    # Medical domain
    'diagnose', 'caused-by', 'presents-with', 'requires', 'prevents',
    'enables', 'implies', 'first-line', 'contraindicated', 'flag',
    # Geometry domain
    'build-problem', 'given', 'prove', 'derive',
    'triangle', 'point', 'parallel', 'altitude', 'intersect',
    'ratio', 'side', 'angle', 'similar', 'congruent', 'midpoint',
    # Logic domain
    'proposition', 'holds', 'not', 'and', 'or',
    'modus-ponens', 'hypothetical-syllogism', 'disjunctive-syllogism',
    # General
    'evaluate-offer', 'review-proposal',
}


# ═══════════════════════════════════════════════════════════
# PART 3: PREDICATE STORE + CONSISTENCY CHECKING
# All registered predicates stored here.
# Consistency rules checked on every registration.
# ═══════════════════════════════════════════════════════════

class PredicateStore:
    """
    Stores registered (predicate, args) pairs.
    Automatically checks consistency rules on each registration.
    """

    def __init__(self):
        self.entries   = []   # list of (predicate, args) tuples
        self.conflicts = []   # absolute contradictions
        self.warnings  = []   # conditional constraint warnings

    def add(self, pred, args):
        """Register a predicate. Raises ValueError for unknown predicates."""
        if pred not in ALLOWED_PREDICATES:
            raise ValueError(
                f"UnknownPredicateError: '{pred}' is not in the "
                f"allowed predicate vocabulary"
            )
        self.entries.append((pred, args))
        self._check_consistency(pred, args)

    def _check_consistency(self, pred, args):
        """Apply consistency rules to the newly registered predicate."""

        # requires vs prevents: absolute contradiction on same argument
        if pred in ('requires', 'prevents') and args:
            opposite = 'prevents' if pred == 'requires' else 'requires'
            for (p, a) in self.entries[:-1]:
                if p == opposite and a[0] == args[0]:
                    self.conflicts.append(
                        f"{pred}({args[0]}) and {opposite}({args[0]}) "
                        f"cannot coexist"
                    )

        # first-line vs contraindicated:
        # unconditional → conflict; conditional → warning
        elif pred == 'contraindicated' and args:
            drug = args[0]
            has_condition = len(args) > 1
            for (p, a) in self.entries[:-1]:
                if p == 'first-line' and a[0] == drug:
                    if has_condition:
                        self.warnings.append(
                            f"⚠ Conditional constraint: first-line({drug}) and "
                            f"contraindicated({drug}) coexist. "
                            f"Condition: {args[1]}. "
                            f"Confirm condition before prescribing."
                        )
                    else:
                        self.conflicts.append(
                            f"first-line({drug}) and "
                            f"contraindicated({drug}) — unconditional conflict"
                        )

    def consistent(self):
        """Returns True iff no absolute contradictions exist."""
        return len(self.conflicts) == 0

    def report(self, indent=0):
        """Print a consistency report."""
        pad = "  " * indent
        print(f"{pad}── Consistency check ──")
        for c in self.conflicts:
            print(f"{pad}  ✗ Conflict: {c}")
        for w in self.warnings:
            print(f"{pad}  {w}")
        status = "PASSED ✓" if self.consistent() else "FAILED ✗"
        print(f"{pad}  Result: {status}")
        return self.consistent()


# ═══════════════════════════════════════════════════════════
# PART 4: EVALUATOR
# Recursively executes an S-expression, registering each
# leaf predicate and reporting the three-way isomorphism.
# ═══════════════════════════════════════════════════════════

LEAF_PREDICATES = {
    'caused-by', 'presents-with', 'requires', 'prevents', 'enables',
    'implies', 'given', 'prove', 'derive', 'first-line', 'contraindicated',
    'flag', 'proposition', 'holds',
}

def evaluate(expr, store, depth=0):
    """Recursively evaluate an S-expression node."""
    pad = "  " * depth
    if isinstance(expr, str):
        return expr

    head, args = expr[0], expr[1:]

    # Root nodes: show the three-way isomorphism T(P) ≅ D(P) ≅ V(P)
    if head in ('diagnose', 'build-problem', 'evaluate-offer', 'review-proposal'):
        label = args[0] if args else '?'
        n_children = len(args) - 1
        print(f"{pad}▶ [{head}] {label}  (child nodes: {n_children})")
        print(f"{pad}T(P) — Parse tree: root='{head}', child count={n_children}")
        print(f"{pad}D(P) — Data structure: ({head} {label} ...)")
        print(f"{pad}V(P) — Node-by-node execution:")
        for child in args[1:]:
            evaluate(child, store, depth + 1)
        print()
        return store.report(depth)

    # progn: sequential evaluation with shared state semantics
    elif head == 'progn':
        print(f"{pad}(progn — sequential execution: {len(args)} steps)")
        for i, child in enumerate(args, 1):
            print(f"{pad}  ── step {i} ──")
            evaluate(child, store, depth + 2)
        return True

    # Leaf predicates: register in store, report result
    elif head in LEAF_PREDICATES:
        flat = [' '.join(a) if isinstance(a, list) else str(a) for a in args]
        try:
            store.add(head, flat)
        except ValueError as e:
            print(f"{pad}  ✗ {e}")
            return None
        conflict_flag = flat and any(str(flat[0]) in c for c in store.conflicts)
        suffix = "  ← ✗ conflict!" if conflict_flag else ""
        print(f"{pad}({head} {' '.join(flat)}) → registered{suffix}")
        return flat

    # Unknown head: recurse over arguments
    else:
        return [evaluate(a, store, depth) for a in args]


# ═══════════════════════════════════════════════════════════
# PART 5: MACRO EXPANSION
# Implements build-recursive-problem from the paper (Section 4.5)
# ═══════════════════════════════════════════════════════════

INSOMNIA_LAYERS = [
    [('requires', 'adequate-sleep-opportunity'),
     ('requires', 'duration-3-months')],

    [('requires', 'adequate-sleep-opportunity'),
     ('requires', 'duration-3-months'),
     ('requires', 'frequency-several-per-week')],

    [('requires', 'adequate-sleep-opportunity'),
     ('requires', 'duration-3-months'),
     ('requires', 'frequency-several-per-week'),
     ('prevents', 'secondary-insomnia'),
     ('enables',  'independent-clinical-focus')],
]

def build_recursive(disease, difficulty):
    """
    Macro expansion: generate a difficulty-stratified diagnostic structure.
    Mirrors Demo 5 from the paper.
    """
    n = min(difficulty, len(INSOMNIA_LAYERS))

    print(f"Input: (build-recursive-problem {disease} {difficulty})")
    print(f"\nExpanded S-expression (before evaluation):")
    print("(progn")
    for i in range(n):
        preds = ' '.join(f'({p} {a})' for p, a in INSOMNIA_LAYERS[i])
        print(f"  (diagnose {disease} patient {preds})")
    print(")")

    print(f"\nExecution:")
    accumulated, total = [], 0

    for i in range(n):
        layer = INSOMNIA_LAYERS[i]
        print(f"\n  [Layer {i+1}]")
        layer_store = PredicateStore()
        for pred, arg in layer:
            layer_store.add(pred, [arg])
            conflict = any(arg in c for c in layer_store.conflicts)
            suffix = "  ← ✗ conflict!" if conflict else ""
            print(f"    ({pred} {arg}) → registered{suffix}")
            accumulated.append((pred, [arg]))
        total += len(layer)

    # Check overall consistency
    final = PredicateStore()
    for p, a in accumulated:
        final.entries.append((p, a))

    consistent_label = "PASSED ✓" if final.consistent() else "FAILED ✗"
    print(f"\n  Total predicates: {total}  "
          f"Consistency: {consistent_label}")


# ═══════════════════════════════════════════════════════════
# THE FIVE DEMOS
# ═══════════════════════════════════════════════════════════

def demo1():
    """
    Demo 1 — T(P) ≅ D(P) ≅ V(P)
    The three-way structural isomorphism, demonstrated on a medical
    diagnosis example. Penicillin appears in both first-line and
    contraindicated (with condition) — interpreter surfaces the
    conditional warning without failing.
    """
    print("=" * 62)
    print("Demo 1 — T(P) ≅ D(P) ≅ V(P): The Isomorphism Property")
    print("Medical diagnosis: normal case, conditional warning surfaced")
    print("=" * 62)

    s = """
(diagnose streptococcal-pneumonia
  (caused-by streptococcus-pneumoniae)
  (presents-with fever)
  (presents-with productive-cough)
  (requires antibiotics)
  (first-line penicillin)
  (contraindicated penicillin penicillin-allergy))
"""
    print(f"Prompt:\n{s}")
    evaluate(parse_sexpr(s), PredicateStore())


def demo2():
    """
    Demo 2 — Level 1 Verification: Dyck Language Bracket Check, O(n)
    Bracket balance is checked before any semantic evaluation.
    A malformed S-expression fails here without reaching the evaluator.
    """
    print("\n" + "=" * 62)
    print("Demo 2 — Level 1: Bracket Balance (Dyck Language Check, O(n))")
    print("=" * 62)

    def dyck_check(s):
        depth = 0
        for i, ch in enumerate(s):
            if ch == '(':
                depth += 1
            elif ch == ')':
                depth -= 1
                if depth < 0:
                    return False, i
        return depth == 0, -1

    cases = [
        ("(diagnose patient (requires fever))",  "well-formed"),
        ("(diagnose patient (requires fever)",   "missing closing bracket"),
        ("(diagnose patient requires fever))",   "extra closing bracket"),
    ]
    for expr, label in cases:
        ok, pos = dyck_check(expr)
        result = "PASSED ✓" if ok else f"FAILED ✗  (position {pos})"
        print(f"\n  [{label}]  {result}")
        print(f"    {expr}")


def demo3():
    """
    Demo 3 — Level 2 Verification: Predicate Contradiction Detection
    requires(X) and prevents(X) for the same argument X is an
    absolute contradiction, detected on the second registration.
    """
    print("\n" + "=" * 62)
    print("Demo 3 — Level 2: Predicate Contradiction Detection")
    print("=" * 62)

    s = """
(diagnose chronic-insomnia patient
  (requires adequate-sleep-opportunity)
  (prevents adequate-sleep-opportunity))
"""
    print(f"Prompt (deliberate contradiction):\n{s}")
    evaluate(parse_sexpr(s), PredicateStore())


def demo4():
    """
    Demo 4 — Vocabulary Whitelist: Unknown Predicate Detection
    Predicates not in ALLOWED_PREDICATES raise UnknownPredicateError
    at registration time, before any consistency checking.
    """
    print("\n" + "=" * 62)
    print("Demo 4 — Vocabulary Whitelist: Unknown Predicate Detection")
    print("=" * 62)

    cases = [
        ("requires",   ["fever"],     "valid predicate"),
        ("prevents",   ["toxicity"],  "valid predicate"),
        ("must_have",  ["data"],      "invalid: underscore style"),
        ("important",  ["point"],     "invalid: natural language word"),
        ("given",      ["triangle"],  "valid predicate"),
    ]
    store = PredicateStore()
    for pred, args, label in cases:
        try:
            store.add(pred, args)
            print(f"  ({pred} {args[0]}) → registered ✓  [{label}]")
        except ValueError as e:
            print(f"  ({pred} {args[0]}) → {e}  [{label}]")


def demo5():
    """
    Demo 5 — Macro Expansion: Difficulty-Stratified Recursive Generation
    build-recursive-problem expands to a progn of increasing diagnostic
    complexity. Structure-preserving throughout — every intermediate
    form is an S-expression. No translation layer.
    """
    print("\n" + "=" * 62)
    print("Demo 5 — Macro Expansion: Recursive Structure Generation")
    print("(build-recursive-problem chronic-insomnia 3)")
    print("=" * 62)
    build_recursive("chronic-insomnia", 3)


# ═══════════════════════════════════════════════════════════
# MAIN
# ═══════════════════════════════════════════════════════════

if __name__ == "__main__":
    demo1()
    demo2()
    demo3()
    demo4()
    demo5()

    print("\n" + "=" * 62)
    print("All demos complete ✓")
    print("=" * 62)
```

---

# Appendix B: Predicate Vocabulary Reference

> A starting vocabulary for five common domains.
> These are not complete ontologies — they are starting points.
> Your domain expertise determines what goes in your vocabulary.

> **Note on output-contract**: For any domain below, you can add an `output-contract` node to specify what shape the model's output should take. Common fields: `(format s-expression)`, `(must-address prevents-nodes)`, `(leaf-strings allowed/forbidden)`. See Chapter Five, Step 3.5.

---

## B.1 Medical Diagnosis

**Gate predicates** (universal, reuse across domains):

| Predicate  | Semantics                                              |
| ---------- | ------------------------------------------------------ |
| `requires` | Necessary diagnostic criterion                         |
| `prevents` | Exclusionary criterion — presence rules out diagnosis  |
| `enables`  | Supportive criterion — increases diagnostic confidence |
| `flag`     | Advisory — warrants specialist confirmation            |

**Domain predicates** (medical-specific):

| Predicate             | Semantics                                         |
| --------------------- | ------------------------------------------------- |
| `caused-by`           | Etiological agent                                 |
| `presents-with`       | Clinical manifestation                            |
| `first-line`          | Recommended primary treatment                     |
| `contraindicated`     | Prohibited treatment; takes drug + condition args |
| `implies`             | Clinical inference from observed findings         |
| `duration-criterion`  | Temporal threshold for diagnosis                  |
| `frequency-criterion` | Recurrence threshold for diagnosis                |
| `severity-level`      | Clinical severity classification                  |

**Consistency rules**:

```
requires(X) and prevents(X): absolute contradiction
first-line(X) and contraindicated(X): conditional warning if condition arg present;
  absolute conflict if unconditional
enables(X) and prevents(X): contradiction
```

---

## B.2 Legal / Contract Review

**Gate predicates**: `requires`, `prevents`, `flag`

**Domain predicates**:

| Predicate                   | Semantics                                                     |
| --------------------------- | ------------------------------------------------------------- |
| `governing-law-clause`      | Jurisdiction specified                                        |
| `dispute-resolution-clause` | Arbitration/litigation path defined                           |
| `termination-clause`        | Exit conditions specified                                     |
| `confidentiality-clause`    | Non-disclosure obligations defined                            |
| `liability-cap`             | Maximum liability bounded                                     |
| `unlimited-liability`       | No liability cap — use with `prevents`                        |
| `unilateral-amendment`      | One party can modify terms unilaterally — use with `prevents` |
| `auto-renewal`              | Contract renews without affirmative action — use with `flag`  |
| `ip-assignment`             | Intellectual property assignment terms                        |
| `indemnification-clause`    | Indemnity scope and limits                                    |

**Consistency rules**:

```
requires(X) and prevents(X): contradiction
requires(governing-law-clause) and flag(governing-law-clause): contradiction
  (if you require it, don't also merely flag it — know what you need)
```

---

## B.3 Project / Proposal Review

**Gate predicates**: `requires`, `prevents`, `flag`

**Domain predicates**:

| Predicate                   | Semantics                                                |
| --------------------------- | -------------------------------------------------------- |
| `budget-within-limit`       | Proposed budget ≤ approved ceiling                       |
| `timeline-has-milestones`   | Measurable checkpoints defined                           |
| `team-fully-staffed`        | All critical roles confirmed                             |
| `risks-identified`          | Material risks enumerated with mitigations               |
| `budget-exceeds-limit`      | Proposed budget > ceiling — use with `prevents`          |
| `unresolved-dependencies`   | Required predecessor not confirmed — use with `prevents` |
| `novel-technology`          | New technology adoption — use with `flag`                |
| `single-point-of-failure`   | Architectural risk — use with `flag`                     |
| `market-validation-missing` | No evidence of demand — use with `prevents` or `flag`    |
| `regulatory-risk`           | Compliance pathway unclear — use with `flag`             |

**Structural mapping**:

```
Nesting   → evaluate all criteria before rendering verdict
progn     → phased review (initial screen → detailed analysis → decision)
let       → compare two competing proposals simultaneously
```

---

## B.4 Candidate / Offer Evaluation

**Gate predicates**: `requires`, `prevents`, `flag`

**Domain predicates**:

| Predicate                    | Semantics                                                           |
| ---------------------------- | ------------------------------------------------------------------- |
| `salary-meets-expectation`   | Compensation within declared range                                  |
| `location-acceptable`        | Commute or relocation is feasible                                   |
| `has-growth-path`            | Role offers advancement within 18-24 months                         |
| `company-stable`             | No material financial or structural risk signals                    |
| `relevant-domain-experience` | Candidate has substantive experience in this domain                 |
| `culture-fit-evidence`       | Credible positive culture signals                                   |
| `toxic-culture`              | Credible evidence of systematic dysfunction — use with `prevents`   |
| `excessive-overtime`         | Regular expectations beyond sustainable hours — use with `prevents` |
| `equity-vesting-cliff`       | Significant cliff risk — use with `flag`                            |
| `reference-check-pending`    | Not yet completed — use with `flag`                                 |
| `remote-policy-unclear`      | Remote arrangements not contractually specified — use with `flag`   |

**Structural mapping**:

```
Nesting   → evaluate single candidate/offer (all criteria before verdict)
let       → compare two offers simultaneously
progn     → full evaluation pipeline (research → evaluate → compare → negotiate → decide)
```

---

## B.5 Learning Plan Design

**Gate predicates**: `requires`, `prevents`, `enables`, `flag`

**Domain predicates**:

| Predicate               | Semantics                                              |
| ----------------------- | ------------------------------------------------------ |
| `prerequisite`          | Must be mastered before this can be taught             |
| `builds-on`             | Extends existing knowledge — lighter than prerequisite |
| `practice-required`     | Concept requires active application to internalize     |
| `estimated-hours`       | Time investment for competency                         |
| `assessment-checkpoint` | Point where learner progress is formally evaluated     |
| `knowledge-gap`         | Identified missing foundational understanding          |
| `learning-objective`    | Specific, measurable outcome                           |
| `foundational-concept`  | Core idea that many other concepts depend on           |
| `optional-enrichment`   | Deepens understanding; not required for competency     |

**Structural mapping**:

```
Nesting   → concept decomposition (understanding X requires sub-concepts)
progn     → learning sequence (cannot skip prerequisite concepts)
let       → comparative concept analysis (contrast two similar ideas)
```

**Consistency rules**:

```
requires(X) and prevents(X): contradiction
prerequisite(X) and optional-enrichment(X): contradiction
  (a concept cannot be both required and optional)
```

---

# Appendix C: Further Reading

## The Papers Behind This Tutorial

**Paper 1: Prompts That Execute: Isomorphic Neuro-Symbolic Reasoning via S-Expressions**

The theoretical foundation of this tutorial. Formalizes the isomorphism condition T(P) ≅ D(P) ≅ V(P), proves that S-expressions are the unique common notation satisfying it, and demonstrates the framework across medical diagnosis (ICD-11), Euclidean geometry, and propositional logic. Includes the reference ~220-line Python implementation (see Appendix A of this tutorial).

**Paper 2: From Natural Language to AST: LLM as Cognitive Compiler**

The cognitive science and programming language theory behind the framework. Formalizes the LLM as a cognitive compiler — translating natural language (source language) to S-expressions (target language). Establishes the correspondence between the three structural primitives (nesting, progn, let) and three cognitive primitives from cognitive science (hierarchical decomposition, sequential state update, associative binding).

## The Mathematical Foundation

**Domain Algebra** — [domainalgebra.org](https://www.domainalgebra.org)

The mathematical framework underlying predicate design in this tutorial. Domain Algebra formalizes the intuition that relations must be bound to domains to have determinate meaning: `r @ D` — relation `r` in domain `D`. The predicate vocabulary design methodology in Chapter Four is an application of Domain Algebra's principle of local semantic generation: meaning is constituted within a specific domain, not universally.

The site includes a visualization of the framework applied to medical knowledge (ICD-11), which provides a complementary view of the domain modeling approach demonstrated in this tutorial.

## For Deeper Technical Engagement

**On homoiconicity**: McCarthy, J. (1960). *Recursive Functions of Symbolic Expressions and Their Computation by Machine, Part I.* Communications of the ACM, 3(4), 184–195. The original paper that introduced Lisp and, implicitly, homoiconicity.

**On formal verification**: The connection between S-expression prompts and formal verification systems (Lean, Coq, Isabelle) is direct: the predicate store is a lightweight proof obligation checker. Readers interested in extending strict mode to full formal verification should explore LeanDojo (Yang et al., 2023) and AlphaGeometry (Trinh et al., 2024), both of which are discussed in Paper 1.

**On neuro-symbolic systems**: The framework presented here is positioned relative to PAL/Program-of-Thought (Gao et al., 2022) and Chain-of-Thought (Wei et al., 2022) in Paper 1's related work section. The key architectural distinction: all prior neuro-symbolic approaches require a translation layer between the neural and symbolic components; S-expression prompts eliminate that layer.

---

## On Going Further

**Level 2 → Level 3**: The transition from writing specifications to building domain models requires deepening your domain knowledge and systematizing it into predicate vocabularies. The highest-value activity is consistency rule design — knowing which predicate combinations are genuinely impossible versus merely unusual. This is where domain expertise compounds.

**Level 3 → Level 4**: Look for patterns in your Level 3 architectures where the analysis would benefit from self-reference — from knowing how deep it has gone, from detecting whether new structure is emerging, from adapting its analytical approach based on what it has already found. These are the signals that a Level 4 structure is warranted.

**Engineering strict mode**: The interpreter in Appendix A is a minimal implementation — sufficient to demonstrate all core mechanisms, not optimized for production. Extending it for production use would involve: richer predicate type systems, automatic extraction of predicate nodes from model output (removing the need for manual node listing in output verification), and integration with a backend formal verifier (Lean or a SAT solver) for domains requiring full proof-level guarantees.

---

*End of tutorial.*

*From "how do you use AI" to "how do you build cognitive architectures that run on AI" — that is the distance this tutorial covers.*

*The rest is your domain, your predicates, your structures.*

*The faster you think, the bigger the lab.*

```

```


