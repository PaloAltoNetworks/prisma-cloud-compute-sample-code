#!/usr/bin/env bash

# API Docs
# https://prisma.pan.dev/api/cloud/cwpp/defenders#operation/post-defenders-fargate.json

# This Bash script can be used to deploy a Container Defender.
# To use, update the 4 variables prefixed with `PCC_` below.

# If using SaaS, PCC_USER and PCC_PASS will be an access key and secret key.
# Can also set environment variables PCC_USER or PCC_PASS or PCC_URL or PCC_SAN
ACCESS_KEY=""
SECRET_KEY=""

# PCC_URL should be the exact value copied from
# Compute > Manage > System > Utilities > Path to Console
CONSOLE_ADDRESS="" #https://us-west1.cloud.twistlock.com/us-3-xxxxxxxxx
CONSOLE_SAN="" #us-west1.cloud.twistlock.com

#Specifiy regional proxy here
PROXY="" #http://proxy.address
NOPROXY="" # 169.254.169.254 comma separated list, if needed

#Will leverage env variables  PCC_USER or PCC_PASS or PCC_URL or PCC_SAN if set. 
[[ -z "${PCC_USER}" ]] && PCC_USER="${ACCESS_KEY}" || PCC_USER="${PCC_USER}"
[[ -z "${PCC_PASS}" ]] && PCC_PASS="${SECRET_KEY}" || PCC_PASS="${PCC_PASS}"
[[ -z "${PCC_URL}" ]] && PCC_URL="${CONSOLE_ADDRESS}" || PCC_URL="${PCC_URL}"
[[ -z "${PCC_SAN}" ]] && PCC_SAN="${CONSOLE_SAN}" || PCC_SAN="${PCC_SAN}"


#This  command will generate an authorization token (Only valid for 1 hour)
json_auth_data="$(printf '{ "username": "%s", "password": "%s" }' "${PCC_USER}" "${PCC_PASS}")"
token=$(curl -sSLk -d "$json_auth_data" -H 'content-type: application/json' "$PCC_URL/api/v1/authenticate" | python3 -c 'import sys, json; print(json.load(sys.stdin)["token"])')

generate_proxy_data()
{
cat <<EOF
{"httpProxy":"$1","noProxy":"$2"}
EOF
}

#Retrieve current global proxy settings
CURRENT_PROXY=$(curl -sSLk -H "authorization: Bearer ${token}" -X GET "$PCC_URL/api/v1/settings/proxy")

# This is where you would pass in a variable/unprotected task ro file
unprotectedTask=unprotectedTask.json

#Set proxy for this function
curl ${OPTIONS} -H "authorization: Bearer ${token}" -X POST "$PCC_URL/api/v1/settings/proxy" --data "$(generate_proxy_data $PROXY $NOPROXY)" 

#Generate protected task
curl ${OPTIONS} -H "Authorization: Bearer ${token}" "${PCC_URL}/api/v1/defenders/fargate.json?consoleaddr=${PCC_SAN}&defenderType=appEmbedded" -X POST --data-binary "@${unprotectedTask}" --output protectedTask.json

#Reset glopbal proxy to original values
curl ${OPTIONS} -H "authorization: Bearer ${token}" -X POST "$PCC_URL/api/v1/settings/proxy" --data "$CURRENT_PROXY" 
