#/bin/bash

# authorized keys
destination="/local/cs744-hw2-main/authorized_keys"
touch "$destination"

for user_dir in /users/*/; do
    if [ -d "$user_dir/.ssh" ]; then
        cat "$user_dir/.ssh/authorized_keys" >> "$destination"
    fi
done

# Add Docker's official GPG key:
apt-get -y update
apt-get -y install ca-certificates curl
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get -y update

apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# setup docker root-dir
systemctl stop docker
json_content='{
    "data-root":"/mydata"
}'
echo "$json_content" > /etc/docker/daemon.json
systemctl start docker
