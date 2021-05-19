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

echo "** running.. "

# to change port
#-Dserver.port=8083
java -jar $WORKDIR/../target/dear-unit-1.0.0.jar
