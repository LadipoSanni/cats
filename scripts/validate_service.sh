#!/bin/bash
set -e

echo "Validating Puma app health..."
for i in {1..10}; do
  if curl -s http://localhost:8000/ > /dev/null; then
    echo "App is healthy!"
    exit 0
  else
    echo "Waiting for app to be healthy... attempt $i"
    sleep 5
  fi
done

echo "App failed healthcheck."
exit 1
