#!/usr/bin/env bash
set -e

# Attendre la DB
echo "==> Attente de la DB..."
until python - <<'PY'
import os, psycopg2, time
import sys
from psycopg2 import OperationalError
for _ in range(30):
    try:
        psycopg2.connect(
            dbname=os.getenv("DB_NAME","zsdb"),
            user=os.getenv("DB_USER","zs"),
            password=os.getenv("DB_PASSWORD",""),
            host=os.getenv("DB_HOST","db"),
            port=int(os.getenv("DB_PORT","5432")),
        ).close()
        sys.exit(0)
    except OperationalError:
        time.sleep(1)
sys.exit(1)
PY
do
  echo "DB pas prête, on réessaie..."
  sleep 1
done
echo "DB OK"

# Lancer le serveur (dev)
python manage.py migrate || true
python manage.py runserver 0.0.0.0:8000
