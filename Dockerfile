# Gunakan Debian sebagai base image
FROM debian

# Set environment untuk port SSH
ARG PORT=22
ENV DEBIAN_FRONTEND=noninteractive

# Update dan install paket yang dibutuhkan
RUN apt update && apt upgrade -y && apt install -y \
    ssh wget curl vim npm

# Install LocalTunnel
RUN npm install -g localtunnel

# Konfigurasi SSH
RUN mkdir /run/sshd \
    && echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config \
    && echo root:123 | chpasswd

# Script untuk memulai SSH dan LocalTunnel
RUN echo "#!/bin/bash" > /start.sh \
    && echo "/usr/sbin/sshd &" >> /start.sh \
    && echo "sleep 3" >> /start.sh \
    && echo "lt --port ${PORT} --subdomain mysshsubdomain &" >> /start.sh \
    && chmod +x /start.sh

# Buka port SSH
EXPOSE ${PORT}

# Jalankan start.sh untuk memulai SSH dan LocalTunnel
CMD ["/start.sh"]
