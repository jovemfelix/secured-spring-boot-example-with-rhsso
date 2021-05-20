#!/bin/bash

THIS_SCRIPT=$(basename -- "$0")
WORKDIR=$(cd -P -- "$(dirname -- "$0")" && pwd -P)

./mvnw clean package -f $WORKDIR/../pom.xml -Dmaven.test.skip=true
