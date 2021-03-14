pgAdmin 4
=========

pgAdmin 4 is a rewrite of the popular pgAdmin3 management tool for the
PostgreSQL (http://www.postgresql.org) database. 

The build script has been updated for pgAdmin4 version 5.0 which uses nodeJS.

This is a slackbuild script for building pgAdmin4 package for slackware.
The script was inspired by a thread on Linux Questions Slackware forum
"https://www.linuxquestions.org/questions/slackware-14/building-pgadmin-4-in-slackware-current-4175648889"
 
Big thank you is due to "bassmadrigal" for his work posted in the above 
mentioned thread. Also thank you to ArchLinux PKGBUILD for pgAdmin4.
My approach was different; using Python Virtual Environment. Please read
the README.PVE file.
PVE is recommended by pgAdmin4 developers, we do not have to provide almost
30 SlackBuilds scripts for required Python modules and PVE does not modify
system Python installation.

There are a lot of tools to create and work with python virtual environment,
some are available at SlackBuilds.org like virtualenvwrapper and virtualenv.
Feel free to use anything you like. In "mk-pve.sh" I used a function provided
with the source code.

I hope somebody will find this script helpful.

Wael Hammoudeh
12/19/2020
