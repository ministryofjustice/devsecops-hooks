# devsecops-hooks

[![OpenSSF Scorecard](https://api.scorecard.dev/projects/github.com/ministryofjustice/devsecops-hooks/badge)](https://scorecard.dev/viewer/?uri=github.com/ministryofjustice/devsecops-hooks)
[![OpenSSF Best Practices](https://www.bestpractices.dev/projects/11923/badge)](https://www.bestpractices.dev/projects/11923)
[![Ministry of Justice Repository Compliance](https://github-community.service.justice.gov.uk/repository-standards/api/devsecops-hooks/badge)](https://github-community.service.justice.gov.uk/repository-standards/devsecops-hooks)

Pre-commit hooks for Ministry of Justice repositories.

---

## Prerequisites

[prek](https://github.com/j178/prek) and [gitleaks](https://github.com/gitleaks/gitleaks#installing) must both be installed and available on your `PATH`. On macOS:

```console
brew install prek gitleaks
```

[pre-commit](https://pre-commit.com/#install) can be used in place of prek (`pip install pre-commit`); all commands in this document are compatible with both. For other platforms, refer to the upstream install instructions: [prek](https://github.com/j178/prek/releases), [gitleaks](https://github.com/gitleaks/gitleaks/releases).

---

## Usage

Add the following to your repository's `.pre-commit-config.yaml`, replacing `<SHA>` with a commit SHA from this repository (see [releases](https://github.com/ministryofjustice/devsecops-hooks/releases)):

```yaml
repos:
  - repo: https://github.com/ministryofjustice/devsecops-hooks
    rev: <SHA>
    hooks:
      - id: baseline
```

Then install the hook:

```console
prek install
```

The hook will run automatically on `git commit`. To run it manually:

```console
prek run baseline --all-files
```

### Pinning to a commit SHA

Use a commit SHA rather than a tag in `rev:`. Tags are mutable — a SHA guarantees you are running exactly what you reviewed. Find the SHA for any release on the [releases page](https://github.com/ministryofjustice/devsecops-hooks/releases) or by running:

```console
git ls-remote https://github.com/ministryofjustice/devsecops-hooks refs/tags/v<version>
```

---

## Hooks

| Hook | Description |
|---|---|
| [`baseline`](hooks/gitleaks/README.md) | Scans staged changes for hardcoded secrets using gitleaks |

---

## Contributing

Raise an issue or open a pull request. See [CHANGELOG.md](CHANGELOG.md) for release history.

## Licence

[MIT](LICENSE) — Crown Copyright (Ministry of Justice)
