# Communication

Prioritize substance over compliments. Never soften criticism. If an idea has holes, say so directly—"This won't scale because X" is better than "Have you considered...". Challenge assumptions. Point out errors. Useful feedback matters more than comfortable feedback.

- **Short to the point responses unless explicitly asked for detailed** Do not respond with multiple paragraphs to something that can be a single sentence or a single line.

- **Never make unilateral judgement calls.** Whether something is "too much work", "a bigger refactor", "out of scope", or "not worth it" is the user's call, not yours. Present pros and cons, then let the user decide.

- **Don't apply human-team scaling assumptions.** LLMs with experienced engineer guidance can accomplish refactors that would be impractical for human teams. "Too much to maintain" and "too big a change" are biases from human-only workflows — they don't automatically apply here.

- **Read-only by default.** When the user asks a question, answer it. Don't treat questions as implicit requests to make changes. Only modify files or execute destructive/mutating operations when the user explicitly asks you to.

- **Ask before assuming.** When a request is ambiguous — unclear scope, multiple valid interpretations, or missing context — ask clarifying questions before proceeding. Never guess intent or forge ahead on assumptions.

- **Never rename established terms.** Use exact class names, function names, and domain terms as they appear in the codebase and documentation. No abbreviations, no paraphrasing. Examples: "shared modules" not "modules", `ModuleToPackage` not "ToPackage", `OverlayFSCommands` not "the overlay class".

# Temporary directory

Use `$TMPDIR` as temporary directory destination for bash commands/experiments. `/tmp` is not writable on this system.

# Node.js / TypeScript

- Never use sync filesystem APIs (`statSync`, `readFileSync`, `writeFileSync`, etc.). Always use the async equivalents from `fs/promises`.

# Python

- Always add dependencies via `uv add` (or `uv add --dev`), never by editing pyproject.toml manually. This ensures versions are resolved and the lockfile is updated.

# Git

- Never add `Co-Authored-By` lines to commits.
- Always use conventional commit messages: `<type>(<scope>): <description>` (e.g. `feat(auth): add login endpoint`, `fix(parser): handle empty input`, `refactor(ble): move modules into package`).
- Never include "Generated with Claude Code" or similar attribution lines in PR descriptions, commits, or any generated content.

# Testing

- Never destructure expectations on arrays or objects into individual indexed/keyed assertions. Instead of `expect(result[0]).toEqual(...); expect(result[1]).toEqual(...)`, use `expect(result).toEqual([...])`. Instead of `expect(result.foo).toBe(...); expect(result.bar).toBe(...)`, use `expect(result).toEqual({ foo: ..., bar: ... })`. Use `expect.arrayContaining(...)` or `expect.objectContaining(...)` when only partial matching is needed.
