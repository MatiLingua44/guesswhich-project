# server.rb

require 'sinatra/base'
require 'sinatra/activerecord'
require 'sqlite3'

require './models/user'

class App < Sinatra::Application

    set :database_file, './config/database.yml'

    def initialize(app = nil)
        super()
    end

    get '/' do
        'Welcome'
    end
   
    get '/users' do
        @users = User.all
        erb :'users/index'
    end
    
    # Configure conection to the database
    configure do
        DB = SQLite3::Database.new 'database.db'
        DB.results_as_hash = true
    end

    # Shows the login page
    get '/login' do
        erb :login
    end

    # Shows the sign in page
    get '/register' do
        erb :register
    end

    get '/questions' do
        @questions = Question.all
        erb :'questions/show'
    end

    # Manages the login request
    post '/login' do
        username = params[:username]
        password = params[:password]

        existing_user = User.find_by(username:username)

        if existing_user && existing_user['password'] == password
            redirect '/home'
        else
            "Credenciales incorrectas. Inténtalo de nuevo."
        end
    end

    # Manages the sign up request
    post '/register' do
        username = params[:username]
        password = params[:password]
        email = params[:email]
        names = params[:names]

        # Verify if the username already exists
        existing_user = User.find_by(username:username)
        if existing_user
            return "El nombre de usuario ya está en uso. Por favor, elige otro."
        end

        existing_email = User.find_by(email:email)
        if existing_email
            return "El email ya está siendo utilizado por otro usuario. Por favor, elige otro."
        end

        # Insert the new user into the database
        User.create(names: names, username: username, email: email, password: password)
      
      
        # Redirect to homepage after succesfully sign up
        redirect '/home'
    end

    # Homepage
    get '/home' do
        erb :home
    end
end

