# Asyra VNC Microservice

A Docker-based microservice that provides a VNC server with web-based access through noVNC. This service allows you to view and interact with a remote desktop environment directly from your browser.

## Features

- Ubuntu 22.04 with XFCE4 desktop environment
- TigerVNC server for VNC protocol
- noVNC for browser-based access
- Supervisor for process management
- Easy deployment with Docker and Docker Compose

## Quick Start

### Prerequisites

- Docker
- Docker Compose

### Building and Running

1. Clone this repository:
```bash
git clone <repository-url>
cd asyra-vnc
```

2. Build and start the container:
```bash
docker-compose up -d
```

3. Access the VNC server from your browser:
```
http://localhost:6080/vnc.html?autoconnect=true&resize=scale&reconnect=true
```

Or for HTTPS (with proper reverse proxy setup):
```
https://host:port/vnc.html?autoconnect=true&resize=scale&reconnect=true
```

### Default VNC Password

The default VNC password is: `asyra123`

To change it, modify the Dockerfile and rebuild the image.

## Configuration

### Ports

- **5901**: VNC server port
- **6080**: noVNC web interface port

### Environment Variables

You can customize the display by modifying the environment variables in [docker-compose.yml](docker-compose.yml):

- `DISPLAY`: X display number (default: `:1`)

### Screen Resolution

To change the default resolution (1280x720), edit the geometry parameter in [supervisord.conf](supervisord.conf):

```
command=/usr/bin/vncserver :1 -geometry 1920x1080 -depth 24 -localhost no
```

## Usage

### Starting the Service

```bash
docker-compose up -d
```

### Stopping the Service

```bash
docker-compose down
```

### Viewing Logs

```bash
docker-compose logs -f
```

### Accessing via Browser

Navigate to:
```
http://localhost:6080/vnc.html?autoconnect=true&resize=scale&reconnect=true
```

Query parameters:
- `autoconnect=true`: Automatically connect to the VNC server
- `resize=scale`: Scale the remote screen to fit the browser window
- `reconnect=true`: Automatically reconnect if the connection is lost

## Production Deployment

For production deployment, consider:

1. **Change the VNC password**: Update the password in the Dockerfile
2. **Use a reverse proxy**: Setup Nginx or Traefik with SSL/TLS
3. **Authentication**: Add additional authentication layer
4. **Resource limits**: Configure Docker resource constraints
5. **Monitoring**: Implement health checks and monitoring

### Example Nginx Configuration

```nginx
server {
    listen 443 ssl;
    server_name your-domain.com;

    ssl_certificate /path/to/cert.pem;
    ssl_certificate_key /path/to/key.pem;

    location / {
        proxy_pass http://localhost:6080;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

## Architecture

```
┌─────────────────┐
│   Browser       │
│  (Frontend)     │
└────────┬────────┘
         │ HTTPS/HTTP
         │ Port 6080
┌────────▼────────┐
│   noVNC         │
│  (WebSocket)    │
└────────┬────────┘
         │ VNC Protocol
         │ Port 5901
┌────────▼────────┐
│  VNC Server     │
│  (TigerVNC)     │
└────────┬────────┘
         │
┌────────▼────────┐
│ XFCE4 Desktop   │
│   Environment   │
└─────────────────┘
```

## Troubleshooting

### Connection Refused

- Ensure the container is running: `docker ps`
- Check logs: `docker-compose logs`
- Verify ports are not in use: `netstat -an | grep 6080`

### Black Screen

- VNC server might not have started properly
- Check supervisor logs inside the container:
  ```bash
  docker exec -it asyra-vnc-server cat /var/log/supervisor/vncserver.log
  ```

### Performance Issues

- Increase container resources in docker-compose.yml
- Reduce screen resolution
- Check host system resources

## License

MIT

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.
