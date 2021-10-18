pgAdmin 4
=========

pgAdmin 4 is a rewrite of the popular pgAdmin3 management tool for the
PostgreSQL (http://www.postgresql.org) database. 

The build script has been updated for pgAdmin4 version 6.0 which uses nodejs.

This is a slackbuild script for building pgAdmin4 package for slackware.
The script was inspired by a thread on Linux Questions Slackware forum
"https://www.linuxquestions.org/questions/slackware-14/building-pgadmin-4-in-slackware-current-4175648889"
 
This script uses build functions provided with source code to build slackware64 package.
The python virtual environment is included within the package now. The build function
has been patched to use pre-downloaded "nwjs" tar ball; that is an added download but
only done once.

    A note about Slackware upgrading to python3 version 3.10.0:

This program "pgAdmin4" uses python3 extensively, the python3 upgrade is for a
major version - not a bug fix upgrade - the language changed here. It will take time
for developers to change / fix code. I hope that pgAdmin4 will support python3
version 3.10 soon.
This build script was written and used with python3 version 3.9.7 installed.

I hope somebody will find this script helpful.

Wael Hammoudeh
October 17/2021
