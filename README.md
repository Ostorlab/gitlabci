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
- `OSTORLAB_FILE_PATH` - Specifies the path to the Android APK file or iOS IPA file
- `OSTORLAB_PLATFORM` - Specifies the platform. Possible values: `android` or `ios`

### Optional environment variables

- `OSTORLAB_PLAN` - Specifies your scan plan. Possible values: `free` for community scans or `static_dynamic_backend` for full analysis
- `OSTORLAB_TITLE` - Specifies the scan title
- `OSTORLAB_WAIT_FOR_RESULTS` - Set to `true` if you want to wait for the scan to finish and retrieve the result
- `OSTORLAB_WAIT_MINUTES` - Specifies the number of minutes to wait. Default value: `30`
- `OSTORLAB_BREAK_BUILD_ON_SCORE` - Set to `tru`e to generate an exception if the scan risk rating is higher than the threshold
- `OSTORLAB_RISK_THRESHOLD` - Specifies your risk rating threshold. Possible values: `LOW`

## Creating a GitLab CI pipeline:

Example to use for your `.gitlab-ci.yml`

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
