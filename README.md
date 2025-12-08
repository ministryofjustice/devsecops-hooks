# 🔐 DevSecOps Hooks

> Ministry of Justice pre-commit hooks for scanning hardcoded secrets and credentials.

[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Docker](https://img.shields.io/badge/Docker-Enabled-blue.svg)](Dockerfile)

[![Ministry of Justice Repository Compliance Badge](https://github-community.service.justice.gov.uk/repository-standards/api/devsecops-hooks/badge)](https://github-community.service.justice.gov.uk/repository-standards/devsecops-hooks)

## 📋 Overview

A lightweight, Docker-based security scanner that integrates seamlessly with Git workflows to prevent hardcoded secrets from being committed to your repository. Built for the Ministry of Justice, this tool leverages following CLI commands to detect sensitive information such as API keys, passwords, tokens, and other credentials.

- [GitLeaks](https://github.com/gitleaks/gitleaks)

## ✨ Features

- 🛡️ **Automated Secret Detection** - Scans code for hardcoded secrets using GitLeaks
- 🐳 **Docker-Based** - Runs in an isolated Alpine Linux container
- 🔗 **Pre-Commit Integration** - Works seamlessly with the pre-commit framework
- ⚡ **Fast & Lightweight** - Minimal footprint with optimised scanning
- 🎯 **Fail-Fast** - Stops commits immediately when secrets are detected
- 🔍 **Verbose Logging** - Detailed output for easy debugging
- 🏷️ **Version Controlled** - Pinned GitLeaks version with checksum validation

## 🚀 Getting Started

### Prerequisites

- [pre-commit](https://pre-commit.com/) framework installed
- Docker (for running the containerised scanner)
- Git repository

### Installation

1. **Install pre-commit** (if not already installed):

   ```bash
   pip install pre-commit
   ```

2. **Add to your repository** by creating or updating `.pre-commit-config.yaml`:

   ```yaml
   repos:
     - repo: https://github.com/ministryofjustice/devsecops-hooks
       rev: v1.0.0
       hooks:
         - id: baseline
   ```

3. **Install the hook**:

   ```bash
   pre-commit install
   ```

4. **Run manually** (optional):

   ```bash
   pre-commit run --all-files
   ```

## 🔧 Configuration

### Hook Configuration

The hook is configured in `.pre-commit-hooks.yaml` with the following settings:

- **ID**: `baseline`
- **Stages**: `pre-commit`, `pre-push`
- **Language**: `docker_image`
- **Image**: `ghcr.io/ministryofjustice/pre-commit-hook:latest`
- **Excludes**: Hidden files and directories (regex: `^\\..*|/\\..*`)

### Docker Build Arguments

The Docker image supports the following build arguments:

| Argument | Default | Description |
|----------|---------|-------------|
| `VERSION` | `1.0.0` | Scanner version number |
| `GIT_LEAKS_VERSION` | `8.30.0` | GitLeaks version to install |
| `GIT_LEAKS_SHA512` | (specified) | SHA-512 checksum for verification |
| `ROOT` | `/app` | Application root directory |

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
git commit -m "Your commit message"
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
docker run --rm -v $(pwd):/src ghcr.io/ministryofjustice/pre-commit-hook:latest
```

## 🎯 Example Output

### ✅ Success (No Secrets Detected)

```bash
⚡️ Ministry of Justice - Scanner 1.0.0⚡️

○
    │╲
    │ ○
    ○ ░
    ░    gitleaks

12:34PM INF 123 commits scanned.
12:34PM INF scan completed in 1.2s
✅ No secrets have been detected.
```

### ❌ Failure (Secrets Detected)

```bash
⚡️ MoJ scanner 1.0.0⚡️

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

12:34PM WRN leaks found: 1
```

## 🛠️ Development

### Building the Docker Image

```bash
docker build -t devsecops-hooks:local .
```

### Testing Locally

```bash
# Test the GitLeaks installation script
docker run --rm -it alpine:3.22 sh -c "
  export GIT_LEAKS_VERSION=8.30.0
  export GIT_LEAKS_SHA512=3ae7b3e80a19ee9dd16098577d61f280b6b87d908ead1660deef27911aa407165ac68dbed0d60fbe16dc8e1d7f2e5f9f2945b067f54f0f64725070d16e0dbb58
  ./scripts/gitleaks.sh
"

# Test the scanner
docker run --rm -v $(pwd):/src devsecops-hooks:local
```

## 📝 Environment Variables

### Build Arguments

- `GIT_LEAKS_VERSION` - GitLeaks version to install (e.g., `8.30.0`)
- `GIT_LEAKS_SHA512` - SHA-512 checksum for downloaded archive

### Runtime

- `VERSION` - Scanner version displayed in output
- `ROOT` - Application root directory (default: `/app`)

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
- The hook is configured with `fail_fast: true` to stop execution immediately upon finding secrets

---

Made with ❤️ by the Ministry of Justice
