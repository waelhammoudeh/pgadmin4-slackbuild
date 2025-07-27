### PgAdmin4 Server Setup on Slackware64

This guide explains how to setup and run **pgAdmin4 in server mode** on a local
network composed primarily of Slackware64 systems, with some Windows and macOS
machines. All machines use static IPs and share a common `/etc/hosts` file.

#### Important Notes

 PgAdmin4 can run in **Desktop** *or* **Server** mode, but **not both at the same time**.
 Server mode allows access from any browser on your local network.

---

#### 1. Create pgadmin User and Group

A dedicated system user and group is used to run the server. Run as `root`:

```
  # groupadd -g 990 pgadmin
  # useradd -r -u 990 -g pgadmin -d /opt/pgadmin4/srvr-data -s /bin/bash pgadmin
```

#### 2. Create Data Directory

By default pgAdmin4 stores server data under the system directory "/var/lib/".
I prefer to keep ALL pgAdmin4 files and directories under my package root
"/opt/pgadmin4". We create "srvr-data" directory and sets ownership to "pgadmin":

```
  # mkdir -p /opt/pgadmin4/srvr-data
  # chown pgadmin:pgadmin /opt/pgadmin4/srvr-data
```

#### 3. Enable Server Mode

Copy my `config_local.py` file to the pgAdmin4 `web` directory:

```
  # cp config_local.py /opt/pgadmin4/web/
```

The file contents are below also: **replace '192.168.1.5'** with your own IP.

```
import os
import logging

# Enable server mode
SERVER_MODE = True

# DEFAULT_SERVER = '0.0.0.0'   # Accept connections from all interfaces
DEFAULT_SERVER = '192.168.1.5'
DEFAULT_SERVER_PORT = 5050   # Or another port if running behind a proxy

# Central data directory for pgAdmin4 running in server mode
DATA_DIR = '/opt/pgadmin4/srvr-data'

LOG_FILE = os.path.join(DATA_DIR, 'pgadmin4.log')
SQLITE_PATH = os.path.join(DATA_DIR, 'pgadmin4.db')
SESSION_DB_PATH = os.path.join(DATA_DIR, 'sessions')
STORAGE_DIR = os.path.join(DATA_DIR, 'storage')
AZURE_CREDENTIAL_CACHE_DIR = os.path.join(DATA_DIR, 'azurecredentialcache')
KERBEROS_CCACHE_DIR = os.path.join(DATA_DIR, 'kerberoscache')
```

This file enables "Server mode" and **disables** Desktop mode,  to disable Server
mode and switch back to Desktop mode , remove the file or hide it:

```
  # mv /opt/pgadmin4/web/config_local.py /opt/pgadmin4/web/config_local.py.disable
```

#### 4. Setup Server database:

Source provided script "setup.py" is used to setup the server database, this
script will use our "config_local.py" file to setup initial server database, we
run the script as "pgadmin" user under our python virtual enironment:

```
  # su pgadmin
```

Your terminal prompt should show "$" instead of "#" character. **Activate python
virtual enironment**:

```
  $ source /pgadmin4/venv/bin/activate
```

Run the setup script with "setup-db" as parameter:

```
  (venv) $ python3 /opt/pgadmin4/web/setup.py setup-db
```

You will be prompted for an email and password.
The email identifies the user (first one becomes admin).

The "steup.py" script is used to adminstrate the server; try "steup.py --help"
to see all options.

#### 5. Run the Server

With this setup, you can start the server from your terminal with:

```
  (venv) $ python3 /opt/pgadmin4/web/pgAdmin4.py
```

This is the output I get from the above command on my terminal:

```
  (venv) pgadmin@yafa:/root$ python3 /opt/pgadmin4/web/pgAdmin4.py
  Starting pgAdmin 4. Please navigate to http://192.168.1.5:5050 in your browser.
   * Serving Flask app 'pgadmin'
   * Debug mode: off

 ```

 You may access the server from any machine on your LAN (including the machine
 your are using now) by entering the URL into your browser.

