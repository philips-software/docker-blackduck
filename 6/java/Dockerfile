ARG detect_latest_release_version=6.0.0

FROM alpine:latest AS builder
ARG detect_latest_release_version
ENV DETECT_VERSION_KEY $detect_latest_release_version

RUN mkdir -p /airgap
RUN cd /airgap \
    && wget https://sig-repo.synopsys.com/bds-integrations-release/com/synopsys/integration/synopsys-detect/$DETECT_VERSION_KEY/synopsys-detect-$DETECT_VERSION_KEY-air-gap.zip \
    && unzip synopsys-detect-$DETECT_VERSION_KEY-air-gap.zip

FROM java:8 
MAINTAINER Forest Keepers

ARG detect_latest_release_version
ENV DETECT_LATEST_RELEASE_VERSION $detect_latest_release_version
ENV DETECT_VERSION_KEY $detect_latest_release_version

ENV SRC_PATH /code

RUN mkdir -p /airgap/packaged-inspectors/gradle/
COPY --from=builder /airgap/packaged-inspectors/gradle/ /airgap/packaged-inspectors/gradle/

RUN mkdir -p /app
RUN curl -o /app/detect.sh https://detect.synopsys.com/detect.sh

RUN chmod +x /app/detect.sh

RUN /app/detect.sh --help

ADD /scripts/entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh
ENTRYPOINT [ "/app/entrypoint.sh" ]

ADD REPO .
ADD TAGS .

CMD /app/detect.sh --blackduck.hub.url="${HUB_URL}" --blackduck.hub.api.token="${HUB_TOKEN}" --blackduck.hub.trust.cert=true --detect.policy.check=true --detect.source.path="${SRC_PATH}"
