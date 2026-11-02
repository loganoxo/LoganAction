FROM alpine:latest
ENV TZ="Asia/Shanghai"
ENV XRAY_LOCATION_ASSET="/usr/share/xray"

ARG TARGETPLATFORM
WORKDIR /root
COPY xray.sh /root/xray.sh

RUN set -ex \
  && apk add --no-cache ca-certificates tzdata bash curl wget openssl unzip \
  && mkdir -p /var/log/xray /usr/share/xray \
  && chmod +x /root/xray.sh \
  && /root/xray.sh "${TARGETPLATFORM}" \
  && rm -fv /root/xray.sh \
  && wget -O /usr/share/xray/geosite.dat https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/geosite.dat \
  && wget -O /usr/share/xray/geoip.dat https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/geoip.dat

CMD [ "/usr/bin/xray", "-c", "/etc/xray/config.json" ]
