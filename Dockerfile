FROM openjdk:11
# plugin version from https://github.com/ostorlab/gitlabci/releases
ENV PLUGIN_VERSION 1.0
#
# Download Ostorlab plugin source
RUN mkdir -p /usr/local/share/ostorlab
RUN curl -Ls https://github.com/ostorlab/gitlabci/archive/${PLUGIN_VERSION}.tar.gz | tar -xzf - -C /usr/local/share/ostorlab
RUN cp /usr/local/share/ostorlab/gitlabci-${PLUGIN_VERSION}/bin/run.sh /usr/local/bin/run_ostorlab.sh

ENV PLUGIN_JAR /usr/local/share/ostorlab/gitlabci-${PLUGIN_VERSION}/libs/ostorlab_integration_${PLUGIN_VERSION}.jar
#

### Supported environment variables:
### OSTORLAB_API_KEY - (Required) Specify API KEY from your Ostorlab account
### OSTORLAB_FILEPATH - (Required) Path to Android apk or IOS ipa - this file must be mounted via volume for the access
### OSTORLAB_PLATFORM - (Required) android or ios depending on the type of the application to analyze
#

CMD /usr/local/bin/run_ostorlab.sh

## DOCKER COMMAND
# docker run -v ~/Projects/apk:/source -v /tmp:/artifacts -e STORLAB_API_KEY=$OSTORLAB_API_KEY -e OSTORLAB_FILEPATH=$OSTORLAB_FILEPATH -e OSTORLAB_PLATFORM=android -it --rm $IMAGE_ID

