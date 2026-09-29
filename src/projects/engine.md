---
title: Satyrn Engine
description: "Help small models succeed for routine Python work — a Pi extension that gives bounded, reviewable changes without touching your working tree."
---

Satyrn Engine helps small models succeed for routine Python work, supporting the developer's regular flow. It works together with the "big brain" for larger projects. Currently, the Engine is mostly used as a testbed for [Satyrn Evals](evals.md); version 0.2 will aim for more general use.

## What It Is

Satyrn Engine is a **Python library and CLI**, plus a **thin TypeScript adapter** that makes it available inside Pi (the Python in AI coding assistant). It turns a bounded contract into a candidate change, without modifying the caller's working tree.

The core idea: a developer's own AI partner works on their machine, in their repo, at their pace — and its output arrives as something they review and own, never as a rewrite of their working tree underneath them.

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

## Next Steps

- Version 0.2 will target general use beyond the Evals testbed.
- Improve onboarding so the Engine is accessible to more contributors.
- Expand the contract system and guard coverage based on eval findings.

## How to Join

The code lives in the [satyrn-engine](https://github.com/pauleveritt/satyrn-engine) repository. If you want to help build tools that keep small models on track, [get involved](../get-involved.md).

For architecture details, contract specifications, and more, see the [Satyrn Engine docs](https://pauleveritt.github.io/satyrn-engine/).
