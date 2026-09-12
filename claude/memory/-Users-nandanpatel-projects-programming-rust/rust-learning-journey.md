---
name: rust-learning-journey
description: Nandan is learning intermediate Rust by building the `parsley` workspace; format is scaffold-and-fill with maintainer-style review.
metadata:
  type: project
---

Started 2026-09-03. Nandan wants to move from "knows Rust syntax" to "designs
Rust well" — specifically lifetimes, heap types (`Box`/`Rc`/`Arc`), and real
codebase idiom. The vehicle is `parsley`, a zero-copy text-parsing workspace
built in 5 stages (see `docs/ROADMAP.md` in the repo).

**Why:** he explicitly said tutorials-level material is beneath him — he already
has borrowing, traits, iterators, basic lifetimes. The gap is *design judgement*,
not language features.

**How to apply:** follow [[rust-scaffold-and-fill-format]]. Don't write his
implementations for him, don't lower the difficulty when tests fail, and keep
justifying design decisions (why `Vec` not `HashMap`, why `&'static str` in
errors) rather than only explaining syntax.
