# 🔐 DevSecOps Hooks

Ministry of Justice pre-commit hooks for scanning hardcoded secrets and credentials.

[![Ministry of Justice Repository Compliance Badge](https://github-community.service.justice.gov.uk/repository-standards/api/devsecops-hooks/badge)](https://github-community.service.justice.gov.uk/repository-standards/devsecops-hooks)

---

[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Docker](https://img.shields.io/badge/Docker-Enabled-blue.svg)](Dockerfile)

[![GitHub release](https://img.shields.io/github/v/release/ministryofjustice/devsecops-hooks)](https://github.com/ministryofjustice/devsecops-hooks/releases)
[![GitHub issues](https://img.shields.io/github/issues/ministryofjustice/devsecops-hooks)](https://github.com/ministryofjustice/devsecops-hooks/issues)
[![GitHub pull requests](https://img.shields.io/github/issues-pr/ministryofjustice/devsecops-hooks)](https://github.com/ministryofjustice/devsecops-hooks/pulls)

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
       rev: v1.3.0
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
       rev: v1.3.0
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
    rev: v1.3.0
    hooks:
      - id: baseline
        exclude: .pre-commit-ignore
```

### Hook Configuration

The hook is configured in `.pre-commit-hooks.yaml` with the following settings:

- **ID**: `baseline`
- **Stages**: `pre-commit`, `pre-push`
- **Language**: `docker_image`
- **Image**: `ghcr.io/ministryofjustice/devsecops-hooks:latest`
- **Excludes**: Hidden files and directories (regex: `^\\..*|/\\..*`)
- **Pass Filenames**: `false` - Hook runs on the entire repository, not individual files
- **Always Run**: `true` - Executes on every invocation regardless of file changes
- **Verbose**: `true` - Provides detailed output for debugging
- **Fail Fast**: `false` - Allows other hooks to run even if this hook fails

### Docker Build Arguments

The Docker image supports the following build arguments:

| Argument                      | Default             | Description                       |
| ----------------------------- | ------------------- | --------------------------------- |
| `VERSION`                     | `1.3.0`             | Scanner version number            |
| `GIT_LEAKS_VERSION`           | `8.30.0`            | GitLeaks version to install       |
| `GIT_LEAKS_SHA512`            | (specified)         | SHA-512 checksum for verification |
| `GITLEAKS_CONFIGURATION_FILE` | `./.gitleaks.toml`  | GitLeaks configuration file path  |
| `GITLEAKS_IGNORE_FILE`        | `./.gitleaksignore` | GitLeaks ignore file path         |
| `GIT_MODE`                    | `true`              | Enable Git mode for scanning      |
| `WORKDIR`                     | `/app`              | Application root directory        |
| `TERM`                        | `xterm-256color`    | Terminal type for colour output   |
| `CLICOLOR_FORCE`              | `1`                 | Force colour output in pipelines  |

## 🏗️ Architecture

### Components

1. **gitleaks.sh** - Downloads, verifies, and installs GitLeaks
2. **scan.sh** - Executes the security scan using CLI commands
3. **Dockerfile** - Multi-stage build for optimised container image
4. **.pre-commit-hooks.yaml** - Hook configuration for pre-commit framework

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
docker run --rm -v $(pwd):/src ghcr.io/ministryofjustice/devsecops-hooks:latest
```

## 🎯 Example Output

### ✅ Success (No Secrets Detected)

```bash
⚡️ Ministry of Justice - Scanner 1.3.0⚡️

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
⚡️ MoJ scanner 1.3.0⚡️

○
    │╲
    │ ○
    ○ ░
    ░    gitleaks

Finding:     export API_KEY=""
Secret:      sk-1234567890abcdef
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

The dockerfile pulls `docker.io/alpine:3.23@sha256:865b95f46d98cf867a156fe4a135ad3fe50d2056aa3f25ed31662dff6da4eb62` which when analysed using `scout`
presented the following findings on `19/12/2025 10:17:40 UTC`.

```bash
docker scout cves docker.io/alpine:3.23@sha256:865b95f46d98cf867a156fe4a135ad3fe50d2056aa3f25ed31662dff6da4eb62
```

| Field           | Value                                                                                      |
| --------------- | ------------------------------------------------------------------------------------------ |
| Target          | alpine:3.23                                                                                |
| Digest          | 410dabcd6f1d                                                                               |
| Platform        | linux/arm64/v8                                                                             |
| Provenance      | https:// github.com/alpinelinux/docker-alpine.git 13b62f5f47ffa526f9c372e0bd73b33ef2a5f865 |
| Vulnerabilities | 0C 0H 0M 0L                                                                                |
| Size            | 4.2 MB                                                                                     |
| Packages        | 20                                                                                         |

## 📝 Environment Variables

### Build Arguments

- `GIT_LEAKS_VERSION` - GitLeaks version to install (e.g., `8.30.0`)
- `GIT_LEAKS_SHA512` - SHA-512 checksum for downloaded archive

### Runtime

- `VERSION` - Scanner version displayed in output
- `WORKDIR` - Application root directory (default: `/app`)

## 📄 Licence

This project is licensed under the MIT Licence - see the [LICENSE](LICENSE) file for details.

Copyright © 2025 Crown Copyright (Ministry of Justice)

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
