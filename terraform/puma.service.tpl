[Unit]
Description=Puma HTTP Server for Sinatra App
After=network.target

[Service]
Type=simple
User=ubuntu
WorkingDirectory=/app
ExecStart=/usr/local/bin/bundle exec puma -C /app/puma.rb
Restart=always
RestartSec=5
Environment=RACK_ENV=production
Environment=PORT=8000

[Install]
WantedBy=multi-user.target
