# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/json'
require 'net/http'
require 'json'

module Cats
  class Web < Sinatra::Base
    configure do
      set :url, URI('http://thecatapi.com/api/images/get').freeze
    end

    get '/' do
      json url: Net::HTTP.get_response(settings.url)['location']
    end

    # Health Check Endpoint
    get '/health' do
      status 200
      json status: 'UP', timestamp: Time.now.to_s
    end

    # Readiness Check Endpoint
    get '/ready' do
      # Simulate a readiness check (e.g., database connection check, etc.)
      status 200
      json status: 'READY', timestamp: Time.now.to_s
    end

    # Circuit Breaker Endpoint (Simple Example)
    get '/breaker' do
      begin
        response = Net::HTTP.get_response(settings.url)
        if response.is_a?(Net::HTTPSuccess)
          json status: 'SUCCESS', data: response.body
        else
          halt 500, json(status: 'FAILURE', error: 'Downstream service failed')
        end
      rescue => e
        halt 503, json(status: 'ERROR', error: e.message)
      end
    end
  end
end
