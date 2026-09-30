---
title: Satyrn Engine
description: "Help small models succeed for routine Python work — a Pi extension that gives bounded, reviewable changes without touching your working tree."
---

Satyrn Engine helps small models succeed for routine Python work, supporting the developer's regular flow. It works together with the "big brain" for larger projects. Currently, the Engine is mostly used as a testbed for [Satyrn Evals](evals.md); version 0.2 will aim for more general use.

## What It Is

Satyrn Engine is a **Python library and CLI**, plus a **thin TypeScript adapter** that makes it available inside Pi (the Python in AI coding assistant). It turns a bounded contract into a candidate change, without modifying the caller's working tree.

The core idea: a developer's own AI partner works on their machine, in their repo, at their pace — and its output arrives as something they review and own, never as a rewrite of their working tree underneath them.

## Why Pi

We tried [OpenCode](https://opencode.ai) first — it's a capable agent, but it was missing the lifecycle methods we need for contract-driven, bounded operations. Pi has them.

Beyond the technical fit, Pi is non-profit oriented. That cultural alignment matters: we're building tools for routine Python work that developers can trust, and Pi's mission points in the same direction.

This isn't a long-term declaration of Pi exclusivity. We're making an Engine — it might run inside Pi today, but tomorrow it could run in notebooks, other agents, or wherever developers need bounded, reviewable changes.

## How It Works

Release one ships `/implement`: a developer-invoked bounded operation that runs one piece of work in a fresh model context and its own worktree under a derived contract, with guards loaded, and returns a candidate plus a compact receipt.

The architecture is deliberately simple:

- **One Python process per operation** — the adapter starts the engine executable, writes a versioned JSON request to stdin, reads one JSON response, and waits for exit. No persistent sidecar, no pool, no supervisor.
- **Guards in TypeScript** — safety checks run inside Pi's `emitToolCall`, catching loops, out-of-scope writes, and command bounds on every tool call during `/implement`.
- **Contract-driven** — the engine parses and validates a contract, enforces writable paths and revisions, and produces a candidate worktree with commit-or-discard behavior.

## What It Is For — and Not For

The engine owns:

- Contract parsing and validation.
- Writable-path and revision enforcement.
- Candidate worktree management with commit-or-discard and receipt behavior.
- Pi-side guards: loop breaker, writable-path scope, command bounds.
- The Pi package and its TypeScript adapter.

It does **not** own:

- Workloads, grading, repeated runs, or comparison statistics — those live in [Satyrn Evals](evals.md).
- Contract authoring — that is a main-agent skill, not engine machinery.

This split is deliberate: evals runs the measurements, and the features built into the engine are the ones that evidence surfaces.

## Initial Results

The Engine was evaluated through two release cycles in [Satyrn Evals](evals.md):

- **Release One** showed the model failed on ceiling tasks for reasons the Engine could not reach — a valuable negative result that clarified constraints.
- **Release Two** demonstrated the Engine's value: **16 of 24 passes against Baseline's 2 of 24** on the primary task.

## Current Wins

Release Two's census didn't just produce a headline number — it showed which
pieces of machinery are earning their keep, and which are still unproven:

- **Writable-path scope.** The guard that refuses edits outside a contract's
  declared paths. It fired — refusing 5 of 36 cells in the census — which is
  the difference between "a check exists" and "a check activates."
- **Workspace isolation, two layers deep.** The Engine's own candidate
  worktrees keep a delivery off the caller's working tree (git-based, and
  explicitly not a security boundary). Evals' harness goes further: the model
  runs as a separate OS user with no view of grader material — the isolation
  that let the comparison run 108 cells with zero infrastructure failures.
- **Finish-on-green steering.** A nudge that tells the model to stop once its
  own tests pass. It steered 20 of 24 cells on the primary task, and 16 of
  those went on to deliver a pass.
- **Loop breaker and symbol preservation.** The other two guards shipped and
  tested, but neither fired in the census's measured runs. For a bounds check
  meant to rarely trigger, that's not a failure — but it isn't proof of
  triggering, either.

None of this is free. On small, already-passing tasks the Engine costs more
tokens and turns than bare Pi — `/implement` is for a build, not a small
repair — and the Release Two effect held on only one of the two medium-sized
tasks tested.

We're working on tackling this cost.

## Next Steps

- Version 0.2 will target general use beyond the Evals testbed.
- Improve onboarding so the Engine is accessible to more contributors.
- Expand the contract system and guard coverage based on eval findings.

## How to Join

The code lives in the [satyrn-engine](https://github.com/pauleveritt/satyrn-engine) repository. If you want to help build tools that keep small models on track, [get involved](../get-involved.md).

For architecture details, contract specifications, and more, see the [Satyrn Engine docs](https://pauleveritt.github.io/satyrn-engine/).
