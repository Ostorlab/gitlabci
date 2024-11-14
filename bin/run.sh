#!/bin/bash -e
###
# Ostorlab shell script to use the oxo library. it uploads the application, start the scan and fetch the results
###

if [[ ! -v OSTORLAB_API_KEY ]]; then
  echo "OSTORLAB_API_KEY is not set"
  exit 1
fi

if [[ ! -v OSTORLAB_FILE_PATH && ! -v OSTORLAB_URLS ]]; then
  echo "Either OSTORLAB_FILE_PATH or OSTORLAB_URLS must be set"
  exit 1
fi

if [[ ! -v OSTORLAB_PLATFORM ]]; then
  echo "OSTORLAB_PLATFORM is not set"
  exit 1
fi

# Add --scan-profile argument
PLATFORM=""
if [[ "${OSTORLAB_PLATFORM,,}" == "android" ]]; then
  PLATFORM="android-apk"
elif [[ "${OSTORLAB_PLATFORM,,}" == "ios" ]]; then
  PLATFORM="ios-ipa"
elif [[ "${OSTORLAB_PLATFORM,,}" == "link" ]]; then
  PLATFORM="link"
else
  echo "Unsupported platform: ${OSTORLAB_PLATFORM}"
  exit 1
fi


# Add optional --title argument if OSTORLAB_TITLE is set
TITLE_ARG=""
if [[ -n "${OSTORLAB_TITLE}" ]]; then
  TITLE_ARG="--title=${OSTORLAB_TITLE}"
else
  TITLE_ARG="--title=Gitlab scan"
fi

# Add optional --break-on-risk-rating argument if OSTORLAB_RISK_THRESHOLD is set
BREAK_ON_RISK_RATING=""
if [[ -n "${OSTORLAB_RISK_THRESHOLD}" ]]; then
  BREAK_ON_RISK_RATING="--break-on-risk-rating=${OSTORLAB_RISK_THRESHOLD}"
fi

# Add optional --max-wait-minutes argument if OSTORLAB_MAX_WAIT_MINUTES is set
MAX_WAIT_MINUTES=""
if [[ -n "${OSTORLAB_MAX_WAIT_MINUTES}" ]]; then
  MAX_WAIT_MINUTES="--max-wait-minutes=${OSTORLAB_MAX_WAIT_MINUTES}"
fi

# Add --scan-profile argument
SCAN_PROFILE=""
if [[ "${OSTORLAB_SCAN_PROFILE}" == "Full Scan" ]]; then
  SCAN_PROFILE="--scan-profile=full_scan"
elif [[ "${OSTORLAB_SCAN_PROFILE}" == "Full Web Scan" ]]; then
  SCAN_PROFILE="--scan-profile=full_web_scan"
else
  SCAN_PROFILE="--scan-profile=fast_scan"
fi

# Add URLS as arguments if OSTORLAB_URLS is set
URLS=""
if [[ -n "${OSTORLAB_URLS}" ]]; then
  for url in ${OSTORLAB_URLS}; do
    URLS+="--url=${url} "
  done
fi

# Add SBOM files as arguments if OSTORLAB_SBOM_FILES is set
SBOM_ARGS=""
if [[ -n "${OSTORLAB_SBOM_FILES}" ]]; then
  for sbom_file in ${OSTORLAB_SBOM_FILES}; do
    SBOM_ARGS+="--sbom-file=${sbom_file} "
  done
fi

