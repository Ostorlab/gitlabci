#!/bin/bash -e
###
# Ostorlab shell script to use the jar library. it uploads the application, start the scan and fetch the results
###

if [[ ! -v PLUGIN_VERSION ]]; then
  PLUGIN_VERSION="1.3"
fi

if [[ ! -v PLUGIN_JAR ]]; then
  BIN_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
  PLUGIN_JAR=${BIN_DIR}/../libs/ostorlab_integration_${PLUGIN_VERSION}.jar
fi

if [[ ! -v OSTORLAB_API_KEY ]]; then
  echo "OSTORLAB_API_KEY is not set"
  exit 1
fi

if [[ ! -v OSTORLAB_ARTIFACTS_DIR ]]; then
  OSTORLAB_ARTIFACTS_DIR="/tmp/ostorlab/artifacts"
  mkdir -p ${OSTORLAB_ARTIFACTS_DIR}
fi

if [[ ! -v OSTORLAB_FILE_PATH ]]; then
  echo "OSTORLAB_FILE_PATH is not set"
  exit 1
fi

if [[ ! -v OSTORLAB_PLATFORM ]]; then
  echo "OSTORLAB_PLATFORM is not set"
  exit 1
fi

exec java -jar ${PLUGIN_JAR} --api-key $OSTORLAB_API_KEY --file-path $OSTORLAB_FILE_PATH --artifacts-dir $OSTORLAB_ARTIFACTS_DIR --platform $OSTORLAB_PLATFORM
