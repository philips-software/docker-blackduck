#!/bin/bash

# Check if we should enable airgap
if [[ ! -z "${DETECT_AIR_GAP}" ]]; then
    if [ -d /airgap/packaged-inspectors/nuget ]; then
        export DETECT_NUGET_INSPECTOR_AIR_GAP_PATH=/airgap/packaged-inspectors/nuget/
        echo "[entrypoint] Setting AIRGAP NuGet inspector: $DETECT_NUGET_INSPECTOR_AIR_GAP_PATH"
    fi
fi

exec "$@"
