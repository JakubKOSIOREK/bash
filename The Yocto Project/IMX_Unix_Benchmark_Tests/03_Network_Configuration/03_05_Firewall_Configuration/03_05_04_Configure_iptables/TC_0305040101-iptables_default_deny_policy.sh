#!/bin/bash

TEST_TITLE="Ensure default deny firewall policy"
TEST_ID=0305040101

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

# Array holding the names of chains to check
firewalls_list=("INPUT" "OUTPUT" "FORWARD")

# Variable to track the policy status, initially set to false indicating nao issues found
policy_status=false

# Function to check the policy of a given firewall chain
check_firewall_policy() {
    local chain=$1

    # Retrive the policy for the given chain
    policy=$(iptables -L "$chain" --line-numbers -n | grep "Chain $chain" | awk '{print $4}')

    # Check if the policy is set to DROP or REJECT
    if [[ $policy != "DROP" && $policy != "REJECT" ]]; then
        # Mark that an issue was found by setting policy_status to true
        policy_status=true
    fi
}

# Ceck each chain's policy
for chain in "${firewalls_list[@]}"; do
    check_firewall_policy "$chain"
done

# Determine the overall result based on the policy_status variable
if $policy_status; then
    echo "$TEST_ID:$TEST_TITLE:1:One or more chains do not have the correct default policy" # FAIL
    exit 1
else
    echo "$TEST_ID:$TEST_TITLE:0" # PASS
    exit 0
fi
