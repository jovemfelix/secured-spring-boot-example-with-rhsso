#!/bin/bash

THIS_SCRIPT=$(basename -- "$0")
WORKDIR=$(cd -P -- "$(dirname -- "$0")" && pwd -P)

export KEYCLOAK_URL=http://localhost:8180
#export KEYCLOAK_URL=https://rhsso-acty-stg02.cloudalgartelecom.com.br:8443
export KEYCLOAK_REALM_NAME=demo
export KEYCLOAK_CLIENT_ID=demoapp

echo "*** Running $THIS_SCRIPT ***"
echo "** KEYCLOAK_URL=$KEYCLOAK_URL"
echo "** KEYCLOAK_REALM_NAME=$KEYCLOAK_REALM_NAME"
echo "** KEYCLOAK_CLIENT_ID=$KEYCLOAK_CLIENT_ID"
#export PUBLIC_KEY=$(curl -k -s -X GET "$KEYCLOAK_URL/auth/realms/$KEYCLOAK_REALM_NAME/protocol/openid-connect/certs"  | jq -r '.keys[0].x5c[0]')
export PUBLIC_KEY=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAkPw9CVj3uGS28JDr1ToOT6ZPaPE9H1TlHKSPGGE0TxtVrmVmfnxbF7655grTA7cl5Ae09+Cemuv398GhtrZWmJdeOAhookSnkQai8LWf0l3iZeyjxWEfowO7VJwGRjBnlBVi3y8ll3WeHH+yLT6elBinc7DnSww97m9OEZF8oJ3hRaBOndDtJPLNd7QeAh4T127abf3xy5lz21w3VJohW0j4VbVznw6ugTYHF+ZdvxUQGgGaZi0hL+FRDbYS5O5Z85vlPXHKm4YGABlSntDrJhtBUsU/bZQxUkaSmDJdOT/H6Bkmj4IGuS15GC2sfVrVIDsRdPT8TVvZk7mFQYoCkQIDAQAB
echo "** PUBLIC_KEY=$PUBLIC_KEY"
echo "*** Run time: $(date) @ $(hostname)"
echo

# to change port
#-Dserver.port=8083

./mvnw clean package -f $WORKDIR/../pom.xml -Dmaven.test.skip=true -DSSO_AUTH_SERVER_URL=$KEYCLOAK_URL/auth -DSSO_REALM=$KEYCLOAK_REALM_NAME -DSSO_RESOURCE=$KEYCLOAK_CLIENT_ID -DSSO_PUBLIC_KEY=$PUBLIC_KEY spring-boot:run
