# Base image
FROM ruby:3.2

# Set environment variables
ENV APP_HOME /app
WORKDIR $APP_HOME

# Install required packages
RUN apt-get update -qq && \
    apt-get install -y build-essential libpq-dev curl

# Copy Gemfile and Gemfile.lock before running bundle install
COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install


# Copy application code
COPY . .

# Copy the startup script and make it executable
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Expose port
EXPOSE 8000

# Start the application using Puma
CMD ["/start.sh"]
