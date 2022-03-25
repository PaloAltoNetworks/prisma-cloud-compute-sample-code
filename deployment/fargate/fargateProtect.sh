#!/usr/bin/env bash

# https://cdn.twistlock.com/docs/downloads/Twistlock-API.html#defenders_fargate_json_post

# This Bash script can be used to deploy a Container Defender.
# To use, update the 4 variables prefixed with `PCC_` below.

# If using SaaS, PCC_USER and PCC_PASS will be an access key and secret key.
PCC_USER="<ACCESS-KEY>"
PCC_PASS="<SECRET-KEY>"


#Specifiy regional proxy here
PROXY="<PROXY>"
NOPROXY="<NOPROXY>" #comma separated list, if needed

# If using SaaS, PCC_URL should be the exact value copied from
# Compute > Manage > System > Utilities > Path to Console
PCC_URL="<CONSOLE-URL>"
SAN_NAME="us-west1.cloud.twistlock.com"

json_auth_data="$(printf '{ "username": "%s", "password": "%s" }' "${PCC_USER}" "${PCC_PASS}")"

generate_proxy_data()
{
cat <<EOF
{"httpProxy":"$1","noProxy":"$2"}
EOF
}

OPTIONS=" -k -s"
HEADER="Content-Type: application/json"

#Authenticate and Return Token
TOKEN=$(curl ${OPTIONS} -H "${HEADER}"  --data  "$json_auth_data"  "${PCC_URL}/api/v1/authenticate" | jq -r .token )

#echo -e "Token:\n$TOKEN\n"

#Retrieve current global proxy settings
CURRENT_PROXY=$(curl -sSLk -H "authorization: Bearer ${TOKEN}" -X GET "$PCC_URL/api/v1/settings/proxy")

unprotectedTask=unprotectedTask.json

#Set proxy for this funcation
curl ${OPTIONS} -H "authorization: Bearer ${TOKEN}" -X POST "$PCC_URL/api/v1/settings/proxy" --data "$(generate_proxy_data $PROXY $NOPROXY)" 

#Generate protected task
curl ${OPTIONS} -H "Authorization: Bearer ${TOKEN}" "${PCC_URL}/api/v1/defenders/fargate.json?consoleaddr=${SAN_NAME}&defenderType=appEmbedded" -X POST --data-binary "@${unprotectedTask}" --output protectedTask.json

#Reset glopbal proxy to original values
curl ${OPTIONS} -H "authorization: Bearer ${TOKEN}" -X POST "$PCC_URL/api/v1/settings/proxy" --data "$CURRENT_PROXY" 
