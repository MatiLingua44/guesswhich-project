ENV['APP_ENV'] = 'test'

require_relative '../server.rb'
require 'rspec'
require 'rack/test'

RSpec.describe 'Server' do
  include Rack::Test::Methods

  def app
    # Sinatra::Application
    App
  end

  it 'says hello' do
    get '/test'

    expect(last_response).to be ok
    expect(last_response.body).to eq('hello')
  end
end