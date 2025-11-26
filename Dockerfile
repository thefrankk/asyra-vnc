FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install required packages
RUN apt-get update && apt-get install -y \
    xfce4 \
    xfce4-goodies \
    tigervnc-standalone-server \
    tigervnc-common \
    novnc \
    websockify \
    supervisor \
    net-tools \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set up VNC password
RUN mkdir -p /root/.vnc
RUN echo "asyra123" | vncpasswd -f > /root/.vnc/passwd
RUN chmod 600 /root/.vnc/passwd

# Create xstartup file
RUN echo '#!/bin/sh' > /root/.vnc/xstartup \
    && echo 'unset SESSION_MANAGER' >> /root/.vnc/xstartup \
    && echo 'unset DBUS_SESSION_BUS_ADDRESS' >> /root/.vnc/xstartup \
    && echo 'exec startxfce4' >> /root/.vnc/xstartup \
    && chmod +x /root/.vnc/xstartup

# Configure noVNC
RUN ln -s /usr/share/novnc/vnc.html /usr/share/novnc/index.html

# Copy supervisor configuration
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Expose VNC and noVNC ports
EXPOSE 5901 6080

# Create startup script
COPY start-services.sh /start-services.sh
RUN chmod +x /start-services.sh

CMD ["/start-services.sh"]
