#!/bin/bash
TEST_TITLE="Ensure package manager repositories are configured"
TEST_ID=010201

# Function to check repository status for different package managers
check_repository_status() {
    local package_manager=$1
    local status
    case $package_manager in
        apt)
            status=$(apt-cache policy 2>&1)
            if [[ $status == *"No package files"* ]]; then
                echo "1"
            else
                echo "0"
            fi
            ;;
        yum)
            status=$(yum repolist 2>&1)
            if [[ $status == "repolist: 0" ]]; then
                echo "1"
            else
                echo "0"
            fi
            ;;
        *)
            echo "2"
            ;;
    esac
}

# Detect package manager and check repository status
if command -v apt >/dev/null 2>&1; then
    REPO_STATUS=$(check_repository_status apt)
elif command -v yum >/dev/null 2>&1; then
    REPO_STATUS=$(check_repository_status yum)
else
    REPO_STATUS="2"
fi

# Output test result in the specified format
case $REPO_STATUS in
    0)
        echo "$TEST_ID:$TEST_TITLE:0"
        exit 0
        ;;
    1)
        echo "$TEST_ID:$TEST_TITLE:1"
        exit 1
        ;;
    2)
        echo "$TEST_ID:$TEST_TITLE:2:Package manager not supported or not found"
        exit 2
        ;;
esac
