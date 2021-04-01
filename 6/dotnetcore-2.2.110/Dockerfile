# This docker image is for supporting .net core sdk 2.2.110.
# It is the most latest version supported in VS2017.
# It is not available as docker image, so it is downloaded and extracted
ARG detect_latest_release_version=6.9.1

FROM mcr.microsoft.com/dotnet/core/sdk:2.2
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

# Install .NET 2.2.110 SDK
ENV DOTNET_SDK_VERSION_2_2_110 2.2.110

RUN curl -SL --output dotnet.tar.gz https://dotnetcli.blob.core.windows.net/dotnet/Sdk/$DOTNET_SDK_VERSION_2_2_110/dotnet-sdk-$DOTNET_SDK_VERSION_2_2_110-linux-x64.tar.gz \
    && dotnet_sha512='cd3bc601ccc45edf38cdcc254831b88539dd51f26bdafa2d74eebb09d20d19d745fe319a93c4290e3b74a7a5d8fe851773a748ef0f23f7997c76b26e74d0d94f' \
    && echo "$dotnet_sha512 dotnet.tar.gz" | sha512sum -c - \
    && mkdir -p /usr/share/dotnet \
    && tar -zxf dotnet.tar.gz -C /usr/share/dotnet \
    && rm dotnet.tar.gz 

ENV DETECT_DOTNET_PATH /usr/share/dotnet/dotnet

# Download detect script
RUN mkdir -p /app
RUN curl -o /app/detect.sh https://detect.synopsys.com/detect.sh

RUN chmod +x /app/detect.sh

RUN /app/detect.sh --help

ADD /6/dotnetcore-2.2.110/scripts/entrypoint.sh /app/entrypoint.sh

RUN chmod +x /app/entrypoint.sh
ENTRYPOINT [ "/app/entrypoint.sh" ]

ADD REPO .
ADD TAGS .

CMD /app/detect.sh --blackduck.hub.url="${HUB_URL}" --blackduck.hub.api.token="${HUB_TOKEN}" --blackduck.hub.trust.cert=true --detect.policy.check=true
