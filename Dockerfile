FROM alpine:3.16

ARG BUILD_DATE

LABEL org.opencontainers.image.created=$BUILD_DATE
LABEL org.opencontainers.image.authors="feniarus@gmail.com"
LABEL org.opencontainers.image.source="https://github.com/Feniarus/iLO4_FanControl"
LABEL org.opencontainers.image.version=0.1
LABEL org.opencontainers.image.title="iLO 4 Fan Control"

ENV ILO_IP=10.10.10.13
ENV ILO_USER=fancon
ENV ILO_PASS=test1234
ENV ILO_DELAY=120

RUN apk add --no-cache sshpass openssh bash && adduser -G tty -u 1000 user -D

USER user

COPY fan.sh fan.sh

CMD bash fan.sh