# CodeIgniter 3 Docker Compose

This assumes:
- traefik for reverse proxy and SSL, configured inside docker-compose.yml
- an accessible mysql server
- a docker network named "proxy"

```
docker compose -f docker-compose.local.yml up -d
```