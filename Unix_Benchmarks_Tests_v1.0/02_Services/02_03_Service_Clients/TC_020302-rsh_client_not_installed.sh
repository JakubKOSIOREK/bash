#!/bin/bash

TEST_TITLE="Ensure RSH Client is not installed"
TEST_ID=020302
PACKAGES=("rsh-client")

# Function to check if a package is installed
check_package() {
    local package=$1
    dpkg -s $package &> /dev/null
}

# Check for installed packages
installed_packages=()
for package in "${PACKAGES[@]}"; do
    if check_package $package; then
        installed_packages+=("$package")
    fi
done

# Check if any packages are installed
if [ ${#installed_packages[@]} -eq 0 ]; then
    echo "$TEST_ID:$TEST_TITLE:0"
    exit 0
fi

# If package is installed
for package in "${installed_packages[@]}"; do
    echo "$TEST_ID:$TEST_TITLE:1:$package is installed"
    exit 1
done
