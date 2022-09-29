FROM alpine:3.16 as maker
RUN apk --no-cache add alpine-sdk coreutils cmake sudo \
  && adduser -G abuild -g "Alpine Package Builder" -s /bin/ash -D builder \
  && echo "builder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
  && mkdir /packages \
  && chown builder:abuild /packages \
  && mkdir -p /var/cache/apk \
  && ln -s /var/cache/apk /etc/apk/cache
WORKDIR /home/builder
RUN chmod 777 /home/builder
RUN wget https://gitlab.alpinelinux.org/alpine/aports/-/archive/3.16-stable/aports-3.16-stable.tar.gz && tar -xf aports-3.16-stable.tar.gz

RUN su -c "mkdir crypto && cp -r /home/builder/aports-3.16-stable/testing/crypto++/ ./crypto/ \
    && cd crypto/crypto++ && abuild-keygen -i -n -a && abuild -r" builder

RUN su -c "mkdir sqlight && cp -r /home/builder/aports-3.16-stable/main/sqlite ./sqlight/ \
    && cd sqlight/sqlite && abuild-keygen -i -n -a && abuild -r" builder

RUN su -c "mkdir sodium && cp -r /home/builder/aports-3.16-stable/main/libsodium ./sodium/ \
    && cd sodium/libsodium && abuild-keygen -i -n -a && abuild -r" builder

RUN su -c "mkdir cares && cp -r /home/builder/aports-3.16-stable/main/c-ares/ ./cares/ \
    && cd cares/c-ares && abuild-keygen -i -n -a && abuild -r" builder

RUN su -c "mkdir library && cp -r /home/builder/aports-3.16-stable/main/z-lib/ ./library/ \
    && cd library/z-lib && abuild-keygen -i -n -a && abuild -r" builder

RUN su -c "mkdir google && cp -r /home/builder/aports-3.16-stable/main/brotil/ ./google/ \
    && cd google/crypto++ && abuild-keygen -i -n -a && abuild -r" builder



RUN ls -a && ls -a /home/builder/packages/
FROM scratch AS alpinesdk

COPY --from=maker /home/builder/ /
