#!/bin/bash
# Author: Sebos Technology
# Date: January 12, 2025
# Purpose: Script to sync local directory with a remote server securely using rsync.

# Define the username for rsync operations
RSYNC_USER="rsyncuser"

# Define the IP address or hostname of the remote server
REMOTE_SERVER="192.168.178.76"

# Define the local directory to sync
LOCAL_DIR="/srv/data/xlsx/upload/"

# Define the remote directory where data will be synced
REMOTE_DIR="/data/stock_predictor/xlsx/upload/"

# Usage function to display help
usage() {
    echo "Usage: $0"
    echo "  This script syncs the directory '$LOCAL_DIR' to the remote server '$REMOTE_SERVER' at '$REMOTE_DIR'."
    echo ""
    echo "  Ensure the local directory exists and is accessible, and that SSH access is properly configured."
    echo ""
    echo "Options:"
    echo "  -h, --help    Show this help message and exit"
}

# Check for help argument
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    usage
    exit 0
fi

# Check if the local directory exists
if [[ ! -d "$LOCAL_DIR" ]]; then
    echo "Error: Local directory '$LOCAL_DIR' does not exist. Exiting."
    exit 1
fi

# Check if the remote server is reachable
if ! ping -c 1 -W 1 "$REMOTE_SERVER" &>/dev/null; then
    echo "Error: Remote server '$REMOTE_SERVER' is not reachable. Exiting."
    exit 1
fi

# Perform the rsync operation
# -a: Archive mode (preserves permissions, symbolic links, etc.)
# -v: Verbose output
# -z: Compress files during transfer for efficiency
# --delete: Remove files in the destination that no longer exist in the source
echo "Starting rsync from '$LOCAL_DIR' to '$RSYNC_USER@$REMOTE_SERVER:$REMOTE_DIR'..."
rsync -avz --delete --exclude "$EXCLUDE_DIR" "$LOCAL_DIR" "$RSYNC_USER@$REMOTE_SERVER:$REMOTE_DIR"

# Check the rsync result
if [[ $? -eq 0 ]]; then
    echo "Rsync completed successfully."
else
    echo "Error: Rsync failed. Check the logs for details."
    exit 1
fi
