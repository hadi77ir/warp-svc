FROM debian:bookworm-slim
EXPOSE 40000/tcp
RUN apt-get update && \
  apt-get install curl gpg socat -y && \
  curl https://pkg.cloudflareclient.com/pubkey.gpg | \
  gpg --yes --dearmor --output /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg && \
  echo "deb [arch=amd64 signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ bookworm main" | \
  tee /etc/apt/sources.list.d/cloudflare-client.list && \
  apt-get update && \
  apt-get install cloudflare-warp -y && \
  rm -rf /var/lib/apt/lists/*
COPY --chmod=755 entrypoint.sh entrypoint.sh
VOLUME ["/var/lib/cloudflare-warp"]
CMD ["./entrypoint.sh"]
