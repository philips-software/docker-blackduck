ARG detect_latest_release_version=7.14.0

FROM golang:1.16.4-buster

MAINTAINER Forest Keepers

RUN apt-get update && \
    apt-get install -y \
      curl \
      jq \
      git \
      wget \
      openssl \
      netcat-openbsd \
      bash \
      net-tools \
      default-jdk && \
    rm -rf /var/lib/apt/lists/*

ARG detect_latest_release_version
ENV DETECT_LATEST_RELEASE_VERSION $detect_latest_release_version
ENV DETECT_VERSION_KEY $detect_latest_release_version

ENV SRC_PATH /code

RUN mkdir -p /app
RUN wget -O /app/detect.sh https://detect.synopsys.com/detect.sh

RUN chmod +x /app/detect.sh

RUN /app/detect.sh --help

ADD REPO .
ADD TAGS .

CMD /app/detect.sh --blackduck.hub.url="${HUB_URL}" --blackduck.hub.api.token="${HUB_TOKEN}" --detect.policy.check=true --detect.source.path="${SRC_PATH}"
