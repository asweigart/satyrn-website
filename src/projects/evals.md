---
title: Satyrn Evals
description: "Fine-grained evaluation for small models: find real problems, experiment with fixes, and prove they work — with rigorous, evidence-based comparison."
---

Small models get lost and drive into the ditch. Ideas for fixes are cheap, and usually wrong. Evidence is what matters.

Satyrn Evals provides a unique, fine-grained way to find the actual problems small models face, see the details, experiment with ideas, and prove they make things better.

## Status

We are ready to show what Satyrn Evals does and share initial numbers. The evaluation framework has run two complete release cycles producing concrete results. We are still working on making it easier to onboard and use — the tool is powerful but not yet accessible to everyone who wants to try it.

## Overview

Satyrn Evals captures a task, invokes an attempt command, persists the patch and transcript, and grades the saved evidence offline. The engine seam is an executable command, so the suite can be developed independently without importing engine internals.

The north star: keep a small model on track, so a Python developer can use local AI and stay at the wheel. The developer's engineering is domain engineering — specs and tests — not agent engineering.

## How It Works

The framework is built around five core invariants:

- **Preserve before judging** — persist the patch and transcript before grading, so repairs never require re-running a model.
- **Independent verdict evidence** — the verdict comes from an oracle test hook, never stdout or an exit status.
- **State the population** — report explicit denominators, missing cells, and unmeasured diagnostics.
- **Freeze before spending budget** — record all conditions before a run; verify model settings against the server, not by declaration.
- **Prove checks both ways** — a grader accepts known-good fixtures and rejects known-broken ones.

Evaluation is designed for fast development feedback (10–15 minutes) using the cheapest check that can answer the current question — from deterministic regression tests with no model, through bounded attempts, to full comparison runs.

## Results

Satyrn Evals has completed two release cycles:

**Release One** (concluded 2026-09-15) tested whether the Satyrn Engine could keep a small model on track better than bare Pi on a "ceiling" workload. The result was a **stated negative**: the model failed on all ceiling tasks for reasons the Engine could not reach. This was a valuable finding — it revealed flaws and set clearer constraints for what to try next.

**Release Two** (pre-registered 2026-09-19, read once) showed the promise of the approach. One machine, arms interleaved three cells at a time. 108 cells, 0 infrastructure failures, 0 wall-clock timeouts, 0 replaced cells.

### The primary claim

On medium-build tasks, `/implement` delivers a passing candidate within the task's budget more often than bare Pi, and stops when the developer's tests are green.

| reading | Baseline | Engine | p |
|---|---|---|---|
| delivered pass, as graded | 2 of 24 | 16 of 24 | 0.000029 |
| pre-registered sensitivity: stray non-source files stripped, both arms | 3 of 24 | 17 of 24 | 0.000044 |
| part A alone (reported, not tested) | 2 of 12 | 8 of 12 | |
| part B alone (reported, not tested) | 0 of 12 | 8 of 12 | |

**The win rule is met.** What the Engine changed is delivery, not ability: 21 of Baseline's 24 cells ran out of budget, and at least 18 of those 21 held a tree that passes the hidden suite. Bare Pi builds the change, keeps working (coverage runs, lint, provenance, commits, re-verification) and never hands it over.

### Cost on the primary task

| per cell, median (range) | Baseline | Engine |
|---|---|---|
| turns | 73 (39 to 73) | 52 (25 to 72) |
| output tokens | 40,108 (26,596 to 48,125) | 39,125 (24,684 to 48,743) |
| minutes, three cells sharing the GPU | 43 (26 to 50) | 44 (23 to 57) |
| tool calls | 72 | 51 |

| per delivered pass | Baseline | Engine |
|---|---|---|
| machine time | 8.5 cell-hours | 1.1 cell-hours |
| output tokens | about 473,000 | about 58,000 |
| delivered inside 32,000 tokens and 48 turns | 1 | 7 |

An attempt is not faster with the Engine; a usable result is about eight times cheaper, because most attempts end in one.

### Where it did not help

| task | kind | Baseline delivered | Engine delivered | one-sided p |
|---|---|---|---|---|
| `selfhost-docs-linter` | medium build, secondary, n = 12 | 7 of 12 | 8 of 12 | 0.50 |
| `agentclinic-repair-depth-3` (R2) | small repair, floor, n = 6 | 6 of 6 | 6 of 6 | |
| `selfhost-guard-prefixes` | small build, floor, n = 6 | 4 of 6 | 4 of 6 | |
| `selfhost-review-script` | small build, floor, n = 6 | 2 of 6 | 5 of 6 | 0.12, not tested |

On floor tasks both arms pass, the Engine costs more:

| floor task | Baseline, median per delivered pass | Engine |
|---|---|---|
| depth-3 | 5,682 tokens, 13 turns, 3 min | 8,066 tokens, 16 turns, 5 min |
| guard-prefixes | 8,042 tokens, 14 turns, 5 min | 18,740 tokens, 24 turns, 15 min |
| review-script | 6,682 tokens, 24 turns, 5 min | 10,737 tokens, 17 turns, 11 min |

The Engine's self-test runs and guard messages are real overhead. `/implement` is for a build, not a small repair.

These results demonstrate that the evaluation framework can produce clear, actionable evidence: it can prove an improvement when one exists, and it can identify specific failure modes when it doesn't.

## Principles

Every comparison Satyrn Evals runs follows strict policies learned from getting things wrong:

- Declare both outcome and cost questions before a run.
- An informed selection is legitimate; a hidden one is not.
- Checkpoints verify execution integrity, nothing else.
- Outcome-shaped signals are not stop triggers.
- Never restart from zero by default.

## Next Steps

- Make the framework easier to onboard and use for new contributors.
- Integrate more closely with the [Satyrn Models](models.md) training pipeline for continuous feedback.
- Expand evaluation coverage to more task types and Python frameworks.
- Build visualisation tools for tracking model improvement over time.

## How to Join

The code lives in the [satyrn-evals](https://github.com/pauleveritt/satyrn-evals) repository. If you're interested in building better ways to measure and improve small models, [get involved](../get-involved.md).

For the full methodology, pre-registration details, and recompute instructions, see the [Satyrn Evals docs](https://pauleveritt.github.io/satyrn-evals/).
