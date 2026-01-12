#!/usr/bin/env bash
# ==========================================================
# ED25519 SSH key generator + AWS EC2 KeyPair importer
# Safe, idempotent, multi-region compatible
# ==========================================================

set -euo pipefail

# --------------------------
# Arguments
# --------------------------
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <key_name> <aws_region>"
  exit 1
fi

KEY_NAME="$1"
REGION="$2"

# --------------------------
# Paths
# --------------------------
SSH_DIR="$HOME/.ssh"
PRIVATE_KEY="${SSH_DIR}/${KEY_NAME}"
PUBLIC_KEY="${PRIVATE_KEY}.pub"

# --------------------------
# Prepare SSH directory
# --------------------------
mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"

# --------------------------
# Generate key if missing
# --------------------------
if [ ! -f "$PRIVATE_KEY" ]; then
  echo "🔐 Generating ED25519 key: $KEY_NAME"
  ssh-keygen -t ed25519 -f "$PRIVATE_KEY" -N "" -C "$KEY_NAME"
  chmod 400 "$PRIVATE_KEY"
else
  echo "ℹ️ Local key already exists: $PRIVATE_KEY"
fi

# --------------------------
# Import key to AWS (idempotent)
# --------------------------
if aws ec2 describe-key-pairs \
  --region "$REGION" \
  --key-names "$KEY_NAME" >/dev/null 2>&1; then
  echo "ℹ️ Key pair already exists in AWS ($REGION): $KEY_NAME"
else
  echo "☁️ Importing key to AWS ($REGION)"
  aws ec2 import-key-pair \
    --region "$REGION" \
    --key-name "$KEY_NAME" \
    --public-key-material "fileb://${PUBLIC_KEY}"
  echo "✅ Key imported to AWS ($REGION)"
fi

echo "🎉 SSH key ready for region $REGION"
