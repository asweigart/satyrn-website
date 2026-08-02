---
title: Local-First
description: "Satyrn runs on your machine, on your terms — no mandatory round-trip to someone else's cloud."
---

Runs on your machine, on your terms — no mandatory round-trip to someone else's
cloud.

## What that means

!!! warning "Still being written"

    This describes the intent. The technical detail underneath it is not
    settled yet, so take the specifics as provisional.

Your code and your prompts stay on hardware you control. Nothing leaves unless
you send it.

That's the whole idea. The consequences are pleasantly boring: you can work on
a train, a provider outage is someone else's bad day, and no bill arrives at
the end of the month that scales with how much you typed.

The one that matters most to us is harder to demo. When something behaves
strangely you can read the code that did it. You can't do that with an API you
only get to poke from the outside.

## Using a hosted model anyway

Local-first isn't local-only. Some work really is better on a big hosted model,
and Satyrn will happily send it there. The difference is that you decide, per
task, and you can see it happen.
