pgAdmin 4
=========

pgAdmin4 is a rewrite of the popular pgAdmin3 management tool for the
PostgreSQL (http://www.postgresql.org) database. 

This build script has been updated to build pgAdmin4 version 8.9 on July 7/2024

**Note:** Nodejs and Yarn versions used to build package:
 - Nodejs version 21.1.0
 - Yarn version 1.22.19

Note: use nwjs version "0.77.0" from https://dl.nwjs.io/

NOTE:
PgAdmin4 version 8.9 requires "node" version: 18.18.0 || 20.9.0 || >= 21.1.0
Upgraded "node" to version 21.1.0 using Willy's script from https://slackbuilds.org/

The pgAdmin4 executable uses Python3 Virtual Environment; this build script does
NOT alter any of Slackware64 python3 installation.

This is a slackbuild script for building pgAdmin4 package for slackware.
The script was inspired by a thread on Linux Questions Slackware forum
"https://www.linuxquestions.org/questions/slackware-14/building-pgadmin-4-in-slackware-current-4175648889"
 
The build script in this repository has been restructured along with the package
file system layout, the package is installed under /opt directory.

The info file "DOWNLOAD" line is NOT confirming to any standard! You may need
to adjust your script - if you use this - or edit the info file.
There are 2 lines with "DOWNLOAD1" and "DOWNLOAD2" prefixes.

I hope somebody will find this script helpful.

Wael Hammoudeh  

07/07/2024
