#!/usr/bin/env bats

@test "install git cli" {
    # Arrange
    mkdir -p mockbin
    PATH="$PWD/mockbin:$PATH"

    echo '#!/bin/sh
    echo "$@"' > mockbin/apk
    
    chmod +x mockbin/apk

    # Act
    run ./scripts/git.sh

    # Assert
    [ "$status" -eq 0 ]
    [ "$output" = "add --no-cache git" ]

}