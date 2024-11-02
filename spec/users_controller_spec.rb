# frozen_string_literal: true

ENV['APP_ENV'] = 'test'

require 'simplecov'
SimpleCov.start

require 'rspec'
require 'rack/test'
require_relative '../controllers/main_controller'
require_relative '../app'
require_relative '../models/user'

RSpec.describe 'UsersController' do
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

  it 'redirects to the user information when authenticated', :aggregate_failures do
    post '/login', { username: 'testuser', password: 'testuserpassword', email: 'testuser@example.com' }
    follow_redirect!

    expect(last_response.status).to eq(200)
    expect(last_request.path).to eq('/menu')

    get '/user'
    expect(last_response.status).to eq(200)
    expect(last_request.path).to eq('/user')
    expect(last_response.body).to include('testuser')
    expect(last_response.body).to include('testuser@example.com')
  end

  it 'deletes a user' do
    post '/login', { username: 'testuser', password: 'testuserpassword' }
    follow_redirect!

    expect(last_response.status).to eq(200)
    expect(last_request.path).to eq('/menu')

    get '/user'
    expect(last_response.status).to eq(200)
    expect(last_request.path).to eq('/user')
    expect(last_response.body).to include('testuser')
    expect(last_response.body).to include('testuser@example.com')

    post '/user/delete'
    expect(last_response.status).to eq(302)
  end

  it 'edits a user' do
    post '/login', {
      username: 'testuser',
      password: 'testuserpassword',
      email: 'testuser@example.com'
    }
    follow_redirect!
    expect(last_response.status).to eq(200)
    expect(last_request.path).to eq('/menu')

    get '/edit-profile'
    expect(last_request.path).to eq('/edit-profile')
    expect(last_response.body).to include('Delete User')
  end

  it 'resets score user' do
    post '/login', {
      username: 'testuser',
      password: 'testuserpassword',
      email: 'testuser@example.com'
    }

    follow_redirect!
    expect(last_response.status).to eq(200)
    expect(last_request.path).to eq('/menu')

    get '/edit-profile'
    expect(last_response.status).to eq(200)
    expect(last_request.path).to eq('/edit-profile')

    post '/user/reset-score', {
      user_score: 0
    }
    expect(last_request.path).to eq('/user/reset-score')

    get '/edit-profile'
    expect(last_response.status).to eq(200)
    expect(last_request.path).to eq('/edit-profile')
    expect(last_response.body).to include('Reset Score')
  end

  it 'modifies the username successfully' do
    post '/login', {
      username: 'testuser',
      password: 'testuserpassword',
      email: 'testuser@example.com'
    }

    follow_redirect!
    expect(last_response.status).to eq(200)
    expect(last_request.path).to eq('/menu')

    get '/edit-profile'
    expect(last_response.status).to eq(200)
    expect(last_request.path).to eq('/edit-profile')

    post '/profile-modification', {
      username: 'new_username'
    }
    follow_redirect!
    expect(last_response.status).to eq(200)
    expect(last_request.path).to eq('/edit-profile')

    get '/user'
    expect(last_response.body).to include('new_username')
  end

  it 'fails to modify the username if it is already in use' do
    post '/login', {
      username: 'testuser',
      password: 'testuserpassword',
      email: 'testuser@example.com'
    }

    follow_redirect!
    expect(last_response.status).to eq(200)
    expect(last_request.path).to eq('/menu')

    User.create(username: 'existing_user', email: 'existing@example.com', password: 'password')

    post '/profile-modification', {
      username: 'existing_user'
    }
    follow_redirect!
    expect(last_response.status).to eq(200)
    expect(last_request.path).to eq('/failed')

    get '/failed'
    expect(last_response.body).to include('The username is already being used')
  end

  it 'modifies the email successfully' do
    post '/login', {
      username: 'testuser',
      password: 'testuserpassword',
      email: 'testuser@example.com'
    }

    follow_redirect!
    expect(last_response.status).to eq(200)
    expect(last_request.path).to eq('/menu')

    get '/edit-profile'
    expect(last_response.status).to eq(200)
    expect(last_request.path).to eq('/edit-profile')

    post '/profile-modification', {
      email: 'new_email@example.com'
    }
    follow_redirect!
    expect(last_response.status).to eq(200)
    expect(last_request.path).to eq('/edit-profile')

    get '/user'
    expect(last_response.body).to include('new_email@example.com')
  end

  it 'fails to modify the email if it is already in use' do
    post '/login', {
      username: 'testuser',
      password: 'testuserpassword',
      email: 'testuser@example.com'
    }

    follow_redirect!
    expect(last_response.status).to eq(200)
    expect(last_request.path).to eq('/menu')

    User.create(username: 'existing_user', email: 'existing@example.com', password: 'password')

    post '/profile-modification', {
      email: 'existing@example.com'
    }
    follow_redirect!
    expect(last_response.status).to eq(200)
    expect(last_request.path).to eq('/failed')

    get '/failed'
    expect(last_response.body).to include('The email is already being used')
  end
end