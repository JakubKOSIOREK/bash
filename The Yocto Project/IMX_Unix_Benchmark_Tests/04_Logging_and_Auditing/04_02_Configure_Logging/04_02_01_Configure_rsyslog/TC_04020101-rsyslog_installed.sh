#!/bin/bash

TEST_TITLE="Ensure rsyslog is installed"
TEST_ID=04020101

# initialize a flag variable
is_installed=false

# Check for rsyslog
if command -v rsyslogd >/dev/null; then
    echo "$TEST_ID:$TEST_TITLE:0:rsyslogd"
    is_installed=true
fi

# Check for syslog-ng
if command -v syslog-ng >/dev/null; then
    echo "$TEST_ID:$TEST_TITLE:0:syslog-ng"
    is_installed=true
fi

# Check for syslogd
if command -v syslogd >/dev/null; then
    echo "$TEST_ID:$TEST_TITLE:0:syslogd"
    is_installed=true
fi

# Check for traditional syslog
if [ -f /etc/syslog.conf ] || [ -d /etc/syslog.d ]; then
    echo "$TEST_ID:$TEST_TITLE:0:More information in /etc/syslog.conf or /etc/syslog.d"
    is_installed=true
fi

# Summarize the result
if $is_installed; then
exit 0
else
    echo "$TEST_ID:$TEST_TITLE:1:No rsyslog or syslog packages installed."
    exit 1
fi
