#!/bin/sh
# Run from ~/Desktop/joby/infra after extracting the bundle there:
#   tar -xzf joby-n8n-bundle.tar.gz && sh install.sh
set -e
[ -f docker-compose.yml ] && cp docker-compose.yml docker-compose.yml.bak.$(date +%s) 2>/dev/null || true
mkdir -p n8n-files workflows scripts
if [ -f .env ] && grep -q '^JOB_SHEET_ID=' .env; then
  echo "[install] .env already has job settings, leaving it"
else
  cat env.n8n.example >> .env
  echo "[install] job settings appended to .env, edit them now: nano .env"
fi
for k in POSTGRES_PASSWORD N8N_ENCRYPTION_KEY; do
  grep -q "^$k=" .env || { echo "[install] WARNING: $k is missing in .env"; }
done
[ -f n8n-files/cv.pdf ] || echo "[install] put your CV here: $(pwd)/n8n-files/cv.pdf"
echo "[install] then run: docker compose up -d"
