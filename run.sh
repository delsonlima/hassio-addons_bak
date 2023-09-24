#!/usr/bin/with-contenv bashio

export LOG_LEVEL="trace"

bashio::log.info "Configuring Matrix Synapse..."

DATA_DIR="$(bashio::config 'data_dir')"
SERVER_NAME="$(bashio::config 'server_name')"
REPORT_STATS="$(bashio::config 'report_stats')"
SERVER_CONF="${DATA_DIR}/homeserver.yaml"
ENABLE_STATS=$([ "$REPORT_STATS" = true ] && echo "yes" || echo "no")

mkdir -p "${DATA_DIR}"

synapse_homeserver \
    --data-directory "${DATA_DIR}" \
    --config-path "${SERVER_CONF}" \
    --server-name "${SERVER_NAME}" \
    --generate-config \
    --report-stats="${ENABLE_STATS}"

SERVER_CONF_CONTENT=$(cat "${SERVER_CONF}")

yq '.listeners[0].bind_addresses = ["0.0.0.0"]' <<< "$SERVER_CONF_CONTENT" > "${SERVER_CONF}"

bashio::log.info "Starting Matrix Synapse..."

exec synapse_homeserver --config-path "${SERVER_CONF}"