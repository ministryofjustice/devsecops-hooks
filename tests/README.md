# 🧪 Testing Guide

Unit tests for DevSecOps Hooks using BATS (Bash Automated Testing System).

---

[![BATS](https://img.shields.io/badge/BATS-1.13.0-blue.svg)](https://github.com/bats-core/bats-core)
[![Shell](https://img.shields.io/badge/Shell-Bash-green.svg)](https://www.gnu.org/software/bash/)

## 📋 Overview

This directory contains unit tests for the DevSecOps Hooks project. Tests are written using BATS,
a testing framework specifically designed for Bash scripts. BATS provides a simple syntax for
writing test cases and includes powerful features for testing shell scripts in isolation.

## 🧩 Structure

```text
tests/
└── unit/
    ├── git.bats         # Tests for Git CLI installation script
    ├── gitleaks.bats    # Tests for GitLeaks installation script
    └── scan.bats        # Tests for scanning functionality
```

## ✨ Features

- 🎯 **Isolated Testing** - Each test runs in a clean environment
- 🔄 **Setup & Teardown** - Automatic test environment management
- 🎭 **Mocking** - Mock external commands for predictable testing
- 📊 **Clear Output** - Verbose and readable test results
- ⚡ **Fast Execution** - Lightweight and efficient test runner

## 🚀 Getting Started

### Prerequisites

- [Bash](https://www.gnu.org/software/bash/) (version 4.0 or higher)
- [BATS](https://github.com/bats-core/bats-core) testing framework
- [Node.js](https://nodejs.org/) and npm (for running test scripts)

### Installation

BATS is already included as a development dependency in the project. Simply install the project dependencies:

```bash
npm install
```

## 📝 Writing Tests

### Basic Test Structure

BATS tests follow a simple and intuitive syntax:

```bash
#!/usr/bin/env bats

@test "test description" {
    # Arrange - Set up test conditions

    # Act - Execute the code being tested

    # Assert - Verify the results
}
```

### Test Lifecycle

#### Setup Function

Runs before each test case to prepare the test environment:

```bash
setup() {
    mkdir -p mockbin
    PATH="$PWD/mockbin:$PATH"
}
```

#### Teardown Function

Runs after each test case to clean up resources:

```bash
teardown() {
    rm -rf mockbin
}
```

### Common Patterns

#### 1. Testing Exit Status

```bash
@test "should exit with status 0" {
    run ./scripts/example.sh

    [ "$status" -eq 0 ]
}
```

#### 2. Testing Output

```bash
@test "should display correct message" {
    run ./scripts/example.sh

    [[ "$output" == *"Expected message"* ]]
}
```

#### 3. Mocking Commands

Create mock executables to simulate external dependencies:

```bash
@test "should call git command" {
    # Arrange
    mkdir -p mockbin
    PATH="$PWD/mockbin:$PATH"

    echo '#!/bin/sh
    echo "$@"' > mockbin/git

    chmod +x mockbin/git

    # Act
    run ./scripts/example.sh

    # Assert
    [ "$status" -eq 0 ]
    [[ "$output" == *"expected arguments"* ]]
}
```

#### 4. Setting Environment Variables

```bash
@test "should use VERSION environment variable" {
    export VERSION=1.0.0

    run ./scripts/example.sh

    [[ "$output" == *"${VERSION}"* ]]
}
```

### Best Practises

1. **Use Descriptive Test Names** - Clearly state what the test verifies
2. **Follow AAA Pattern** - Arrange, Act, Assert for clear test structure
3. **Test One Thing** - Each test should verify a single behaviour
4. **Clean Up** - Use teardown to remove temporary files and directories
5. **Isolate Tests** - Tests should not depend on each other
6. **Mock External Dependencies** - Use mock commands for predictable tests
7. **Test Error Cases** - Verify error handling and edge cases

## 🏃 Running Tests

### Run All Tests

Execute all unit tests with verbose output:

```bash
npm run test:unit
```

### Run Specific Test File

Run tests from a single file:

```bash
npx bats tests/unit/git.bats --verbose-run
```

### Run Individual Test

Run a specific test by line number:

```bash
npx bats tests/unit/git.bats --verbose-run --filter "should install git cli"
```

## 🔍 Understanding Test Output

### Successful Test

```bash
✓ should install git cli
```

### Failed Test

```bash
✗ should install git cli
  (in test file tests/unit/git.bats, line 14)
    `[ "$status" -eq 0 ]' failed
```

### Verbose Output

Use `--verbose-run` flag to see detailed test execution:

```bash
npx bats tests/unit/git.bats --verbose-run
```

## 📚 BATS Fundamentals

### Assertions

BATS uses standard shell test commands for assertions:

| Assertion                     | Description                    |
| ----------------------------- | ------------------------------ |
| `[ "$status" -eq 0 ]`         | Check exit status equals 0     |
| `[ "$status" -ne 0 ]`         | Check exit status not equals 0 |
| `[[ "$output" == *"text"* ]]` | Check output contains text     |
| `[ -f "file.txt" ]`           | Check file exists              |
| `[ -d "directory" ]`          | Check directory exists         |
| `[ -x "script.sh" ]`          | Check file is executable       |

### Special Variables

| Variable      | Description                       |
| ------------- | --------------------------------- |
| `$status`     | Exit status of the last command   |
| `$output`     | Combined stdout and stderr output |
| `$lines`      | Array of output lines             |
| `${lines[0]}` | First line of output              |

### Run Command

The `run` command executes a command and captures its output:

```bash
run ./scripts/example.sh argument1 argument2
```

Benefits:

- Captures exit status in `$status`
- Captures output in `$output`
- Prevents test termination on command failure

## 🐛 Debugging Tests

### Print Debug Information

Add `echo` statements to display debug information:

```bash
@test "debug example" {
    echo "# Debug: Variable value is ${VARIABLE}" >&3
    run ./scripts/example.sh
    [ "$status" -eq 0 ]
}
```

### Run Tests in Debug Mode

Use `--trace` flag for detailed execution trace:

```bash
npx bats tests/unit/git.bats --trace
```

### Check Test Environment

Verify the test environment state:

```bash
@test "check environment" {
    run pwd
    echo "# Current directory: $output" >&3

    run ls -la
    echo "# Directory contents: $output" >&3
}
```

## 🛠️ Advanced Techniques

### Conditional Skip

Skip tests based on conditions:

```bash
@test "should run on Linux only" {
    if [[ "$OSTYPE" != "linux-gnu"* ]]; then
        skip "This test only runs on Linux"
    fi

    run ./scripts/example.sh
    [ "$status" -eq 0 ]
}
```

### Testing Multiple Scenarios

Use loops to test multiple inputs:

```bash
@test "should handle various inputs" {
    inputs=("input1" "input2" "input3")

    for input in "${inputs[@]}"; do
        run ./scripts/example.sh "$input"
        [ "$status" -eq 0 ]
    done
}
```

### Temporary Files

Create temporary test files:

```bash
@test "should process file" {
    # Create temporary file
    temp_file=$(mktemp)
    echo "test content" > "$temp_file"

    # Act
    run ./scripts/example.sh "$temp_file"

    # Assert
    [ "$status" -eq 0 ]

    # Clean up
    rm "$temp_file"
}
```

## 🔗 Links

- [BATS Core Documentation](https://bats-core.readthedocs.io/)
- [BATS GitHub Repository](https://github.com/bats-core/bats-core)
- [Bash Test Documentation](https://www.gnu.org/software/bash/manual/html_node/Bash-Conditional-Expressions.html)

## 🆘 Support

If you encounter issues with tests:

1. Ensure all dependencies are installed (`npm install`)
2. Check that scripts have execute permissions (`chmod +x scripts/*.sh`)
3. Verify your Bash version (`bash --version`)
4. Review test output for specific error messages

---

Made with ❤️ by the Ministry of Justice UK
