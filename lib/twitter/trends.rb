module Twitter
  module Trends
    
    extend SingleForwardable
    
    def self.client; Client.new end
    
    def_delegators :client, :current, :daily, :weekly, :available, :for_location

  end
end
