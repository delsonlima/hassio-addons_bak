#!/usr/bin/with-contenv bashio

export LOG_LEVEL="trace"

bashio::log.info "Configuring Matrix Synapse..."

DATA_DIR="$(bashio::config 'data_dir')"
LOG_DIR="${DATA_DIR}/logs"
SERVER_NAME="$(bashio::config 'server_name')"
REPORT_STATS="$(bashio::config 'report_stats')"
SERVER_CONF="${DATA_DIR}/homeserver.yaml"
LOG_CONF="${DATA_DIR}/${SERVER_NAME}.log.config"
ENABLE_STATS=$([ "$REPORT_STATS" = true ] && echo "yes" || echo "no")

mkdir -p "${DATA_DIR}"
mkdir -p "${LOG_DIR}"

synapse_homeserver \
    --data-directory "${DATA_DIR}" \
    --config-path "${SERVER_CONF}" \
    --server-name "${SERVER_NAME}" \
    --generate-config \
    --report-stats="${ENABLE_STATS}"

SERVER_CONF_CONTENT=$(cat "${SERVER_CONF}")
LOG_CONF_CONTENT=$(cat "${LOG_CONF}")

yq '.listeners[0].bind_addresses = ["0.0.0.0"]' \
  <<< "$SERVER_CONF_CONTENT" \
  > "${SERVER_CONF}"

LOG_FILE="${LOG_DIR}/homeserver.log" \
  yq '.handlers.file.filename = env(LOG_FILE)' \
    <<< "${LOG_CONF_CONTENT}" \
    > "${LOG_CONF}"

bashio::log.info "Starting Matrix Synapse..."

exec synapse_homeserver --config-path "${SERVER_CONF}"