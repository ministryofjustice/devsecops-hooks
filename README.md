# 🔐 DevSecOps Hooks

Ministry of Justice pre-commit hooks for scanning hardcoded secrets and credentials.

[![Ministry of Justice Repository Compliance Badge](https://github-community.service.justice.gov.uk/repository-standards/api/devsecops-hooks/badge)](https://github-community.service.justice.gov.uk/repository-standards/devsecops-hooks)

---

[![OpenSSF Scorecard](https://api.scorecard.dev/projects/github.com/ministryofjustice/devsecops-hooks/badge)](https://scorecard.dev/viewer/?uri=github.com/ministryofjustice/devsecops-hooks)
[![OpenSSF Best Practices](https://www.bestpractices.dev/projects/11923/badge)](https://www.bestpractices.dev/projects/11923)

[![GitHub release](https://img.shields.io/github/v/release/ministryofjustice/devsecops-hooks)](https://github.com/ministryofjustice/devsecops-hooks/releases)
[![GitHub issues](https://img.shields.io/github/issues/ministryofjustice/devsecops-hooks)](https://github.com/ministryofjustice/devsecops-hooks/issues)
[![GitHub pull requests](https://img.shields.io/github/issues-pr/ministryofjustice/devsecops-hooks)](https://github.com/ministryofjustice/devsecops-hooks/pulls)

[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Docker](https://img.shields.io/badge/Docker-Enabled-blue.svg)](Dockerfile)

## 📋 Overview

A lightweight, Docker-based security scanner that integrates seamlessly with Git workflows to prevent hardcoded secrets from being committed to your repository.
Built for the Ministry of Justice, this tool leverages following CLI commands to detect sensitive information such as API keys, passwords, tokens, and other credentials.

- [GitLeaks](https://github.com/gitleaks/gitleaks)

## 🧩 Workflow

![Workflow](docs/pre-commit-workflow.svg)

## ✨ Features

- 🛡️ **Automated Secret Detection** - Scans code for hardcoded secrets using GitLeaks
- 🐳 **Docker-Based** - Runs in an isolated Alpine Linux container
- 🔗 **Pre-Commit Integration** - Works seamlessly with the pre-commit framework
- ⚡ **Fast & Lightweight** - Minimal footprint with optimised scanning
- 🎯 **Fail-Fast** - Stops commits immediately when secrets are detected
- 🔍 **Verbose Logging** - Detailed output for easy debugging
- 🏷️ **Version Controlled** - Pinned GitLeaks version with checksum validation

## 🚀 Getting Started

### Development prerequisites

- [Git CLI](https://cli.github.com/)
- [Docker](https://www.docker.com/get-started/)
- [pre-commit](https://pre-commit.com/) or [prek](https://github.com/j178/prek?tab=readme-ov-file#installation)

### Installation

1. **Add**
   - Filename: `.pre-commit-config.yaml`
   - Location: Root of your project

   ```yaml
   repos:
     - repo: https://github.com/ministryofjustice/devsecops-hooks
       rev: v1.4.0
       hooks:
         - id: baseline
   ```

2. **Install**:

   Ensure [prek](https://github.com/j178/prek?tab=readme-ov-file#installation) is installed globally

   Linux / MacOS

   ```bash
   curl --proto '=https' --tlsv1.2 \
   -LsSf https://raw.githubusercontent.com/ministryofjustice/devsecops-hooks/e85ca6127808ef407bc1e8ff21efed0bbd32bb1a/prek/prek-installer.sh | sh
   ```

   Windows

   ```bash
   powershell -ExecutionPolicy ByPass \
   -c "irm https://raw.githubusercontent.com/ministryofjustice/devsecops-hooks/e85ca6127808ef407bc1e8ff21efed0bbd32bb1a/prek/prek-installer.ps1 | iex"
   ```

3. **Activate**

   Execute the following command in the repository directory

   ```bash
   prek install
   ```

4. **Test**

   ```bash
   prek run
   ```

## 🔧 Configuration

### Configuration file

One can add gitleaks configuration file to their repository root under `./.gitleaks.toml` file name.
Gitleaks offers a [configuration format](https://www.npmjs.com/package/@ministryofjustice/hmpps-precommit-hooks?activeTab=code)
you can follow to write your own secret detection rules.

### Ignore file

One can add gitleaks `fingerprint` to the `./.gitleaksignore` file, if it is a false positive.
To add one to the ignore file simply add the `Fingerprint` presented to the ignore file.

Just like the configuration file please add ignore file to the root of your repository.

```txt
f3a930047bf1373b540608f54fcd7619b57801c8:README.md:generic-api-key:161
```

### Exclusion list

One can exclude files and directories by adding them to `exclude` property. Exclude property accepts [regular expression](https://pre-commit.com/#regular-expressions).

Ignore everything under `reports` and `docs` directories for `baseline` hook as an example.

```yaml
   repos:
     - repo: https://github.com/ministryofjustice/devsecops-hooks
       rev: v1.4.0
       hooks:
         - id: baseline
            exclude: |
            ^reports/|
            ^docs/
```

Or one can also create a file with list of exclusions.

```yaml
repos:
  - repo: https://github.com/ministryofjustice/devsecops-hooks
    rev: v1.4.0
    hooks:
      - id: baseline
        exclude: .pre-commit-ignore
```

### Environment Variables

One can customise the scanner behaviour by setting environment variables in the hook configuration.

#### Scan All Files (Not Just Staged)

By default, `STAGE_MODE` is set to `true`, which scans only staged files. To scan all files in the repository regardless of staging
status, set `STAGE_MODE` to `false`:

```yaml
repos:
  - repo: https://github.com/ministryofjustice/devsecops-hooks
    rev: v1.4.0
    hooks:
      - id: baseline
        env:
          STAGE_MODE: false
```

### Hook Configuration

The hook is configured in `.pre-commit-hooks.yaml` with the following settings:

- **ID**: `baseline`
- **Stages**: `pre-commit`, `pre-push`
- **Language**: `docker_image`
- **Image**: `ghcr.io/ministryofjustice/devsecops-hooks:v1.4.0`
- **Excludes**: Hidden files and directories (regex: `^\\..*|/\\..*`)
- **Pass Filenames**: `false` - Hook runs on the entire repository, not individual files
- **Always Run**: `true` - Executes on every invocation regardless of file changes
- **Verbose**: `true` - Provides detailed output for debugging
- **Fail Fast**: `false` - Allows other hooks to run even if this hook fails

### Docker Build Arguments

The Docker image supports the following build arguments:

| Argument                      | Default             | Description                        |
| ----------------------------- | ------------------- | ---------------------------------- |
| `VERSION`                     | `1.4.0`             | Scanner version number             |
| `GIT_LEAKS_VERSION`           | `8.30.0`            | GitLeaks version to install        |
| `GIT_LEAKS_SHA512`            | (specified)         | SHA-512 checksum for verification  |
| `GITLEAKS_CONFIGURATION_FILE` | `./.gitleaks.toml`  | GitLeaks configuration file path   |
| `GITLEAKS_IGNORE_FILE`        | `./.gitleaksignore` | GitLeaks ignore file path          |
| `GIT_MODE`                    | `true`              | Enable Git mode for scanning       |
| `STAGE_MODE`                  | `true`              | Scan only staged files in Git mode |
| `WORKDIR`                     | `/app`              | Application root directory         |
| `TERM`                        | `xterm-256color`    | Terminal type for colour output    |
| `CLICOLOR_FORCE`              | `1`                 | Force colour output in pipelines   |

## 🏗️ Architecture

### Components

1. **gitleaks.sh** - Downloads, verifies, and installs GitLeaks binary
2. **git.sh** - Installs Git version control system in Alpine Linux
3. **scan.sh** - Executes the security scan using GitLeaks CLI
4. **Dockerfile** - Multi-stage build for optimised container image
5. **.pre-commit-hooks.yaml** - Hook configuration for pre-commit framework

### Scripts Documentation

#### gitleaks.sh

Downloads and installs the GitLeaks binary with SHA-512 checksum verification.

**Environment Variables:**

- `GIT_LEAKS_VERSION` - Version to install (required)
- `GIT_LEAKS_SHA512` - SHA-512 checksum for verification (required)

**Process:**

1. Validates environment variables
2. Downloads GitLeaks from GitHub releases
3. Verifies checksum integrity
4. Extracts to `/usr/local/bin`
5. Validates installation

**Exit Codes:**

- `0` - Installation successful
- `1` - Missing dependencies or checksum mismatch

#### git.sh

Installs Git using Alpine Package Keeper (apk).

**Dependencies:**

- Alpine Linux package manager (apk)

**Process:**

1. Installs Git with `apk add --no-cache git`

#### scan.sh

Executes GitLeaks security scanning with configurable modes.

**Environment Variables:**

- `VERSION` - Scanner version for banner display
- `GITLEAKS_CONFIGURATION_FILE` - Custom config path (optional)
- `GITLEAKS_IGNORE_FILE` - Ignore file path (optional)
- `GIT_MODE` - Enable Git mode (default: `true`)
- `STAGE_MODE` - Scan staged files only (default: `true`)

**Modes:**

- **Git Mode** (default): Pre-commit scan using Git history
- **Non-Git Mode**: Direct filesystem scan with JSON output

**Exit Codes:**

- `0` - No secrets detected
- `1` - Secrets found or execution error

### Docker Image

Built using a multi-stage Alpine Linux approach:

- **Build Stage**: Downloads and verifies binary
- **Production Stage**: Minimal runtime image with scanner scripts
- **User**: Runs as non-root `scanner` user for security

## 📦 Usage

### Automatic (Pre-Commit Hook)

Once installed, the hook runs automatically:

```bash
git add .
git commit -S -m "Your commit message"
# Hook runs automatically and blocks commit if secrets detected
```

### Manual Execution

Run the scanner manually on specific files:

```bash
pre-commit run baseline --files path/to/file.py
```

Run on all files in the repository:

```bash
pre-commit run baseline --all-files
```

### Docker Container

You can also run the scanner directly using Docker:

```bash
docker run --rm -v $(pwd):/src ghcr.io/ministryofjustice/devsecops-hooks:v1.4.0
```

## 🎯 Example Output

### ✅ Success (No Secrets Detected)

```bash
⚡️ Ministry of Justice - Scanner 1.4.0⚡️

○
    │╲
    │ ○
    ○ ░
    ░    gitleaks

5:13PM INF 0 commits scanned.
5:13PM INF scanned ~325 bytes (325 bytes) in 305ms
5:13PM INF no leaks found
✅ No secrets have been detected.
```

### ❌ Failure (Secrets Detected)

```bash
⚡️ MoJ scanner 1.4.0⚡️

○
    │╲
    │ ○
    ○ ░
    ░    gitleaks

Finding:     export API_KEY=""
Secret:      fake-123
RuleID:      generic-api-key
Entropy:     4.5
File:        config/settings.py
Line:        42
Commit:      a1b2c3d4

5:13PM INF 0 commits scanned.
5:13PM INF scanned ~325 bytes (325 bytes) in 305ms
5:13PM WRN leaks found: 1
```

## 🛠️ Local

### Building the Docker Image

```bash
docker build -t devsecops-hooks:local .
```

### Testing Locally

```bash
docker run --rm -v $(pwd):/src devsecops-hooks:local
```

## 📦 Docker

The Dockerfile pulls `docker.io/alpine:3.23.3@sha256:25109184c71bdad752c8312a8623239686a9a2071e8825f20acb8f2198c3f659` which when analysed using `scout`
presented the following findings on `17/02/2026 15:21:52 UTC`.

```bash
docker scout cves docker.io/alpine:3.23.3@sha256:25109184c71bdad752c8312a8623239686a9a2071e8825f20acb8f2198c3f659
```

| Field           | Value          |
| --------------- | -------------- |
| Target          | alpine:3.23.3  |
| Digest          | 1529d13528ed   |
| Platform        | linux/arm64/v8 |
| Vulnerabilities | 0C 0H 1M 0L    |
| Size            | 4.2 MB         |
| Packages        | 20             |

## 📝 Environment Variables

### Build Arguments

- `VERSION` - Scanner version number (default: `1.4.0`)
- `GIT_LEAKS_VERSION` - GitLeaks version to install (default: `8.30.0`)
- `GIT_LEAKS_SHA512` - SHA-512 checksum for downloaded archive
- `GITLEAKS_CONFIGURATION_FILE` - Custom configuration file path (default: `./.gitleaks.toml`)
- `GITLEAKS_IGNORE_FILE` - Ignore file path (default: `./.gitleaksignore`)
- `GIT_MODE` - Enable Git-based scanning (default: `true`)
- `STAGE_MODE` - Scan only staged files (default: `true`)
- `WORKDIR` - Application root directory (default: `/app`)

### Runtime Environment Variables

- `VERSION` - Scanner version displayed in banner output
- `GIT_LEAKS_VERSION` - GitLeaks binary version in use
- `GITLEAKS_CONFIGURATION_FILE` - Path to active configuration file
- `GITLEAKS_IGNORE_FILE` - Path to active ignore file
- `GIT_MODE` - Current scanning mode (`true` for Git mode, `false` for filesystem)
- `STAGE_MODE` - Whether to scan staged files only (`true`/`false`)
- `WORKDIR` - Working directory for scanner execution
- `TERM` - Terminal type for colour output (default: `xterm-256color`)
- `CLICOLOR_FORCE` - Force colour output in CI/CD (default: `1`)

## 📄 Licence

This project is licensed under the MIT Licence - see the [LICENSE](LICENSE) file for details.

Copyright © 2026 Crown Copyright (Ministry of Justice)

## 🔗 Links

- [GitLeaks Documentation](https://github.com/gitleaks/gitleaks)
- [Pre-Commit Framework](https://pre-commit.com/)
- [Ministry of Justice GitHub](https://github.com/ministryofjustice)

## 🆘 Support

If you encounter any issues or have questions:

1. Review existing issues in the repository
2. Create a new issue with detailed information

## ⚠️ Important Notes

- Always review detected secrets before committing
- Update the `rev` field in `.pre-commit-config.yaml` to the latest commit SHA
- The scanner runs on both `pre-commit` and `pre-push` stages
- Hidden files and directories are excluded by default
- The hook is configured with `fail_fast: false` to allow other hooks to run even if secrets are detected
- The scanner runs on the entire repository (`pass_filenames: false`) rather than individual staged files
- Colour output is enabled for better visibility in CI/CD pipelines

---

Made with ❤️ by the Ministry of Justice UK
