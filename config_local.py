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
