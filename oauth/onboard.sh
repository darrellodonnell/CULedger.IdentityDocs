#!/bin/bash

source ./config.sh

while getopts :i:p: opt; do
  case "${opt}" in
    i) MEMBERID=${OPTARG}
    ;;
    p) PHONE=${OPTARG}
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
  echo ""
  echo "  Please provide both memberId and phoneNumber as they are required for this procedure"
  echo "===================================================================================="
  exit
fi

INPUT_JSON=$(cat <<EOF
{
    "memberId": "$MEMBERID",
    "phoneNumber": "$PHONE",
    "emailAddress": "someone@culedger.com",
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

TOKEN=$(curl -s -X POST \
        -H "Content-Type: application/x-www-form-urlencoded" \
        -d "client_id=$CLIENTID" \
        -d "grant_type=client_credentials" \
        -d "client_secret=$SECRET" \
        "https://login.microsoftonline.com/$TENANTID/oauth2/token" | jq -r .access_token)

curl \
  -H "Content-Type: application/json" \
  -H "Ocp-Apim-Subscription-Key: $SUBSCRIPTIONKEY" \
  -H "Authorization: Bearer $TOKEN" \
  -X POST \
  -d "$INPUT_JSON" \
  "$ENDPOINT/CULedger/CULedger.Identity/0.2.0/member/$MEMBERID/onboard"
