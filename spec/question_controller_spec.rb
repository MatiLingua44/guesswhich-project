# frozen_string_literal: true

ENV['APP_ENV'] = 'test'

require 'simplecov'
SimpleCov.start

require 'rspec'
require 'rack/test'
require_relative '../controllers/question_controller'
require_relative '../app'
require_relative '../models/user'

RSpec.describe 'QuestionStatistics' do
  include Rack::Test::Methods

  def app
    App.new
  end

  before(:each) do
    @user = User.create(
      username: 'testuser',
      password: 'testuserpassword',
      email: 'testuser@example.com',
      names: 'Test User',
      score: 0
    )
  end

  it 'shows the question statistics page' do
    post '/login', {
      username: 'testuser',
      password: 'testuserpassword',
      email: 'testuser@example.com'
    }
    get '/question-statistics'
    expect(last_response.status).to eq(200)
    expect(last_response.body).to include('Correct Answered Questions')
    expect(last_response.body).to include('Incorrect Answered Questions')
  end
end

RSpec.describe 'AddQuestion' do
  include Rack::Test::Methods

  def app
    App.new
  end

  before(:each) do
    User.delete_all
    @user = User.create(
      username: 'testuser',
      password: 'testuserpassword',
      email: 'testuser@example.com',
      names: 'Test User',
      score: 0
    )
  end

  it 'shows the page to add questions' do
    post '/login', { username: 'testuser', password: 'testuserpassword', email: 'testuser@example.com' }
    get '/add-questions'
    expect(last_response).to be_ok
  end

  it 'adds question, but it is already in the database' do
    post '/login', { username: 'testuser', password: 'testuserpassword', email: 'testuser@example.com' }

    get '/add-questions'
    expect(last_response).to be_ok

    Question.create(description: 'Test question', event: 1)

    post '/add-questions', {
      question: 'Test question',
      correct_answer: '1',
      incorrect_answer1: '2',
      incorrect_answer2: '3',
      incorrect_answer3: '4',
      'rack.session' => { selected_event: 1 }
    }

    expect(last_request.env['rack.session'][:result]).to eq('The question is already in the database.')
  end
end

RSpec.describe 'AnswerQuestions' do
  include Rack::Test::Methods

  def app
    App.new
  end

  before(:each) do
    @user = User.create(
      username: 'testuser',
      password: 'testuserpassword',
      email: 'testuser@example.com',
      names: 'Test User',
      score: 0
    )
  end

  it 'shows the game finished because answered all the questions' do
    post '/login', {
      username: 'testuser',
      password: 'testuserpassword',
      email: 'testuser@example.com'
    }
    follow_redirect!
    expect(last_response.status).to eq(200)
    expect(last_request.path).to eq('/menu')

    get '/questions'
    allow(Question).to receive(:where).and_return([])

    follow_redirect!
    expect(last_response.status).to eq(200)
    expect(last_request.path).to eq('/finish')
    expect(last_response.body).to include('You answered all the questions')
  end

  it 'Redirect to completion page when user answers incorrectly' do
    post '/login', {
      username: 'testuser',
      password: 'testuserpassword',
      email: 'testuser@example.com  '
    }

    follow_redirect!
    expect(last_response.status).to eq(200)

    question = Question.create(description: 'Test question', event: 1)
    incorrect_answer = Answer.create(description: 'Incorrect answer', is_correct: false, question: question)

    post '/questions', { answer: incorrect_answer.id }, 'rack.session' => {
      question_count: 5,
      user_score: 50,
      username: 'testuser'
    }

    follow_redirect!

    expect(last_request.path).to eq('/finish')
    expect(last_response.body).to include('Your answer is not correct, you lost!')
    expect(last_request.env['rack.session'][:user_score]).to eq(50)
  end

  it 'Redirect to finish page when user runs out of time' do
    post '/login', {
      username: 'testuser',
      password: 'testuserpassword',
      email: 'testuser@example.com  '
    }

    follow_redirect!
    expect(last_response.status).to eq(200)

    question = Question.create(description: 'Test question', event: 1)
    Answer.create(description: 'Incorrect answer', is_correct: false, question: question)

    session_data = {
      user_score: 0,
      question_count: 0,
      username: 'testuser',
      user_time: -1,
      processed_questions: [],
      selected_event: 1
    }

    get '/questions', {}, 'rack.session' => session_data

    get '/finish'
    expect(last_request.path).to eq('/finish')
    expect(last_response.body).to include('You ran out of time!')
  end

  it 'increments score and redirects to /questions when answer is correct' do
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
      question_count: 5,
      user_score: 50,
      username: 'testuser'
    }

    expect(last_response).to be_ok

    expect(last_response.body).to include('You answer is correct!')

    expect(last_request.path).to eq('/questions')
    expect(last_request.env['rack.session'][:question_count]).to eq(6)
    expect(last_request.env['rack.session'][:user_score]).to eq(60)
  end

  it 'finishes the game when answer is correct and reaches 15 questions' do
    post '/login', {
      username: 'testuser',
      password: 'testuserpassword',
      email: 'testuser@example.com'
    }
    follow_redirect!
    expect(last_response.status).to eq(200)

    question = Question.create(description: 'Test question', event: 1)
    correct_answer = Answer.create(description: 'Correct answer', is_correct: true, question: question)

    session_data = {
      question_count: 14,
      user_score: 140,
      username: 'testuser'
    }

    post '/questions', { answer: correct_answer.id }, 'rack.session' => session_data

    expect(last_response).to be_redirect
    follow_redirect!
    expect(last_request.path).to eq('/finish')
    expect(last_response.body).to include('Congratulations, You won!')

    expect(last_request.env['rack.session'][:question_count]).to eq(15)
    expect(last_request.env['rack.session'][:user_score]).to eq(150)
  end

  it 'shows that the game is over because answered 14 questions
  and used the question skipping streak or second chance streak' do
    post '/login', {
      username: 'testuser',
      password: 'testuserpassword',
      email: 'testuser@example.com'
    }

    session_data = {
      question_count: 14,
      user_score: 140,
      username: 'testuser'
    }

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
