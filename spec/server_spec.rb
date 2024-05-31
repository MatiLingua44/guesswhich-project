ENV['APP_ENV'] = 'test'

require_relative '../server.rb'
require_relative '../models/user'
require 'rspec'
require 'rack/test'


RSpec.describe 'Server' do
  include Rack::Test::Methods

  def app
    App.new
  end

  before(:each) do
    User.delete_all

    @user = User.create(
      username: 'testuser',
      password: 'testuserpassword',
      email: 'testuser@example.com',
      names: 'Test User',
      score: 0
    )
  end

  it 'shows the login form' do
    get '/login'
    expect(last_response).to be_ok
    expect(last_response.body).to include('<form')
  end

  it 'logs in with valid credentials' do
    post '/login', username: 'testuser', password: 'testuserpassword'
    expect(last_response.status).to eq(302)
    follow_redirect!
    expect(last_request.path).to eq('/menu')
  end

  it 'fails to log in with invalid credentials' do
    post '/login', username: 'testuser', password: 'wrongpassword'
    expect(last_response.status).to eq(302)
    follow_redirect!
    expect(last_request.path).to eq('/login')
  end

  it 'redirects to login page if accessing a protected route without logging in' do
    get '/menu'
    expect(last_response.status).to eq(302)
    follow_redirect!
    expect(last_request.path).to eq('/login')
  end

  it 'shows register form' do
    get '/register'
    expect(last_response).to be_ok
    expect(last_response.body).to include('<form')
  end

  it 'sign up with used credentials' do
    post '/register', username: 'testuser', password: 'testuserpassword', email: 'testuser@example.com', names: 'Test User'
    expect(last_response.status).to eq(200)
    expect(last_request.path).to eq('/register')
  end

  it 'sign up with available credentials' do
    post '/register', username: 'testuserOk', password: 'testuserpasswordOk', email: 'testuserOk@example.com', names: 'Test User'
    expect(last_response.status).to eq(302)
    follow_redirect!
    expect(last_request.path).to eq('/login')
  end
end