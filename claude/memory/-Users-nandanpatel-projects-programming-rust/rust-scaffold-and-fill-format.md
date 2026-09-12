---
name: rust-scaffold-and-fill-format
description: For Rust learning work, Nandan chose "you scaffold, I fill in" — Claude writes signatures/docs/tests, he writes the bodies.
metadata:
  type: feedback
---

Nandan picked the scaffold-and-fill format over "Claude writes it, you read it"
and over pure Socratic. Concretely: Claude supplies module structure, exact type
signatures, doc comments explaining the *why* behind each signature, and failing
tests. Bodies are `todo!()`. He implements; Claude then reviews harshly, like a
crate maintainer — API design and idiom, not just "does it compile".

He also pushed back on a narrowing choice (offered one of three parser domains,
he asked for all three) — he prefers more scope when the scope teaches more.

**Why:** he learns by writing code against a spec, but wants the design
decisions surfaced rather than discovered by trial and error.

**How to apply:** never fill in a `todo!()` he hasn't attempted. When he asks
for help, explain the concept and let him write it. Tests are the spec — add
tests rather than prose when tightening a requirement. Part of
[[rust-learning-journey]].
