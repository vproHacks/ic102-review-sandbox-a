# The ruleset on main

A repository you create gets no rules of its own, so you set this ruleset up by hand, under
Settings › Rules › Rulesets › New ruleset › **Import a ruleset**, which reads
[ruleset.json](ruleset.json) from your clone. Nobody has imported this file into a real repository
yet, so check what the page shows against this table before you press **Create**.

| Part | Setting | Why |
|---|---|---|
| Name | main: one approval and green checks | |
| Enforcement | Active | An "Evaluate" ruleset only reports; it blocks nothing |
| Target | The default branch (`~DEFAULT_BRANCH`) | A ruleset with no target protects no branch |
| Restrict deletions | On | |
| Block force pushes | On | A force push to `main` would rewrite the history everyone else's branch starts from |
| Require a pull request before merging | On, 1 approval | Every change is seen by someone other than its author |
| Dismiss stale approvals when new commits are pushed | On | An approval covers the commit it was given on; a merge that rebuilt the GDS is a new layout |
| Require approval of the most recent reviewable push | On | Someone other than the person who pushed the last commit has to approve it, so a change pushed after an approval can't ride on that approval |
| Require conversation resolution before merging | On | A requested change has to be answered before the merge |
| Allowed merge methods | Merge | Keeps each claim, and the merge that resolved its conflict, in the history |
| Require status checks to pass | `docs`, `gds`, `precheck` | The three jobs that run on a pull request |
| Require branches to be up to date before merging | Off | A pull request that conflicts can't be merged anyway, and resolving the conflict is what brings it up to date |
| Bypass list | Repository admin, "For pull requests only" | Explained below |

Only an approval from someone with write access to the repository counts towards the one the rule
asks for. On a repository in your own account that's you, as its admin, and nobody else, so your
partner's pull request can be approved, by you, but a pull request of your own can't be approved by
anyone. The bypass entry lets you merge your own pull request without an approval, after its
checks have passed. "For pull requests only" means it covers nothing else: a direct push to
`main` is refused for you as it is for everyone, so every change still arrives as a pull request
with its runs and its diff in one place.

`viewer` isn't a required check. It's skipped on pull requests (see the comment in
`.github/workflows/gds.yaml`), and it runs, and publishes `main`'s layout to Pages, when a merge is
pushed to `main`.

Two repository settings go with the ruleset:

- Settings › Pages › Build and deployment › Source: GitHub Actions, so that `viewer` can deploy.
  Pages is off in a new repository, so after you turn it on, start a new run (Actions › `gds` ›
  **Run workflow** on `main`) rather than re-running the failed one.
- Settings › Actions › General › "Approval for running fork pull request workflows from
  contributors": leave GitHub's default, "Require approval for first-time contributors". That means
  anyone who has never had a commit or pull request merged into the repository, which includes your
  partner, so their pull request's runs wait until you press **Approve and run workflows** on it.
  Read the change before you approve its runs: the runs are what will execute it.
