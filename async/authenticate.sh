#!/bin/bash

while getopts :i: opt; do
  case "${opt}" in
    i) MEMBERID=${OPTARG}
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

if [ -z $MEMBERID ]; then
  echo "===================================================================================="
  echo "USAGE:"
  echo "  -i: Member Identifier"
  echo ""
  echo "  Please provide a memberId as it is required for this procedure"
  echo ""
  echo "You will receive a JSON response with an id field.  Copy that id and provide as a "
  echo "parameter to the ./poll.sh script to get further details"
  echo "===================================================================================="
  exit
fi

endpoint="http://localhost:8080"

curl -H "Prefer: respond-async" -H "Content-Type: application/json" -X PUT "$endpoint/CULedger/CULedger.Identity/0.2.0/member/$MEMBERID/authenticate"
