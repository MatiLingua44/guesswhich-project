# frozen_string_literal: true

# GameController: Handles game-related events such as streaks and event views,
# ranking, end of game, and events info.
class GameController < Sinatra::Base
    set :views, File.expand_path('../views', __dir__)
  
    # Shows the information about the selected event
    get '/learn-event' do
      selected_event = session[:selected_event]
      event_learn = {
        '0' => 'util/second-world-war.pdf',
        '1' => 'util/industrial-revolution.pdf',
        '2' => 'util/french-revolution.pdf',
        '3' => 'util/11-9-terrorist-attack.pdf',
        '4' => 'util/apollo-11.pdf',
        '5' => 'util/first-world-war.pdf'
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
      @second_chance_streak = session[:secondChanceStreak]
      @title = session[:title]
      erb :finish
    end
  
    # Shows all the events available for playing
    post '/events' do
      event = params[:event]
      session[:selected_event] = event
      session[:user_score] = 0
      session[:processed_questions] = []
      session[:question_count] = 0
      session[:extraTimeStreak] = false
      session[:skipQuestionStreak] = false
      session[:secondChanceStreak] = false
      session[:count] = 0
      event_titles = {
        '0' => 'Second World War',
        '1' => 'Industrial Revolution',
        '2' => 'French Revolution',
        '3' => '11/9 Terrorist Attack',
        '4' => 'Apollo 11',
        '5' => 'First World War'
      }
      @event_title = event_titles[event]
      user = User.find_by(username: session[:username])
      @admin = user.is_admin
      erb :'show-event'
    end
  
    # Shows the ranking
    get '/ranking' do
      @users = User.all.order('score DESC')
      erb :'/ranking'
    end
  
    # Use extra time game feature
    get '/extraTimeStreak' do
      session[:extraTimeStreak] = false
  
      status 204
    end
  
    # Use skip question game feature
    get '/skipQuestionStreak' do
      session[:question_count] ||= 0
      session[:question_count] += 1
  
      session[:skipQuestionStreak] = false
      redirect '/questions'
    end
  
    # Use second chance game feature
    get '/secondChanceStreak' do
      session[:question_count] ||= 0
      session[:question_count] += 1
      session[:user_score] -= 5
  
      session[:secondChanceStreak] = false
      redirect '/questions'
    end
  end