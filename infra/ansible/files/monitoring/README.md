# Monitoring Stack Guide

This stack deploys Grafana, Prometheus, Alertmanager, Node Exporter, Blackbox Exporter, and MongoDB Exporter.

## What Is Monitored

- Host hardware: CPU, memory, root disk usage, and network throughput through Node Exporter.
- Project database: MongoDB scrape health, MongoDB reachability, connections, operations, and memory through Percona MongoDB Exporter.
- HTTP endpoint availability through Blackbox Exporter.

## Deploy

Run the full VPS playbook from the Ansible directory:

```sh
cd infra/ansible
ansible-playbook -i hosts.ini install_vps.yml
```

Optional Grafana admin credentials and Gmail alert credentials can be supplied from your shell before running Ansible:

```sh
export GRAFANA_ADMIN_USER=admin
export GRAFANA_ADMIN_PASSWORD='replace-with-a-strong-password'
export ALERTMANAGER_SMTP_PASSWORD='your-gmail-app-password'
ansible-playbook -i hosts.ini install_vps.yml
```

If those variables are not set, the playbook uses `admin` / `admin123`.
Alertmanager is configured to send email through Gmail using `kennynguyen110702@gmail.com` by default.
`ALERTMANAGER_SMTP_PASSWORD` enables email notifications and should be the Gmail app password, with or without spaces.
If it is not set, the playbook also checks local file `infra/ansible/.alertmanager_smtp_password`.
If neither source is present, the monitoring stack still deploys, but Alertmanager keeps the placeholder receiver and does not send email.

Optional Alertmanager overrides:

```sh
export ALERTMANAGER_EMAIL='kennynguyen110702@gmail.com'
export ALERTMANAGER_EMAIL_TO='receiver@example.com'
export ALERTMANAGER_SMTP_USERNAME='kennynguyen110702@gmail.com'
export ALERTMANAGER_SMTP_SMARTHOST='smtp.gmail.com:587'
```

## Open The UI

- Grafana: `http://<server-ip>:3000`
- Prometheus: `http://<server-ip>:9090`
- Alertmanager: `http://<server-ip>:9093`

Grafana is provisioned automatically:

- Datasource: `Prometheus`
- Dashboard folder: `Final Project`
- Dashboard: `Final Project - Host and MongoDB`

No manual Grafana datasource setup is required. After login, open `Dashboards` -> `Final Project` -> `Final Project - Host and MongoDB`.

## UI Checks After Deploy

1. In Grafana, confirm the dashboard panels show data for CPU, memory, disk, and MongoDB.
2. In Prometheus, open `Status` -> `Targets` and confirm these jobs are `UP`: `node-exporter`, `mongodb-exporter`, `blackbox-http`, `prometheus`, `alertmanager`.
3. In Prometheus, open `Alerts` and confirm the rules from `alerts.yml` are loaded.

## Updating HTTP Probe Targets

Edit `prometheus.yml` under the `blackbox-http` job:

```yaml
static_configs:
  - targets:
      - http://frontend:3000
      - https://final-project.nguyentrungkien.net
```

For Docker services, use a service and port that return HTTP 2xx from the production app network. For public URLs, use the full external URL.

## Alert Delivery

Alertmanager email delivery is generated from `templates/alertmanager.yml.j2`.
After deploying with `ALERTMANAGER_SMTP_PASSWORD`, open `http://<server-ip>:9093/#/status` and verify the active receiver is `gmail`.
To test an alert path, temporarily stop one monitored container, wait for the alert's `for` duration, then start it again and confirm the resolved email arrives.
