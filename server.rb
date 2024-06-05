# server.rb

require 'sinatra/base'
require 'sinatra/activerecord'
require 'sqlite3'
require 'json'

require './models/user'
require './models/question'
require './models/answer'

class App < Sinatra::Application

    set :database_file, './config/database.yml'
    set :public_folder, 'public'

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

    get '/learn-event' do
        selected_event = session[:selected_event]
        if selected_event == 0
            @learnPdf = "util/industrial-revolution.pdf"
        elsif selected_event == 1
            @learnPdf = "util/industrial-revolution.pdf"
        end

        erb :'learn-event'
    end

    get '/learn-industrial' do
        erb :'learn-industrial'
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
            session[:username] = params[:username]
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

    post '/select_event' do
        event = params[:event]
        session[:selected_event] = event

        if event == '0'
            @eventTitle = "Second World War"
            erb :'show-event'
        elsif event == '1'
            @eventTitle = "Industrial Revolution"
            erb :'show-event'
        else
            redirect '/menu'
        end
    end

    get '/questions' do
        selected_event = session[:selected_event]

        if selected_event == '0'
            @questions = Question.where(event: 0).order("RANDOM()").first
        elsif selected_event == '1'
            @questions = Question.where(event: 1).order("RANDOM()").first
        else
            @questions = Question.none
        end

        if @questions.nil?
            redirect '/finish'
        else
            processed_questions << @questions.description
            @answers = @questions.answers.all
            erb :'questions/show'
        end
    end

    post '/questions' do
        if session[:username]
            user = User.find_by(username: session[:username])
            existing_answer = Answer.find_by(id: params["answer"])
            if existing_answer&.is_correct
                session[:question_count] ||= 0
                session[:question_count] += 1
                session[:user_score] ||= 0
                session[:user_score] += 1
                if user.score < session[:user_score]
                    user.update(score: session[:user_score])
                end
                redirect '/questions'
            else
                session[:question_count] = 0
                session[:user_score] = 0
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