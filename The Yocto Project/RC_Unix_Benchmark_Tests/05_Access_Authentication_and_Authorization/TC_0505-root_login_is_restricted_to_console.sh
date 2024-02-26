#!/bin/bash
TEST_TITLE="Ensure root login is restricted to system console"
TEST_ID=0505

# File containing the list of secure terminals
SECURE_TTY_FILE="/etc/securetty"

# List of defined consoles considered to be secure
# Add or remove the console according to your security requirements
# example: DEFINED_CONSOLES=("console" "ttyS0" "ttyS1" "ttyS2" "vc/63" "vc/62")
DEFINED_CONSOLES=()

# Check if the securetty file exists
if [[ ! -f "$SECURE_TTY_FILE" ]]; then
    echo "$TEST_ID:$TEST_TITLE:2:$SECURE_TTY_FILE file not found"
    exit 2
fi

# Function to check if a console is in the defined list
is_console_secure() {
    local console=$1
    for secure_console in "${DEFINED_CONSOLES[@]}"; do
        if [[ $console == $secure_console ]]; then
            return 0 # Console is secure
        fi
    done
    return 1 # Console is not secure
}

# Array to store insecure consoles
INSECURE_CONSOLES=()

# Read and check each line in securetty, ignoring commented lines
while IFS= read -r console; do
    # Skip if the line is commented
    if [[ $console == \#* || -z "$console" ]]; then
        continue
    fi

    if ! is_console_secure "$console"; then
        INSECURE_CONSOLES+=("$console")
    fi
done < "$SECURE_TTY_FILE"

# Check if any insecure consoles were found
if [[ ${#INSECURE_CONSOLES[@]} -ne 0 ]]; then
    echo "$TEST_ID:$TEST_TITLE:1:Insecure consoles found '${INSECURE_CONSOLES[*]}'"
    exit 1
else
    echo "$TEST_ID:$TEST_TITLE:0:All consoles in $SECURE_TTY_FILE are secure"
    exit 0
fi
