#!/bin/bash

THIS_SCRIPT=$(basename -- "$0")
WORKDIR=$(cd -P -- "$(dirname -- "$0")" && pwd -P)


echo "*** Running $THIS_SCRIPT ***"

if [ "x${1}" = "x" ]; then
  echo "** loading local"
  source $WORKDIR/local.env
else
  echo "** loading hml"
  source $WORKDIR/hml.env
fi

echo "** API_URL=$API_URL"
echo "** SSO_AUTH_SERVER_URL=$SSO_AUTH_SERVER_URL"
echo "** SSO_REALM=$SSO_REALM"
echo "** SSO_RESOURCE (client_id)=$SSO_RESOURCE"
echo "** SSO_PUBLIC_KEY=$SSO_PUBLIC_KEY"
echo "** SSO_USERNAME=$SSO_USERNAME"
echo "** SSO_PASSWORD=$SSO_PASSWORD"
echo "*** Run time: $(date) @ $(hostname)"
echo

TOKEN_URL=$SSO_AUTH_SERVER_URL/auth/realms/$SSO_REALM/protocol/openid-connect/token
echo "** getting TOKEN $TOKEN_URL"
export TOKEN=$(curl -k -v "$TOKEN_URL" \
-H 'Content-Type: application/x-www-form-urlencoded' \
-d 'grant_type=password' \
-d "username=$SSO_USERNAME" \
-d "password=$SSO_PASSWORD" \
-d "client_id=$SSO_RESOURCE" | jq -r .access_token)

echo "** TOKEN=$TOKEN"
if  [ -x "$(command -v jwt)" ]; then
  jwt decode $TOKEN
fi

echo "** calling API $API_URL"
curl -H "Authorization: Bearer $TOKEN" $API_URL
