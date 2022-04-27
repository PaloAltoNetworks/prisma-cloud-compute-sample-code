#!/bin/bash
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
PROXY="http://proxy.address" #http://proxy.address
NOPROXY="169.254.169.254" # 169.254.169.254 comma separated list, if needed

#Will leverage env variables  PCC_USER or PCC_PASS or PCC_URL or PCC_SAN if set. 
[[ -z "${PCC_USER}" ]] && PCC_USER="${ACCESS_KEY}" || PCC_USER="${PCC_USER}"
[[ -z "${PCC_PASS}" ]] && PCC_PASS="${SECRET_KEY}" || PCC_PASS="${PCC_PASS}"
[[ -z "${PCC_URL}" ]] && PCC_URL="${CONSOLE_ADDRESS}" || PCC_URL="${PCC_URL}"
[[ -z "${PCC_SAN}" ]] && PCC_SAN="${CONSOLE_SAN}" || PCC_SAN="${PCC_SAN}"


#This will generate the post data that will be sent to the defenders/daemonset.yaml API endpoint
generate_post_data()
{
cat <<EOF
{
    "proxy":
      {"httpProxy":"$PROXY",
      "ca":"","user":"",
      "password":"",
      "noProxy":"$NOPROXY"}
}
EOF
}


json_auth_data="$(printf '{ "username": "%s", "password": "%s" }' "${PCC_USER}" "${PCC_PASS}")"
token=$(curl -sSLk -d "$json_auth_data" -H 'content-type: application/json' "$PCC_URL/api/v1/authenticate" | python -c 'import sys, json; print(json.load(sys.stdin)["token"])')


curl -sSLk -H "authorization: Bearer $token" -X POST "$PCC_URL/api/v1/scripts/defender.sh" --data "$(generate_post_data)" | sudo bash -s -- -c "$PCC_SAN" -d "none" -m
