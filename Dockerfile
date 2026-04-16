###################
# 0. BASE
###################

# Image
FROM docker.io/alpine:3.23.4@sha256:5b10f432ef3da1b8d4c7eb6c487f2f5a8f096bc91145e68878dd4a5019afde11 AS base

# Shell
SHELL ["/bin/sh",  "-e", "-u", "-o", "pipefail", "-c"]

# Variables
ARG VERSION=1.6.0
ARG GIT_LEAKS_VERSION=8.30.0
ARG GIT_LEAKS_SHA512="3ae7b3e80a19ee9dd16098577d61f280b6b87d908ead1660deef27911aa407165ac68dbed0d60fbe16dc8e1d7f2e5f9f2945b067f54f0f64725070d16e0dbb58"
ARG GITLEAKS_CONFIGURATION_FILE=./.gitleaks.toml
ARG GITLEAKS_IGNORE_FILE=./.gitleaksignore
ARG GIT_MODE=true
ARG STAGE_MODE=true
ARG COMMITLINT_CONFIGURATION_FILE=./commitlint.config.js
ARG WORKDIR=/app

ENV VERSION=$VERSION \
    GIT_LEAKS_VERSION=$GIT_LEAKS_VERSION \
    GIT_LEAKS_SHA512=$GIT_LEAKS_SHA512 \
    GITLEAKS_CONFIGURATION_FILE=$GITLEAKS_CONFIGURATION_FILE \
    GITLEAKS_IGNORE_FILE=$GITLEAKS_IGNORE_FILE \
    GIT_MODE=$GIT_MODE \
    STAGE_MODE=$STAGE_MODE \
    COMMITLINT_CONFIGURATION_FILE=$COMMITLINT_CONFIGURATION_FILE \
    WORKDIR=$WORKDIR \
    TERM=xterm-256color \
    CLICOLOR_FORCE=1

# Root
WORKDIR ${WORKDIR}

# Bash
RUN apk add --no-cache bash

###################
# 1. BUILD
###################

# Image
FROM base AS build

# Scripts
COPY --chmod=755 ./scripts ./scripts
COPY --chmod=755 ./node ./node
COPY --chmod=644 ./commitlint.config.js ./commitlint.config.js

# GitLeak
RUN ./scripts/gitleaks.sh

# ###################
# # 2. PRODUCTION
# ###################

# Image
FROM base AS production

# Labels
LABEL org.opencontainers.image.title="MoJ Secret Scan" \
    org.opencontainers.image.description="Pre-commit hook scanning for hardcoded secrets and credentials" \
    org.opencontainers.image.version="${VERSION}" \
    org.opencontainers.image.vendor="Ministry of Justice UK" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.source="https://github.com/ministryofjustice/devsecops-hooks" \
    org.opencontainers.image.documentation="https://github.com/ministryofjustice/devsecops-hooks#readme" \
    org.opencontainers.image.authors="Abhi Markan"

# User
RUN adduser -D -H -s /sbin/nologin scanner

# Executables
COPY --chown=scanner:scanner --chmod=755 --from=build ${WORKDIR}/scripts/git.sh ./scripts/git.sh
COPY --chown=scanner:scanner --chmod=755 --from=build ${WORKDIR}/scripts/npm.sh ./scripts/npm.sh
COPY --chown=scanner:scanner --chmod=755 --from=build ${WORKDIR}/scripts/scan.sh ./scripts/scan.sh

COPY --chown=scanner:scanner --chmod=644 --from=build ${WORKDIR}/node/package.json ./
COPY --chown=scanner:scanner --chmod=644 --from=build ${WORKDIR}/node/package-lock.json ./
COPY --chown=scanner:scanner --chmod=644 --from=build ${WORKDIR}/commitlint.config.js ./

COPY --chown=scanner:scanner --chmod=755 --from=build /usr/local/bin/gitleaks /usr/local/bin/gitleaks

# Execute
RUN ./scripts/git.sh \
    && ./scripts/npm.sh

# Healthcheck
HEALTHCHECK \
--interval=60s \
--timeout=30s \
CMD node -v \
|| exit 1

# User
USER scanner

# Execute
ENTRYPOINT ["/app/scripts/scan.sh"]
