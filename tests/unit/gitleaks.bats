#!/usr/bin/env bats

setup() {
    mkdir -p mockbin
    PATH="$PWD/mockbin:$PATH"
}

teardown() {
    if [ "${SKIP_TEARDOWN:-false}" = "true" ]; then
        return;
    fi

        rm -rf mockbin gitleaks*.tar.gz
}

@test "should exit if GIT_LEAKS_VERSION has not been specified" {
    # Act
    run ./scripts/gitleaks.sh

    # Assert
    [ "$status" -eq 1 ]
    [[ "$output" == *"Missing GIT_LEAKS_VERSION environment variable"* ]]
}

@test "should exit if wget command is not available" {
    # Arrange
    export GIT_LEAKS_VERSION=8.30.0
    export GIT_LEAKS_SHA512=invalid
    export SKIP_TEARDOWN=true
    PATH="$PWD/mockbin"

    # Act
    run ./scripts/gitleaks.sh

    # Assert
    [ "$status" -eq 1 ]
    [[ "$output" == *"Missing wget executable."* ]]
}

@test "should exit if tar command is not available" {
    # Arrange
    export GIT_LEAKS_VERSION=8.30.0

    # Mock wget
    echo '#!/bin/sh; echo "fake wget called with: $@"' > mockbin/wget
    chmod +x mockbin/wget

    # Provide executables
    ln -s /bin/rm mockbin/rm
    ln -s /bin/chmod mockbin/chmod

    # Set PATH so tar is missing
    PATH="$PWD/mockbin"

    # Act
    run ./scripts/gitleaks.sh

    # Assert
    [ "$status" -eq 1 ]
    [[ "$output" == *"Missing tar executable."* ]]
}

@test "should exit if checksum does not match" {
    # Arrange
    export GIT_LEAKS_VERSION=8.30.0
    export GIT_LEAKS_SHA512=invalid
    PATH="$PWD/mockbin:/usr/bin:/bin"

    # Mock wget
    echo '#!/bin/sh' > mockbin/wget
    echo 'exit 0' >> mockbin/wget
    chmod +x mockbin/wget

    # Mock tar
    echo '#!/bin/sh' > mockbin/tar
    echo 'exit 0' >> mockbin/tar
    chmod +x mockbin/tar

    # Mock sha512sum
    echo '#!/bin/sh' > mockbin/sha512sum
    echo 'echo "valid";' >> mockbin/sha512sum
    chmod +x mockbin/sha512sum

    # Act
    run ./scripts/gitleaks.sh

    # Assert
    [[ "$output" == *"Installing GitLeaks ${GIT_LEAKS_VERSION}."* ]]

    [ "$status" -eq 1 ]
    [[ "$output" == *"Failed checksum"* ]]
}

@test "should exit when gitleaks is not installed" {
    # Arrange
    export GIT_LEAKS_VERSION=8.30.0
    export GIT_LEAKS_SHA512=valid
    PATH="$PWD/mockbin:/usr/bin:/bin"

    # Mock wget
    echo '#!/bin/sh' > mockbin/wget
    echo 'exit 0' >> mockbin/wget
    chmod +x mockbin/wget

    # Mock tar
    echo '#!/bin/sh' > mockbin/tar
    echo 'exit 0' >> mockbin/tar
    chmod +x mockbin/tar

    # Mock sha512sum
    echo '#!/bin/sh' > mockbin/sha512sum
    echo 'echo "valid";' >> mockbin/sha512sum
    chmod +x mockbin/sha512sum

    # Act
    run ./scripts/gitleaks.sh

    # Assert
    [[ "$output" == *"Installing GitLeaks ${GIT_LEAKS_VERSION}."* ]]

    [ "$status" -eq 1 ]
    [[ "$output" == *"Missing gitleaks executable"* ]]
}

@test "should exit with status 0" {
    # Arrange
    export GIT_LEAKS_VERSION=8.30.0
    export GIT_LEAKS_SHA512=valid
    PATH="$PWD/mockbin:/usr/bin:/bin"

    # Mock wget
    echo '#!/bin/sh' > mockbin/wget
    echo 'exit 0' >> mockbin/wget
    chmod +x mockbin/wget

    # Mock tar
    echo '#!/bin/sh' > mockbin/tar
    echo 'exit 0' >> mockbin/tar
    chmod +x mockbin/tar

    # Mock sha512sum
    echo '#!/bin/sh' > mockbin/sha512sum
    echo 'echo "valid";' >> mockbin/sha512sum
    chmod +x mockbin/sha512sum

    # Mock gitleaks
    echo '#!/bin/sh' > mockbin/gitleaks
    echo 'exit 0' >> mockbin/gitleaks
    chmod +x mockbin/gitleaks

    # Act
    run ./scripts/gitleaks.sh

    # Assert
    [[ "$output" == *"Installing GitLeaks ${GIT_LEAKS_VERSION}."* ]]

    [ "$status" -eq 0 ]
    [[ "$output" == *"GitLeaks ${GIT_LEAKS_VERSION} has been installed"* ]]
}