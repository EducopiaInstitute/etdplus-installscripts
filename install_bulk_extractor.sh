#!/bin/bash

# Install Bulk Extractor
set -o errexit -o nounset -o xtrace -o pipefail

# Read settings and environmental overrides
# $1 = platform (aws or vagrant); $2 = path to install scripts
[ -f "${2}/config.sh" ] && . "${2}/config.sh"
[ -f "${2}/config_${1}.sh" ] && . "${2}/config_${1}.sh"

$RUN_AS_INSTALLUSER mkdir -p "$INSTALL_DIR/bulk_extractor/hashdb"
cd "$INSTALL_DIR/bulk_extractor/hashdb/"

apt-get install -y gcc g++ libxml2-dev libssl-dev libtre-dev pkg-config libtool make

$RUN_AS_INSTALLUSER wget --quiet "http://digitalcorpora.org/downloads/hashdb/old/hashdb-${HASHDB_VERSION}.tar.gz"
$RUN_AS_INSTALLUSER tar -xzf "./hashdb-${HASHDB_VERSION}.tar.gz" --strip-components=1

$RUN_AS_INSTALLUSER ./configure
$RUN_AS_INSTALLUSER make
make install

cd "$INSTALL_DIR/bulk_extractor"

apt-get install -y gcc g++ flex libewf-dev

$RUN_AS_INSTALLUSER wget --quiet "http://digitalcorpora.org/downloads/bulk_extractor/bulk_extractor-${BULK_EXTRACTOR_VERSION}.tar.gz"
$RUN_AS_INSTALLUSER tar -xzf "./bulk_extractor-${BULK_EXTRACTOR_VERSION}.tar.gz" --strip-components=1

$RUN_AS_INSTALLUSER ./configure
$RUN_AS_INSTALLUSER make
make install
