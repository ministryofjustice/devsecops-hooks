###################
# 0. BASE
###################
ARG VERSION=1.0.0
ARG GIT_LEAKS_VERSION=8.30.0
ARG GIT_LEAKS_SHA512="3ae7b3e80a19ee9dd16098577d61f280b6b87d908ead1660deef27911aa407165ac68dbed0d60fbe16dc8e1d7f2e5f9f2945b067f54f0f64725070d16e0dbb58"
ARG ROOT=/app

###################
# 1. BUILD
###################

# Image
FROM alpine:3.22 AS build

# Shell
SHELL ["/bin/sh", "-c"]

# Variables
ARG VERSION
ARG GIT_LEAKS_VERSION
ARG GIT_LEAKS_SHA512
ARG ROOT
ENV VERSION=$VERSION
ENV GIT_LEAKS_VERSION=$GIT_LEAKS_VERSION
ENV GIT_LEAKS_SHA512=$GIT_LEAKS_SHA512
ENV ROOT=$ROOT

# Root
WORKDIR ${ROOT}

# Scripts
COPY ./scripts ./scripts

# Permissions
RUN chmod -R +x ${ROOT}/scripts

# GitLeak
RUN ${ROOT}/scripts/gitleaks.sh


# ###################
# # 2. PRODUCTION
# ###################

# Image
FROM alpine:3.22 AS production

# Shell
SHELL ["/bin/sh", "-c"]

# Variables
ARG VERSION
ARG GIT_LEAKS_VERSION
ARG GIT_LEAKS_SHA512
ARG ROOT
ENV VERSION=$VERSION
ENV GIT_LEAKS_VERSION=$GIT_LEAKS_VERSION
ENV GIT_LEAKS_SHA512=$GIT_LEAKS_SHA512
ENV ROOT=$ROOT

# Labels
LABEL org.opencontainers.image.title="MoJ Secret Scan"
LABEL org.opencontainers.image.description="Pre-commit hook scanning for hardcoded secrets and credentials"
LABEL org.opencontainers.image.version=$VERSION
LABEL org.opencontainers.image.vendor="Ministry of Justice"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.source="https://github.com/ministryofjustice/pre-commit-hook"

# Root
WORKDIR ${ROOT}

# Executables
COPY --from=build ${ROOT}/scripts/scan.sh ./scripts/scan.sh
COPY --from=build /usr/local/bin/gitleaks /usr/local/bin/gitleaks

# Permissions
RUN chmod +x ${ROOT}/scripts/scan.sh

# User
RUN adduser -D scanner
USER scanner

# Execute
ENTRYPOINT ["sh", "-c", "exec \"$ROOT/scripts/scan.sh\""]
