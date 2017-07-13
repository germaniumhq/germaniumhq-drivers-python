#!/usr/bin/env bash

# fail fast
set -e

# we source to set the right environment
. /home/ciplogic/python/bin/activate

#############################################################################
# Utility functions.
#############################################################################
function deactivate_proxy() {
    set old_http_proxy="$http_proxy"
    set old_https_proxy="$https_proxy"
    set old_ftp_proxy="$ftp_proxy"
    unset http_proxy
    unset https_proxy
    unset ftp_proxy
}

function activate_proxy() {
    set http_proxy="$old_http_proxy"
    set https_proxy="$old_https_proxy"
    set ftp_proxy="$old_ftp_proxy"
}

deactivate_proxy

#############################################################################
# Do the actual publish
#############################################################################

# make sure we know about the nexus package index
cp /scripts/_pypirc_nexus ~/.pypirc

# publish
cd /tmp/project
python setup.py sdist upload -r nexus