# Add credentials as arguments if OSTORLAB_CREDENTIALS is set
CREDENTIALS_ARGS=""
if [[ -n "${OSTORLAB_CREDENTIALS}" ]]; then
  # Split OSTORLAB_CREDENTIALS by semicolon to process each credential
  IFS=';' read -ra CREDENTIALS_ARRAY <<< "${OSTORLAB_CREDENTIALS}"

  for credential in "${CREDENTIALS_ARRAY[@]}"; do
    # Split each credential by comma
    IFS=',' read -ra FIELDS <<< "${credential}"

    login="${FIELDS[0]}"
    password="${FIELDS[1]}"
    role="${FIELDS[2]}"
    url="${FIELDS[3]}"

    # Add login and password (required)
    CREDENTIALS_ARGS+="--test-credentials-login=${login} --test-credentials-password=${password} "

    # Add optional role and url if they are provided
    if [[ -n "${role}" ]]; then
      CREDENTIALS_ARGS+="--test-credentials-role=${role} "
    fi
    if [[ -n "${url}" ]]; then
      CREDENTIALS_ARGS+="--test-credentials-url=${url} "
    fi
  done
fi

# Add credentials as arguments if OSTORLAB_CUSTOM_CREDENTIALS is set
CUSTOM_CREDENTIALS_ARGS=""
if [[ -n "${OSTORLAB_CUSTOM_CREDENTIALS}" ]]; then
  # Split OSTORLAB_CREDENTIALS by semicolon to process each credential
  IFS=';' read -ra CUSTOM_CREDENTIALS_ARRAY <<< "${OSTORLAB_CUSTOM_CREDENTIALS}"

  for credential in "${CUSTOM_CREDENTIALS_ARRAY[@]}"; do
    # Split each credential by comma
    IFS=',' read -ra FIELDS <<< "${credential}"

    name="${FIELDS[0]}"
    value="${FIELDS[1]}"

    # Add login and password (required)
    CREDENTIALS_ARGS+="----test-credentials-name=${name} ----test-credentials-value=${value} "
  done
fi

# Add optional --api-schema argument if OSTORLAB_API_SCHEMA is set
API_SCHEMA=""
if [[ -n "${OSTORLAB_API_SCHEMA}" ]]; then
  API_SCHEMA="--api-schema=${OSTORLAB_API_SCHEMA}"
fi

# Add filtered url regexes as arguments if OSTORLAB_FILTERED_URL_REGEXES is set
FILTERED_URL_REGEXES_ARGS=""
if [[ -n "${OSTORLAB_FILTERED_URL_REGEXES}" ]]; then
  for filtered-url in ${OSTORLAB_FILTERED_URL_REGEXES}; do
    FILTERED_URL_REGEXES_ARGS+="--filtered-url-regexes=${filtered-url} "
  done
fi

# Add optional --proxy argument if OSTORLAB_PROXY is set
PROXY=""
if [[ -n "${OSTORLAB_PROXY}" ]]; then
  PROXY="--proxy=${OSTORLAB_PROXY}"
fi

# Add optional --qps argument if OSTORLAB_QPS is set
QPS=""
if [[ -n "${OSTORLAB_QPS}" ]]; then
  QPS="--qps=${OSTORLAB_QPS}"
fi

# Check if the platform is "android-apk" or "ios-ipa"
if [[ "$PLATFORM" == "android-apk" || "$PLATFORM" == "ios-ipa" ]]; then
  exec /usr/local/bin/oxo --api-key $OSTORLAB_API_KEY ci-scan run "${TITLE_ARG}" ${BREAK_ON_RISK_RATING} ${MAX_WAIT_MINUTES} ${SCAN_PROFILE} ${SBOM_ARGS} ${CREDENTIALS_ARGS} ${CUSTOM_CREDENTIALS_ARGS} $PLATFORM $OSTORLAB_FILE_PATH
# Check if the platform contains "link"
elif [[ "$PLATFORM" == "link" ]]; then
    exec /usr/local/bin/oxo --api-key $OSTORLAB_API_KEY ci-scan run "${TITLE_ARG}" ${BREAK_ON_RISK_RATING} ${MAX_WAIT_MINUTES} ${SCAN_PROFILE} ${SBOM_ARGS} ${API_SCHEMA} ${FILTERED_URL_REGEXES_ARGS} ${PROXY} ${QPS} ${CREDENTIALS_ARGS} ${CUSTOM_CREDENTIALS_ARGS} $PLATFORM $URLS
fi

