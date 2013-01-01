require_relative '../app.rb'
require 'rack/test'

set :environment, :test

def app
  Sinatra::Application
end

describe 'Simple Capistrano Web API' do
  include Rack::Test::Methods

  it "should load homepage" do
    get '/'
    last_response.should be_ok
  end
end
