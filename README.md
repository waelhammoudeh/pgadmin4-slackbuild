PgAdmin 4
=========

Slackware64 build script for pgAdmin4 program.

Use the script included here at your OWN risk.

VERSION # 9.6

pgAdmin 4 is written as a web application with Python(Flask) on the server side
and ReactJS, HTML5 with CSS for the client side processing and UI.

Although developed using web technologies, pgAdmin 4 can be deployed either on
a web server using a browser, or standalone on a workstation. The runtime/
subdirectory contains an Electron based runtime application intended to allow this,
which will fork a Python server process and display the UI.

This script builds the desktop only.

To setup pgAdmin4 Server, see guide in SETUP-SERVER.md

Requirements:

 - Nodejs version >= 20.0.0
 - Yarn.
 - PostgreSQL slackware package.
 - Internet connection.

File list included in pgadmin4-slackbuild directory:
 1) LICENSE
 2) README
 3) pgadmin4.SlackBuild
 4) slack-desc
 5) pgadmin4.info
 6) doinst.sh
 7) config_distro.py

NOTE:
Upgraded "nodejs" to version 21.1.0 using Willy's script from SlackBuild.org

Build Instructions:

 1) Install required packages. Both Nodejs and Yarn are available from
    www.slackbuilds.org, I suppose you have postgresql installed already.

 2) Download source tar ball for pgAdmin4 AND electron zipped file and place both
     in the same directory as the build script; URLs are in the info file.

 3) Build the package with "pgadmin4.SlackBuild". You can find the built
    package in your /tmp directory.

 4) Use Slackware package tool (installpkg or upgradepkg) to install or
     upgrade in your system.

Wael Hammoudeh

July 27/2025
