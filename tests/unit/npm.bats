#!/usr/bin/env bats

setup() {
    mkdir -p mockbin
    PATH="$PWD/mockbin:$PATH"
}

teardown() {
    rm -rf mockbin
}

@test "should install npm cli" {
    # Arrange
    echo '#!/bin/sh
    echo "$@"' > mockbin/apk

    chmod +x mockbin/apk

    echo '#!/bin/sh
    echo "$@"' > mockbin/npm

    chmod +x mockbin/npm

    # Act
    run ./scripts/npm.sh

    # Assert
    [ "$status" -eq 0 ]
    [[ "$output" == *"add --no-cache npm"* ]]
}

@test "should run npm ci with arguments" {
    # Arrange
    echo '#!/bin/sh
    echo "$@"' > mockbin/apk

    chmod +x mockbin/apk

    echo '#!/bin/sh
    echo "$@"' > mockbin/npm

    chmod +x mockbin/npm

    # Act
    run ./scripts/npm.sh

    # Assert
    [ "$status" -eq 0 ]
    [[ "$output" == *"ci --ignore-scripts --omit=dev"* ]]
}