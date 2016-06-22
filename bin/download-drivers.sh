#!/usr/bin/env bash

GERMANIUM_FOLDER=$(readlink -f $(dirname $0)/..)

rm -fr $GERMANIUM_FOLDER/germaniumdrivers/binary
mkdir $GERMANIUM_FOLDER/germaniumdrivers/binary

CHROMEDRIVER_VERSION=2.22
FIREFOXDRIVER_VERSION=0.8.0
IEDRIVER_VERSION=2.53.1
IEDRIVER_VERSION_MAJOR=2.53

#
# Chrome drivers
#
mkdir -p $GERMANIUM_FOLDER/germaniumdrivers/binary/chrome/linux/64
mkdir -p $GERMANIUM_FOLDER/germaniumdrivers/binary/chrome/linux/32
mkdir -p $GERMANIUM_FOLDER/germaniumdrivers/binary/chrome/win/32
mkdir -p $GERMANIUM_FOLDER/germaniumdrivers/binary/chrome/mac/32

rm -fr /tmp/germaniumdrivers
mkdir -p /tmp/germaniumdrivers
cd /tmp/germaniumdrivers
wget http://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux32.zip
wget http://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip
wget http://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_win32.zip
wget http://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_mac32.zip

cd $GERMANIUM_FOLDER/germaniumdrivers/binary/chrome/linux/64
unzip /tmp/germaniumdrivers/chromedriver_linux64.zip
cd $GERMANIUM_FOLDER/germaniumdrivers/binary/chrome/linux/32
unzip /tmp/germaniumdrivers/chromedriver_linux32.zip
cd $GERMANIUM_FOLDER/germaniumdrivers/binary/chrome/win/32
unzip /tmp/germaniumdrivers/chromedriver_win32.zip
cd $GERMANIUM_FOLDER/germaniumdrivers/binary/chrome/mac/32
unzip /tmp/germaniumdrivers/chromedriver_mac32.zip

#
# Firefox drivers
#
mkdir -p $GERMANIUM_FOLDER/germaniumdrivers/binary/firefox/linux/64
mkdir -p $GERMANIUM_FOLDER/germaniumdrivers/binary/firefox/win/32
mkdir -p $GERMANIUM_FOLDER/germaniumdrivers/binary/firefox/mac/32

cd /tmp/germaniumdrivers
wget https://github.com/mozilla/geckodriver/releases/download/v$FIREFOXDRIVER_VERSION/geckodriver-$FIREFOXDRIVER_VERSION-linux64.gz
wget https://github.com/mozilla/geckodriver/releases/download/v$FIREFOXDRIVER_VERSION/geckodriver-$FIREFOXDRIVER_VERSION-OSX.gz
wget https://github.com/mozilla/geckodriver/releases/download/v$FIREFOXDRIVER_VERSION/geckodriver-v$FIREFOXDRIVER_VERSION-win32.zip

cd $GERMANIUM_FOLDER/germaniumdrivers/binary/firefox/linux/64
gunzip -c /tmp/germaniumdrivers/geckodriver-$FIREFOXDRIVER_VERSION-linux64.gz > geckodriver
chmod +x geckodriver
cd $GERMANIUM_FOLDER/germaniumdrivers/binary/firefox/win/32
unzip /tmp/germaniumdrivers/geckodriver-v$FIREFOXDRIVER_VERSION-win32.zip
cd $GERMANIUM_FOLDER/germaniumdrivers/binary/firefox/mac/32
gunzip -c /tmp/germaniumdrivers/geckodriver-$FIREFOXDRIVER_VERSION-OSX.gz > geckodriver
chmod +x geckodriver

#
# IE Driver
#
mkdir -p $GERMANIUM_FOLDER/germaniumdrivers/binary/ie/win/32
mkdir -p $GERMANIUM_FOLDER/germaniumdrivers/binary/ie/win/64

cd /tmp/germaniumdrivers
wget http://selenium-release.storage.googleapis.com/$IEDRIVER_VERSION_MAJOR/IEDriverServer_Win32_$IEDRIVER_VERSION.zip
wget http://selenium-release.storage.googleapis.com/$IEDRIVER_VERSION_MAJOR/IEDriverServer_x64_$IEDRIVER_VERSION.zip

cd $GERMANIUM_FOLDER/germaniumdrivers/binary/ie/win/32
unzip /tmp/germaniumdrivers/IEDriverServer_Win32_$IEDRIVER_VERSION.zip
cd $GERMANIUM_FOLDER/germaniumdrivers/binary/ie/win/64
unzip /tmp/germaniumdrivers/IEDriverServer_x64_$IEDRIVER_VERSION.zip

