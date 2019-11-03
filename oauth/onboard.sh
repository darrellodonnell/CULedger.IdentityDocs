#!/bin/bash

source ./config.sh

while getopts :i:p:e: opt; do
  case "${opt}" in
    i) MEMBERID=${OPTARG}
    ;;
    p) PHONE=${OPTARG}
    ;;
    e) EMAIL=${OPTARG}
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

if [ -z $MEMBERID ] || [ -z $PHONE ]; then
  echo "===================================================================================="
  echo "USAGE:"
  echo "       -i: Member Identifier"
  echo "       -p: Phone Number that will receive the txt message for ConnectMe introduction"
  echo "       -e: email address"
  echo ""
  echo "  Please provide both memberId and phoneNumber as they are required for this procedure"
  echo "===================================================================================="
  exit
fi


if [ -z $EMAIL ]; then
  $EMAIL = "test@culedger.com"
fi
INPUT_JSON=$(cat <<EOF
{
    "memberId": "$MEMBERID",
    "phoneNumber": "$PHONE",
    "emailAddress": "$EMAIL",
    "displayTextFromFI": "Let's get connected via MyCUID!",
    "credentialData": {
        "CredentialId": "UUID-GOES-HERE",
        "CredentialDescription": "TESTING",
        "Institution": "CULedger Credit Union",
        "CredentialName": "TEST CRED",
        "MemberNumber": "$MEMBERID",
        "MemberSince": "NOV2016"
    }
}
EOF
)

echo "$INPUT_JSON"

TOKEN=$(curl -s -v \
        -H "Content-Type: application/x-www-form-urlencoded" \
        -d "client_id=$CLIENTID" \
        -d "grant_type=client_credentials" \
        -d "client_secret=$SECRET" \
        "https://login.microsoftonline.com/$TENANTID/oauth2/token" | jq -r .access_token)

curl -k \
  -H "Prefer: respond-async" \
  -H "Content-Type: application/json" \
  -H "Ocp-Apim-Subscription-Key: $SUBSCRIPTIONKEY" \
  -H "Authorization: Bearer $TOKEN" \
  -X POST \
  -d "$INPUT_JSON" \
  "$ENDPOINT/member/$MEMBERID/onboard"
