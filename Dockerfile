# Use Ubuntu 24.04 LTS as base image
FROM ubuntu:24.04

# Avoid prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Define admin user environment variables
ENV ADMIN_EMAIL=""
ENV ADMIN_NAME=""
ENV ADMIN_PASSWORD=""

# Install required packages and PufferPanel
RUN apt-get update && \
    apt-get install -y \
    curl \
    wget \
    systemctl \
    sudo \
    gnupg \
    && rm -rf /var/lib/apt/lists/*

# Install PufferPanel repository and package
RUN curl -s https://packagecloud.io/install/repositories/pufferpanel/pufferpanel/script.deb.sh?any=true | bash && \
    apt-get update && \
    apt-get install -y pufferpanel

# Create entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expose PufferPanel web interface port
EXPOSE 8080

# Set entrypoint
ENTRYPOINT ["/entrypoint.sh"]
