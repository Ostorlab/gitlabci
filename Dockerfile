FROM python:3.11-slim

# Download Ostorlab plugin source
RUN python3.11 -m pip install --upgrade pip
RUN python3.11 -m pip install ostorlab
COPY bin/run.sh /usr/local/bin/run_ostorlab.sh

#

### Supported environment variables:
### OSTORLAB_API_KEY - (Required) Specify API KEY from your Ostorlab account
### OSTORLAB_FILEPATH - (Required) Path to Android apk or IOS ipa - this file must be mounted via volume for the access
### OSTORLAB_PLATFORM - (Required) android or ios depending on the type of the application to analyze
#

CMD /usr/local/bin/run_ostorlab.sh

## DOCKER COMMAND for Android mobile scan
# docker run -v ~/Projects/apk:/source -e OSTORLAB_API_KEY=$OSTORLAB_API_KEY -e OSTORLAB_FILE_PATH=$OSTORLAB_FILE_PATH -e OSTORLAB_PLATFORM=android -it --rm $IMAGE_ID

## DOCKER COMMAND for Web scan
# docker run -v ~/Projects/apk:/source -e OSTORLAB_API_KEY=$OSTORLAB_API_KEY -e OSTORLAB_FILE_PATH=$OSTORLAB_FILE_PATH -e OSTORLAB_PLATFORM=link -it --rm $IMAGE_ID

