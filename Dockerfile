FROM alpine:3.12
MAINTAINER David Personette <dperson@gmail.com>
ARG healthcheck_url

# Install openvpn
RUN apk --no-cache --no-progress upgrade && \
    apk --no-cache --no-progress add bash curl ip6tables iptables openvpn \
                shadow tini && \
    addgroup -S vpn && \
    rm -rf /tmp/*

COPY openvpn.sh /usr/bin/

HEALTHCHECK --interval=1h --timeout=15s --start-period=120s \
             CMD curl -LSs "${healthcheck_url}"

VOLUME ["/vpn"]

ENTRYPOINT ["/sbin/tini", "--", "/usr/bin/openvpn.sh"]
