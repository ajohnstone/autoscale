#!/usr/bin/env bash

#set -ue # bail out on errors, be strict

CONFIG=${CONFIG:-'/etc/pagerduty/config.sh'}

if [ -e "$CONFIG" ]; then
    . "$CONFIG"
fi

DEBUG=${DEBUG:-0}
PD_TOKEN=${PD_TOKEN:-}
PD_SCHEDULE_ID=${PD_SCHEDULE_ID:-}

T_AUTH_TOKEN=${T_AUTH_TOKEN:-}
T_ACCOUNT_SID=${T_ACCOUNT_SID:-}
T_PHONE_NUMBER_SID=${T_PHONE_NUMBER_SID:-}

user_on_call_id=$(curl -s -H "Content-type: application/json" -H "Authorization: Token token=${PD_TOKEN}" -X GET \
  "https://photobox.pagerduty.com/api/beta/schedules/$PD_SCHEDULE_ID?since=`date +'%Y-%m-%dT%H:%M'`&until=`date +'%Y-%m-%dT%H:%M'`&overflow=1&include_oncall=1" | json_xs |
  grep -A6 oncall | grep id | awk -F':' '{print $2}' | sed 's/[", ]//g;');

phone_number=$(curl -s -H "Content-type: application/json" -H "Authorization: Token token=${PD_TOKEN}" -X GET \
  -G "https://photobox.pagerduty.com/api/v1/users/${user_on_call_id}/contact_methods" \
  | json_xs | grep "phone_number" | head -n1 | awk -F':' '{print $2}' | sed 's/[", ]//g;');

curl -s -X POST "https://api.twilio.com/2010-04-01/Accounts/${T_ACCOUNT_SID}/IncomingPhoneNumbers/${T_PHONE_NUMBER_SID}.json" \
  --data-urlencode "VoiceUrl=http://twimlets.com/forward?PhoneNumber=+44${phone_number}" \
  -u "${T_ACCOUNT_SID}:${T_AUTH_TOKEN}" | json_xs > /dev/null

if [ "$DEBUG" = "1" ]; then
    env | egrep "^PD_|^T_";
    echo "phone_number: $phone_number | user_on_call_id: $user_on_call_id";
fi
