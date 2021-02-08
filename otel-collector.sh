#!/bin/bash
if [ "${CODESPACES}" != "true" ]; then
    echo 'Not in a codespace. Aborting.'
    exit 0
fi

sed -i -e 's/TOKEN/$LS_ACCESS_TOKEN/g' .collector-config.yaml

OTEL_COLLECTOR_VERSION=0.19.0
OTEL_COLLECTOR_URL=https://github.com/open-telemetry/opentelemetry-collector-contrib/releases/download/v$OTEL_COLLECTOR_VERSION/otel-contrib-collector_$OTEL_COLLECTOR_VERSION\_amd64.deb
OTEL_COLLECTOR_PATH=/var/otelcontribcol/otel-contrib-collector.deb
wget $OTEL_COLLECTOR_URL $OTEL_COLLECTOR_PATH
sudo apt install $OTEL_COLLECTOR_PATH
otelcontribcol --config=~/.collector-config.yaml & disown