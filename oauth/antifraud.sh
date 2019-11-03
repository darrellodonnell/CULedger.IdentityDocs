#!/bin/bash

source ./config.sh

# getopts :i:p: opt; do
while getopts :i:m:question:yes:no:notification:greeting: opt; do
  case "${opt}" in
    i) MEMBERID=${OPTARG}
    ;;
    m) MESSAGE=${OPTARG}
    ;;
    greeting) GREETING=${OPTARG}
    ;;
    no) NOQUESTION=${OPTARG}
    ;;
    yes) YESQUESTION=${OPTARG}
    ;;
    notification) NOTIFICATION=${OPTARG}
    ;;

    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done


# -i MemberID
if [ -z $MEMBERID ]; then
  echo "===================================================================================="
  echo "USAGE:"
  echo "  -i: Member Identifier"
  echo ""
  echo "  Please provide memberId as it is required for this procedure"
  echo "===================================================================================="
  exit
fi

# set defaults
if [ -z $NOTIFICATION ]; then
  NOTIFICATION="The credit union has a secure question for you."
fi
if [ -z $MESSAGE ]; then
  MESSAGE="Please confirm that you are speaking with the credit union."
fi
if [ -z $NOQUESTION ]; then
  NOQUESTION="No, I am not."
fi
if [ -z $YESQUESTION ]; then
  YESQUESTION="No, I am not."
fi
if [ -z $GREETING ]; then
  GREETING="Security check."
fi



echo "MemberID: $MEMBERID"
echo "NOTIFICATION: $NOTIFICATION"
echo "GREETING: $GREETING"
echo "MESSAGE: $MESSAGE"
echo "YESQUESTION: $YESQUESTION"
echo "NOQUESTION: $NOQUESTION"

input_json=$(cat <<EOF
{
    "messageId": "42",
    "messageTitle": "$NOTIFICATION",
    "messageQuestion": "$GREETING",
    "messageText": "$MESSAGE",
    "positiveOptionText": "$YESQUESTION",
    "negativeOptionText": "$NOQUESTION"
}
EOF
)

TOKEN=$(curl -s -X POST \
        -H "Content-Type: application/x-www-form-urlencoded" \
        -d "client_id=$CLIENTID" \
        -d "grant_type=client_credentials" \
        -d "client_secret=$SECRET" \
        "https://login.microsoftonline.com/$TENANTID/oauth2/token" | jq -r .access_token)

curl -v \
  -H "Content-Type: application/json" \
  -d "$input_json" \
  -H "Ocp-Apim-Subscription-Key: $SUBSCRIPTIONKEY" \
  -H "Authorization: Bearer $TOKEN" \
  "$ENDPOINT/member/$MEMBERID/SendAntiFraudPrompt"
