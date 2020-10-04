pgAdmin 4
=========

pgAdmin 4 is a rewrite of the popular pgAdmin3 management tool for the
PostgreSQL (http://www.postgresql.org) database. 

This is pgadmin4.SlackBuils README file for version 4.26.

Requirements:
 1) Slackware current: provides qt5 and python3
 2) PostgreSQL slackware package, version ??? I use 9.6.0 and 10.10.0
 3) Internet connection.

Optional: [needed to build javascripts bundles]
  1) Yarn-v1.22.4.tar.gz --> URL: https://github.com/yarnpkg/yarn/releases/download/v1.22.4/yarn-v1.22.4.tar.g
  2) Nodejs-v14.4.0.tar.gz --> URL: https://nodejs.org/dist/v14.4.0/node-v14.4.0.tar.gz
  To build javascripts packages (bundles). Available SlackBuild scripts for both packages
  will work with just changing the version number in each script.
  
Files list: the list has eleven files - [source included; get source tar ball from its URL below]
 1) LICENSE  
 2) README
 3) README.PVE
 4) mk-pve.sh  
 5) pgAdmin4-pve.sh  
 6) pgadmin4-4.26.tar.gz --> https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v4.26/source/pgadmin4-4.26.tar.gz 
 7) pgadmin4.SlackBuild
 8) pgadmin4.conf  
 9) pve-paths.patch
 10) slack-desc
 11) pgadmin4.info
 
Please place all files in one directory. Or download the compressed tarball
and untar it.

Start Fresh:
  Remove old package and all its files. If you used my build use removepkg.
  Then remove its installation directory by: rm -rf /usr/lib64/pgadmin4
  We do so to remove all python cache files which may cause trouble!
  Also remove /var/lib/pgadmin4 directory and python virtual environment
  directory at /usr/local/pve/pgadmin4-pve.
  

Build Instructions:
 1) Place all files in one directory - script directory
 2) As root, change to script directory and run mk-pve.sh script:
      root# ./mk-pve.sh
    this will initial python virtual environment and install
    all required python modules / packages.
 3) As root run slackbuild script:
      root# ./pgadmin4.SlackBuild  
             -- or -- 
      root# BUNDLE=yes ./pgadmin4.SlackBuild -- to build javascripts bundles
    this will produce slackware package in /tmp directory.
 4) Install the package from above with:
      root# installpkg /tmp/pgadmin4-4.26-x86_64-1_wh.tgz
 5) As root again run initial server setup script:
      $ /usr/lib64/pgadmin4/runtime/pgadmin4-initial-server
    this will initial the application.
    Note: I think this step is needed for server mode! We do not do server mode :(
 6) Now as your normal user, copy pgadmin4.conf:
      user$ mkdir ~/.config/pgadmin
      user$ cp {script-directory}/pgadmin4.conf ~/.config/pgadmin
 7) Start pgAdmin4 on your desktop - first use maybe slow Starting.
 
About javascripts bundles:
 I build my package WITHOUT bundles, I think bundles will benefits server mode
setup. I use and build the desktop application, you are on your own to setup
server mode.
 
Hope everything work great for all.

To configure the server manually, you can right-click on its tray icon and
choose configure which will bring up a dialog with two tabs for settings:

  Set Browser Command to : /usr/bin/google-chrome-stable %URL%
                      or : /usr/bin/firefox %URL%
                      
  Set Python Path to: /usr/local/pve/pgAdmin4-pve/lib64/python3.8/site-packages
  
Here is my complete pgadmin4.conf file in my ~/.config/pgadmin/pgadmin4.conf

[General]
ApplicationPath=/usr/lib64/pgadmin4/web
BrowserCommand=/usr/bin/google-chrome-stable %URL%
FixedPort=false
OpenTabAtStartup=true
PortNumber=1
PythonPath=/usr/local/pve/pgAdmin4-pve/lib64/python3.8/site-packages

Enjoy.
Wael Hammoudeh