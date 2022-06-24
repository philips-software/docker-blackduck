ARG detect_latest_release_version=7.14.0

FROM mcr.microsoft.com/dotnet/core/sdk:3.0.101

MAINTAINER Forest Keepers

ARG detect_latest_release_version
ENV DETECT_LATEST_RELEASE_VERSION $detect_latest_release_version
ENV DETECT_VERSION_KEY $detect_latest_release_version

# Install utilities
RUN apt-get update -y && apt-get install -y wget unzip netcat-openbsd

# Install airgap
RUN wget https://sig-repo.synopsys.com/bds-integrations-release/com/synopsys/integration/synopsys-detect/$DETECT_VERSION_KEY/synopsys-detect-$DETECT_VERSION_KEY-air-gap-gradle-nuget.zip \
    && unzip synopsys-detect-$DETECT_VERSION_KEY-air-gap-gradle-nuget.zip -d /airgap

# Install JRE
RUN apt-get -y install default-jre \
    && apt-get -q autoremove \
    && apt-get -q clean -y \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/*.bin

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

ADD /7/dotnetcore-3.0.101/scripts/entrypoint.sh /app/entrypoint.sh

RUN chmod +x /app/entrypoint.sh

ENTRYPOINT [ "/app/entrypoint.sh" ]

ADD REPO .
ADD TAGS .

CMD /app/detect.sh --blackduck.hub.url="${HUB_URL}" --blackduck.hub.api.token="${HUB_TOKEN}" --detect.policy.check=true
