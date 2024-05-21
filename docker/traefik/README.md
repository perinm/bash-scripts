# README

Example docker-compose project to run traefik + whoami with ssl certificate easily.

## Edit docker-compose
To run this demo you need to edit cloudflare credentinials and domain name.

```diff
- - "--certificatesresolvers.letsencrypt.acme.email=EMAIL@DOMAIN.com"
+ - "--certificatesresolvers.letsencrypt.acme.email=your-real-email@gmail.com"
```

```diff
- - CLOUDFLARE_EMAIL=EMAIL@DOMAIN.com
+ - CLOUDFLARE_EMAIL=your-real-email@gmail.com
```

```diff
- - CLOUDFLARE_DNS_API_TOKEN=XXXXXXXXXXX
+ - CLOUDFLARE_DNS_API_TOKEN=<some-token>
```

## Run

```bash
docker network create proxy
docker-compose up -d --build
```

or if docker swarm

```bash
docker network create --driver overlay proxy
docker stack deploy -c docker-compose.yml traefik
```

## Urls

After editing and run docker-compose you can check urls

- traefik.DOMAIN.com
- whoami.DOMAIN.com

## Traefik admin panel

Traefik has basic auth middleware, so you need to enter this user password.

| Username | Password |
|----------|----------|
| user     | password |

To generate new user password you can use `htpasswd`.
Make sure to have apache2-utils installed on your system in order to use htpasswd command.

```bash
htpasswd -nb user password
```

which will output

```
user:$$apr1$$q8eZFHjF$$Fvmkk//V6Btlaf2i/ju5n/
```