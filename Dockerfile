FROM docker.io/alpine:3.23@sha256:51183f2cfa6320055da30872f211093f9ff1d3cf06f39a0bdb212314c5dc7375

ARG VERSION="local" \ 
    GIT_LEAKS_VERSION="8.30.0" \
    GIT_LEAKS_SHA512="3ae7b3e80a19ee9dd16098577d61f280b6b87d908ead1660deef27911aa407165ac68dbed0d60fbe16dc8e1d7f2e5f9f2945b067f54f0f64725070d16e0dbb58"

ENV CONTAINER_GID="65532" \
    CONTAINER_GROUP="scanner" \
    CONTAINER_UID="65532" \
    CONTAINER_USER="scanner" \
    CONTAINER_WORKDIR="/scanner" \
    VERSION="${VERSION}"

LABEL org.opencontainers.image.title="MoJ Secret Scan" \
      org.opencontainers.image.description="Pre-commit hook scanning for hardcoded secrets and credentials" \
      org.opencontainers.image.version="${VERSION}" \
      org.opencontainers.image.vendor="Ministry of Justice" \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.source="https://github.com/ministryofjustice/devsecops-actions"

# Shell
SHELL ["/bin/sh", "-e", "-u", "-o", "pipefail", "-c"]

# Create non-root user and group, and working directory
RUN <<EOF
addgroup -g "${CONTAINER_GID}" -S "${CONTAINER_GROUP}"

adduser -u "${CONTAINER_UID}" -D -S -G "${CONTAINER_GROUP}" "${CONTAINER_USER}"

install --directory --owner "${CONTAINER_USER}" --group "${CONTAINER_GROUP}" --mode 0755 "${CONTAINER_WORKDIR}"
EOF

# Install GitLeaks
RUN <<EOF
wget -O /tmp/gitleaks.tar.gz "https://github.com/gitleaks/gitleaks/releases/download/v${GIT_LEAKS_VERSION}/gitleaks_${GIT_LEAKS_VERSION}_linux_x64.tar.gz"

tar -xzf /tmp/gitleaks.tar.gz -C /tmp gitleaks

echo "${GIT_LEAKS_SHA512}  /tmp/gitleaks.tar.gz" | sha512sum -c -
    
install --owner root --group root --mode 0755 /tmp/gitleaks /usr/local/bin/gitleaks

rm -rf /tmp/gitleaks /tmp/gitleaks.tar.gz
EOF

# Copy scripts
COPY --chown=nobody:nogroup --chmod=0755 scripts/ "${CONTAINER_WORKDIR}/scripts/"

# Switch to non-root user and set working directory
USER "${CONTAINER_USER}"
WORKDIR "${CONTAINER_WORKDIR}"

ENTRYPOINT ["sh", "-c", "exec ${CONTAINER_WORKDIR}/scripts/scan.sh"]
