#!/bin/sh

# Install PostgreSQL

# Read settings and environmental overrides
# $1 = platform (aws or vagrant); $2 = path to install scripts
[ -f "${2}/config.sh" ] && . "${2}/config.sh"
[ -f "${2}/config_${1}.sh" ] && . "${2}/config_${1}.sh"

cd "$INSTALL_DIR"

apt-get install -y postgresql libpq-dev
$POSTGRESQL_COMMAND psql -c "CREATE USER ${INSTALL_USER} WITH PASSWORD '${DB_PASS}';"
$POSTGRESQL_COMMAND psql -c "CREATE DATABASE ${DB_NAME} WITH OWNER ${INSTALL_USER} ENCODING 'UTF8';"

# Create new config/database.yml that uses PostgreSQL as a DB
cat <<EOF > "${HYDRA_HEAD_DIR}/config/database.yml"
test:
  adapter: sqlite3
  pool: 5
  timeout: 5000
  database: db/test.sqlite3

${APP_ENV}:
  adapter: postgresql
  encoding: UTF8
  database: ${DB_NAME}
  username: ${INSTALL_USER}
  password: ${DB_PASS}
EOF
