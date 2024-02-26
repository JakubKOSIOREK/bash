#!/bin/bash

TEST_TITLE="Ensure logging is configured"
TEST_ID=04020103
RSYSLOG_CONF="/etc/syslog.conf"
RSYSLOG_DIR="/etc/syslog.d"

# Define expected logging rules
expected_rules=(
    "*.emerg :omusrmsg:*"
    "auth,authpriv.* /var/log/auth.log"
    "mail.* -/var/log/mail"
    "mail.info -/var/log/mail.info"
    "mail.warning -/var/log/mail.warn"
    "mail.err /var/log/mail.err"
    "news.crit -/var/log/news/news.crit"
    "news.err -/var/log/news/news.err"
    "news.notice -/var/log/news/news.notice"
    "*.=warning;*.=err -/var/log/warn"
    "*.crit /var/log/warn"
    "*.*;mail.none;news.none -/var/log/messages"
    "local0,local1.* -/var/log/localmessages"
    "local2,local3.* -/var/log/localmessages"
    "local4,local5.* -/var/log/localmessages"
    "local6,local7.* -/var/log/localmessages"
)

# Function to check if a specific logging rule is in the rsyslog configuration
check_logging_rule() {
    local rule=$1
    if [ -f "$RSYSLOG_CONF" ]; then
        fgrep -q -- "$rule" "$RSYSLOG_CONF" && found=1
    fi
    if [ -d "$RSYSLOG_DIR" ]; then
        fgrep -q -- "$rule" "$RSYSLOG_DIR"/*.conf && found=1
    fi
    return $found
}

# Check if the rsyslog configuration file exists
if [ ! -f "$RSYSLOG_CONF" ] && [ ! -d "$RSYSLOG_DIR" ]; then
    echo "$TEST_ID:$TEST_TITLE:2: Rsyslog configuration files not found"
    exit 2
fi

# Check for the existence of rsyslog configuration files and standard rules
missing_rules=0
for rule in "${expected_rules[@]}"; do
    if ! check_logging_rule "$rule"; then
        echo "$TEST_ID:$TEST_TITLE:1:Missing logging rule $rule"
        missing_rules=$((missing_rules + 1))
    fi
done

# Final result
if [ $missing_rules -eq 0 ]; then
    echo "$TEST_ID:$TEST_TITLE:0"
else
    echo "$TEST_ID:$TEST_TITLE:1:One or more required logging rules are missing"
    exit 1
fi
