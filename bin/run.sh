#!/bin/bash -e
###
# Ostorlab shell script to use the jar library. it uploads the application, start the scan and fetch the results
###

if [[ -z "${PLUGIN_VERSION}" ]]; then
  PLUGIN_VERSION="1.3"
fi

if [[ -z "${PLUGIN_JAR}" ]]; then
  BIN_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
  PLUGIN_JAR=${BIN_DIR}/../libs/ostorlab_integration_${PLUGIN_VERSION}.jar
fi

if [[ -z "$OSTORLAB_API_KEY" ]]; then
  echo "Please specify API KEY using environment variable ostorlab.apikey"
  exit 1
fi

if [[ -z "${OSTORLAB_ARTIFACTS_DIR}" ]]; then
  OSTORLAB_ARTIFACTS_DIR="/tmp/ostorlab/artifacts"
  mkdir -p ${OSTORLAB_ARTIFACTS_DIR}
fi

if [[ -z "${OSTORLAB_FILE_PATH}" ]]; then
  echo "Please specify the application file to scan using environment variable OSTORLAB_FILE_PATH"
  exit 1
fi

if [[ -z "${OSTORLAB_PLATFORM}" ]]; then
  echo "Please specify the application pltaform to scan using environment variable OSTORLAB_PLATFORM"
  exit 1
fi

exec java -jar ${PLUGIN_JAR} --api-key $OSTORLAB_API_KEY --api-key $OSTORLAB_API_KEY --file-path $OSTORLAB_FILE_PATH  --artifacts-dir $OSTORLAB_ARTIFACTS_DIR --platform $OSTORLAB_PLATFORM

