#!/usr/bin/env bash

# fail fast
set -e

# we source to set the right environment
. /home/ciplogic/python/bin/activate

#############################################################################
# Utility functions.
#############################################################################
function deactivate_proxy() {
    old_http_proxy="$http_proxy"
    old_https_proxy="$https_proxy"
    old_ftp_proxy="$ftp_proxy"
    unset http_proxy
    unset https_proxy
    unset ftp_proxy
}

function activate_proxy() {
    http_proxy="$old_http_proxy"
    https_proxy="$old_https_proxy"
    ftp_proxy="$old_ftp_proxy"
}

deactivate_proxy

# we checkout the sources of the project
git clone --recursive $SOURCES_URL /tmp/project

cd /tmp/project

#############################################################################
# Get the dependencies, and binary drivers.
#############################################################################
activate_proxy

pip install -r requirements.txt
bin/download-drivers.sh

deactivate_proxy

#############################################################################
# Run the actual tests on the binary drivers
#############################################################################
behave -t @chrome,@firefox

