# Tagging Guide

> [!NOTE]
> Check the `tag-release.sh` script which does the right thing!

This document explains how to create Git tags that match an existing build run so the release workflow can
find and publish the corresponding artifacts. It assumes:

- CI produces artifacts for commits on `main` (workflow: `build.yml`).
- Release automation requires an exact prior successful build for the same commit (workflow: `release.yml`).
If no matching build exists, the release fails by design.

Goals

- Tag the exact commit that was built (the "merge commit" on `main`), not a different commit.
- Push the tag in a way that does not unintentionally re-trigger builds.
- Verify the build exists before tagging.

Quick summary

- Find the commit SHA associated with the successful build run.
- Create an annotated tag pointing at that SHA.
- Push only the tag (do not push branch + tag together).
- Verify the release workflow finds the build artifact.

1. Find the built commit

- In GitHub Actions UI: open the successful `build.yml` run and note `head_sha` (the commit SHA).
- With `gh` (GitHub CLI):
  - List recent build runs:
    - `gh run list --workflow=build.yml --limit 10`
  - Inspect a run to get its commit:
    - `gh run view <run-id> --json headSha --jq .headSha`
  - Or find a successful run for a given commit:
    - `gh api repos/${GITHUB_REPOSITORY}/actions/workflows/build.yml/runs --jq '.workflow_runs | map(select(.
    head_sha=="<COMMIT>" and .conclusion=="success")) | .[0]'`

1. Verify the build exists and succeeded

- Using `gh`:
  - `gh api repos/${GITHUB_REPOSITORY}/actions/workflows/build.yml/runs --jq '.workflow_runs | map(select(.
  head_sha=="<COMMIT>" and .conclusion=="success")) | length'`
  - If result is `0`, there is no successful build for that commit.
- Or with the REST API + `curl` + `jq`:
  - `curl -s -H "Authorization: token ${GITHUB_TOKEN}" "https://api.github.
  com/repos/${GITHUB_REPOSITORY}/actions/workflows/build.yml/runs?per_page=100" | jq -r --arg COMMIT "<COMMIT>"
  '.workflow_runs | map(select(.head_sha==$COMMIT and .conclusion=="success")) | .[0]'`

1. Create an annotated tag that points at the built commit

- Recommended: tag locally then push only the tag.

Commands:

- Fetch the repo and ensure you have the target commit locally:
  - `git fetch origin`
- Create an annotated tag at the target commit:
  - `git tag -a v0.1.7 <COMMIT> -m "Release v0.1.7 — built from <COMMIT>"`
  - Replace `<COMMIT>` with the `head_sha` from the build run.
- Push only the tag:
  - `git push origin v0.1.7`

Notes:

- Do NOT use `git push --tags` or `git push --follow-tags` if the intend is to avoid pushing branch updates.
- Do NOT include branch refs in the same push as the tag (avoid `git push origin main v0.1.7`).

1. Alternative: create tag via GitHub web UI

- Go to the repository → **Releases** → **Draft a new release**.
- Enter the tag name (e.g., `v0.1.7`) and select the exact target commit from the dropdown (the merge commit).
- Publish the release — GitHub creates the tag.

1. Verify the release workflow will match the build

- After pushing the tag, the `release.yml` workflow will run (trigger: tag push).
- The release workflow will look up a successful `build.yml` run for the tag's commit and download
`deb-artifacts-<run_id>`.
- If no matching successful build exists, the release will abort with an error. This is intentional.

1. Troubleshooting & tips

- If the release aborts with “no successful build run found for commit \<SHA\>”:
  - Confirm the commit SHA that was tagged is the same `head_sha` from a prior successful `build.yml` run.
  - If the tag points at a different commit (e.g., it was created the tag on a new commit after the build), tag
  the original merge commit instead.
- Defensive workflow config:
  - The build job can include a safety guard: `if: startsWith(github.ref, 'refs/heads/')` so it never runs on
  tag-only events even if a tag/branch push occurs together.
- Signed tags:
  - If tags should be signed and annotated  (`git tag -sa`), ensure local GPG keys are set up. Example:
    - `git tag -sa v0.1.7 <COMMIT> -m "Release v0.1.7"`
    - `git push origin v0.1.7`
- Automation checks (optional script):
  - Before creating the tag, run a small check that a successful build exists for the commit (use the `gh` or
  REST commands above) and fail early if not.

1. Example minimal flow

- Find commit: `COMMIT=$(gh run view <run-id> --json head_sha --jq .head_sha)`
- Create tag:
  - `git tag -sa v0.1.7 $COMMIT -m "Release v0.1.7"`
- Push tag only:
  - `git push origin v0.1.7`

1. Why this policy is safest

- Releasing from the exact commit that CI built guarantees the published artifacts match the source code
labeled by the tag.
- Avoids generating releases from unbuilt or different source states.

