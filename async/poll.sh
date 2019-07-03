#!/bin/bash

if [ -z $1 ]; then
  echo "===================================================================================="
  echo "USAGE:"
  echo "  ./poll.sh <jobId>"
  echo ""
  echo "  Please provide a jobId provided by calling either the onboard or authenticate async"
  echo "  functions to get further details."
  echo ""
  echo "===================================================================================="
  exit
fi

endpoint="http://localhost:8080"

curl "$endpoint/CULedger/CULedger.Identity/0.2.0/poll/$1"