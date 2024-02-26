#!/bin/bash
TEST_TITLE="Ensure sudo commands use pty"
TEST_ID=010302

# Function to check sudo configuration
check_sudo_config() {
    local config_file=$1
    if [ ! -f "$config_file" ]; then
        return 1
    fi

    grep -Ei '^\s*Defaults\s+([^#]+,\s*)?use_pty(,\s+\S+\s*)*(\s+#.*)?$' "$config_file"
}

# Check configuration in /etc/sudoers and /etc/sudoers.d/*
sudo_config_found=0
if check_sudo_config "/etc/sudoers"; then
    sudo_config_found=1
fi
for config_file in /etc/sudoers.d/*; do
    if check_sudo_config "$config_file"; then
        sudo_config_found=1
    fi
done

# Output test result
if [[ $sudo_config_found -eq 1 ]]; then
    echo "$TEST_ID:$TEST_TITLE:0"
    exit 0
else
    echo "$TEST_ID:$TEST_TITLE:1:SUDO is not configured to use pty or config files are missing."
    exit 1
fi
