module Twitter
  module Trends
    
    class Client

    
      def initialize(options={})
        @api_endpoint = options.delete(:api_endpoint)
        @api_endpoint ||= "api.twitter.com/#{Twitter::API_VERSION}/trends"
        @api_endpoint = Addressable::URI.heuristic_parse(@api_endpoint)
        @api_endpoint.path = "/trends" if @api_endpoint.path.blank?
        @api_endpoint = @api_endpoint.to_s
      end
    
      # :exclude => 'hashtags' to exclude hashtags
      def current(options={})
        results = connection.get do |req|
          req.url "current.json", options
        end.body
        results.trends = results.trends.values.flatten
        results
      end

      # :exclude => 'hashtags' to exclude hashtags
      # :date => yyyy-mm-dd for specific date
      def daily(options={})
        results = connection.get do |req|
          req.url "daily.json", options
        end.body
        results.trends = results.trends.values.flatten
        results
      end

      # :exclude => 'hashtags' to exclude hashtags
      # :date => yyyy-mm-dd for specific date
      def weekly(options={})
        results = connection.get do |req|
          req.url "weekly.json", options
        end.body
        results.trends = results.trends.values.flatten
        results
      end
    
      def available(query={})
        connection.get do |req|
          req.url "available.json", query
        end.body
      end

      def for_location(woeid,options = {})
        connection.get do |req|
          req.url "#{woeid}.json", options
        end.body
      end
    
      def connection
        headers = {
          :user_agent => Twitter.user_agent
        }
        @connection ||= Faraday::Connection.new(:url => @api_endpoint, :headers => headers) do |builder|
          builder.adapter(@adapter || Faraday.default_adapter)
          builder.use Faraday::Response::MultiJson
          builder.use Faraday::Response::Mashify
        end
            
      end
      
    end
  end
end
