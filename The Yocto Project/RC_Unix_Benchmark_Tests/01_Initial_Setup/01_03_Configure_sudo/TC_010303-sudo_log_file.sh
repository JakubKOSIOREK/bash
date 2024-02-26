#!/bin/bash
TEST_TITLE="Ensure sudo log file exists"
TEST_ID=010303

SUDOERS_FILE="/etc/sudoers"
SUDOERS_DIR="/etc/sudoers.d"

# Check for existence of file and directory
if [ ! -f "$SUDOERS_FILE" ] && [ ! -d "$SUDOERS_DIR" ]; then
    echo "$TEST_ID:$TEST_TITLE:2:$SUDOERS_FILE and $SUDOERS_DIR >> No such file or directory."
    exit 2
fi

# Function to check sudo configuration
check_sudo_log_config() {
    local config_file=$1
    if [ ! -f "$config_file" ]; then
        return 1
    fi

    grep -Ei '^\s*Defaults\s+logfile=\S+' "$config_file"
}

# Check configuration in /etc/sudoers and /etc/sudoers.d/*
sudo_log_config_found=0
if check_sudo_log_config "$SUDOERS_FILE"; then
    sudo_log_config_found=1
fi
for config_file in $SUDOERS_DIR*; do
    if check_sudo_log_config "$config_file"; then
        sudo_log_config_found=1
    fi
done

# Output test result
if [[ $sudo_log_config_found -eq 1 ]]; then
    echo "$TEST_ID:$TEST_TITLE:0"
    exit 0
else
    echo "$TEST_ID:$TEST_TITLE:1:SUDO does not have a custom log file configured."
    exit 1
fi
