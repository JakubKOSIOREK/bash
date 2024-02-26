#!/bin/bash

TEST_TITLE="Audit SGID executables"
TEST_ID=060114

# Expected list of SGID executables
EXPECTED_LIST=(
    "/run/log/journal"
    "/run/log/journal/0e19af699ad445649221733a3454b757"
    "/sys/kernel/debug/audio_pll_monitor/audio_pll2/pll_parameter"
    "/sys/kernel/debug/audio_pll_monitor/audio_pll1/pll_parameter"
)

# Getting actual output from the find command
actual_list=$(find / -perm /2000 2>/dev/null)

# Check for discrepancies
extra_files=()
while IFS= read -r file; do
    if [[ ! " ${EXPECTED_LIST[*]} " =~ " ${file} " ]]; then
        extra_files+=("$file")
    fi
done <<< "$actual_list"

# Output the result
if [ ${#extra_files[@]} -eq 0 ]; then
    echo "$TEST_ID:$TEST_TITLE:0"
    exit 0
else
    echo "$TEST_ID:$TEST_TITLE:1:Unexpected SGID files found -> ${extra_files[@]}"
    exit 1
fi
