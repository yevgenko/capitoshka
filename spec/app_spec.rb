ENV['CAP_PROJECTS_PATH'] = File.expand_path('../projects', __FILE__)

require_relative '../app.rb'
require 'rack/test'

set :environment, :test

def app
  Sinatra::Application
end

describe 'Capistrano Web API' do
  include Rack::Test::Methods

  it "should load homepage" do
    get '/'
    last_response.should be_ok
  end

  describe "get /projects" do
    it "should be ok" do
      get '/projects'
      last_response.should be_ok
    end

    it "should response with json" do
      get '/projects'
      last_response.header['Content-Type'].should match /json/
    end

    it 'should look for the projects' do
      Project.should_receive(:all).with(ENV['CAP_PROJECTS_PATH'])
      get '/projects'
    end
  end

  describe "post /projects/:name/cap" do
    let(:args) { ['deploy:check'] }

    before(:each) do
      @project_a = Project.new("#{ENV['CAP_PROJECTS_PATH']}/a")
      @project_a.stub(:cap)
      Project.stub('new').and_return(@project_a)
    end

    it 'should be ok' do
      post '/projects/a/cap', { args: args }.to_json
      last_response.should be_ok
    end

    it 'should instanciate right project' do
      Project.should_receive(:new).with("#{ENV['CAP_PROJECTS_PATH']}/a")
      post '/projects/a/cap', { args: args }.to_json
    end

    it 'should call cap method on the project' do
      @project_a.should_receive(:cap)
      post '/projects/a/cap', { args: args }.to_json
    end

    it 'should pass arguments to the cap method' do
      @project_a.should_receive(:cap).with(args)
      post '/projects/a/cap', { args: args }.to_json
    end

    it 'should not call cap method without arguments' do
      @project_a.should_not_receive(:cap)
      post '/projects/a/cap'
    end
  end
end
