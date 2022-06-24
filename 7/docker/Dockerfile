# This docker image is for supporting docker detect.
ARG detect_latest_release_version=7.14.0

FROM alpine:latest AS builder
MAINTAINER Forest Keepers

ARG detect_latest_release_version
ENV DETECT_LATEST_RELEASE_VERSION $detect_latest_release_version
ENV DETECT_VERSION_KEY $detect_latest_release_version

# Install airgap
RUN mkdir -p /airgap
RUN cd /airgap \
    && wget https://sig-repo.synopsys.com/bds-integrations-release/com/synopsys/integration/synopsys-detect/$DETECT_VERSION_KEY/synopsys-detect-$DETECT_VERSION_KEY-air-gap.zip \
    && unzip synopsys-detect-$DETECT_VERSION_KEY-air-gap.zip


FROM openjdk:8-slim-buster

ARG detect_latest_release_version
ENV DETECT_LATEST_RELEASE_VERSION $detect_latest_release_version
ENV DETECT_VERSION_KEY $detect_latest_release_version
ENV SYNOPSYS_SKIP_PHONE_HOME true
USER root

# Install utilities
RUN apt-get update && apt-get -y install \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg-agent \
        software-properties-common \
        unzip

# Install docker - Installation instructions https://docs.docker.com/engine/install/debian/
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN apt-key fingerprint 0EBFCD88
RUN add-apt-repository \
        "deb [arch=amd64] https://download.docker.com/linux/debian \
        $(lsb_release -cs) \
        stable"
RUN apt-get update && apt-get -y install \
        docker-ce \
        docker-ce-cli \
        containerd.io

# Copy docker inspector from builder stage
RUN mkdir -p /airgap/packaged-inspectors/docker/
COPY --from=builder /airgap/packaged-inspectors/docker/ /airgap/packaged-inspectors/docker/

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

ADD /7/docker/scripts/entrypoint.sh /app/entrypoint.sh

RUN chmod +x /app/entrypoint.sh
RUN chmod +x /airgap/packaged-inspectors/docker/blackduck-docker-inspector.sh

ENTRYPOINT [ "/app/entrypoint.sh" ]

ADD REPO .
ADD TAGS .

CMD /app/detect.sh --blackduck.hub.url="${HUB_URL}" --blackduck.hub.api.token="${HUB_TOKEN}" --detect.policy.check=true
