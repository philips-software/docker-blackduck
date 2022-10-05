#!/bin/bash

# Check if we should enable airgap
if [[ ! -z "${DETECT_AIR_GAP}" ]]; then
    if [ -d /airgap/packaged-inspectors/gradle ]; then
        export DETECT_GRADLE_INSPECTOR_AIR_GAP_PATH=/airgap/packaged-inspectors/gradle/
        echo "[entrypoint] Setting AIRGAP Gradle inspector: $DETECT_GRADLE_INSPECTOR_AIR_GAP_PATH"
    fi
fi

# Enable Gradle HTTPS proxy support
if [[ ! -z "${HTTPS_PROXY}" ]]; then
    export https_proxy_settings=$HTTPS_PROXY
fi

if [[ ! -z "${https_proxy}" ]]; then
    export https_proxy_settings=$https_proxy
fi

pattern='^(([[:alnum:]]+)://)?(([[:alnum:]]+)@)?([^:^@]+)(:([[:digit:]]+))?$'
if [[ "$https_proxy_settings" =~ $pattern ]]; then
        host=${BASH_REMATCH[5]}
        port=${BASH_REMATCH[7]}
        export GRADLE_OPTS="$GRADLE_OPTS -Dhttps.proxyHost=$host -Dhttps.proxyPort=$port"
        export MAVEN_OPTS="$MAVEN_OPTS -Dhttps.proxyHost=$host -Dhttps.proxyPort=$port -X"
        echo "[entrypoint] Setting GRADLE_OPTS: $GRADLE_OPTS"
        echo "[entrypoint] Setting MAVEN_OPTS: $MAVEN_OPTS"
fi

exec "$@"
