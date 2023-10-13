# warp-svc
Cloudflare WARP client in Proxy mode, as a Docker Container

This Dockerfile will create a Docker image with official Cloudflare WARP client (which has been packaged for Debian), and provides a SOCKS5 proxy for usage in workloads.

The official Cloudflare WARP client for Linux:

* Only listens on `127.0.0.1` in proxy mode, so you cannot access it from other containers.

## Features
* Just runs it in proxy mode

## How to use
Just run it and manage it using built-in `warp-cli` command. Its proxy port will be exposed on port `1080` via `socat`.

You should use a volume to make `/var/lib/cloudflare-warp` directory of the container persistent, or you will be
forced to register a new account each time you fire up a container.

### First-run
In your first run, you should start the container.
```
docker run -d --name=warp -e -p 127.0.0.1:1080:1080 -v ${PWD}/warp:/var/lib/cloudflare-warp warp-svc:latest
```

Then, you will have to register an account using `warp-cli`.
```
docker exec -it warp warp-cli --accept-tos register
docker exec -it warp warp-cli set-license <LICENSE>
```

### Using as a local proxy with Docker

You can verify WARP connection by visiting this url:
```
curl -x socks5h://127.0.0.1:1080 -sL https://cloudflare.com/cdn-cgi/trace | grep warp
```
It should say `warp=on`

You can also use `warp-cli` command to control your connection:
```
docker exec warp warp-cli status
```
