#!/usr/bin/env bash

GERMANIUM_FOLDER=$(readlink -f $(dirname $0)/..)

set -e

. $GERMANIUM_FOLDER/bin/driver_versions

#
# Check the Chrome Driver version.
#
echo -n "Checking Chrome Driver $CHROMEDRIVER_VERSION ... "

CHROME_VERSION=$(wget -q -O - http://chromedriver.storage.googleapis.com/LATEST_RELEASE)

if [[ "$CHROME_VERSION" != "$CHROMEDRIVER_VERSION" ]]; then
    echo "NOPE"
    echo "Newer Chrome Version: $CHROME_VERSION is available"
else # not [[ "CHROME_VERSION" != "$CHROMEDRIVER_VERSION" ]]
    echo "OK"
fi   # else [[ "CHROME_VERSION" != "$CHROMEDRIVER_VERSION" ]]

#
# Check the Marionette/Firefox Driver Version
#

echo -n "Checking Firefox (Marionette) Driver $FIREFOXDRIVER_VERSION ... "

FIREFOX_VERSION=$(wget -q -O - https://github.com/mozilla/geckodriver/releases.atom | grep '<title>v' | perl -pe 's|\s*<title>v(.*?)</title>|$1|' | head -n 1)

if [[ "$FIREFOX_VERSION" != "$FIREFOXDRIVER_VERSION" ]]; then
    echo "NOPE"
    echo "Newer Firefox Marionette Version: $FIREFOX_VERSION"
else # not [[ "$FIREFOX_VERSION" != "$FIREFOXDRIVER_VERSION" ]]
    echo "OK"
fi   # else [[ "$FIREFOX_VERSION" != "$FIREFOXDRIVER_VERSION" ]]

#
# Check the IE Driver Version
#
echo -n "Checking IE Driver $IEDRIVER_VERSION ... "

IE_VERSION=$(wget -q -O - http://www.seleniumhq.org/download/ | grep "selenium-release" | grep IEDriver | grep Win32 | perl -pe 's|.*_Win32_(.*?).zip.*|$1|')

if [[ "$IEDRIVER_VERSION" != "$IE_VERSION" ]]; then
    echo "NOPE"
    echo "Newer IE Driver Version: $IE_VERSION"
else # not [[ "$IEDRIVER_VERSION" != "$IE_VERSION" ]]
    echo "OK"
fi   # else [[ "$IEDRIVER_VERSION" != "$IE_VERSION" ]]

