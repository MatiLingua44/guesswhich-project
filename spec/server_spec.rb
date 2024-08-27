ENV['APP_ENV'] = 'test'

require 'simplecov'
SimpleCov.start

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

  it 'redirects to the user information when authenticated' do
    post '/login' , {username: 'testuser', password: 'testuserpassword',email: 'testuser@example.com'}
    follow_redirect!

    expect(last_response.status).to eq(200)
    expect(last_request.path).to eq('/menu')

    follow_redirect!
    get '/users'
    expect(last_response.status).to eq(200)
    expect(last_request.path).to eq('/users')
    expect(last_response.body).to include('testuser')
    expect(last_response.body).to include('testuser@example.com')
  end

  it 'redirects to the login page when not authenticated' do 
    get '/users'
     expect(last_response.status).to eq(302)
     expect(last_response.headers['Location']).to include('/login')
  end

  it 'shows the home page' do
    get '/' do
      expect(last_response.status).to eq(200)
      expect(last_request.path).to eq('/')
    end
  end

  it 'redirects to the page event when authenticated'do
    post '/login' , {username: 'testuser', password: 'testuserpassword'}
    get '/events'
    expect(last_response.status).to eq(200)
    expect(last_request.path).to eq('/events')
  end

  it 'redirects to the login page when not authenticated' do
      get '/events' 
      expect(last_response.status).to eq(302)
      expect(last_response.headers['Location']).to include('/login')
  end

  it 'shows the login form' do
    get '/login'
    expect(last_response).to be_ok
    expect(last_response.body).to include('<form')
    expect(last_response.body).to include('Log In')
    expect(last_response.body).to include('name="username"')
    expect(last_response.body).to include('name="password"')
  end

  it 'logs in with valid credentials' do
    post '/login', username: 'testuser', password: 'testuserpassword'
    expect(last_response.status).to eq(302)
    follow_redirect!
    expect(last_request.path).to eq('/menu')
    expect(last_response.body).to include('User: testuser')
  end

  it 'fails to log in with invalid credentials' do
    post '/login', username: 'testuser', password: 'wrongpassword'
    expect(last_response.status).to eq(302)
    follow_redirect!
    expect(last_request.path).to eq('/failed')
    expect(last_response.body).to include('Invalid credentials')
  end

  it 'redirects to login page if accessing a protected route without logging in' do
    get '/menu'
    expect(last_response.status).to eq(302)
    follow_redirect!
    expect(last_request.path).to eq('/login')
  end

  it 'shows the register form' do
    get '/register'
    expect(last_response).to be_ok
    expect(last_response.body).to include('<form')
    expect(last_response.body).to include('Sign Up')
    expect(last_response.body).to include('name="username"')
    expect(last_response.body).to include('name="password"')
    expect(last_response.body).to include('name="confirm_password"')
    expect(last_response.body).to include('name="email"')
    expect(last_response.body).to include('name="names"')
  end

  it 'signs up with used credentials' do
    post '/register', username: 'testuser', password: 'testuserpassword', confirm_password: 'testuserpassword', email: 'testuser@example.com', names: 'Test User'
    expect(last_response.status).to eq(302)
    follow_redirect!
    expect(last_request.path).to eq('/failed')
    expect(last_response.body).to include('The username is already being used. Please use a different one')
  end

  it 'signs up with available credentials' do
    post '/register', username: 'testuserOk', password: 'testuserpasswordOk', confirm_password: 'testuserpasswordOk', email: 'testuserOk@example.com', names: 'Test User'
    expect(last_response.status).to eq(302)
    follow_redirect!
    expect(last_request.path).to eq('/login')
  end

  it 'signs up with mismatched passwords' do
    post '/register', username: 'testuserNew', password: 'testuserpassword1', confirm_password: 'testuserpassword2', email: 'testuserNew@example.com', names: 'Test User New'
    expect(last_response.status).to eq(302)
    follow_redirect!
    expect(last_request.path).to eq('/failed')
    expect(last_response.body).to include('Passwords do not match')
  end

  it 'fails to sign up with a used email' do
    post '/register', username: 'testuserNew', password: 'testuserpassword1', confirm_password: 'testuserpassword2', email: 'testuser@example.com', names: 'Test User New'
    expect(last_response.status).to eq(302)
    follow_redirect!
    expect(last_request.path).to eq('/failed')
    expect(last_response.body).to include('The email is already being used. Please use a different one')
  end
end
