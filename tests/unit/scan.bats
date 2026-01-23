#!/usr/bin/env bats

setup() {
    mkdir -p mockbin
    PATH="$PWD/mockbin:/usr/bin:/bin"
}

teardown() {
    rm -rf mockbin
}

@test "should exit if gitleaks is not available" {
    # Arrange
    export VERSION=1.0.0

    # Mock cd
    echo '#!/bin/sh' > mockbin/cd
    echo 'exit 0' >> mockbin/cd

    chmod +x mockbin/cd

    # Act
    run ./scripts/scan.sh

    # Assert
    [[ "$output" == *"Ministry of Justice - Scanner ${VERSION}"* ]]

    [ "$status" -eq 1 ]
    [[ "$output" == *"Missing gitleaks executable"* ]]
}

@test "should exit if /src directory does not exist" {
    # Arrange
    export VERSION=1.0.0

    # Mock gitleaks
    echo "#!/bin/sh" > mockbin/gitleaks
    echo "exit 0" >> mockbin/gitleaks

    chmod +x mockbin/gitleaks

    # Act
    run ./scripts/scan.sh

    # Assert
    [[ "$output" == *"Ministry of Justice - Scanner ${VERSION}"* ]]

    [ "$status" -eq 1 ]
    [[ "$output" == *"Unable to find /src directory"* ]]
}
