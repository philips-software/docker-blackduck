ARG detect_latest_release_version=6.9.1

FROM philipssoftware/node:14.13.1-stretch-java-2

MAINTAINER Forest Keepers

ARG detect_latest_release_version
ENV DETECT_LATEST_RELEASE_VERSION $detect_latest_release_version
ENV DETECT_VERSION_KEY $detect_latest_release_version

ENV SRC_PATH /code

USER root

RUN apt-get update && \
    apt-get install -y \
      netcat-openbsd && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /app
RUN curl -o /app/detect.sh https://detect.synopsys.com/detect.sh

RUN chmod +x /app/detect.sh

RUN /app/detect.sh --help

ADD REPO .
ADD TAGS .

CMD /app/detect.sh --blackduck.hub.url="${HUB_URL}" --blackduck.hub.api.token="${HUB_TOKEN}" --blackduck.hub.trust.cert=true --detect.policy.check=true --detect.source.path="${SRC_PATH}"
