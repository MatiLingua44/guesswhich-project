# frozen_string_literal: true

# UsersController: Handles user-related actions such as profile viewing,
# editing, score resetting, and account deletion. Each action interacts
# with the User model and sessions to manage the current user's data.
class UsersController < Sinatra::Base
  set :views, File.expand_path('../views', __dir__)

  # Shows the user information
  get '/user' do
    @user = User.find_by(username: session[:username])
    erb :'users/info'
  end

  # Shows user edit window
  get '/edit-profile' do
    erb :'users/edit-profile'
  end

  # Profile modification
  post '/profile-modification' do
    user_name = params[:username]
    e_mail    = params[:email]

    session[:redirect] = '/edit-profile'

    if user_name
      if User.find_by(username: user_name)
        session[:error] = 'The username is already being used. Please use a different one'
        redirect '/failed'
      else
        User.find_by(username: session[:username]).update(username: user_name)
        session[:username] = user_name
        redirect '/edit-profile'
      end
    end

    if e_mail
      if User.find_by(email: e_mail)
        session[:error] = 'The email is already being used. Please use a different one'
        redirect '/failed'
      else
        User.find_by(username: session[:username]).update(email: e_mail)
        redirect '/edit-profile'
      end
    end
  end

  # Route for score reset
  post '/user/reset-score' do
    if session[:username]
      user = User.find_by(username: session[:username])
      user.update(score: 0)
      redirect '/edit-profile'
    end
  end

  # Route for deleting a user
  post '/user/delete' do
    if session[:username]
      user = User.find_by(username: session[:username])
      user.destroy
      session.clear
      session[:notice] = 'The user has been successfully deleted'
      redirect '/password_resets/notice'
    end
  end
end
