#!/bin/bash

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
  echo "  -i: Member Identifier"
  echo "  -p: Phone Number that will receive the txt message for ConnectMe introduction"
  echo ""
  echo "  Please provide both memberId and phoneNumber as they are required for this procedure"
  echo "===================================================================================="
  exit
fi

endpoint="https://olenickculidentity.culedgerapi.com"

input_json=$(cat <<EOF
{
    "memberId": "$MEMBERID",
    "phoneNumber": "$PHONE",
    "emailAddress": "someone@culedger.com",
    "displayTextFromFI": "Let's get connected via MyCUID!",
    "credentialData": {
        "CredentialId": "UUID-GOES-HERE",
        "Institution": "CULedger Credit Union",
        "credential": null,
        "memberNumber": "$MEMBERID",
        "memberSince": null
    }
}
EOF
)

curl -H "Content-Type: application/json" -X POST -d "$input_json" "$endpoint/CULedger/CULedger.Identity/0.2.0/member/$MEMBERID/onboard"

