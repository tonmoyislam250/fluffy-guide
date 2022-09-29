FROM alpine:3.16
RUN apk --no-cache add alpine-sdk coreutils cmake sudo \
  && adduser -G abuild -g "Alpine Package Builder" -s /bin/ash -D builder \
  && echo "builder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
  && mkdir /packages \
  && chown builder:abuild /packages \
  && mkdir -p /var/cache/apk \
  && ln -s /var/cache/apk /etc/apk/cache
WORKDIR /home/builder
RUN chmod 777 /home/builder
RUN wget https://gitlab.alpinelinux.org/alpine/aports/-/archive/3.16-stable/aports-3.16-stable.tar.gz && tar -xvf aports-3.16-stable.tar.gz
RUN mkdir crypto++ && cd crypto++ && cp -r /home/builder/aports-3.16-stable/testing/crypto++/ .
RUN cd crypto++ && abuild -i -a && abuild -r
RUN cd packages && ls -a
