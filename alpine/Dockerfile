FROM alpine:latest
RUN apk update
RUN apk upgrade
RUN apk add --no-cache \
        curl \
        gzip \
        bash \
        libc6-compat \
        jq \
        openrc
RUN mkdir /opt/wordcloud
