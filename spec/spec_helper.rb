require 'rubygems'
gem 'rspec'
require 'spec'
 
$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'flickr_fu'

Flickr::Base.logger = Logger.new('/dev/null')

module SpecHelper
  def self.flickr
    Flickr.new(:key => "2f7bf3aceba0ca2f11f9ad46e7552459", :secret => "17b59864beb29370")
  end
  
  def mock_flickr_request_with_fixture(flickr, path, times_called = 1)
    xml = File.read(File.expand_path(File.dirname(__FILE__) + "/fixtures/flickr/#{path}.xml"))
    flickr.should_receive(:request_over_http).exactly(times_called).times.and_return(xml)
  end
end

class Hash
  def strip_api_params!
    delete :api_sig
    delete :api_key
    delete :api_token
  end
end