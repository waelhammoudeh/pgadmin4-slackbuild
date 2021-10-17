#!/bin/bash

# doc python virtual environment to build pgAdmin4 documentation with slackware package.
# pass root directory where to create temporary PVE to script.

CWD=$(pwd)

PVE_ROOT=$1
APP_PVE=docpve

# remove if left over
rm -f requirements.txt

# File requirements.txt was copied from pgAmin4 version 6.0 source tar ball

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

Flask==1.*
Flask-Gravatar==0.*
Flask-Login==0.*
Flask-Mail==0.*
Flask-Migrate==2.*
Flask-SQLAlchemy==2.*
Flask-WTF==0.*
Flask-Compress==1.*
passlib==1.*
pytz==2021.*
simplejson==3.*
six==1.*
speaklater3==1.*
sqlparse==0.*
WTForms==2.*
Flask-Paranoid==0.*
psutil==5.*
psycopg2==2.8.*
python-dateutil==2.*
SQLAlchemy==1.3.*
itsdangerous<=1.1.0
Flask-Security-Too==4.*
bcrypt==3.*
cryptography==3.*
sshtunnel==0.*
ldap3==2.*
Flask-BabelEx==0.*
gssapi==1.6.*
flask-socketio>=5.0.1
eventlet==0.31.0
httpagentparser==1.9.*
user-agents==2.2.0
pywinpty==1.1.1; sys_platform=="win32"
Authlib==0.15.*
requests==2.25.*

END

# tell user what we are doing
echo "Making Python Virual Environment ..."

# use python3
PY_EXEC=/usr/bin/python3

# create PVE_ROOT directory if it does not exist
if [ ! -d $PVE_ROOT ]; then
  echo "Creating directory: $PVE_ROOT"
  mkdir $PVE_ROOT
fi

cd $PVE_ROOT

# create - initial APP_PVE for pgAdimin4
$PY_EXEC -m venv $APP_PVE

# activate virtual environment to install required modules
source $APP_PVE/bin/activate

# install required python modules
# pip install --upgrade pip @@@@ very BAD BAD BAD idea DO NOT DO IT !!!

echo "Installing required python MODULES for pgAdmin4"

# pip3 install --no-cache-dir Sphinx -r $CWD/requirements.txt

pip3 install Sphinx -r $CWD/requirements.txt

# source: _create_python_virtualenv() function in SOURCE/pkg/linux/build-functions.sh
# Figure out some paths for use when completing the venv
# Use "python3" here as we want the venv path

PYMODULES_PATH=$(python3 -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())")
DIR_PYMODULES_PATH=`dirname ${PYMODULES_PATH}`

# Use /usr/bin/python3 here as we want the system path
PYSYSLIB_PATH=$(/usr/bin/python3 -c "import sys; \
                print('%s/lib64/python%d.%.d' % (sys.prefix, sys.version_info.major, sys.version_info.minor))")

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

# remove requirements text file
rm $CWD/requirements.txt

# be nice
deactivate

cd $CWD
