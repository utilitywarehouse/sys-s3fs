#!/bin/sh
echo $AWS_KEY:$AWS_SECRET_KEY > passwd && chmod 600 passwd
s3fs $S3_BUCKET $MNT_POINT -o passwd_file=passwd -o nonempty -d -f -o f2 -o curldbg
