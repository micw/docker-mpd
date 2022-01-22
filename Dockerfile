FROM debian:11-slim

RUN apt -y update && apt -y install --no-install-recommends mpd mpc ca-certificates
COPY mpd.conf /etc/mpd.conf
VOLUME /var/lib/mpd

EXPOSE 6600
CMD ["mpd", "--stdout", "--no-daemon"]
