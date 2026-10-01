# Contributing

We use GitHub to manage reviews of pull requests.

If you're planning to do a large amount of work, you should discuss your ideas in a new issue. This will help you avoid unnecessary work and surely give you and us a good deal
of inspiration.

For trivial fixes or improvements, pull requests can be opened immediately without an issue.

## Before Contributing

- Sign our CLA otherwise we're not able to accept contributions.
- If you use generative AI tools, you must review our [Generative AI Contribution Policy](./genai.md).

### Signed commits

All Grafana Labs repositories [require signed commits](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches#require-signed-commits).
To learn how to enable commit verification, refer to [about commit signature verification](https://docs.github.com/en/authentication/managing-commit-signature-verification/about-commit-signature-verification) and refer to this page to learn about [checking your commit signature verification status](https://docs.github.com/en/authentication/troubleshooting-commit-signature-verification/checking-your-commit-and-tag-signature-verification-status).

**NOTE** Unsigned commits and pull requests will be rejected and closed. This includes pull requests that have been authored by Agents.

## Steps to Contribute

Should you wish to work on an issue, please claim it first by commenting on the GitHub issue that
you want to work on it. This is to prevent duplicated efforts from contributors on the same issue.

Please check the `good first issue` label to find issues that are good for
getting started. If you have questions about one of the issues, with or without the tag, please
comment on them and one of the maintainers will clarify it.

## Pull Request Checklist

Changes should be branched off of the `main` branch. It's recommended to rebase on top of `main`
before submitting the pull request to fix any merge conflicts that may have appeared during
development.

PRs should not introduce regressions or any critical bugs. If your PR isn't covered by
existing tests, some tests should be added to validate the new code (100% code coverage is _not_ a
requirement). Smaller PRs are more likely to be reviewed faster and easier to validate for
correctness; consider splitting up your work across multiple PRs if making a significant
contribution.

If your PR is not getting reviewed or you need a specific person to review it, you can @-reply a
reviewer asking for a review in the pull request or a comment, or you can ask for a review on the
Slack channel [#integrations](https://slack.grafana.com).

## Pull request titles and commit messages

### tl;dr:

#### PR titles (and by extension CHANGELOG entries) should:

1. Adhere to [Conventional Commit](https://www.conventionalcommits.org/en/v1.0.0/) style and use one
   of the ["types" defined in our linting workflow](../../.github/workflows/release-lint-pr-title.yml).
2. Read as a complete sentence in the imperative, present tense (e.g. "Change", not "Changes" or
   "Changed").
3. Have a "description" which starts with an uppercase letter.
4. Describe the impact on the user which is reading the changelog.

For example: `feat: Increase config file read speed by 1500%`

> Readers should be able to understand how a change impacts them. Default to being explicit over
> vague.
>
> - Vague: `fix: Fix issue with metric names`
> - Explicit: `fix: Fix 's' getting replaced by 'z' in metric names`

General title format:

```
  ┌──────────── Type
  │   ┌──────── Scope (optional)
  │   │   ┌──── Description
  │   │   │
feat(ui): Improve UI load time for large component pages
```

#### PR "Extended descriptions" (i.e. commit bodies):

1. Are optional, depending on the needs of the PR.
2. Should be a human-readable description of the PR in the imperative, present tense.
3. Should include text from the "Brief description of Pull Request" section of the PR description.
4. **Should not** contain more than one line starting with `feat` or `fix` as this will result in
   multiple changelog entries.
5. Should include a `BREAKING-CHANGE: [...]` footer if the change is breaking.
6. Should maintain pre-populated co-authors.

### Details

We use [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) as the basis for
[CHANGELOG](../../CHANGELOG.md) entries, but **you don't need** to worry about this for anything
other than the Pull Request title. This is because we use squash commits when merging Pull Requests,
so the commit title and body are determined at merge time.

To ensure your Pull Request gets a proper changelog entry and semantic version bump, your **PR
title** must adhere to Conventional Commit style.

When a maintainer goes to merge your PR, the prompt they get will contain the PR title as the squash
commit's title and all of the individual commit details as the squashed commit's body.

You can find the list of all Conventional Commit "types" we allow
[here](../../.github/workflows/release-lint-pr-title.yml).

## (Maintainers) Merging a PR

PR merge time is the point at which you can modify the commit title (via the "Commit message" box)
and the commit body (via the "Extended description" box) to get the desired changelog entry. This
can also be fixed after the fact, but it's easiest to address it at this point. In general, when you
click the "Squash and merge" button, you want to:

1. Doublecheck that the "Commit message" box says what the changelog entry should say.
2. Put a human-readable description of the PR into the "Extended description" box, which can be:
    - A copy/paste of the text from the "Brief description of Pull Request" section from the PR's
      description, if available.
    - A copy/paste of a relevant commit message (e.g. if there's only one on the PR and it is
      descriptive).
3. If needed, add a `BREAKING-CHANGE: [...]` footer to the bottom of the "Extended description" with
   a detailed description of the breaking change. For example:

   ```
   Commit message
   ┌─────────────────────────────────────────────────────┐
   │ feat!: This is the conventional commit-style title  │
   └─────────────────────────────────────────────────────┘

   Extended description
   ┌─────────────────────────────────────────────────────┐
   │ This is the detailed description of the PR.         │
   │                                                     │
   │ BREAKING-CHANGE: This is where you write a detailed │
   │ description about the breaking change. You can use  │
   │ markdown if needed.                                 │
   └─────────────────────────────────────────────────────┘
   ```

## Dependency management

This repository uses [jsonnet-bundler][jsonnet-bundler] to manage dependencies on external packages.

To add or update a new dependency, use the `jb install` command:

```bash
jb install https://github.com/example/example-project

```

You have to commit the changes to `jsonnetfile.json` before submitting the pull request, though note the associated `jsonnetfile.lock.json` and vendored files should not be committed.

[community-slack]: https://slack.grafana.com/
[jsonnet-bundler]: https://github.com/jsonnet-bundler/jsonnet-bundler
