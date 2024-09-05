# Use the latest Ubuntu LTS as the base image
FROM ubuntu:20.04

# Install basic utilities and dependencies for MinIO client
RUN apt-get update && apt-get install -y \
    bash \
    curl \
    vim \
    && rm -rf /var/lib/apt/lists/*

# Download and install MinIO client (mc)
RUN curl https://dl.min.io/client/mc/release/linux-amd64/mc \
  --create-dirs \
  -o /usr/local/bin/mc && \
  chmod +x /usr/local/bin/mc \
  export PATH=$PATH:$HOME/minio-binaries/

# Set the command to sleep indefinitely
CMD ["sleep", "infinity"]
