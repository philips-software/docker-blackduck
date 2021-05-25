#!/bin/bash

# Check if we should enable airgap
if [[ ! -z "${DETECT_AIR_GAP}" ]]; then
    if [ -d /airgap/packaged-inspectors/docker ]; then
        export DETECT_DOCKER_INSPECTOR_AIR_GAP_PATH=/airgap/packaged-inspectors/docker/
        echo "[entrypoint] Setting AIRGAP docker inspector: $DETECT_DOCKER_INSPECTOR_AIR_GAP_PATH"
    fi
fi

# Enable docker HTTPS proxy support
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
        export DOCKER_OPTS="$DOCKER_OPTS -Dhttps.proxyHost=$host -Dhttps.proxyPort=$port"
        echo "[entrypoint] Setting DOCKER_OPTS: $DOCKER_OPTS"
fi

exec "$@"