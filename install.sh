#!/bin/bash

ARCHITECTURE=${ARCH:="linux-amd64"}
PROMETHEUS_VERSION=${PROM_VERSION:="2.22.1"}
NODE_EXPORTER_VERSION=${NE_VERSION:="1.0.1"}

PROMETHEUS_RELEASE=prometheus-$PROMETHEUS_VERSION.$ARCHITECTURE
NODE_EXPORTER_RELEASE=node_exporter-$NODE_EXPORTER_VERSION.$ARCHITECTURE

useradd --no-create-home --shell /bin/false prometheus
useradd --no-create-home --shell /bin/false node_exporter

mkdir /etc/prometheus
mkdir /var/lib/prometheus

chown prometheus:prometheus /etc/prometheus
chown prometheus:prometheus /var/lib/prometheus

wget https://github.com/prometheus/prometheus/releases/download/v$PROMETHEUS_VERSION/$PROMETHEUS_RELEASE.tar.gz
tar xvf ./$PROMETHEUS_RELEASE.tar.gz

cp ./$PROMETHEUS_RELEASE/prometheus /usr/local/bin/
cp ./$PROMETHEUS_RELEASE/promtool /usr/local/bin/

chown prometheus:prometheus /usr/local/bin/prometheus
chown prometheus:prometheus /usr/local/bin/promtool

cp -r ./$PROMETHEUS_RELEASE/consoles /etc/prometheus
cp -r ./$PROMETHEUS_RELEASE/console_libraries /etc/prometheus

chown -R prometheus:prometheus /etc/prometheus/consoles
chown -R prometheus:prometheus /etc/prometheus/console_libraries

cp ./etc/prometheus/prometheus.yml /etc/prometheus/prometheus.yml
chown prometheus:prometheus /etc/prometheus/prometheus.yml

cp ./etc/systemd/system/prometheus.service /etc/systemd/system/prometheus.service
systemctl daemon-reload
systemctl start prometheus
systemctl enable prometheus

wget https://github.com/prometheus/node_exporter/releases/download/v$NODE_EXPORTER_VERSION/$NODE_EXPORTER_RELEASE.tar.gz
tar xvf ./$NODE_EXPORTER_RELEASE.tar.gz

cp ./$NODE_EXPORTER_RELEASE/node_exporter /usr/local/bin

chown node_exporter:node_exporter /usr/local/bin/node_exporter

cp ./etc/systemd/system/node_exporter.service /etc/systemd/system/node_exporter.service
systemctl daemon-reload
systemctl start node_exporter
systemctl enable node_exporter

rm -rf ./node_exporter-*
rm -rf ./prometheus-*
