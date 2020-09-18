#!/bin/sh

# Wrapper script to start pgAdmin4 under Python Virtual Environment

PVE_ROOT=/usr/local/pve/
APP_PVE=pgAdmin4-pve

# activate python virtual environment
if [ ! -f $PVE_ROOT/$APP_PVE/bin/activate ]; then
  echo ""
  echo "Missing or wrong path to application Python Virtual Environment!"
  echo "This slackware application rquires Python Virtual Environment to be"
  echo "initialed by \"mk-pve.sh\" found with package source."
  echo "You may want to rerun the script \"mk-pve.sh\"!?"
  echo ""
  exit 1;
fi

source $PVE_ROOT/$APP_PVE/bin/activate

# now start pgAdmin4 executable
/usr/lib64/pgadmin4/runtime/pgAdmin4