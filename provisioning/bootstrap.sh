#!/bin/bash

set -e
set -x

readonly PROGNAME=$(basename $0)
readonly PROGDIR=$(readlink -m $(dirname $0))

if [ "$1" != "gogogo" ] ; then
  "$PROGDIR/$PROGNAME" gogogo 2>&1 | tee /root/install.log
  exit $?
fi


##############
# initial stuff
##############

me=172.21.131.30
homer=172.21.128.126

ifconfig eth0:mammoth $me netmask 255.252.0.0
echo "Acquire::http::proxy \"http://$homer:3128/\";" >> /etc/apt/apt.conf

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get -y upgrade


##############
# user
##############

readonly THE_USER=rubby
useradd -m -s /bin/bash $THE_USER

useradd -m -s /bin/bash buildbox

cat >> /etc/sudoers <<EOF

# Buildbox can do things as rubby
buildbox ALL = (rubby) NOPASSWD: ALL

EOF

##############
# buildbox
##############

apt-get install -y curl supervisor

curl -sL https://raw.githubusercontent.com/buildboxhq/buildbox-agent/master/install.sh > /home/buildbox/install_buildbox.sh
chmod +x /home/buildbox/install_buildbox.sh
su - buildbox /home/buildbox/install_buildbox.sh

cat > /etc/supervisor/conf.d/buildbox-agent.conf <<EOF
[program:buildbox-agent]

command=/home/buildbox/.buildbox/buildbox-agent start --access-token d726c4c0e895329cd666ef8cd1da80c5e01616a4e30873f7bb
redirect_stderr=true
user=buildbox
environment=HOME="/home/buildbox",USER="buildbox"
autostart=true
autorestart=true
EOF

/etc/init.d/supervisor stop
sleep 1
/etc/init.d/supervisor start

##############
# ruby
##############

RUBY_VERSION=2.1.2

echo "gem: --no-document" > ~/.gemrc
echo "gem: --no-document" > /home/$THE_USER/.gemrc

apt-get install -y build-essential libffi-dev libgdbm-dev libncurses5-dev libreadline-dev libssl-dev libyaml-dev zlib1g-dev libmysqlclient-dev libxml2-dev libxslt-dev git

cd /tmp

wget -O chruby-0.3.8.tar.gz https://github.com/postmodern/chruby/archive/v0.3.8.tar.gz
tar -xzf chruby-0.3.8.tar.gz
cd chruby-0.3.8/
make install

echo source /usr/local/share/chruby/chruby.sh > /etc/profile.d/chruby.sh
chmod +x /etc/profile.d/chruby.sh

cd /tmp

wget -O ruby-install-0.4.3.tar.gz https://github.com/postmodern/ruby-install/archive/v0.4.3.tar.gz
tar -xzf ruby-install-0.4.3.tar.gz
cd ruby-install-0.4.3/
make install

/usr/local/bin/ruby-install ruby $RUBY_VERSION

echo "chruby ruby-$RUBY_VERSION" >> /home/$THE_USER/.bash_profile

rm -rf chruby-* ruby-install-*

##############
# nginx
##############


# install stuff
apt-get -y install nginx

# nginx config
rm /etc/nginx/sites-enabled/default
cat > /etc/nginx/sites-available/dashboard.conf <<EOF

upstream dashboard {
  server unix:/tmp/dashboard.unicorn.sock;
}

server {
  listen 80 default_server;
  server_name _;

  root /home/$THE_USER/dashboard/public;

  location @payments {
    proxy_pass http://dashboard;
    proxy_set_header X-Forwarded-Host \$host;
  }

  gzip_types text/plain text/css text/javascript application/x-javascript application/javascript;

  location ^~ /assets/ {
    expires +1y;
    add_header Pragma public;
    add_header Cache-Control "public";
    autoindex off;
    add_header Last-Modified "";
  }

  try_files \$uri @payments;
}

EOF

ln -s /etc/nginx/sites-available/dashboard.conf /etc/nginx/sites-enabled/dashboard.conf


##############
# mysql
##############

apt-get install -y mysql-server mysql-client


##############
# dashboard
##############

