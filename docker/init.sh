#!bin/bash

if [ -d "/home/frappe/frappe-bench/apps/frappe" ]; then
    echo "Bench already exists, skipping init"
    cd frappe-bench
    bench start
else
    echo "Creating new bench..."
fi

bench init --skip-redis-config-generation frappe-bench --version version-15

cd frappe-bench

# Use containers instead of localhost
bench set-mariadb-host mariadb
bench set-redis-cache-host redis://redis:6379
bench set-redis-queue-host redis://redis:6379
bench set-redis-socketio-host redis://redis:6379

# Remove redis, watch from Procfile
sed -i '/redis/d' ./Procfile
sed -i '/watch/d' ./Procfile

bench get-app crm --branch main

bench new-site frappe.pontoads.com.br \
    --force \
    --mariadb-root-password Rise26120092@ \
    --admin-password admin \
    --no-mariadb-socket

bench --site frappe.pontoads.com.br install-app crm
bench --site frappe.pontoads.com.br set-config developer_mode 1
bench --site frappe.pontoads.com.br set-config mute_emails 1
bench --site frappe.pontoads.com.br set-config server_script_enabled 1
bench --site frappe.pontoads.com.br clear-cache
bench use frappe.pontoads.com.br

bench start
