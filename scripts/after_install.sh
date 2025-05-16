#!/bin/bash
set -e

echo "Installing gem dependencies..."
cd /app
gem install bundler --no-document
bundle install --deployment --without development test
