#!/bin/bash
TEST_TITLE="Ensure filesystem integrity is regularly checked"
TEST_ID=010402

# Check if there is a cron job scheduled to run the aide check
cron_job_output=$(crontab -u root -l 2>&1)
cron_job=$(echo $cron_job_output| grep aide)

# If crontab command fails due to directory issues, handle the error
if [[ $cron_job_output == *"No such file or directory"* ]]; then
    message=$(echo $cron_job_output | awk -F "'" '{print $3}')
    echo "$TEST_ID:$TEST_TITLE:2:$message >> No such file or directory"
    exit 2
fi

# If no cron job is found, then check if aidcheck.service and aidcheck.timer are enabled and running
if [[ -z $cron_job ]]; then
    service_status=$(systemctl is-enabled aidecheck.service 2>&1)
    timer_status=$(systemctl is-enabled aidecheck.timer 2>&1)
    timer_running=$(systemctl status aidecheck.timer 2>&1)

    # If aidcheck.service and aidcheck.timer are not enabled or not running, then test fails
    if [[ $service_status != "enabled" || $timer_status != "enabled" || $timer_running != *"running"* ]]; then
        echo "$TEST_ID:$TEST_TITLE:1:No cron job or systemd timer is scheduled to run the aide check"
        exit 1
    fi
fi

# If no failures, then test passes
echo "$TEST_ID:$TEST_TITLE:0"
exit 0
