# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/activerecord'

# This class is the Main Controller
class MainController < Sinatra::Base
  set :views, File.expand_path('../../views', __FILE__)
  get '/' do
    session.clear
    erb :home
  end

  get '/menu' do
    @username = session[:username]
    user = User.find_by(username: session[:username])
    @admin = user.is_admin
    erb :menu
  end

  # Show the failed page when the player looses
  get '/failed' do
    @error = session[:error]
    @redirect = session[:redirect]
    erb :failed
  end
end
