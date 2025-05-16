#!/bin/bash

# Variables from Terraform template interpolation
APP_HOME="/app"
APP_PORT=${app_port}
REPO_URL="https://github.com/YOUR_GITHUB_USER/YOUR_REPO.git"  # Replace this with your app repo URL
BRANCH="main"

# Update packages and install dependencies
apt-get update -y
apt-get install -y git curl build-essential libpq-dev

# Install Ruby environment
apt-get install -y ruby-full ruby-bundler

# Create app directory
mkdir -p $APP_HOME
cd $APP_HOME

# Clone the app repo
if [ ! -d "$APP_HOME/.git" ]; then
  git clone --branch $BRANCH $REPO_URL .
else
  git pull origin $BRANCH
fi

# Install bundler and gems
gem install bundler
bundle install --deployment --without development test

# Start Puma server (background process)
bundle exec puma -C puma.rb &

# Optionally, create a systemd service for Puma (better for managing process lifecycle)
# systemctl enable puma.service
# systemctl start puma.service
