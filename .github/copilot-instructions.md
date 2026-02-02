# GitHub Copilot Instructions

## Language and Spelling

- Use British English spelling and grammar in all code comments, documentation, and string literals
- Examples: "colour" not "color", "behaviour" not "behavior", "initialise" not "initialize", "organise" not "organize"

## Project Context

- This is a security-focused DevSecOps tool for the Ministry of Justice UK
- Primary purpose: Pre-commit hooks for detecting hardcoded secrets and credentials
- Core technology: Docker-based Alpine Linux containers running GitLeaks scanner
- Target users: Government developers and security teams

## Code Style and Conventions

### Shell Scripts (Bash)

- Always use strict error handling: `set -euo pipefail` at script start
- Include comprehensive header comments documenting purpose, environment variables, exit codes, and dependencies
- Use explicit error messages with emoji prefixes (❌ for errors, ✅ for success, ⚡️ for branding
- Validate all dependencies with `command -v` checks before execution
- Use double quotes for variable expansions to prevent word splitting
- Prefer explicit exit codes (0 for success, 1 for failures)

### Docker and Containerisation

- Use pinned image digests (SHA256) for all base images to ensure reproducibility
- Implement multi-stage builds to minimise final image size
- Run containers as non-root users (e.g., `scanner` user)
- Use `SHELL` directive for consistent shell behaviour across build stages
- Document all ARG/ENV variables with their purpose and defaults
- Include OCI labels for image metadata (title, description, version, vendor, licence, source)

### Testing

- Write unit tests using BATS (Bash Automated Testing System)
- Include setup/teardown functions for test isolation
- Mock external dependencies using temporary mock scripts
- Test both success and failure scenarios explicitly
- Validate error messages and exit codes in assertions

## Documentation Standards

- Include workflow diagrams (SVG format) for complex processes
- Document all configuration files with inline comments explaining purpose and usage
- Provide both automatic (pre-commit) and manual execution examples
- Include troubleshooting sections and example outputs (success/failure scenarios)
- Maintain a CHANGELOG.md following conventional commits format

## Security Requirements

- Never commit secrets or credentials
- Use SHA-512 checksums for binary verification
- Pin all external dependencies (Docker images, GitHub actions) using commit SHAs
- Implement checksum validation for downloaded binaries
- Run security scanning (SCA) on dependencies
- Use minimal Alpine Linux base images
- Document security audit findings with timestamps

## CI/CD and Workflow Patterns

- Pin GitHub Actions using frozen commit SHAs with version comments (e.g., `# frozen: v6.0.1`)
- Use minimal permissions with explicit `permissions:` blocks
- Implement job dependencies with `needs:` for proper execution order
- Pass environment context via job outputs
- Use descriptive emoji in workflow names and job titles for visual clarity
- Validate changes through linting (YAML, Markdown) before merging

## Package Management

- Use `npm ci --ignore-scripts` in CI for deterministic installs
- Include housekeeping script combining update, audit, validation, and package sorting
- Maintain devDependencies for linting, testing, and validation tools
- Use scoped npm scripts for different validation types (yml, md, all)

## Configuration Files

- Use `.gitleaks.toml` for GitLeaks scanner configuration
- Use `.gitleaksignore` for false positive fingerprints
- Support regex-based exclusions via pre-commit `exclude:` property
- Maintain `.markdownlint.json` for Markdown linting rules
- Use `cspell.json` with British English dictionary (en-gb)
- Include British-specific technical terms and project-specific words in spell checker dictionary
