# frozen_string_literal: true

ENV['APP_ENV'] = 'test'

require 'simplecov'
SimpleCov.start

require 'rspec'
require 'rack/test'
require_relative '../controllers/main_controller'
require_relative '../app'
require_relative '../models/user'

RSpec.describe 'Ranking and streak' do
  include Rack::Test::Methods
  def app
    App.new
  end

  it 'shows the ranking when logged in' do
    post '/login', { username: 'testuser', password: 'testuserpassword', email: 'testuser@example.com' }
    follow_redirect!
    expect(last_response.status).to eq(200)

    get '/ranking'
    expect(last_response.status).to eq(200)
    expect(last_response.body).to include('Ranking table')
  end

  it 'disables extra time streak and responds with 204 No Content' do
    post '/login', { username: 'testuser', password: 'testuserpassword', email: 'testuser@example.com' }

    session_data = { extraTimeStreak: true, username: 'testuser' }

    get '/extraTimeStreak', {}, 'rack.session' => session_data

    expect(last_response.status).to eq(204)
    expect(last_request.env['rack.session'][:extraTimeStreak]).to eq(false)
  end
end

RSpec.describe 'Applies second chance streak' do
  include Rack::Test::Methods
  def app
    App.new
  end

  it 'applies second chance streak and redirects to questions' do
    post '/login', { username: 'testuser', password: 'testuserpassword', email: 'testuser@example.com' }

    session_data = { secondChanceStreak: true, user_score: 100, username: 'testuser' }

    get '/secondChanceStreak', {}, 'rack.session' => session_data

    expect(last_response).to be_redirect
    follow_redirect!

    expect(last_request.path).to eq('/questions')

    expect(last_request.env['rack.session'][:secondChanceStreak]).to eq(false)
    expect(last_request.env['rack.session'][:user_score]).to eq(95)
  end
end

RSpec.describe 'Game over' do
  include Rack::Test::Methods
  def app
    App.new
  end

  it 'shows that the game is over because answered 14 questions
  and used the question skipping streak or second chance streak' do
    post '/login', { username: 'testuser', password: 'testuserpassword', email: 'testuser@example.com' }

    session_data = { question_count: 14, user_score: 140, username: 'testuser' }

    get '/skipQuestionStreak', {}, 'rack.session' => session_data
    expect(last_request.path).to eq('/skipQuestionStreak')

    expect(last_request.env['rack.session'][:question_count]).to eq(15)

    follow_redirect!
    expect(last_request.path).to eq('/questions')

    allow(Question).to receive(:where).and_return([])

    follow_redirect!
    expect(last_response.status).to eq(200)
    expect(last_request.path).to eq('/finish')
    expect(last_response.body).to include('Congratulations, You won!')
  end
end

RSpec.describe 'Extra time streak set' do
  include Rack::Test::Methods
  def app
    App.new
  end

  it 'sets extraTimeStreak to true when count is 3' do
    post '/login', { username: 'testuser', password: 'testuserpassword', email: 'testuser@example.com' }

    follow_redirect!
    expect(last_response.status).to eq(200)

    question = Question.create(description: 'Test question', event: 1)
    correct_answer = Answer.create(description: 'Correct answer', is_correct: true, question: question)

    post '/questions', { answer: correct_answer.id }, 'rack.session' => {
      count: 2,
      question_count: 2,
      user_score: 20,
      username: 'testuser',
      extraTimeStreak: false
    }

    expect(last_response).to be_ok

    expect(last_response.body).to include('You answer is correct!')
    expect(last_request.env['rack.session'][:count]).to eq(3)
    expect(last_request.env['rack.session'][:extraTimeStreak]).to eq(true)
  end
end

RSpec.describe 'Skip question streak set' do
  include Rack::Test::Methods
  def app
    App.new
  end

  it 'sets skipQuestionStreak to true when count is 5' do
    post '/login', {
      username: 'testuser',
      password: 'testuserpassword',
      email: 'testuser@example.com'
    }

    follow_redirect!
    expect(last_response.status).to eq(200)

    question = Question.create(description: 'Test question', event: 1)
    correct_answer = Answer.create(description: 'Correct answer', is_correct: true, question: question)

    post '/questions', { answer: correct_answer.id }, 'rack.session' => {
      count: 4,
      question_count: 4,
      user_score: 40,
      username: 'testuser',
      skipQuestionStreak: false
    }

    expect(last_response.body).to include('You answer is correct!')
    expect(last_request.env['rack.session'][:count]).to eq(5)
    expect(last_request.env['rack.session'][:skipQuestionStreak]).to eq(true)
  end
end

RSpec.describe 'Second chance streak set' do
  include Rack::Test::Methods
  def app
    App.new
  end

  it 'sets secondChanceStreak to true when count is 8' do
    post '/login', {
      username: 'testuser',
      password: 'testuserpassword',
      email: 'testuser@example.com'
    }

    follow_redirect!
    expect(last_response.status).to eq(200)

    question = Question.create(description: 'Test question', event: 1)
    correct_answer = Answer.create(description: 'Correct answer', is_correct: true, question: question)

    post '/questions', { answer: correct_answer.id }, 'rack.session' => {
      count: 7,
      question_count: 7,
      user_score: 70,
      username: 'testuser',
      secondChanceStreak: false
    }

    expect(last_response).to be_ok
    expect(last_request.env['rack.session'][:count]).to eq(8)
    expect(last_request.env['rack.session'][:secondChanceStreak]).to eq(true)
  end
end

RSpec.describe 'Learn event' do
  include Rack::Test::Methods
  def app
    App.new
  end

  it 'choose an event and read its material.' do
    post '/login',
         {
           username: 'testuser',
           password: 'testuserpassword',
           mail: 'testuser@example.com'
         }
    follow_redirect!
    expect(last_response.status).to eq(200)

    session_data = { username: 'testuser', question_count: 0, user_score: 0,
                     processed_questions: [], selected_event: 1 }

    post '/events', {}, 'rack.session' => session_data
    expect(last_response.status).to eq(200)
    expect(last_response.body).to include('Star')
    expect(last_response.body).to include('Learn')
    expect(last_response.body).to include('Back')

    get '/learn-event'
    expect(last_response.status).to eq(200)
    expect(last_request.path).to eq('/learn-event')
    expect(last_response.body).to include('Back')
  end
end
