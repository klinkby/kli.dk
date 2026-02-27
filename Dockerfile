# Build stage: install Hugo and produce static files
FROM alpine:3.22 AS builder
ARG HUGO_VERSION=0.145.0
RUN apk add --no-cache wget tar
RUN wget -q "https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_linux-amd64.tar.gz" \
    && tar -xzf "hugo_extended_${HUGO_VERSION}_linux-amd64.tar.gz" hugo \
    && mv hugo /usr/local/bin/ \
    && rm "hugo_extended_${HUGO_VERSION}_linux-amd64.tar.gz"
WORKDIR /src
COPY src/ .
RUN hugo --minify

# Runtime stage: serve static files with lighttpd on Alpine Linux
FROM alpine:3.22
RUN apk add --no-cache lighttpd
RUN addgroup -S web && adduser -S -G web -h /app -s /sbin/nologin web
COPY --from=builder /src/public /app
RUN chown -R web:web /app && mkdir -p /var/run/lighttpd && chown web:web /var/run/lighttpd
COPY lighttpd.conf /etc/lighttpd/lighttpd.conf
USER web:web
CMD ["lighttpd", "-D", "-f", "/etc/lighttpd/lighttpd.conf"]
