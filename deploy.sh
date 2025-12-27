#!/bin/bash

KEY_FILE="$1"
EC2_CONNECTION="$2"
LOCAL_PATH="${3:-.}"

if [ -z "$KEY_FILE" ] || [ -z "$EC2_CONNECTION" ]; then
    echo "Usage: ./deploy.sh <key-file> <ec2-connection> [local-path]"
    echo "Example: ./deploy.sh my-key.pem ubuntu@54.123.45.67"
    exit 1
fi

if [ ! -f "$KEY_FILE" ]; then
    echo "Error: Key file '$KEY_FILE' not found"
    exit 1
fi

chmod 400 "$KEY_FILE"

REMOTE_PATH="~/expense-prediction"

if command -v rsync &> /dev/null; then
    echo "Using rsync to transfer files (excluding venv)..."
    rsync -avz --exclude 'venv/' --exclude '__pycache__/' --exclude '*.pyc' --exclude '.git/' -e "ssh -i $KEY_FILE" "$LOCAL_PATH/" "$EC2_CONNECTION:$REMOTE_PATH/"
else
    echo "rsync not found, using tar method..."
    cd "$LOCAL_PATH" || exit 1
    tar --exclude='venv' --exclude='__pycache__' --exclude='*.pyc' --exclude='.git' -czf - . | ssh -i "$KEY_FILE" "$EC2_CONNECTION" "mkdir -p $REMOTE_PATH && cd $REMOTE_PATH && tar -xzf -"
fi

echo "Deployment complete!"

