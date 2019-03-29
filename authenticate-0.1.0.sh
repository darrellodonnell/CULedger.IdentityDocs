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
  echo "===================================================================================="
  exit
fi

endpoint="http://culidentityapi.westus.cloudapp.azure.com:8080"

curl -H "Content-Type: application/json" -X PUT "$endpoint/darrellodonnell/CULedger.Identity/0.1.0/member/$MEMBERID/authenticate"

