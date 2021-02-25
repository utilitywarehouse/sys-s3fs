FROM alpine:3.13 AS build
ARG S3FS_VERSION=v1.89
RUN apk --no-cache add \
    ca-certificates \
    build-base \
    git \
    alpine-sdk \
    libcurl \
    automake \
    autoconf \
    libxml2-dev \
    libressl-dev \
    fuse-dev \
    curl-dev && \
  git clone https://github.com/s3fs-fuse/s3fs-fuse.git && \
  cd s3fs-fuse && \
  git checkout tags/${S3FS_VERSION} && \
  ./autogen.sh && \
  ./configure --prefix=/usr && \
  make -j && \
  make install

FROM alpine:3.13
ENV MNT_POINT /var/lib/s3fs
COPY --from=build /usr/bin/s3fs /usr/bin/s3fs
COPY run.sh run.sh
RUN apk --no-cache add \
      ca-certificates \
      fuse \
      libxml2 \
      libcurl \
      libgcc \
      libstdc++

CMD ["./run.sh"]
