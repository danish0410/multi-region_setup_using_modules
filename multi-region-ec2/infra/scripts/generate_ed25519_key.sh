#!/usr/bin/env bash
# ==========================================================
# Safe ED25519 key generator & AWS importer
# ==========================================================

set -euo pipefail

if [ "$#" -lt 2 ]; then
  echo "Usage: $0 <key_name> <region>"
  exit 2
fi

KEY_NAME="$1"
REGION="$2"
SSH_DIR="${HOME}/.ssh"

mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"

PRIVATE_KEY="${SSH_DIR}/${KEY_NAME}"
PUBLIC_KEY="${PRIVATE_KEY}.pub"
PEM_KEY="${PRIVATE_KEY}.pem"

rm -f "$PRIVATE_KEY" "$PUBLIC_KEY" "$PEM_KEY"

ssh-keygen -t ed25519 -f "$PRIVATE_KEY" -N "" -C "$KEY_NAME"
chmod 400 "$PRIVATE_KEY"

aws ec2 delete-key-pair \
  --key-name "$KEY_NAME" \
  --region "$REGION" >/dev/null 2>&1 || true

aws ec2 import-key-pair \
  --key-name "$KEY_NAME" \
  --public-key-material "fileb://${PUBLIC_KEY}" \
  --region "$REGION"

cp "$PRIVATE_KEY" "$PEM_KEY"
chmod 400 "$PEM_KEY"

echo "✅ Key created and imported for $REGION"
