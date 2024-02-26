#!/bin/bash

TEST_TITLE="Ensure all groups in /etc/passwd exist in /etc/group"
TEST_ID=060215
GROUP_FILE="/etc/group"

# Check if file exists
if [[ ! -f "$GROUP_FILE" ]]; then
    echo "$TEST_ID:$TEST_TITLE:2:$GROUP_FILE >> No such file or directory."
    exit 2
fi


# Associative array for GIDs
declare -A passwd_gids=()   # from /etc/passwd
declare -A group_gids=()    # from /etc/group
declare -a missing_gids=()  # for missing GIDs

# Read GIDs and group names from /etc/group and store them in group_gids
while IFS=: read -r name _ gid; do
    group_gids["$gid"]+="$name"
done < "$GROUP_FILE"

# Read GIDs from /etc/passwd and mark them in passwd_gids
while IFS=: read -r _ _ _ gid _; do
    passwd_gids["$gid"]+=1
done < /etc/passwd

# Check if each GID from /etc/passwd exists in /etc/group
for gid in "${!passwd_gids[@]}"; do
    if [[ ! "${group_gids[$gid]}" ]]; then
        missing_gids+=("${gid}")
    fi
done

# Report the result
if [ ${#missing_gids[@]} -gt 0 ];then
    echo "$TEST_ID:$TEST_TITLE:1:Missing groups -> ${missing_gids[@]}"
    exit 1
else
    echo "$TEST_ID:$TEST_TITLE:0"
    exit 0
fi