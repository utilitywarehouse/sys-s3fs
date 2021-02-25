# sys-s3fs
Builds an image that could be used to mount s3 buckets using s3fs.

### Environment Variables

The following environment variables need to be set:
- `AWS_KEY`: the aws key for the user that has permissions on the bucket
- `AWS_SECRET_KEY`: the secret for above mentioned key
- `S3_BUCKET`: s3 bucket name in the from that s3fs expects it (
- `HOST_MOUNT_POINT`: the local host mountpoint location

## Systemd Srvice

Example systemd service:

```
[Unit]
Description=s3fs mounter
After=docker.service
Requires=docker.service
[Service]
Restart=on-failure
Environment=AWS_KEY=AKIAXXXXXXXXXX
Environment=AWS_SECRET_KEY=XXXXXXXXXXXXXX
Environment=S3_BUCKET=my-bucket
Environment=HOST_MOUNT_POINT=/path/to/mountpoint
ExecStart=/bin/sh -c 'docker run --name=s3fs --rm \
  --privileged \
  -e AWS_KEY=${AWS_KEY} \
  -e AWS_SECRET_KEY=${AWS_SECRET_KEY} \
  -e S3_BUCKET=${S3_BUCKET} \
  -v ${HOST_MOUNT_POINT}:/var/lib/s3fs:shared \
  quay.io/utilitywarehouse/sys-s3fs'
ExecStop=/bin/sh -c 'docker stop -t 3 "$(docker ps -q --filter=name=s3fs)"'
ExecStopPost=-/usr/bin/umount ${HOST_MOUNT_POINT}
[Install]
WantedBy=multi-user.target
```
