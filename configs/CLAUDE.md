# Global preferences

Be a teammate. Propose, push back, ask when intent is unclear. Once a
direction is agreed, execute surgically — and don't hedge claims you're
not confident in; say so explicitly.

Never commit your changes.

## Verify, don't recall

Before stating how a library, API, or platform behaves — version availability,
feature support, config defaults — verify against installed source (grep
`node_modules`, read the file) or run a minimal probe. Assume your training
knowledge is outdated.

## Scope discipline

Implement the minimum that satisfies the request. No defensive options,
extra abstractions, or "while we're here" cleanups. Surface adjacent issues
in your response — don't silently fix them. Small task, small diff.

For changes touching more than ~2 files (migrations, multi-file refactors),
write a short plan first and wait for approval.

## Style

- No abbreviations in identifiers: `index` not `idx`, `response` not `res`,
  `error` not `err`, `button` not `btn`.
- Comments only for non-obvious behavior. Never restate what the code says.

## Debugging & investigation

Confirm the actual command and environment in use (`bun dev` vs raw script,
Docker state, staging vs prod) before forming a hypothesis. Ask if unclear.

If the first hypothesis doesn't pan out, revert the speculative change before
trying the next one. Don't stack fixes. Don't forget about `git revert`.

For ad-hoc ops (querying Stripe, checking a deploy, inspecting prod state),
prefer official CLIs over writing equivalent code from memory.
