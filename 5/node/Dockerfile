FROM philipssoftware/node:java

MAINTAINER Forest Keepers

ENV DETECT_LATEST_RELEASE_VERSION 5.4.0
ENV DETECT_VERSION_KEY 5.4.0

ENV SRC_PATH /code

RUN mkdir -p /app
RUN curl -o /app/detect.sh https://detect.synopsys.com/detect.sh

RUN chmod +x /app/detect.sh

RUN /app/detect.sh --help

ADD REPO .
ADD TAGS .

CMD /app/detect.sh --blackduck.hub.url="${HUB_URL}" --blackduck.hub.api.token="${HUB_TOKEN}" --blackduck.hub.trust.cert=true --detect.policy.check=true --detect.source.path="${SRC_PATH}"
