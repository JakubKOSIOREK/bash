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
            ;;
        yum)
            status=$(yum repolist 2>&1)
            ;;
        dnf)
            status=$(dnf repolist 2>&1)
            ;;
        zypper)
            status=$(zypper repos 2>&1)
            ;;
        pacman)
            status=$(pacman -Sy 2>&1)
            ;;
        emerge)
            status=$(emerge --sync 2>&1)
            ;;
        xbps)
            status=$(xbps-query -L 2>&1)
            ;;
        apk)
            status=$(apk update 2>&1)
            ;;
        opkg)
            status=$(opkg update 2>&1)
            ;;
        *)
            echo "2"
            return
            ;;
    esac

    if [[ -z $status ]] || [[ $status == *"No package files"* ]] || [[ $status == "repolist: 0" ]]; then
        echo "1"
    else
        echo "0"
    fi
}

# Detect package manager and check repository status
if command -v apt >/dev/null 2>&1; then
    REPO_STATUS=$(check_repository_status apt)
elif command -v yum >/dev/null 2>&1; then
    REPO_STATUS=$(check_repository_status yum)
elif command -v dnf >/dev/null 2>&1; then
    REPO_STATUS=$(check_repository_status dnf)
elif command -v zypper >/dev/null 2>&1; then
    REPO_STATUS=$(check_repository_status zypper)
elif command -v pacman >/dev/null 2>&1; then
    REPO_STATUS=$(check_repository_status pacman)
elif command -v emerge >/dev/null 2>&1; then
    REPO_STATUS=$(check_repository_status emerge)
elif command -v xbps >/dev/null 2>&1; then
    REPO_STATUS=$(check_repository_status xbps)
elif command -v apk >/dev/null 2>&1; then
    REPO_STATUS=$(check_repository_status apk)
elif command -v opkg >/dev/null 2>&1; then
    REPO_STATUS=$(check_repository_status apk)
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
        echo "$TEST_ID:$TEST_TITLE:1:Repositories aree not correctly configured or not found."
        exit 1
        ;;
    2)
        echo "$TEST_ID:$TEST_TITLE:2:Package manager not supported or not found."
        exit 2
        ;;
esac
