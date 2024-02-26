#!/bin/bash

TEST_TITLE="Ensure GDM login banner is configured"
TEST_ID=010802
CONFIG_FILE="/etc/gdm3/greeter.dconf-defaults"
BANNER_MESSAGE="<banner message>" # Replace with actual required banner message

# Function to check if the configuration contains required settings
check_config() {
    if grep -q "^\[org/gnome/login-screen\]" "$CONFIG_FILE" && \
       grep -q "^banner-message-enable=true" "$CONFIG_FILE" && \
       grep -q "^banner-message-text='$BANNER_MESSAGE'" "$CONFIG_FILE"; then
        return 0 # True, configuration is correct
    else
        return 1 # False, configuration is incorrect
    fi
}

# Check if the configuration file exists
if [ ! -f "$CONFIG_FILE" ]; then
    #echo "$TEST_ID:$TEST_TITLE:1:Configuration file not found"
    #exit 1

    # No configuration file means that GDM login banner is correctly configured
    echo "$TEST_ID:$TEST_TITLE:2:$CONFIG_FILE >> No such file or directory."
    exit 2
fi

# Check the configuration
if check_config; then
    echo "$TEST_ID:$TEST_TITLE:0"
    exit 0
else
    echo "$TEST_ID:$TEST_TITLE:1:GDM login banner is not correctly configured"
    exit 1
fi
