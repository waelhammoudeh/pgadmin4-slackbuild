#!/bin/sh

# Wrapper script to start pgAdmin4 under Python Virtual Environment

PVE_ROOT=/usr/local/pve/
APP_PVE=pgAdmin4-pve56
VERSION=5.6

ARCH=$( uname -m )  
LIBDIRSUFFIX=""
if [ "$ARCH" = "x86_64" ]; then
  LIBDIRSUFFIX="64"
fi

APP_DIR=/usr/lib$LIBDIRSUFFIX/pgadmin4-$VERSION/runtime

# activate python virtual environment
if [ ! -f $PVE_ROOT/$APP_PVE/bin/activate ]; then
  echo ""
  echo "Missing or wrong path to application Python Virtual Environment!"
  echo "This application requires Python Virtual Environment to be"
  echo "initialed by \"mk-pve.sh\" found with build script source."
  echo "Please see \"README.PVE\" file with build srcipt source."  
  echo "You need to run or rerun the script \"mk-pve.sh\"!?"
  echo ""
  exit 1;
fi

source $PVE_ROOT/$APP_PVE/bin/activate

cd $APP_DIR

node_modules/nw/nwjs/nw .

