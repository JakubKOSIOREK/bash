#!/bin/bash
TEST_TITLE="Ensure password creation requirements are configured"
TEST_ID=050301

# Check for pam_pwquality module installation
if ! dpkg -s libpam-pwquality &> /dev/null; then
    echo "$TEST_ID:$TEST_TITLE:1:libpam-pwquality module is not installed"
    exit 1
fi

# Check for minimum password length
minlen=$(grep '^\s*minlen\s*=' /etc/security/pwquality.conf | awk '{print $3}')
if [[ "$minlen" -lt 14 ]]; then
    echo "$TEST_ID:$TEST_TITLE:1:Password minlen is less than 14"
    exit 1
fi

# Check for password complexity
minclass=$(grep '^\s*minclass\s*=' /etc/security/pwquality.conf | awk '{print $3}')
dcredit=$(grep '^\s*dcredit\s*=' /etc/security/pwquality.conf | awk '{print $3}')
ucredit=$(grep '^\s*ucredit\s*=' /etc/security/pwquality.conf | awk '{print $3}')
ocredit=$(grep '^\s*ocredit\s*=' /etc/security/pwquality.conf | awk '{print $3}')
lcredit=$(grep '^\s*lcredit\s*=' /etc/security/pwquality.conf | awk '{print $3}')

if [[ "$minclass" != "4" ]] && { [[ "$dcredit" != "-1" ]] || [[ "$ucredit" != "-1" ]] || [[ "$ocredit" != "-1" ]] || [[ "$lcredit" != "-1" ]]; }; then
    echo "$TEST_ID:$TEST_TITLE:1:Password complexity not correctly configured"
    exit 1
fi

# Check for retry attempts setting
retry=$(grep -E '^\s*password\s+(requisite|required)\s+pam_pwquality\.so\s+' /etc/pam.d/common-password | grep -o 'retry=[0-9]*' | cut -d= -f2)
if [[ -z "$retry" ]] || [[ "$retry" -gt 3 ]]; then
    echo "$TEST_ID:$TEST_TITLE:1:Retry attempts for password is more than 3"
    exit 1
fi

# If all checks pass
echo "$TEST_ID:$TEST_TITLE:0"
exit 0
