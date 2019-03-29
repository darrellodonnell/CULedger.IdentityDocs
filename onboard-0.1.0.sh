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

endpoint="http://culidentityapi.westus.cloudapp.azure.com:8080"

input_json=$(cat <<EOF
{
    "memberId": "$MEMBERID",
    "memberPhoneNumber": "$PHONE",
    "memberEmail": "someone@culedger.com",
    "displayTextFromFI": "Let's get connected via MyCUID!",
    "credentialData": {
        "id": "UUID-GOES-HERE",
        "Institution": "CULedger Credit Union",
        "memberId": "$MEMBERID",
        "status": "active",
        "memberSince": null,
        "credDataPayload": ""
    }
}
EOF
)

curl -H "Content-Type: application/json" -X POST -d "$input_json" "$endpoint/darrellodonnell/CULedger.Identity/0.1.0/member/$MEMBERID/onboard"

