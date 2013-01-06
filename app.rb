require 'sinatra'
require 'json'
require File.expand_path("../lib/project", __FILE__)

CAP_PROJECTS_PATH = ENV['CAP_PROJECTS_PATH'] || File.expand_path('../.projects', __FILE__)

get '/' do
  'Hello World'
end

get '/projects' do
  content_type :json
  { projects: Project.all(CAP_PROJECTS_PATH) }.to_json
end

post '/projects/:name/cap' do
  content_type :json
  begin
    # extract arguments from request body
    payload = JSON.parse(request.body.read)
    raise 'missing arguments' unless payload['args']

    # execute cap command
    p = Project.new("#{CAP_PROJECTS_PATH}/#{params[:name]}")
    p.cap(payload['args'])
  rescue => e
    error 400, e.message.to_json
  end
  "ok".to_json
end
