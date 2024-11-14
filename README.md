# Ostorlab gitlabci

This is the source repository to build the docker image to be used within GitLab CI. This image gives you the ability to integrate Ostorlab autonomous security testing for Android and iOS mobile apps to your build process.

## Summary

Powered by static taint analysis, 3rd party dependencies fingerprinting and vulnerability analysis, dynamic instrumentation and novel backend scanning capabilities, Ostorlab leads the way providing the most advanced vulnerability detection capabilities.

To get more information visit us at https://www.ostorlab.co

## Getting started

### Access token

1. Go to the [API keys menu](https://report.ostorlab.co/library/api/keys)
2. Click the new button to generate a new key
3. Copy the API key (You can add a name and an expiry date to your key)
4. Click the save button to save your key

![Api key Step1](https://github.com/jenkinsci/ostorlab-plugin/blob/master/images/jenkins-apikey.png)

### Required environment variables

- `OSTORLAB_API_KEY` - Specifies your API key
- `OSTORLAB_FILE_PATH` - Specifies the path to the Android APK file or the iOS IPA file. This is mandatory if you are scanning a mobile application.
- `OSTORLAB_URLS` - Specifies the list of URLS to scan (separated by space). This is mandatory if you are scanning a Web application.
- `OSTORLAB_PLATFORM` - Specifies the platform. Possible values: `android` or `ios` or `link`.

### Optional environment variables

#### For a Mobile scan:
- `OSTORLAB_SCAN_PROFILE` - Select the scan profile to run. You can choose between `Fast Scan` for rapid static analysis or `Full Scan` for full Static, Dynamic and Backend analysis.
- `OSTORLAB_TITLE` - Specifies the scan title
- `OSTORLAB_RISK_THRESHOLD` - Sets a risk rating threshold to break the pipeline if exceeded.
- `OSTORLAB_MAX_WAIT_MINUTES` - Specifies the number of minutes to wait. Default value: `30`. It is applied only if OSTORLAB_RISK_THRESHOLD is set.
- `OSTORLAB_SBOM_FILES` - A space-separated list of paths to SBOM files.
- `OSTORLAB_CREDENTIALS` - A semicolon-separated list of credentials with each credential in the format login,password. For example: "user1,pass1;user2,pass2".
- `OSTORLAB_CUSTOM_CREDENTIALS` - A semicolon-separated list of custom credentials in the format name,value. For example: "api_token,12345;secret_key,67890"

#### For a Web scan:
- `OSTORLAB_SCAN_PROFILE` - Set the value to `Full Web Scan` for a Web scan.
- `OSTORLAB_TITLE` - Specifies the scan title
- `OSTORLAB_RISK_THRESHOLD` - Sets a risk rating threshold to break the pipeline if exceeded.
- `OSTORLAB_MAX_WAIT_MINUTES` - Specifies the number of minutes to wait. Default value: `30`. It is applied only if OSTORLAB_RISK_THRESHOLD is set.
- `OSTORLAB_SBOM_FILES` - A space-separated list of paths to SBOM files.
- `OSTORLAB_CREDENTIALS` - A semicolon-separated list of credentials with each credential in the format login,password,role,url. For example: "user1,pass1,admin,https://example.com;user2,pass2,user,https://example.com". The role and url values are mandatory for the Web scans.
- `OSTORLAB_CUSTOM_CREDENTIALS` - A semicolon-separated list of custom credentials in the format name,value. For example: "api_token,12345;secret_key,67890"
- `OSTORLAB_API_SCHEMA` - The paths to the API schema file to be used for the scan.
- `OSTORLAB_FILTERED_URL_REGEXES` - A space-separated list of regular expressions to exclude URLs from the scan.
- `OSTORLAB_PROXY` - Specifies the proxy settings for the scan.
- `OSTORLAB_QPS` - Specifies queries per second limit for the scan

## Creating a GitLab CI pipeline:

Example to use for your `.gitlab-ci.yml` to scan a Mobile application

```yaml
stages:
  - build
  - test

build:
  stage: build
  script:
      - Pre steps to build
      - ./gradlew assembleDebug
  artifacts:
    paths:
    - app/build/outputs/

runScanOstorlab:
  stage: test
  image: ostorlab/gitlab-ci
  variables:
    OSTORLAB_FILE_PATH: app/build/outputs/apk/debug/app-debug.apk
    OSTORLAB_PLATFORM: android
  script:
    - run_ostorlab.sh
```

Example to use for your `.gitlab-ci.yml` to scan a Mobile application with test credentials and SBOM files

```yaml
stages:
  - build
  - test

build:
  stage: build
  script:
      - Pre steps to build
      - ./gradlew assembleDebug
  artifacts:
    paths:
    - app/build/outputs/

runScanOstorlab:
  stage: test
  image: ostorlab/gitlab-ci
  variables:
    OSTORLAB_FILE_PATH: app/build/outputs/apk/debug/app-debug.apk
    OSTORLAB_PLATFORM: android
    OSTORLAB_CREDENTIALS: user1,pass1;user2,pass2
    OSTORLAB_SBOM_FILES: /path/to/sbom1.json /path/to/sbom2.json
  script:
    - run_ostorlab.sh
```

Example to use for your `.gitlab-ci.yml` to scan a Web application 

```yaml
stages:
  - build
  - test

build:
  stage: build
  script:
      - Pre steps to build
      - ./gradlew assembleDebug
  artifacts:
    paths:
    - app/build/outputs/

runScanOstorlab:
  stage: test
  image: ostorlab/gitlab-ci
  variables:
    OSTORLAB_URLS: https://example1.com https://example2.com
    OSTORLAB_PLATFORM: link
    OSTORLAB_SCAN_PROFILE: 'Full Web Scan'
    OSTORLAB_CREDENTIALS: user1,pass1,admin,https://example1.com;user2,pass2,user,https://example2.com
    OSTORLAB_SBOM_FILES: /path/to/sbom1.json /path/to/sbom2.json
  script:
    - run_ostorlab.sh
```

## Adding environment variables in GitLab pipeline

1. Select Settings option from your GitLab project.

2. Select `CI/CD`.

3. Select `Variables` section to add environment variables for your pipeline, e.g.

## Adding environment variables in GitLab pipeline

Select Settings option from your GitLab project and then jump to `Variables` section to add environment variables for your pipeline, e.g.

![GitLab Environment Add Variable](https://github.com/Ostorlab/gitlabci/blob/main/img/add_variable.png)

![GitLab Environment Variables](https://github.com/Ostorlab/gitlabci/blob/main/img/added_variables.png)

## Verifying the build

Once the job is done, if you choose to wait for the scan result and break if the risk rating is higher than the threshold, than the job might fail if its risk rating is equal or higher than the threshod.
Otherwise, the job will succeed with a line indicating the scan risk rating

![View Score](https://github.com/Ostorlab/gitlabci/blob/main/img/pipeline.png)
