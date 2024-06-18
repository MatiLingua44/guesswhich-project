require 'sinatra/base'
require 'sinatra/activerecord'
require 'sqlite3'
require 'securerandom'
require 'mail'

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
        @username = session[:username]
        erb :menu
    end

    # Shows the ranking
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

    # Show the failed page when the player looses
    get '/failed' do
        @error = session[:error]
        @redirect = session[:redirect]
        erb :failed
    end

    # Shows the information about the selected event
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

    # Manages the events
    get '/events' do
        erb :events
    end

    # Route used when the game finishes
    get '/finish' do
        processed_questions.clear
        @title = session[:title]
        erb :finish
    end

    # Manages the login request
    post '/login' do
        username = params[:username]
        password = params[:password]

        existing_user = User.find_by(username: username)

        if existing_user && existing_user.authenticate(password)
            session[:username] = params[:username]
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

        existing_user = User.find_by(username: username)
        if existing_user
            session[:error] = "The username is already being used. Please use a different one"
            redirect '/failed'
        end

        existing_email = User.find_by(email: email)
        if existing_email
            session[:error] = "The email is already being used. Please use a different one"
            redirect '/failed'
        end

        if password != confirm_password
            session[:error] = "Passwords do not match"
            redirect '/failed'
        end

        # Insert the new user into the database
        User.create(names: names, username: username, email: email, password: password)

        # Redirect to homepage after succesfully sign up
        redirect '/login'
    end

    # Shows all the events available for playing
    post '/events' do
        event = params[:event]
        session[:selected_event] = event
        session[:user_score] = 0
        processed_questions.clear
        session[:question_count] = 0
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

    # Shows the questions with their answers
    get '/questions' do
        selected_event = session[:selected_event]
        @score = session[:user_score] ||= 0
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
                @score = session[:user_score]
                session[:title] = "Your answer is not correct, you lost!"
                redirect '/finish'
            end
        end
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
                from    'guesswhichh@gmail.com'
                to      user.email
                subject 'Password Reset'
                body    "To reset your password, click the link below:\n\n" +
                          "http://localhost:4567/password_resets/#{user.password_reset_token}/edit"
            end

            mail.deliver!
            session[:notice] = "A password reset email has been sent to your email address"
            redirect '/password_resets/notice'
        else
            session[:notice] = "This email address is not registered"
            redirect '/password_resets/notice'
        end
    end

    get '/password_resets/:token/edit' do
        @user = User.find_by(password_reset_token: params[:token])
        if @user && @user.password_reset_sent_at > 2.hours.ago
            erb :'password_resets/edit'
        else
            session[:notice] = "The token has expired, please try again"
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
                session[:notice] = "The password has been reset"
                redirect '/password_resets/notice'
            end
        else
            session[:notice] = "This email address is not registered"
            redirect '/password_resets/notice'
        end
    end

    before do
        public_paths = %w[/login /register / /failed /password_resets/new /password_resets /password_resets/notice]

        public_path_patterns = [
          %r{^/password_resets/\w{22}/edit$},
          %r{^/password_resets/\w{22}$}
        ]

        if public_paths.include?(request.path_info) || public_path_patterns.any? { |pattern| request.path_info.match(pattern) }
            pass
        else
            redirect '/login' unless session[:username]
        end
    end
end
