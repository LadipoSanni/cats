#!/bin/bash

# Random delay between 1 and 10 seconds
DELAY=$((1 + RANDOM % 10))
echo "Starting application in $DELAY seconds..."
sleep $DELAY

# Start the application using Puma
exec bundle exec puma -C puma.rb
