# frozen_string_literal: true

ENV['APP_ENV'] = 'test'

require 'simplecov'
SimpleCov.start

require 'rspec'
require 'rack/test'
require_relative '../controllers/main_controller'
require_relative '../app'
require_relative '../models/user'

RSpec.describe 'MainController' do
  include Rack::Test::Methods

  def app
    App.new
  end

  before(:each) do
    @user = User.create(
      username: 'testuser',
      password: 'testuserpassword',
      email: 'testuser@example.com',
      names: 'Test User',
      score: 0
    )
  end

  it ' shows the home page and logs in with valid credentials' do
    get '/'
    post '/login', username: 'testuser', password: 'testuserpassword'
    expect(last_response.status).to eq(302)
    follow_redirect!
  end

  it 'fails to log in with invalid credentials' do
    post '/login', username: 'testuser', password: 'wrongpassword'
    expect(last_response.status).to eq(302)
    follow_redirect!
    expect(last_request.path).to eq('/failed')
  end
end
