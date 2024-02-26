#!/bin/bash

TEST_TITLE="Ensure firewall rules exist for all open ports"
TEST_ID=0305040104

# Initialize the status variable
test_failed=false

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

# Extract listening port number on all interfaces, excluding loopback addresses
open_ports=$(netstat -tuln | awk '$4 ~ /0.0.0.0:/ {sub(/.*:/, "", $4); print $4}' | sort -u)

if [ -z "$open_ports"]; then
    echo "$TEST_ID:$TEST_TITLE:0" # PASS
    exit 0
else
    # Check iptables rules for each open port in the INPUT, OUTPUT and FORWARD chains
    for port in $open_ports; do
        # Initialize a variable to track if a rule is found for the port
        rule_found=false

        for chain in  INPUT OUTPUT FORWARD; do
            # If an iptables rule is found for the port in the current chain, mark as pass and break the loop
            if iptables -L $chain -v -n | grep -qe "dpt:$port " -e "spt:$port "; then
                rule_found=true
                break
            fi
        done

        # If no rule is found after checking all chains, log a fail
        if [ "$rule_found" = false ]; then
            echo "$TEST_ID:$TEST_TITLE:1:No firewall rule found for port $port in any chain." # FAIL
            test_failed=true
        fi
    done
fi


# Summarize the test result
if [ "$test_failed" = false ]; then
    echo "$TEST_ID:$TEST_TITLE:0" # PASS
    exit 0
else
    exit 1
fi
