#!/bin/bash
#set -u

JOBID="$1"

source ./config.sh


TOKEN=$(curl -s -X POST \
        -H "Content-Type: application/x-www-form-urlencoded" \
        -d "client_id=$CLIENTID" \
        -d "grant_type=client_credentials" \
        -d "client_secret=$SECRET" \
        "https://login.microsoftonline.com/$TENANTID/oauth2/token" | jq -r .access_token)

poll() {
  RESPONSE=$(curl -k -s \
  -H "Content-Type: application/json" \
  -H "Ocp-Apim-Subscription-Key: $SUBSCRIPTIONKEY" \
  -H "Authorization: Bearer $TOKEN" \
  "$ENDPOINT/CULedger/CULedger.Identity/0.2.0/poll/$JOBID")
}

poll
ACTIVE=$(echo "$RESPONSE" | jq -r .active)
echo $RESPONSE

while [ "$ACTIVE" == "true" ]
do
  sleep 5
  poll
  ACTIVE=$(echo "$RESPONSE" | jq -r .active)
  echo "polling ..."
done
echo $RESPONSE
