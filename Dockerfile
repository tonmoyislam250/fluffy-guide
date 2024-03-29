FROM alpine:3.17 as maker
RUN apk --no-cache add alpine-sdk coreutils cmake linux-headers perl musl m4 git sudo \
#  gnutls-dev expat-dev sqlite-dev c-ares-dev cppunit-dev \
  && adduser -G abuild -g "Alpine Package Builder" -s /bin/ash -D builder \
  && echo "builder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
  && mkdir /packages \
  && chown builder:abuild /packages \
  && mkdir -p /var/cache/apk \
  && ln -s /var/cache/apk /etc/apk/cache
WORKDIR /home/builder
RUN chmod 777 /home/builder
RUN wget https://gitlab.alpinelinux.org/alpine/aports/-/archive/master/aports-master.tar.gz && tar -xf aports-master.tar.gz
RUN wget https://gitlab.alpinelinux.org/alpine/aports/-/archive/v3.16.5/aports-v3.16.5.tar.gz && tar -xf aports-v3.16.5.tar.gz
RUN ls -a && cd aports-v3.16.5 && ls -a

RUN su -c "mkdir crypto && cp -r /home/builder/aports-v3.16.5/testing/crypto++/ ./crypto/ \
    && cd crypto/crypto++ && abuild-keygen -i -n -a && abuild -r" builder

#RUN su -c "mkdir sqlight && cp -r /home/builder/aports-3.16-stable/main/sqlite ./sqlight/ \
#    && cd sqlight/sqlite && abuild-keygen -i -n -a && abuild -r" builder

#RUN su -c "mkdir sodium && cp -r /home/builder/aports-3.16-stable/main/libsodium ./sodium/ \
#    && cd sodium/libsodium && abuild-keygen -i -n -a && abuild -r" builder

RUN su -c "mkdir cares && cp -r /home/builder/aports-master/main/c-ares/ ./cares/ \
    && cd cares/c-ares && abuild-keygen -i -n -a && abuild -r" builder

#RUN su -c "mkdir library && cp -r /home/builder/aports-3.16-stable/main/zlib/ ./library/ \
#    && cd library/zlib && abuild-keygen -i -n -a && abuild -r" builder

#RUN su -c "mkdir google && cp -r /home/builder/aports-3.16-stable/main/brotli/ ./google/ \
#     && cd google/brotli && abuild-keygen -i -n -a && abuild -r" builder


#RUN su -c "mkdir curly && cp -r /home/builder/aports-3.16-stable/main/curl/ ./curly/ \
#     && cd curly/curl && abuild-keygen -i -n -a && abuild -r" builder


#RUN su -c "mkdir http && cp -r /home/builder/aports-3.16-stable/main/nghttp2 ./http/ \
#    && cd http/nghttp2 && abuild-keygen -i -n -a && abuild -r" builder

#RUN su -c "mkdir ssl && cp -r /home/builder/aports-3.16-stable/main/openssl ./ssl/ \
#   && cd ssl/openssl && abuild-keygen -i -n -a && abuild -r" builder


RUN cd /home/builder/packages/crypto/x86_64/ && apk add --allow-untrusted *.apk
RUN cd /home/builder/packages/cares/x86_64/ && apk add --allow-untrusted *.apk


#RUN tar -czf apkbuild.tar.gz crypto sqlight sodium cares library google curly http ssl
#RUN tar -czf apkbuild.tar.gz crypto cares

#RUN su -c "mkdir aria && cp -r /home/builder/aports-3.15-stable/community/aria2 ./aria/ \
#   && cd aria/aria2 && abuild-keygen -i -n -a && abuild -r" builder


RUN mkdir /abc && cp -r /home/builder/packages/ /abc/
FROM scratch AS alpinesdk

COPY --from=maker /abc/ /
