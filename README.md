pgAdmin 4
=========

pgAdmin4 is a rewrite of the popular pgAdmin3 management tool for the
PostgreSQL (http://www.postgresql.org) database. 

This build script has been updated for pgAdmin4 version 6.1 which uses nodejs.

This is a slackbuild script for building pgAdmin4 package for slackware.
The script was inspired by a thread on Linux Questions Slackware forum
"https://www.linuxquestions.org/questions/slackware-14/building-pgadmin-4-in-slackware-current-4175648889"
 
The build script in this repository has been restructured along with the package
file system lay out, the package root directory now is under /opt directory.

    A note about Slackware upgrading to python3 version 3.10.0:

This program "pgAdmin4" uses python3 extensively, the python3 upgrade is for a
major version - not a bug fix upgrade - the language changed here. It will take time
for developers to change / fix code. I hope that pgAdmin4 will support python3
version 3.10 soon.
This build script was written and used with python3 version 3.9.7 installed.

I hope somebody will find this script helpful.

Wael Hammoudeh
October 22/2021
