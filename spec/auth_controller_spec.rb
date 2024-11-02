# frozen_string_literal: true

ENV['APP_ENV'] = 'test'

require 'simplecov'
SimpleCov.start

require 'rspec'
require 'rack/test'
require_relative '../controllers/main_controller'
require_relative '../app'
require_relative '../models/user'

RSpec.describe 'AuthController' do
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

  it 'redirects to the page of password resets' do
    get '/password_resets/new'
    expect(last_response.status).to eq(200)
    expect(last_request.path).to eq('/password_resets/new')
  end

  it 'reports that the password change was successful' do
    get '/password_resets/notice'
    expect(last_response.status).to eq(200)
    expect(last_request.path).to eq('/password_resets/notice')
  end

  it 'redirects to the login page when not authenticated' do
    get '/users'
    expect(last_response.status).to eq(302)
    expect(last_response.headers['Location']).to include('/login')
  end

  it 'redirects to the page event when authenticated' do
    post '/login', { username: 'testuser', password: 'testuserpassword' }
    get '/events'
    expect(last_response.status).to eq(200)
    expect(last_request.path).to eq('/events')
  end

  it 'shows the login form' do
    get '/login'
    expect(last_response).to be_ok
    expect(last_response.body).to include('<form')
    expect(last_response.body).to include('Log In')
    expect(last_response.body).to include('name="username"')
    expect(last_response.body).to include('name="password"')
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
    post '/register', username: 'testuser', password: 'testuserpassword', confirm_password: 'testuserpassword',
         email: 'testuser@example.com', names: 'Test User'
    expect(last_response.status).to eq(302)
    follow_redirect!
    expect(last_request.path).to eq('/failed')
    expect(last_response.body).to include('The username is already being used. Please use a different one')
  end

  it 'signs up with available credentials' do
    post '/register', username: 'testuserOk', password: 'testuserpasswordOk', confirm_password: 'testuserpasswordOk',
         email: 'testuserOk@example.com', names: 'Test User'
    expect(last_response.status).to eq(302)
    follow_redirect!
    expect(last_request.path).to eq('/login')
  end

  it 'signs up with mismatched passwords' do
    post '/register', username: 'testuserNew', password: 'testuserpassword1', confirm_password: 'testuserpassword2',
         email: 'testuserNew@example.com', names: 'Test User New'
    expect(last_response.status).to eq(302)
    follow_redirect!
    expect(last_request.path).to eq('/failed')
    expect(last_response.body).to include('Passwords do not match')
  end

  it 'fails to sign up with a used email' do
    post '/register', username: 'testuserNew', password: 'testuserpassword1', confirm_password: 'testuserpassword2',
         email: 'testuser@example.com', names: 'Test User New'
    expect(last_response.status).to eq(302)
    follow_redirect!
    expect(last_request.path).to eq('/failed')
    expect(last_response.body).to include('The email is already being used. Please use a different one')
  end

  it 'password resets with created user' do
    post '/register', {
      username: 'testuser2',
      password: 'testuserpassword2',
      confirm_password: 'testuserpassword2',
      email: 'testuser2@example.com',
      names: 'Test User'
    }
    expect(last_response.status).to eq(302)
    follow_redirect!
    expect(last_request.path).to eq('/login')

    get '/password_resets/new'

    post '/password_resets', {
      username: 'testuser2',
      password: 'testuserpassword2',
      email: 'testuser2@example.com'
    }

    follow_redirect!
    expect(last_response.status).to eq(200)
    expect(last_request.path).to eq('/password_resets/notice')
    expect(last_response.body).to include('A password reset email has been sent to your email address')
    expect(last_response.body).to include('Back To Login')
  end

  it 'password resets with non-existent user' do
    post '/password_resets', {
      username: 'testuser2',
      password: 'testuserpassword2',
      email: 'testuser2@example.com'
    }
    follow_redirect!
    expect(last_response.status).to eq(200)
    expect(last_request.path).to eq('/password_resets/notice')
    expect(last_response.body).to include('This email address is not registered')
    expect(last_response.body).to include('Back To Login')
  end

  it 'renders the password reset form when token is valid' do
    user = User.create(
      username: 'testuser',
      email: 'testuser@example.com',
      password: 'password',
      password_reset_token: 'validtoken',
      password_reset_sent_at: 1.hour.ago
    )

    post '/login', {
      username: 'testuser',
      password: 'testuserpassword',
      email: 'testuser@example.com'
    }
    follow_redirect!
    expect(last_response.status).to eq(200)

    get "/password_resets/#{user.password_reset_token}/edit"

    expect(last_response.status).to eq(200)
    expect(last_response.body).to include('New Password')
  end

  it 'redirects to the notice page when token has expired' do
    user = User.create(
      username: 'testuser',
      email: 'testuser@example.com',
      password: 'password',
      password_reset_token: 'expiredtoken',
      password_reset_sent_at: 3.hours.ago
    )

    post '/login', {
      username: 'testuser',
      password: 'testuserpassword',
      email: 'testuser@example.com'
    }
    follow_redirect!
    expect(last_response.status).to eq(200)

    get "/password_resets/#{user.password_reset_token}/edit"

    expect(last_response).to be_redirect
    follow_redirect!
    expect(last_request.path).to eq('/password_resets/notice')
    expect(last_response.body).to include('The token has expired, please try again')
  end

  it 'resets the password successfully when token is valid' do
    user = User.create(
      username: 'testuser',
      email: 'testuser@example.com',
      password: 'oldpassword',
      password_reset_token: 'validtoken',
      password_reset_sent_at: 1.hour.ago
    )

    post '/login', {
      username: 'testuser',
      password: 'testuserpassword',
      email: 'testuser@example.com'
    }
    follow_redirect!
    expect(last_response.status).to eq(200)

    patch "/password_resets/#{user.password_reset_token}", { password: 'newpassword' }

    expect(user.reload.authenticate('newpassword')).to be_truthy
    expect(user.password_reset_token).to be_nil
    expect(user.password_reset_sent_at).to be_nil

    expect(last_response).to be_redirect
    follow_redirect!
    expect(last_request.path).to eq('/password_resets/notice')
    expect(last_response.body).to include('The password has been successfully reset')
  end

  it 'redirects to the notice page when token is invalid' do
    post '/login', {
      username: 'testuser',
      password: 'testuserpassword',
      email: 'testuser@example.com'
    }
    follow_redirect!
    expect(last_response.status).to eq(200)
    patch '/password_resets/invalidtoken', { password: 'newpassword' }

    expect(last_response).to be_redirect
    follow_redirect!
    expect(last_request.path).to eq('/password_resets/notice')
    expect(last_response.body).to include('This email address is not registered')
  end

  it 'clears the password reset token and timestamp' do
    user = User.create(
      username: 'testuser',
      email: 'testuser@example.com',
      password: 'password',
      password_reset_token: 'sometoken',
      password_reset_sent_at: 1.hour.ago
    )

    user.clear_password_reset_token!

    expect(user.password_reset_token).to be_nil
    expect(user.password_reset_sent_at).to be_nil

    reloaded_user = User.find(user.id)
    expect(reloaded_user.password_reset_token).to be_nil
    expect(reloaded_user.password_reset_sent_at).to be_nil
  end
end