#!/usr/bin/env bats

setup() {
    export VERSION=1.0.0
    export COMMITLINT_CONFIGURATION_FILE=./commitlint.config.js

    mkdir -p mockbin
    PATH="$PWD/mockbin:/usr/bin:/bin"

    # Mock cat
    echo '#!/bin/sh' > mockbin/cat
    echo 'exit 0' >> mockbin/cat

    chmod +x mockbin/cat
}

teardown() {
    rm -rf mockbin
}

@test "should exit if gitleaks is not installed" {
    # Arrange
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
    # Mock gitleaks
    echo "#!/bin/sh" > mockbin/gitleaks
    echo "exit 0" >> mockbin/gitleaks

    chmod +x mockbin/gitleaks

    # Act
    run ./scripts/scan.sh

    # Assert
    [[ "$output" == *"Ministry of Justice - Scanner ${VERSION}"* ]]

    [ "$status" -eq 1 ]
    [[ "$output" == *"Unable to switch to /src directory"* ]]
}

@test "should exit if commit file supplied is not available" {
    # Act
    run ./scripts/scan.sh commit invalid-file

    # Assert
    [[ "$output" == *"Ministry of Justice - Scanner ${VERSION}"* ]]

    [ "$status" -eq 1 ]
    [[ "$output" == *"Unable to read commit message from 'invalid-file'"* ]]
}

@test "should exit if npm is not installed" {
    # Arrange
    # Mock commit
    echo "test" > mock-commit-file

    # Act
    run ./scripts/scan.sh commit mock-commit-file

    # Assert
    [[ "$output" == *"Ministry of Justice - Scanner ${VERSION}"* ]]

    [ "$status" -eq 1 ]
    [[ "$output" == *"Missing npm executable"* ]]
}

@test "should exit if work directory is not available" {
    #Arrange
    # Mock commit
    echo "test" > mock-commit-file
    export WORKDIR="/src"

    # Mock npm
    echo "#!/bin/sh" > mockbin/npm
    echo "exit 0" >> mockbin/npm

    chmod +x mockbin/npm

    # Act
    run ./scripts/scan.sh commit mock-commit-file

    # Assert
    [[ "$output" == *"Ministry of Justice - Scanner ${VERSION}"* ]]

    [ "$status" -eq 1 ]
    [[ "$output" == *"Unable to switch to ${WORKDIR} directory."* ]]
}
