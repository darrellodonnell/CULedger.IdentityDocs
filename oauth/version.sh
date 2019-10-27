#!/bin/bash

source ./config.sh

TOKEN=$(curl -s -X POST \
        -H "Content-Type: application/x-www-form-urlencoded" \
        -d "client_id=$CLIENTID" \
        -d "grant_type=client_credentials" \
        -d "client_secret=$SECRET" \
        "https://login.microsoftonline.com/$TENANTID/oauth2/token" | jq -r .access_token)

curl -v \
  -H "Ocp-Apim-Subscription-Key: $SUBSCRIPTIONKEY" \
  -H "Authorization: Bearer $TOKEN" \
  "$ENDPOINT/CULedger/CULedger.Identity/0.3.0/version"
