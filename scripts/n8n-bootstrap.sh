#!/bin/sh
# Runs inside joby-n8n before n8n starts.
set -e
MARK=/home/node/.n8n/.joby-workflows-imported

if [ ! -f "$MARK" ] || [ "$FORCE_IMPORT" = "true" ]; then
  echo "[joby] importing workflows from /workflows"
  if n8n import:workflow --separate --input=/workflows; then
    touch "$MARK"
  else
    echo "[joby] workflow import failed, n8n will still start"
  fi
fi

if [ "$AUTO_ACTIVATE" = "true" ]; then
  echo "[joby] activating master workflow"
  n8n update:workflow --id=JobMaster0000000 --active=true 2>/dev/null \
    || n8n publish:workflow --id=JobMaster0000000 2>/dev/null \
    || echo "[joby] could not auto-activate, toggle it in the UI"
fi

exec n8n start
