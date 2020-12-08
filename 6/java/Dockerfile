ARG detect_latest_release_version=6.7.0

FROM alpine:latest AS builder
ARG detect_latest_release_version
ENV DETECT_VERSION_KEY $detect_latest_release_version

RUN mkdir -p /airgap
RUN cd /airgap \
    && wget https://sig-repo.synopsys.com/bds-integrations-release/com/synopsys/integration/synopsys-detect/$DETECT_VERSION_KEY/synopsys-detect-$DETECT_VERSION_KEY-air-gap.zip \
    && unzip synopsys-detect-$DETECT_VERSION_KEY-air-gap.zip


FROM openjdk:8 
MAINTAINER Forest Keepers <Jeroen.knoops@philips.com>

RUN apt-get update && apt-get install -y \
    curl \
    jq \
    git \
    wget \
    netcat \
 && rm -rf /var/lib/apt/lists/*

ARG detect_latest_release_version
ARG MAVEN_VERSION=3.6.3
ENV PATH /opt/apache-maven/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV M2_HOME /opt/apache-maven
ENV MAVEN_HOME /opt/apache-maven
ENV DETECT_LATEST_RELEASE_VERSION $detect_latest_release_version
ENV DETECT_VERSION_KEY $detect_latest_release_version

ENV SRC_PATH /code

USER root

RUN wget -nc -O /tmp/apache-maven-${MAVEN_VERSION}-bin.tar.gz https://www-us.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
    && wget -nc -O /tmp/apache-maven-${MAVEN_VERSION}-bin.tar.gz.sha512 https://www.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz.sha512 \
    && sha512sum /tmp/apache-maven-${MAVEN_VERSION}-bin.tar.gz | grep `cat /tmp/apache-maven-${MAVEN_VERSION}-bin.tar.gz.sha512` \
    && tar -xzvf /tmp/apache-maven-${MAVEN_VERSION}-bin.tar.gz -C /opt/ \
    && chown -R root:root /opt/apache-maven-${MAVEN_VERSION} \
    && chmod -R 0755 /opt/apache-maven-${MAVEN_VERSION} \
    && ln -s /opt/apache-maven-${MAVEN_VERSION} /opt/apache-maven \
    && rm -f /tmp/apache-maven-${MAVEN_VERSION}-bin.tar.gz*

RUN mkdir -p /airgap/packaged-inspectors/gradle/
COPY --from=builder /airgap/packaged-inspectors/gradle/ /airgap/packaged-inspectors/gradle/

RUN mkdir -p /app
RUN curl -o /app/detect.sh https://detect.synopsys.com/detect.sh

RUN chmod +x /app/detect.sh

RUN /app/detect.sh --help

ADD /6/java/scripts/entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh
ENTRYPOINT [ "/app/entrypoint.sh" ]

ADD REPO .
ADD TAGS .

CMD /app/detect.sh --blackduck.hub.url="${HUB_URL}" --blackduck.hub.api.token="${HUB_TOKEN}" --blackduck.hub.trust.cert=true --detect.policy.check=true --detect.source.path="${SRC_PATH}"
