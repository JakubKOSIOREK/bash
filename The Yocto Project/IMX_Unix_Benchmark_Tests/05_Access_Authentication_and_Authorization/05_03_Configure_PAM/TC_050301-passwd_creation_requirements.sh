#!/bin/bash
TEST_TITLE="Ensure password creation requirements are configured"
TEST_ID=050301

# Define directories to search for the pam_pwquality.so module
PAM_MODULES_DIRECTORIES=("/")

# Password settings
MINLEN=14
MINCLASS=4
DCREDIT=-1
UCREDIT=-1
OCREDIT=-1
lCREDIT=-1
RETRY=3

# Check for presence of pam_pwquality related tools and the pam_pwquality module file
module_found=false
for dir in "${PAM_MODULES_DIRECTORIES[@]}"; do
    if find "$dir" -name pam_pwquality.so &>/dev/null; then
        module_found=true
        break
    fi
done

if ! $module_found; then
    echo "$TEST_ID:$TEST_TITLE:2:pam_pwqality module is not installed or not found"
    exit 2
fi

# Check if pam_pwqality module is activated in PAM configuration
if ! grep -qr pam_pwquality.so /etc/pam.d/; then
    echo "$TEST_ID:$TEST_TITLE:1:pam_pwqality module is not activated in PAM configuration"
    exit 1
fi

# Check for minimum password length
minlen=$(grep '^\s*minlen\s*=' /etc/security/pwquality.conf | awk '{print $3}')
if [[ "$minlen" -lt "$MINLEN" ]]; then
    echo "$TEST_ID:$TEST_TITLE:1:Password minlen is less than $MINLEN"
    exit 1
fi

# Check for password complexity
minclass=$(grep '^\s*minclass\s*=' /etc/security/pwquality.conf | awk '{print $3}')
dcredit=$(grep '^\s*dcredit\s*=' /etc/security/pwquality.conf | awk '{print $3}')
ucredit=$(grep '^\s*ucredit\s*=' /etc/security/pwquality.conf | awk '{print $3}')
ocredit=$(grep '^\s*ocredit\s*=' /etc/security/pwquality.conf | awk '{print $3}')
lcredit=$(grep '^\s*lcredit\s*=' /etc/security/pwquality.conf | awk '{print $3}')

if [[ "$minclass" != "$MINCLASS" ]] && { [[ "$dcredit" != "$DCREDIT" ]] || [[ "$ucredit" != "$UCREDIT" ]] || [[ "$ocredit" != "$OCREDIT" ]] || [[ "$lcredit" != "$lCREDIT" ]]; }; then
    echo "$TEST_ID:$TEST_TITLE:1:Password complexity not correctly configured"
    exit 1
fi

# Check for retry attempts setting
retry=$(grep -E '^\s*password\s+(requisite|required)\s+pam_pwquality\.so\s+' /etc/pam.d/common-password | grep -o 'retry=[0-9]*' | cut -d= -f2)
if [[ -z "$retry" ]] || [[ "$retry" -gt "$RETRY" ]]; then
    echo "$TEST_ID:$TEST_TITLE:1:Retry attempts for password is more than $RETRY"
    exit 1
fi

# If all checks pass
echo "$TEST_ID:$TEST_TITLE:0"
exit 0
