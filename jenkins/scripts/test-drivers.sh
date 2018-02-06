#!/usr/bin/env bash

# fail fast
set -e

# we source to set the right environment
. /home/ciplogic/python/bin/activate

# we checkout the sources of the project
git clone --recursive $SOURCES_URL /tmp/project

cd /tmp/project

#############################################################################
# Get the dependencies, and binary drivers.
#############################################################################
activate_proxy

set

pip install -r requirements.txt
bin/download-drivers.sh

deactivate_proxy

#############################################################################
# Run the actual tests on the binary drivers
#############################################################################
TAGS="placeholder"

if [[ "$RUN_CHROME_TESTS" == "true" ]]; then
    TAGS="$TAGS,chrome"
fi # [[ "$RUN_CHROME_TESTS" == "true" ]]

if [[ "$RUN_FIREFOX_TESTS" == "true" ]]; then
    TAGS="$TAGS,firefox"
fi # [[ "$RUN_FIREFOX_TESTS" == "true" ]]

behave -t $TAGS

