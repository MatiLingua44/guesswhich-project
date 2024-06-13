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

    processed_questions = []

    get '/' do
        session.clear
        erb :home
    end

    get '/menu' do
        erb :menu
    end

    get '/ranking' do
        @users = User.all.order('score DESC')
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

    get '/failed' do
        @error = session[:error]
        @redirect = session[:redirect]
        erb :failed
    end

    get '/learn-event' do
        selected_event = session[:selected_event]
        event_learn = {
          '0' => "util/second-world-war.pdf",
          '1' => "util/industrial-revolution.pdf",
          '2' => "util/french-revolution.pdf",
          '3' => "util/11-9-terrorist-attack.pdf",
          '4' => "util/apollo-11.pdf",
          '5' => "util/first-world-war.pdf"
        }
        @event = event_learn[selected_event]
        erb :'learn-event'
    end

    get '/events' do
        erb :events
    end

    get '/finish' do
        processed_questions.clear
        @title = session[:title]
        erb :finish
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
            session[:error] = "Invalid credentials"
            session[:redirect] = "/login"
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

        session[:redirect] = "/register"

        # Verify if the username already exists
        existing_user = User.find_by(username:username)
        if existing_user
            session[:error] = "The username is already being used. Please use a different one"
            redirect '/failed'
        end

        existing_email = User.find_by(email:email)
        if existing_email
            session[:error] = "The email is already being used. Please use a different one"
            redirect '/failed'
        end

        if  password != confirm_password
            session[:error] = "Passwords do not match"
            redirect '/failed'
        end

        # Insert the new user into the database
        User.create(names: names, username: username, email: email, password: password)

        # Redirect to homepage after succesfully sign up
        redirect '/login'
    end

    #Game modes implementation
    

    post '/events' do
        event = params[:event]
        session[:selected_event] = event

        event_titles = {
          '0' => "Second World War",
          '1' => "Industrial Revolution",
          '2' => "French Revolution",
          '3' => "11/9 Terrorist Attack",
          '4' => "Apollo 11",
          '5' => "First World War"
        }
        @eventTitle = event_titles[event]
        erb :'show-event'
    end

    get '/questions' do
        selected_event = session[:selected_event]

        @questions = Question.where(event: selected_event.to_i)
                             .where.not(description: processed_questions)
                             .order("RANDOM()").first

        if @questions.nil?
            session[:title] = "You answered all the questions."
            redirect '/finish'
        else
            session[:title] = "You ran out of time!"
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
                session[:user_score] += 10
                @score = session[:user_score]

                if user.score < session[:user_score]
                    user.update(score: session[:user_score])
                end

                if session[:question_count] == 15
                    session[:title] = "Congratulations, You won!"
                    redirect '/finish'
                end
                redirect '/questions'
            elsif !existing_answer.is_correct
                session[:question_count] = 0
                session[:user_score] = 0
                user.update(score: user.score - 5)
                if user.score < 0
                    user.update(score: 0)
                end
                session[:title] = "Your answer is not correct, you lost!"
                redirect '/finish'
            end
        end
    end

    before do
        public_paths = ['/login', '/register', '/', '/failed']
        pass if public_paths.include?(request.path_info)
        redirect '/login' unless session[:username]
    end

end