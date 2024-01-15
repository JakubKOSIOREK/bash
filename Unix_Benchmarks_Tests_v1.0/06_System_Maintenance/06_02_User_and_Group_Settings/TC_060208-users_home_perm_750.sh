#!/bin/bash

PERMISSIONS=750
TEST_TITLE="Ensure users' home directories permissions are ${PERMISSIONS} or more restrictive"
TEST_ID=060208

# Function to convert permission to numeric format
convert_perm_to_numeric() {
    perm="$1"
    numeric_perm=0

    # Owner, Group, and Others permissions
    [[ ${perm:1:1} == "r" ]] && numeric_perm=$((numeric_perm + 400))
    [[ ${perm:2:1} == "w" ]] && numeric_perm=$((numeric_perm + 200))
    [[ ${perm:3:1} == "x" ]] && numeric_perm=$((numeric_perm + 100))
    [[ ${perm:4:1} == "r" ]] && numeric_perm=$((numeric_perm + 40))
    [[ ${perm:5:1} == "w" ]] && numeric_perm=$((numeric_perm + 20))
    [[ ${perm:6:1} == "x" ]] && numeric_perm=$((numeric_perm + 10))
    [[ ${perm:7:1} == "r" ]] && numeric_perm=$((numeric_perm + 4))
    [[ ${perm:8:1} == "w" ]] && numeric_perm=$((numeric_perm + 2))
    [[ ${perm:9:1} == "x" ]] && numeric_perm=$((numeric_perm + 1))

    echo "$numeric_perm"
}

# Arrays to store non-compliant home directories and checked directories
non_compliant_homes=()
checked_dirs=()

# Loop through each user in /etc/passwd and check their home directory permission
while IFS=: read -r user _ _ _ _ home_dir _; do
    if [[ -d "$home_dir" ]] && [[ ! " ${checked_dirs[*]} " =~ " ${home_dir} " ]]; then
        checked_dirs+=("$home_dir")  # Add to checked directories

        perm=$(ls -ld "$home_dir" | awk '{print $1}')
        numeric_perm=$(convert_perm_to_numeric "$perm")

        if [[ $numeric_perm -gt $PERMISSIONS ]]; then
            non_compliant_homes+=("$home_dir current permission $numeric_perm, expected less or equal to $PERMISSIONS")
        fi
    fi
done < /etc/passwd

# Check if any test failed
if [ ${#non_compliant_homes[@]} -eq 0 ]; then
    echo "$TEST_ID:$TEST_TITLE:0"
else
    echo "$TEST_ID:$TEST_TITLE:1:Non-compliant home directories found ${non_compliant_homes[*]}"
    exit 1
fi
