## Quick installation with docker-compose

### Requirements

1. A VPN with at least 2GB RAM.
1. A FQDN pointing to the IP of this server.
1. Docker and docker-compose installed.

### Install docker and docker-compose

1. Install docker in ubuntu-18.04:

   ```bash
   apt update
   apt install \
       apt-transport-https \
       ca-certificates \
       curl \
       software-properties-common

   docker_repo=https://download.docker.com/linux/ubuntu
   add-apt-repository \
       "deb [arch=amd64] $docker_repo bionic stable"

   key_url=https://download.docker.com/linux/ubuntu/gpg
   curl -fsSL $key_url | apt-key add -

   apt update
   apt-cache policy docker-ce
   apt install docker-ce

   systemctl status docker
   docker --version
   ```
   
1. Install docker-compose:

   ```bash
   github_url="https://github.com/docker/compose"
   release="$github_url/releases/download/1.25.4"
   curl -L "$release/docker-compose-$(uname -s)-$(uname -m)" \
        -o /usr/local/bin/docker-compose
   chmod +x /usr/local/bin/docker-compose
   docker-compose --version
   ```

### Install Opencast

1. Create a directory:
   ```bash
   mkdir -p /srv/opencast
   cd /srv/opencast/
   ```

1. Get the assets:
   ```bash
   base_url=https://github.com/opencast/opencast-docker/raw/master
   wget $base_url/docker-compose/assets/activemq.xml
   wget $base_url/docker-compose/assets/opencast-ddl.sql
   mkdir -p assets
   mv activemq.xml opencast-ddl.sql assets/
   ```

1. Get docker-compose config files:
   ```bash
   wget $base_url/docker-compose/docker-compose.allinone.mariadb.ssl.yml
   wget $base_url/docker-compose/env.example
   mv env.example .env
   ```

1. Edit and customize `.env` and create an nginx custom config file
   like this:
   ```bash
   mkdir -p nginx
   echo 'client_max_body_size 100m;' > nginx/custom.conf
   ```
   
1. Start the containers:
   ```bash
   docker-compose up
   ```
   
1. If everything is working fine, stop with `Ctrl-c` and start in
   background:
   ```bash
   docker-compose up -d
   ```
