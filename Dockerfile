FROM alpine:3.18 AS build
ARG S3FS_VERSION=v1.92
RUN apk --no-cache add \
      ca-certificates \
      build-base \
      git \
      alpine-sdk \
      libcurl \
      automake \
      autoconf \
      libxml2-dev \
      openssl-dev \
      fuse-dev \
      curl-dev \
      && git clone https://github.com/s3fs-fuse/s3fs-fuse.git \
      && cd s3fs-fuse \
      && git checkout tags/${S3FS_VERSION} \
      && ./autogen.sh \
      && ./configure --prefix=/usr \
      && make -j \
      && make install

FROM alpine:3.18
ENV MNT_POINT /var/lib/s3fs
# Make additional s3fs options an env var that can be overwritten. Default to
# region specific url to avoid sporadic access failures:
# https://github.com/s3fs-fuse/s3fs-fuse/issues/666#issuecomment-475407515
ENV S3FS_OPTS "-o nonempty -d -f -o f2 -o curldbg -o url=https://s3-eu-west-1.amazonaws.com"
COPY --from=build /usr/bin/s3fs /usr/bin/s3fs
COPY s3fs s3fs
RUN apk --no-cache add \
      ca-certificates \
      fuse \
      libxml2 \
      libcurl \
      libgcc \
      libstdc++

CMD ["./s3fs"]
