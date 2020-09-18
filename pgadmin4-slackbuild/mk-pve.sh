#!/bin/sh -e

# This is a simple script to create Python Virtual Environment for pgAdmin4.
# pgAdmin4 developers recommend running it under Python Virtual Environment.
# I also build pgAdmin4 slackware package under this Python Virtual Environment.
# ------------------------------------------------------------------
# NOTE ***** INTERNET CONNECTION IS REQUIRED FOR THIS SCRIPT *******
#      *****     NO CONNECTION CHECKING IS DONE HERE !!!     ******* 
# ------------------------------------------------------------------

# Python Virtual Environment ROOT "pve" is created under /usr/local directory.
# This makes "PVE_ROOT=/usr/local/pve".
# Script makes application virtual environment directory under PVE_ROOT; it 
# becomes: "APP_PVE=/usr/local/pve/pgAdmin4-pve", script then installs all
# required python packages plus "sphinx" - required to make documentation.
# If script finds APP_PVE directory, it exits and does nothing.
#
# See _create_python_virtualenv() function in SRC/pkg/linux/build-functions.sh

CWD=$(pwd)

rm -f requirements.txt

# File requirements.txt was copied from pgAmin4-4.22 source tar ball
install --mode=644 /dev/stdin "$CWD/requirements.txt" <<END
###############################################################################
#
# IMPORTANT:
#
# If runtime or build time dependencies are changed in this file, the committer
# *must* ensure the DEB and RPM package maintainers are informed as soon as
# possible.
#
###############################################################################


##############################################################################
# NOTE: Any requirements with environment specifiers must be explicitly added
#       to pkg/pip/setup_pip.py (in extras_require), otherwise they will be
#       ignored when building a PIP Wheel.
##############################################################################
blinker==1.4
Flask==1.0.2
Werkzeug>=0.15.0
Flask-Gravatar==0.5.0
Flask-Login==0.4.1
Flask-Mail==0.9.1
Flask-Migrate==2.4.0
Flask-Principal==0.4.0
Flask-SQLAlchemy==2.4.1
Flask-WTF==0.14.3
Flask-Compress==1.4.0
passlib==1.7.2
pytz==2018.9
simplejson==3.16.0
six>=1.12.0
speaklater==1.3
sqlparse==0.2.4
WTForms==2.2.1
Flask-Paranoid==0.2.0
psutil>=5.7.0
psycopg2>=2.8
python-dateutil>=2.8.0
SQLAlchemy>=1.3.13
Flask-Security-Too>=3.0.0
sshtunnel>=0.1.4
ldap3>=2.5.1
END

# postgresql is required to build pgAdmin4 - not part of slackware-current
# Is postgresql package installed?
PG_PKG=$(ls /var/lib/pkgtools/packages/postgresql*)

# empty string from ls command above indecates missing PostgreSQL package
if [ -z "$PG_PKG" ]; then
    echo "PostgreSQL package not found. Please install PostgreSQL with"
    echo "slackpkg. Exiting!"
    exit 1;
fi

# get postgresql bin directory path; needed to install psycopg2 python module.
# pg_config file is usually installed in postgresql bin directory
PG_BIN_PART1=$(cat $PG_PKG | egrep "*/bin/pg_config")

# empty string means missed up installation!
if [ -z "$PG_BIN_PART1" ]; then
    echo "ERROR: Could not get path for PostgreSQL bin directory."
    echo "Exiting!"
    exit 1;
fi

# prepend leading slash to directory
PG_BIN_PART2=/$PG_BIN_PART1

# This is pg_config file which MUST exist in file system
if [ ! -f "$PG_BIN_PART2" ]; then
    echo "ERROR: Could not find pg_config file."
    echo "Exiting"
    exit 1;
fi

# extract pathname using dirname
PG_BIN_PATH=$(dirname "$PG_BIN_PART2")

# add postgresql bin directory to PATH
PATH=$PATH:$PG_BIN_PATH

PVE_ROOT=/usr/local/pve
PY_EXEC=/usr/bin/python3
APP_PVE=$PVE_ROOT/pgAdmin4-pve

if [ -d $APP_PVE ]; then
  echo ""
  echo "Found existing pgAdmin4 python virtual environment at:"
  echo ""
  echo "     $APP_PVE"
  echo ""
  echo "If you want to update pgAdmin4 python virtual environment,"
  echo "please remove its directory first."
  echo "Exiting."
  echo ""
  exit;
fi

# tell user what we are doing
echo "Making Python Virual Environment ..."

# create root directory if it does not exist
if [ ! -d $PVE_ROOT ]; then
  echo "Creating directory: $PVE_ROOT"
  mkdir $PVE_ROOT
fi

cd $PVE_ROOT

# create PVE for pgAdimin4 
$PY_EXEC -m venv $APP_PVE

echo "Created PVE at $APP_PVE"

# activate virtual environment to install required modules
source $APP_PVE/bin/activate

# install required python modules
# pip install --upgrade pip @@@@ very BAD BAD BAD idea DO NOT DO IT !!!
# File requirements.txt was copied from pgAmin4-4.19 tar ball
echo "Installing required python MODULES for pgAdmin4"

pip3 install --no-cache-dir --no-binary psycopg2 sphinx -r $CWD/requirements.txt

# Sphinx is needed to build documentation
# pip3 install sphinx //moved to above line

# source: _create_python_virtualenv() function in SRC/pkg/linux/build-functions.sh
# Figure out some paths for use when completing the venv
# Use "python3" here as we want the venv path
PYMODULES_PATH=$(python3 -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())")
DIR_PYMODULES_PATH=`dirname ${PYMODULES_PATH}`

# Use /usr/bin/python3 here as we want the system path
PYSYSLIB_PATH=$(/usr/bin/python3 -c "import sys; \
                print('%s/lib64/python%d.%.d' % (sys.prefix, sys.version_info.major, sys.version_info.minor))")
#
#
# Symlink in the rest of the Python libs. This is required because the runtime
# will clear PYTHONHOME for safety, which has the side-effect of preventing
# it from finding modules that are not explicitly included in the venv
cd ${DIR_PYMODULES_PATH}

# Files
for FULLPATH in ${PYSYSLIB_PATH}/*.py; do
  FILE=${FULLPATH##*/}
    if [ ! -e ${FILE} ]; then
      ln -s ${FULLPATH} ${FILE}
    fi
done

# Paths
for FULLPATH in ${PYSYSLIB_PATH}/*/; do
  FULLPATH=${FULLPATH%*/}
  FILE=${FULLPATH##*/}
  if [ ! -e ${FILE} ]; then
    ln -s ${FULLPATH} ${FILE}
  fi
done

# Remove tests
cd site-packages
find . -name "test" -type d -print0 | xargs -0 rm -rf
find . -name "tests" -type d -print0 | xargs -0 rm -rf

# Link the python<version> directory to python so that the private environment path is found by the application.
if test -d ${DIR_PYMODULES_PATH}; then
  ln -s $(basename ${DIR_PYMODULES_PATH}) ${DIR_PYMODULES_PATH}/../python
fi

echo ""
echo " All done; to use virtual environment just source the script like:" 
echo " source $APP_PVE/bin/activate"
echo " and to exit or terminate just issue:"
echo " deactivate"
echo ""

# be nice
deactivate
cd $CWD