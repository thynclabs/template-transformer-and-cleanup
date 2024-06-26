# Base image
FROM alpine:latest

# installes required packages for our script
RUN apk add --no-cache \
  bash \
  ca-certificates \
  git

# Copies your code file  repository to the filesystem
COPY run.sh /run.sh

# change permission to execute the script and
RUN chmod +x /run.sh

# file to execute when the docker container starts up
ENTRYPOINT ["/run.sh"]
