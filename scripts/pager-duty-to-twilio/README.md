Pagerduty to twilio call forwarding
================================

Usage
================================

```
Create a config for the pager duty and twilio keys.

mkdir -p /etc/pagerduty/ && cat > /etc/pagerduty/config.sh <<EOF
PD_TOKEN="XXX"           # Pager duty authentication token
PD_SCHEDULE_ID="XXX"     # Pager duty schedule id 
T_ACCOUNT_SID="XXX"      # Twilio account id
T_AUTH_TOKEN="XXX"       # Twilio auth token 
T_PHONE_NUMBER_SID="XXX" # Twilio phone number sid
EOF

./pagerduty-twilio-on-call.sh
```

Setup pager duty
================================
1. Signup/Login
2. Configure on call schedule
3. Create an API key or use an existing one.
![alt text](https://raw.github.com/ajohnstone/autoscale/master/scripts/pager-duty-to-twilio/docs/images/pd.api.access.keys.png "Pager duty - API access keys")
4. Extract schedule id from on call schedules page by the URL and place in config above.
![alt text](https://raw.github.com/ajohnstone/autoscale/master/scripts/pager-duty-to-twilio/docs/images/pd.schedule.png "Pager duty - schedule")
5. Ensure you have a contact method via a phone/mobile

Setup twilio
================================

1. Signup/Login
2. Add a number to Twilio
3. Click the phone number and extract the phone number sid from the URL and place in config above.
![alt text](https://raw.github.com/ajohnstone/autoscale/master/scripts/pager-duty-to-twilio/docs/images/tw.phone_number.png "Twilio - phone number sid")
3. Update the T_ACCOUNT_SID with the account sid on the frontpage of twilio as well as the auth token
![alt text](https://raw.github.com/ajohnstone/autoscale/master/scripts/pager-duty-to-twilio/docs/images/tw.dashboard.png "Twilio - dashboard for account sid and auth token")


