# baseline — MoJ secret scanner

Scans staged changes for hardcoded secrets and credentials using [gitleaks](https://github.com/gitleaks/gitleaks).

The MoJ ruleset (`.gitleaks.toml`) is always applied. It enables the gitleaks default rules and adds Ministry of Justice and wider UK government-specific identifier patterns (NHS numbers, National Insurance numbers, bank account details, sort codes).

## How it works

On each commit, `run.sh` runs:

```bash
gitleaks git --pre-commit --staged ...
```

This scans exactly what will be committed, reporting the file name and line number for each finding. Secrets in unstaged changes are not flagged.

## Configuration

### Suppressing false positives

For a one-off line, add a `gitleaks:allow` comment inline:

```python
secret = "not-a-real-secret"  # gitleaks:allow
```

To permanently ignore a specific finding, create a `.gitleaksignore` file in your repository root and add the `Fingerprint` value from the finding:

```
f3a930047bf1373b540608f54fcd7619b57801c8:README.md:generic-api-key:161
```

### Adding custom rules

Create a `.gitleaks.toml` file in your repository root. The file must not contain `[extend]` — the hook injects that automatically to extend the MoJ base config.

```toml
[[rules]]
id = "my-custom-rule"
description = "Internal service token"
regex = '''myservice-[A-Za-z0-9]{32}'''
```

Custom rules are additive only. They cannot remove or replace MoJ base rules.

### Environment variables

| Variable | Description |
|---|---|
| `GITLEAKS_CONFIG` | Path to a complete gitleaks config file. The hook passes through entirely — gitleaks uses this config as-is, bypassing the MoJ base config. |
| `GITLEAKS_CONFIG_TOML` | Inline config content (the full TOML as a string). Same passthrough behaviour as `GITLEAKS_CONFIG`. |
| `GITLEAKS_BASE_CONFIG` | Path to an alternative base config to use instead of the bundled MoJ config. Custom rules in `.gitleaks.toml` still extend this base. Useful in CI pipelines that provide their own base ruleset. |

See [gitleaks: Load Configuration](https://github.com/gitleaks/gitleaks#load-configuration) for the full upstream resolution order.
