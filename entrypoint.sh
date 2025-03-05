#!/bin/bash

# Start PufferPanel service
echo "Starting PufferPanel service..."
systemctl enable --now pufferpanel

# Check if this is first time startup
FIRST_START_FLAG="/var/lib/pufferpanel/.first_start"
if [ ! -f "$FIRST_START_FLAG" ]; then
    echo "First time startup detected - creating admin user..."
    
    # Check if all required environment variables are set
    if [ -z "$ADMIN_EMAIL" ] || [ -z "$ADMIN_NAME" ] || [ -z "$ADMIN_PASSWORD" ]; then
        echo "Error: Please set ADMIN_EMAIL, ADMIN_NAME, and ADMIN_PASSWORD environment variables"
        exit 1
    fi

    # Create admin user
    pufferpanel user add --admin --email "$ADMIN_EMAIL" --name "$ADMIN_NAME" --password "$ADMIN_PASSWORD"
    
    # Create flag file to indicate first start is complete
    touch "$FIRST_START_FLAG"
fi

# Start PufferPanel
echo "Starting PufferPanel service..."
systemctl start pufferpanel

# Keep container running
echo "Container is running. Press Ctrl+C to stop."
tail -f /dev/null 