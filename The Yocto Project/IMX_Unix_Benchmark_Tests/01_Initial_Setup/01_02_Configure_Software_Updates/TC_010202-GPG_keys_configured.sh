#!/bin/bash
TEST_TITLE="Ensure package manager repositories are configured"
TEST_ID=010201

# Function to check GPG keys for different package managers
check_gpg_keys() {
    local package_manager=$1
    local status
    case $package_manager in
        apt)
            status=$(apt-key list 2>&1)
            ;;
        yum)
            status=$(rpm -qa gpg-pubkey --qf '%{NAME}-%{VERSION}-%{RELEASE}\t%{SUMMARY}\n' 2>&1)
            ;;
        dnf)
            status=$(rpm -qa gpg-pubkey --qf '%{NAME}-%{VERSION}-%{RELEASE}\t%{SUMMARY}\n' 2>&1)
            ;;
        *)
            echo "2"
            return
            ;;
    esac

    if [[ -z $status ]]; then
        echo "1"
    else
        echo "0"
    fi
}

# Detect package manager and check GPG keys
if command -v apt >/dev/null 2>&1; then
    GPG_STATUS=$(check_gpg_keys apt)
elif command -v yum >/dev/null 2>&1; then
    GPG_STATUS=$(check_gpg_keys yum)
elif command -v dnf >/dev/null 2>&1; then
    GPG_STATUS=$(check_gpg_keys dnf)
else
    GPG_STATUS="2"
fi

# Output test result in the specified format
case $GPG_STATUS in
    0)
        echo "$TEST_ID:$TEST_TITLE:0"
        exit 0
        ;;
    1)
        echo "$TEST_ID:$TEST_TITLE:1:GPG keys are not configured or not found."
        exit 1
        ;;
    2)
        echo "$TEST_ID:$TEST_TITLE:2:Package manager not supported or not found."
        exit 2
        ;;
esac