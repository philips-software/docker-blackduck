ARG detect_latest_release_version=6.0.0

FROM mcr.microsoft.com/dotnet/core/sdk:3.0.101

MAINTAINER Forest Keepers

ARG detect_latest_release_version
ENV DETECT_LATEST_RELEASE_VERSION $detect_latest_release_version
ENV DETECT_VERSION_KEY $detect_latest_release_version

RUN apt-get update \ 
    && apt-get -y install default-jre \
    && apt-get -q autoremove \
    && apt-get -q clean -y \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/*.bin

RUN mkdir -p /app
RUN curl -o /app/detect.sh https://detect.synopsys.com/detect.sh

RUN chmod +x /app/detect.sh

RUN /app/detect.sh --help

ADD REPO .
ADD TAGS .

CMD /app/detect.sh --blackduck.hub.url="${HUB_URL}" --blackduck.hub.api.token="${HUB_TOKEN}" --blackduck.hub.trust.cert=true --detect.policy.check=true
