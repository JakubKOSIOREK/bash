#!/bin/bash

TEST_TITLE="Ensure loopback traffic is configured"
TEST_ID=0305040102

# loopback network
LOOPBACK_NETWORK_IP="127.0.0.0/8"

# Check if iptables is available on the system
if ! command -v iptables >/dev/null; then
    echo "$TEST_ID:$TEST_TITLE:2:iptables is not installed" # NOT IMPLEMENTED
    exit 2
fi

# Check if ip_table module is loaded
if ! modprobe ip_tables 2>/dev/null; then
    echo "$TEST_ID:$TEST_TITLE:1:ERROR - could not insert 'ip_tables', Invalid argument" # FAIL
    exit 1
fi

# Initialize the status variable
status_passed=true

# Check if the rule for accepting incoming loopback interface traffic is set
if ! iptables -L INPUT -v -n | grep -q "lo" | grep -q "ACCEPT"; then
    echo "$TEST_ID:$TEST_TITLE:1:Incoming loopback interface traffic ACCEPT rule is missing." # FAIL
    status_passed=false
fi

# Check if the rule for accepting outgoing loopback interface traffic is set
if ! iptables -L OUTPUT -v -n | grep -q "lo" | grep -q "ACCEPT"; then
    echo "$TEST_ID:$TEST_TITLE:1:Outgoing loopback interface traffic ACCEPT rule is missing." # FAIL
    status_passed=false
fi

# Check if the rule for dropping all traffic to the loopback network from other interfaces is set
if ! iptables -L INPUT -v -n | grep -q "${LOOPBACK_NETWORK_IP}" | grep -q "DROP"; then
    echo "$TEST_ID:$TEST_TITLE:1:Rule to DROP all traffic to the loop network ${LOOPBACK_NETWORK_IP} from other interfaces is missing." # FAIL
    status_passed=false
fi

# Determine the overall result based on the status_passed variable
if $status_passed; then
    echo "$TEST_ID:$TEST_TITLE:0" # PASS
    exit 0
else
    exit 1
fi