To stop the server press `Ctrl+C` in the terminal

You may run your server in the background:

```
  (venv) $ python3 /opt/pgadmin4/web/pgAdmin4.py &
```

note its PID, then to stop it use `kill -9 PID` when done.


### PgAdmin4 Behind Apache Using mod_wsgi module:

Slackware includes the Apache HTTP server, an external Apache module is required,
that is "mod_wsgi" which needs to be installed. Luckily it has a build script available
at www.slackbuilds.org.

#### Install "mod_wsgi" module:

I have made two changes to the build script explained below. Download the build
script from this [link here](https://slackbuilds.org/repository/15.0/network/mod_wsgi/).

**A. Update "mod_wsgi" module Version number:**

The SlackBuild uses an old version (e.g., 4.4.6). I used  "mod_wsgi" version 5.0.2.
Use [this link]( https://github.com/GrahamDumpleton/mod_wsgi/archive/5.0.2/mod_wsgi-5.0.02.tar.gz)
to download module tar ball source:

Change the version number line in the "mod_wsgi.SlackBuild" script to read:

```
VERSION=${VERSION:-5.0.2}
```

**B. Force the correct Python version**

Add this to the ./configure line (around line 78) in the build script:

```
./configure --with-python=/usr/bin/python3.9
```

Without this, "mod_wsgi" will default to Python 2.7, which will break compatibility with pgAdmin4.

Compile and install "mod_wsgi" and do not forget to include it in your  "/etc/httpd/httpd.conf" file:

Add to /etc/httpd/httpd.conf:
```
  Include /etc/httpd/extra/mod_wsgi.conf
```

#### Make pgAdmin4.py Executable

```
  # chmod +x /opt/pgadmin4/web/pgAdmin4.py
```

#### Apache VirtualHost Configuration

Add this block to a custom Apache config file (e.g., /etc/httpd/extra/pgadmin.conf) and include it from httpd.conf.

```
<VirtualHost *:80>

    ServerName www.pgadmin.local
    ServerAlias pgadmin.local pgadmin
    ServerAdmin root@pgadmin.local

    # LogLevel debug  # this spits a lot of stuff in your log files!
    LogLevel warn

    # log files use the "_log" suffix used in logrotate configure.
    ErrorLog "/var/log/httpd/error-pgadmin_log"
    CustomLog "/var/log/httpd/access-pgadmin_log" common

    DocumentRoot /opt/pgadmin4/web

    WSGIDaemonProcess pgadmin user=pgadmin group=pgadmin processes=1 threads=25 python-home=/opt/pgadmin4/venv
    WSGIScriptAlias / /opt/pgadmin4/web/pgAdmin4.wsgi

    <Directory /opt/pgadmin4/web>
        Options +ExecCGI
        WSGIProcessGroup pgadmin
        WSGIApplicationGroup %{GLOBAL}

        <IfVersion < 2.4>
            Order allow,deny
            Allow from all
        </IfVersion>

        <IfVersion >= 2.4>
            Require all granted
        </IfVersion>
    </Directory>

    <Directory /opt/pgadmin4/venv>
        Options +ExecCGI

        <IfVersion < 2.4>
            Order allow,deny
            Allow from all
        </IfVersion>

        <IfVersion >= 2.4>
            Require all granted
        </IfVersion>
    </Directory>

</VirtualHost>
```

You may want to add the local hostname/IP to "/etc/hosts" on client machines:

```
192.168.1.5   pgadmin.local www.pgadmin.local
```

Final step is to restart Apache with "apachectl restart" or "/etc/rc.d/rc.httpd restart".

Access your server with URL:

```
http://pgadmin.local/
```

or use the IP directly:

```
http://192.168.1.5/
```

Enjoy

Wael Hammoudeh
July 26/2025
