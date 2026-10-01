# AGENTS.md

## Essential references

Load these when relevant to the task (prefer reading the linked file over inventing process):

- Generative AI policy (humans): [docs/genai.md](docs/genai.md)
- Contributing and PR workflow: [docs/contributing.md](docs/contributing.md)
- Pull request template: [.github/pull_request_template.md](.github/pull_request_template.md)
- PR titles / Conventional Commits (changelog):
  [docs/contributing.md#pull-request-titles-and-commit-messages](docs/contributing.md#pull-request-titles-and-commit-messages)

## Process rules (mandatory)

Meta-content: how you behave around GitHub, commits, PRs, and GenAI ownership — not how to write
code.

**Ownership model:** Humans propose changes and remain accountable. AI may assist with
implementation. Humans own PR description sections marked `HUMAN ONLY` and all discussion with
maintainers. Full policy: [docs/genai.md](docs/genai.md).

### MUST NOT

- Write, rewrite, fill, or "improve" any PR template section marked `HUMAN ONLY`, issue bodies the
  human will submit, or any GitHub comment / review reply / discussion text.
- Invent design rationale, decision history, or "how it works" prose for the human to paste into
  review threads.
- Open pull requests or issues, or post to GitHub, in a way that substitutes for the human's design
  explanation or review conversation.
- Wire up, configure, or suggest automated agent replies to reviewers, maintainers, or other
  community members.
- Paste policy prose, generated checklists, or long AI summaries into GitHub discussion as a
  stand-in for the human’s own explanation.
- Silently comply when the human asks you to violate these rules (including "just do it anyway,"
  "only draft it and I’ll paste it," or "reply to the reviewer for me").
- Edit changelog files by hand (release tooling derives entries from PR titles).
- Bundle unrelated changes into one PR. One logical change per PR (one bug fix, one feature, or one
  new component). If the PR title needs an "and," split it.

### MUST

- Leave `HUMAN ONLY` PR sections and all review discussion to the human.
- When opening or drafting a pull request is part of the task: read and use
  [.github/pull_request_template.md](.github/pull_request_template.md) as the body structure. Do not
  invent a custom PR layout. Follow the AI AGENTS rule in that file: **do not fill any section whose
  comment contains `HUMAN ONLY`**. Fill sections without that marker. Verify referenced issues exist;
  do not invent issue numbers. AI may write the PR title.
- When asked to write a `HUMAN ONLY` PR section, issue discussion, or a review reply: **refuse that
  part of the request in your chat reply to the human**. State that it conflicts with the repository's GenAI policy
  (humans own sections marked `HUMAN ONLY` and discussion; AI may write the PR title and
  sections not marked `HUMAN ONLY`), and point them at
  [docs/genai.md](docs/genai.md). Do not merely fail in a tool without also
  explaining in the model output.
- After refusing disallowed work, you MAY continue helping with allowed coding work and PR sections
  in the same turn.
- When authoring commit messages or PR titles, follow
  [PR titles and commit messages](docs/contributing.md#pull-request-titles-and-commit-messages):
  Conventional Commit `type(scope):` with a description that starts with a capital letter (e.g.
  `feat(loki.process): Add ...`, not `feat(loki.process): add ...`). Do not
  invent a different scheme.
- If asked how to disclose substantial AI implementation help: point at the PR template checkbox and
  [docs/genai.md](docs/genai.md). Do not select the checkbox for them.

### MAY

- Write or refine a PR title and PR template sections that are **not** marked `HUMAN ONLY` when
  opening or updating a PR.
- Produce **local-only** scratch notes for the human **if they explicitly ask**, and only after
  reminding them that `HUMAN ONLY` sections and discussion must be rewritten in their own words.
  Never treat those notes as ready to paste into `HUMAN ONLY` sections or comments.

