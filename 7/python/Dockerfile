ARG detect_latest_release_version=7.14.0

FROM philipssoftware/python:java-3.9

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

RUN curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python -

# Download detect 6 script
RUN mkdir -p /app \
    && curl -o /app/detect6.sh https://detect.synopsys.com/detect.sh \
    && chmod +x /app/detect6.sh \
    && /app/detect6.sh --help

# Download detect 7 script - We want default to 7
RUN mkdir -p /app \
    && curl -o /app/detect.sh https://detect.synopsys.com/detect7.sh \
    && chmod +x /app/detect.sh \
    && /app/detect.sh --help

ADD REPO .
ADD TAGS .

CMD /app/detect.sh --blackduck.hub.url="${HUB_URL}" --blackduck.hub.api.token="${HUB_TOKEN}" --detect.policy.check=true --detect.source.path="${SRC_PATH}"
