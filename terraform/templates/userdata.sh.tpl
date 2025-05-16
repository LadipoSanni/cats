#!/bin/bash

APP_HOME="/app"
APP_PORT=${app_port}
REPO_URL="https://github.com/YOUR_GITHUB_USER/YOUR_REPO.git"
BRANCH="main"
USER="ubuntu"

# Update and install dependencies
apt-get update -y
apt-get install -y git curl build-essential libpq-dev ruby-full ruby-bundler

# Setup app directory
mkdir -p $APP_HOME
chown $USER:$USER $APP_HOME

# Clone or pull app repo as the app user
sudo -u $USER bash <<EOF
cd $APP_HOME
if [ ! -d ".git" ]; then
  git clone --branch $BRANCH $REPO_URL .
else
  git pull origin $BRANCH
fi

gem install bundler
bundle install --deployment --without development test
EOF

# Setup Puma systemd service
cat <<EOL > /etc/systemd/system/puma.service
[Unit]
Description=Puma HTTP Server for Sinatra App
After=network.target

[Service]
Type=simple
User=$USER
WorkingDirectory=$APP_HOME
ExecStart=/usr/local/bin/bundle exec puma -C $APP_HOME/puma.rb
Restart=always
RestartSec=5
Environment=RACK_ENV=production
Environment=PORT=$APP_PORT

[Install]
WantedBy=multi-user.target
EOL

# Reload systemd and enable service
systemctl daemon-reload
systemctl enable puma.service
systemctl start puma.service

# Healthcheck function
function healthcheck() {
  for i in {1..10}; do
    if curl -s http://localhost:$APP_PORT/ >/dev/null; then
      echo "App is healthy."
      return 0
    else
      echo "Waiting for app to be healthy... attempt $i"
      sleep 5
    fi
  done
  echo "App failed healthcheck."
  return 1
}

healthcheck

# Log rotation (optional, example)
cat <<EOL > /etc/logrotate.d/puma
$APP_HOME/log/*.log {
  daily
  missingok
  rotate 14
  compress
  delaycompress
  notifempty
  copytruncate
}
EOL
