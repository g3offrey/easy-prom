#!/bin/bash

useradd --no-create-home --shell /bin/false prometheus
useradd --no-create-home --shell /bin/false node_exporter

mkdir /etc/prometheus
mkdir /var/lib/prometheus

chown prometheus:prometheus /etc/prometheus
chown prometheus:prometheus /var/lib/prometheus

wget https://github.com/prometheus/prometheus/releases/download/v2.22.1/prometheus-2.22.1.linux-amd64.tar.gz
tar xvf ./prometheus-2.22.1.linux-amd64.tar.gz

cp ./prometheus-2.22.1.linux-amd64/prometheus /usr/local/bin/
cp ./prometheus-2.22.1.linux-amd64/promtool /usr/local/bin/

chown prometheus:prometheus /usr/local/bin/prometheus
chown prometheus:prometheus /usr/local/bin/promtool

cp -r ./prometheus-2.22.1.linux-amd64/consoles /etc/prometheus
cp -r ./prometheus-2.22.1.linux-amd64/console_libraries /etc/prometheus

chown -R prometheus:prometheus /etc/prometheus/consoles
chown -R prometheus:prometheus /etc/prometheus/console_libraries

cp ./etc/prometheus/prometheus.yml /etc/prometheus/prometheus.yml
chown prometheus:prometheus /etc/prometheus/prometheus.yml

cp ./etc/systemd/system/prometheus.service /etc/systemd/system/prometheus.service
systemctl daemon-reload
systemctl start prometheus
systemctl enable prometheus

wget https://github.com/prometheus/node_exporter/releases/download/v1.0.1/node_exporter-1.0.1.linux-amd64.tar.gz
tar xvf ./node_exporter-1.0.1.linux-amd64.tar.gz

cp ./node_exporter-1.0.1.linux-amd64/node_exporter /usr/local/bin

chown node_exporter:node_exporter /usr/local/bin/node_exporter

cp ./etc/systemd/system/node_exporter.service /etc/systemd/system/node_exporter.service
systemctl daemon-reload
systemctl start node_exporter
systemctl enable node_exporter

rm -rf ./node_exporter-*
rm -rf ./prometheus-*
