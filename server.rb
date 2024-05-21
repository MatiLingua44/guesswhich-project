# server.rb

require 'sinatra/base'
require 'sinatra/activerecord'
require 'sqlite3'

require './models/user'
require './models/question'
require './models/answer'

class App < Sinatra::Application

    set :database_file, './config/database.yml'

    def initialize(app = nil)
        super()
    end

    configure do
        enable :sessions
    end

    get '/' do
        session.clear
        erb :home
    end

    get '/menu' do
        erb :menu
    end

    get '/ranking' do
        @users = User.all
        erb :'/ranking'
    end

    # Shows the login page
    get '/login' do
        erb :login
    end

    # Shows the sign in page
    get '/register' do
        erb :register
    end

    get '/gamemodes' do
        erb :gamemodes
    end

    # Manages the login request
    post '/login' do
        username = params[:username]
        password = params[:password]

        existing_user = User.find_by(username:username)

        if existing_user && existing_user['password'] == password
            session[:username] = params[:username] # Almacenar el nombre de usuario en la sesión
            puts session
            redirect '/menu'
        else
            redirect '/login'
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
            return "The username is already being used. Please insert a diferent one."
        end

        existing_email = User.find_by(email:email)
        if existing_email
            return "The email is being used by another pearson. Please choose a new one."
        end

        # Insert the new user into the database
        User.create(names: names, username: username, email: email, password: password)
      
      
        # Redirect to homepage after succesfully sign up
        redirect '/login'
    end

    #Game modes implementation
    
    processed_questions = []
    
    get '/questions' do
        question_count = session[:question_count] || 0
        difficulty = case question_count
                     when 0..9
                         'easy'
                     when 10..19
                         'medium'
                     else
                         'hard'
                     end
        @questions = Question.where.not(description: processed_questions).where(difficulty: difficulty).order("RANDOM()").first

        if @questions.nil?
             return "no questions available"
        else
            processed_questions << @questions.description
            @answers = @questions.answers.all
            erb :'questions/show'
         end
    end

    post '/questions' do
        if session[:username]
            @users = User.find_by(username: session[:username])
            existing_answer = Answer.find_by(id: params["answer"])
            if existing_answer&.is_correct
                session[:question_count] ||= 0
                session[:question_count] += 1
                @users.update(score: @users.score + 1)
                redirect '/questions'
            else
                "respuesta incorrecta"
                session[:question_count] = 0
                redirect '/menu'
            end
        else
            redirect '/login'
        end
    end

    before do
        public_paths = ['/login', '/register', '/']
        pass if public_paths.include?(request.path_info)
        redirect '/login' unless session[:username]
    end

end