# frozen_string_literal: true

# AuthController: Handles user authentication processes including login, registration,
# and password reset functionality. This controller is responsible for displaying login
# and registration forms, authenticating users, registering new users, and managing
# password reset requests.
class AuthController < Sinatra::Base
  set :views, File.expand_path('../views', __dir__)
  get('/login') { erb :login }
  get('/register') { erb :register }

  # Manages the login request
  post '/login' do
    username = params[:username]
    password = params[:password]

    existing_user = User.find_by(username: username)

    if existing_user&.authenticate(password)
      session[:username] = params[:username]
      redirect '/menu'
    else
      session[:error] = 'Invalid credentials'
      session[:redirect] = '/login'
      redirect '/failed'
    end
  end

  # Manages the sign up request
  post '/register' do
    username = params[:username]
    password = params[:password]
    confirm_password = params[:confirm_password]
    email = params[:email]
    names = params[:names]

    session[:redirect] = '/register'

    existing_user = User.find_by(username: username)
    if existing_user
      session[:error] = 'The username is already being used. Please use a different one'
      redirect '/failed'
    end

    existing_email = User.find_by(email: email)
    if existing_email
      session[:error] = 'The email is already being used. Please use a different one'
      redirect '/failed'
    end

    if password != confirm_password
      session[:error] = 'Passwords do not match'
      redirect '/failed'
    end

    # Insert the new user into the database
    User.create(names: names, username: username, email: email, password: password)

    # Redirect to homepage after succesfully sign up
    redirect '/login'
  end

  Mail.defaults do
    delivery_method :smtp, {
      address: 'smtp.gmail.com',
      port: 587,
      user_name: 'guesswhichh@gmail.com',
      password: 'djzy qznf ixjg yfrn',
      authentication: 'plain',
      enable_starttls_auto: true
    }
  end

  post '/password_resets' do
    user = User.find_by(email: params[:email])
    if user
      user.generate_password_reset_token!
      mail = Mail.new do
        from 'guesswhichh@gmail.com'
        to      user.email
        subject 'Password Reset'
        body    "To reset your password, click the link below:\n\n" \
                  "http://localhost:4567/password_resets/#{user.password_reset_token}/edit"
      end
      mail.deliver!
      session[:notice] = 'A password reset email has been sent to your email address'
    else
      session[:notice] = 'This email address is not registered'
    end
    redirect '/password_resets/notice'
  end

  get '/password_resets/:token/edit' do
    @user = User.find_by(password_reset_token: params[:token])
    if @user && @user.password_reset_sent_at > 2.hours.ago
      erb :'password_resets/edit'
    else
      session[:notice] = 'The token has expired, please try again'
      redirect '/password_resets/notice'
    end
  end

  get '/password_resets/new' do
    erb :'password_resets/new'
  end

  get '/password_resets/notice' do
    @notice = session[:notice]
    erb :'password_resets/notice'
  end

  patch '/password_resets/:token' do
    token = params[:token]

    @user = User.find_by(password_reset_token: token)

    if @user && @user.password_reset_sent_at > 2.hours.ago
      if @user.update(password: params[:password])
        @user.update(password_reset_token: nil, password_reset_sent_at: nil)
        session[:notice] = 'The password has been successfully reset'
        redirect '/password_resets/notice'
      end
    else
      session[:notice] = 'This email address is not registered'
      redirect '/password_resets/notice'
    end
  end
end
