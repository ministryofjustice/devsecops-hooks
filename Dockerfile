###################
# 0. BASE
###################
ARG VERSION=1.4.0
ARG GIT_LEAKS_VERSION=8.30.0
ARG GIT_LEAKS_SHA512="3ae7b3e80a19ee9dd16098577d61f280b6b87d908ead1660deef27911aa407165ac68dbed0d60fbe16dc8e1d7f2e5f9f2945b067f54f0f64725070d16e0dbb58"
ARG GITLEAKS_CONFIGURATION_FILE=./.gitleaks.toml
ARG GITLEAKS_IGNORE_FILE=./.gitleaksignore
ARG GIT_MODE=true
ARG STAGE_MODE=true
ARG WORKDIR=/app

###################
# 1. BUILD
###################

# Image
FROM docker.io/alpine:3.23.3@sha256:25109184c71bdad752c8312a8623239686a9a2071e8825f20acb8f2198c3f659 AS build

# Shell
SHELL ["/bin/sh",  "-e", "-u", "-o", "pipefail", "-c"]

# Variables
ARG VERSION
ARG GIT_LEAKS_VERSION
ARG GIT_LEAKS_SHA512
ARG GITLEAKS_CONFIGURATION_FILE
ARG GITLEAKS_IGNORE_FILE
ARG GIT_MODE
ARG STAGE_MODE
ARG WORKDIR
ENV VERSION=$VERSION
ENV GIT_LEAKS_VERSION=$GIT_LEAKS_VERSION
ENV GIT_LEAKS_SHA512=$GIT_LEAKS_SHA512
ENV GITLEAKS_CONFIGURATION_FILE=$GITLEAKS_CONFIGURATION_FILE
ENV GITLEAKS_IGNORE_FILE=$GITLEAKS_IGNORE_FILE
ENV GIT_MODE=$GIT_MODE
ENV STAGE_MODE=$STAGE_MODE
ENV WORKDIR=$WORKDIR
ENV TERM=xterm-256color
ENV CLICOLOR_FORCE=1

# Root
WORKDIR ${WORKDIR}

# Bash
RUN apk add --no-cache bash

# Scripts
COPY ./scripts ./scripts

# Permissions
RUN chmod -R +x ${WORKDIR}/scripts

# GitLeak
RUN ${WORKDIR}/scripts/gitleaks.sh


# ###################
# # 2. PRODUCTION
# ###################

# Image
FROM docker.io/alpine:3.23.3@sha256:25109184c71bdad752c8312a8623239686a9a2071e8825f20acb8f2198c3f659 AS production

# Shell
SHELL ["/bin/sh",  "-e", "-u", "-o", "pipefail", "-c"]

# Variables
ARG VERSION
ARG GIT_LEAKS_VERSION
ARG GIT_LEAKS_SHA512
ARG GITLEAKS_CONFIGURATION_FILE
ARG GITLEAKS_IGNORE_FILE
ARG GIT_MODE
ARG STAGE_MODE
ARG WORKDIR
ENV VERSION=$VERSION
ENV GIT_LEAKS_VERSION=$GIT_LEAKS_VERSION
ENV GIT_LEAKS_SHA512=$GIT_LEAKS_SHA512
ENV GITLEAKS_CONFIGURATION_FILE=$GITLEAKS_CONFIGURATION_FILE
ENV GITLEAKS_IGNORE_FILE=$GITLEAKS_IGNORE_FILE
ENV GIT_MODE=$GIT_MODE
ENV STAGE_MODE=$STAGE_MODE
ENV WORKDIR=$WORKDIR
ENV TERM=xterm-256color
ENV CLICOLOR_FORCE=1

# Labels
LABEL org.opencontainers.image.title="MoJ Secret Scan"
LABEL org.opencontainers.image.description="Pre-commit hook scanning for hardcoded secrets and credentials"
LABEL org.opencontainers.image.version="${VERSION}"
LABEL org.opencontainers.image.vendor="Ministry of Justice UK"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.source="https://github.com/ministryofjustice/devsecops-hooks"
LABEL org.opencontainers.image.documentation="https://github.com/ministryofjustice/devsecops-hooks#readme"
LABEL org.opencontainers.image.authors="Abhi Markan"

# Root
WORKDIR ${WORKDIR}

# Bash
RUN apk add --no-cache bash

# User
RUN adduser -D scanner

# Executables
COPY --chown=scanner:scanner --chmod=755 --from=build ${WORKDIR}/scripts/git.sh ./scripts/git.sh
COPY --chown=scanner:scanner --chmod=755 --from=build ${WORKDIR}/scripts/scan.sh ./scripts/scan.sh
COPY --chown=scanner:scanner --chmod=755 --from=build /usr/local/bin/gitleaks /usr/local/bin/gitleaks

# Execute
RUN ${WORKDIR}/scripts/git.sh

# User
USER scanner

# Execute
ENTRYPOINT ["./scripts/scan.sh"]
