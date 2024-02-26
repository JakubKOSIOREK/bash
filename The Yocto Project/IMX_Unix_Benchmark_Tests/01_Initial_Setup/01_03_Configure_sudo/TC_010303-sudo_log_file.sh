#!/bin/bash
TEST_TITLE="Ensure sudo log file exists"
TEST_ID=010303

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
if check_sudo_log_config "/etc/sudoers"; then
    sudo_log_config_found=1
fi
for config_file in /etc/sudoers.d/*; do
    if check_sudo_log_config "$config_file"; then
        sudo_log_config_found=1
    fi
done

# Output test result
if [[ $sudo_log_config_found -eq 1 ]]; then
    echo "$TEST_ID:$TEST_TITLE:0"
    exit 0
else
    echo "$TEST_ID:$TEST_TITLE:1:SUDO does not have a custom log file configured or config files are missing."
    exit 1
fi