# id_deploy from my macbook air
mkdir -p /home/$THE_USER/.ssh && chmod 0700 /home/$THE_USER/.ssh
cat > /home/$THE_USER/.ssh/id_rsa <<EOF
-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEAtOPMS7r3DJl2NcXdfUMkRnqkUeiMtoSiwNY6+B5empMcBLGF
v+89MDVWY4TS+lSaoD7OfMKsBJK9Rc16RKmoKutur0Y4LeoNYgn3ZmRWeRP+UxGs
JQxFgXnUU9tRIrpnQaTunzrc3RWsxJXTM4Ar5Cxxt/cXldSWSj6swIIcOOR7SOlZ
bLVkrIWksPprYhgMoA/UiUW1sorQo/CJ6m1qiSgewu/cc/cCj0eaU1iO1c/As0LK
i7bel8awYAK8zY9IRkCvqiD7T+sRqNUFFPdqK9kxYkVDWcsfDiPtudueKoDLgH34
D/vu442qOIyV/61ncA2D3AIEedL8jubLz2HZBwIDAQABAoIBAFqAYlU9XJ80JH1w
2ojyT7LnZ1EHrWcf4yHhzS0YXLKviWQbwVQvCQkWlntCGCBgteAYrEylRVUgaYwD
6vlxfI7EreMJmc/2+u0jGWFkMBNx2luLSvpaMmg+IOo3n1dltYWVVEHcPGZskrzk
TP/GT69gQSEOggFXlD3fL6U9M4uOhPzLAoIIOgq9vOCnH+xBBfCZA4Tu1rNEjbS+
npwJLXnRC6DUmKdYnFwcnFxxtlHyn2+0MRbDS1weLb4qy5cZwQdjS6eyAvvRc6K8
0/02eBgS6U+VQabxdCRu3LjT4Sl+zt8w0TaUYdvoPvXzFEk1ZLsbO87tbCIdt+qN
B6H6k1ECgYEA5odiWHVxBgZ/iXYVaGEp8H70Uv0KMFXsh72bCvWkW+95R6U627VK
wT4oi6hZAukTlMAuaYz/JHV0owEpXRzRvGJInN13MOQhiHIJ0fRhmcb2tr+WVBLx
XAam93jv2brYYZtfVLr7DgWd6BMrPn1vM0UTlSJFEft4rX02f7cYA/8CgYEAyOBZ
88FZvv5IESvDfVoZlpvFeW2r0avixbdCkVp0zWZkNnhPsGX4R26sRI4MJlQVVI3D
vqNx71bEXuTIUvkI/0DCM41O2fuTEz3FIKuIGge3wOArtlXLGUORGKPmU1l2HWmr
g2lyVWA+K4uyeboNsD+eneCuGM79YEBUwL8iCvkCgYEArJWeousJeqFSye6FiGd1
pn7lG1wlTJqHQfhJIqNUMR/PhDvHHMVU+ec3I5cdTHiCGFLobE0Klpj4gTBVb0gs
HQTXp9iFayzfje8SOwTiLOYvvhEg0kB8QZEZXxxDNJYVeL2BWUXCvnSmCyCOt3Hg
1llYl8XYP+YsKnYbXvIMILECgYEAqTCFsxAUZhDIZGYG9qqPyNGUxwy/Xg83Jq6P
C9wzatkl6Nb2z61jK88km21FAHdrq9bnmscRbLQZG4/4xiHpGQzTRRZs5p7FJryt
LzIqpToA5Bwr1Rx3vuSw7h8GHQfJu0ZIZpvG5+/zDTxRa8NwShWbpIAcQtr8gDhO
6jVSGAkCgYAdx/hVj4suK3TCOV33cIKgwH2h+uDVRgECS12/+ZEvMiknG/la8Itw
E09ePZzscWjJJRrbbNjw43HXZjk9oJS93/XI5CQIvm5Alizqk5lB2XmnnimGFQpK
iOJU7XgVKhjykVYKFLHBx6qa4dfG4FJBz0bluULmiVqiNtF+b21zlA==
-----END RSA PRIVATE KEY-----
EOF

chmod 0600 /home/$THE_USER/.ssh/id_rsa

cat > /home/$THE_USER/.ssh/config <<EOF
Host github.com
  StrictHostKeyChecking no
Host bitbucket.org
  StrictHostKeyChecking no
EOF
chmod 0600 /home/$THE_USER/.ssh/config

cat > /home/$THE_USER/bootstrap_dashboard.sh <<EOF
#!/bin/bash

set -e
set -x

git clone git@bitbucket.org:compassuav/dashboard.git
cd dashboard
gem install bundler
bundle install
RAILS_ENV=production rake db:create db:schema:load
RAILS_ENV=production rake unicorn:start
EOF

chmod +x /home/$THE_USER/bootstrap_dashboard.sh

chown -R $THE_USER /home/$THE_USER

su - $THE_USER /home/$THE_USER/bootstrap_dashboard.sh

/etc/init.d/nginx restart



echo Done
