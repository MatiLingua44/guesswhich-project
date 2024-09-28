ENV['APP_ENV'] = 'test'

require 'simplecov'
SimpleCov.start

require_relative '../server.rb'
require_relative '../models/user'
require 'rspec'
require 'rack/test'

RSpec.describe 'Server' do
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

  it 'redirects to the page of password resets 'do
    get '/password_resets/new' 
    expect(last_response.status).to eq(200)
    expect(last_request.path).to eq('/password_resets/new')
  end

  it 'reports that the password change was successful' do
    get '/password_resets/notice'
    expect(last_response.status).to eq(200)
    expect(last_request.path).to eq('/password_resets/notice')
  end

  it 'redirects to the user information when authenticated' do
    post '/login' , {username: 'testuser', password: 'testuserpassword',email: 'testuser@example.com'}
    follow_redirect!

    expect(last_response.status).to eq(200)
    expect(last_request.path).to eq('/menu')

    get '/user'
    expect(last_response.status).to eq(200)
    expect(last_request.path).to eq('/user')
    expect(last_response.body).to include('testuser')
    expect(last_response.body).to include('testuser@example.com')
  end

  it 'redirects to the login page when not authenticated' do 
    get '/users'
     expect(last_response.status).to eq(302)
     expect(last_response.headers['Location']).to include('/login')
  end

  it 'shows the home page' do
    get '/' do
      expect(last_response.status).to eq(200)
      expect(last_request.path).to eq('/')
    end
  end

  it 'redirects to the page event when authenticated'do
    post '/login' , {username: 'testuser', password: 'testuserpassword'}
    get '/events'
    expect(last_response.status).to eq(200)
    expect(last_request.path).to eq('/events')
  end

  it 'redirects to the login page when not authenticated' do
      get '/events' 
      expect(last_response.status).to eq(302)
      expect(last_response.headers['Location']).to include('/login')
  end

  it 'shows the login form' do
    get '/login'
    expect(last_response).to be_ok
    expect(last_response.body).to include('<form')
    expect(last_response.body).to include('Log In')
    expect(last_response.body).to include('name="username"')
    expect(last_response.body).to include('name="password"')
  end

  it 'logs in with valid credentials' do
    post '/login', username: 'testuser', password: 'testuserpassword'
    expect(last_response.status).to eq(302)
    follow_redirect!
    expect(last_request.path).to eq('/menu')
    expect(last_response.body).to include('User: testuser')
  end

  it 'fails to log in with invalid credentials' do
    post '/login', username: 'testuser', password: 'wrongpassword'
    expect(last_response.status).to eq(302)
    follow_redirect!
    expect(last_request.path).to eq('/failed')
    expect(last_response.body).to include('Invalid credentials')
  end

  it 'redirects to login page if accessing a protected route without logging in' do
    get '/menu'
    expect(last_response.status).to eq(302)
    follow_redirect!
    expect(last_request.path).to eq('/login')
  end

  it 'shows the register form' do
    get '/register'
    expect(last_response).to be_ok
    expect(last_response.body).to include('<form')
    expect(last_response.body).to include('Sign Up')
    expect(last_response.body).to include('name="username"')
    expect(last_response.body).to include('name="password"')
    expect(last_response.body).to include('name="confirm_password"')
    expect(last_response.body).to include('name="email"')
    expect(last_response.body).to include('name="names"')
  end

  it 'signs up with used credentials' do
    post '/register', username: 'testuser', password: 'testuserpassword', confirm_password: 'testuserpassword', email: 'testuser@example.com', names: 'Test User'
    expect(last_response.status).to eq(302)
    follow_redirect!
    expect(last_request.path).to eq('/failed')
    expect(last_response.body).to include('The username is already being used. Please use a different one')
  end

  it 'signs up with available credentials' do
    post '/register', username: 'testuserOk', password: 'testuserpasswordOk', confirm_password: 'testuserpasswordOk', email: 'testuserOk@example.com', names: 'Test User'
    expect(last_response.status).to eq(302)
    follow_redirect!
    expect(last_request.path).to eq('/login')
  end

  it 'signs up with mismatched passwords' do
    post '/register', username: 'testuserNew', password: 'testuserpassword1', confirm_password: 'testuserpassword2', email: 'testuserNew@example.com', names: 'Test User New'
    expect(last_response.status).to eq(302)
    follow_redirect!
    expect(last_request.path).to eq('/failed')
    expect(last_response.body).to include('Passwords do not match')
  end

  it 'fails to sign up with a used email' do
    post '/register', username: 'testuserNew', password: 'testuserpassword1', confirm_password: 'testuserpassword2', email: 'testuser@example.com', names: 'Test User New'
    expect(last_response.status).to eq(302)
    follow_redirect!
    expect(last_request.path).to eq('/failed')
    expect(last_response.body).to include('The email is already being used. Please use a different one')
  end


  it 'shows the ranking when logged in' do
    post '/login' , {username: 'testuser', password: 'testuserpassword',email: 'testuser@example.com'}
    follow_redirect!
    expect(last_response.status).to eq(200)
    expect(last_request.path).to eq('/menu')

    get '/ranking'
    expect(last_response.status).to eq(200)
    expect(last_response.body).to include('Ranking table')
  end

  it 'disables extra time streak and responds with 204 No Content' do 
    post '/login', {
      username: 'testuser',
      password: 'testuserpassword',
      email: 'testuser@example.com'
    }
  
    session_data = {
      extraTimeStreak: true,
      username: 'testuser'
    }

    get '/extraTimeStreak', {}, 'rack.session' => session_data

    expect(last_response.status).to eq(204)
    expect(last_request.env['rack.session'][:extraTimeStreak]).to eq(false)
  end

  it 'applies second chance streak and redirects to questions' do 
    post '/login', {
      username: 'testuser',
      password: 'testuserpassword',
      email: 'testuser@example.com'
    }
    
    session_data = {
      secondChanceStreak: true,
      user_score: 100,
      username: 'testuser'
    }

    get '/secondChanceStreak', {}, 'rack.session' => session_data

    expect(last_response).to be_redirect
    follow_redirect!

    expect(last_request.path).to eq('/questions')

    expect(last_request.env['rack.session'][:secondChanceStreak]).to eq(false)
    expect(last_request.env['rack.session'][:user_score]).to eq(95)

  end


  it 'shows that the game is over because answered 14 questions and used the question skipping streak or second chance streak' do
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

    get '/skipQuestionStreak' , {}, 'rack.session' => session_data
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

  it 'deletes a user' do
    post'/login', {username: 'testuser', password: 'testuserpassword'}
    follow_redirect!

    expect(last_response.status).to eq(200)
    expect(last_request.path).to eq('/menu')

    get '/user'
    expect(last_response.status).to eq(200)
    expect(last_request.path).to eq('/user')
    expect(last_response.body).to include('testuser')
    expect(last_response.body).to include('testuser@example.com')

    post '/user/delete'
    expect(last_response.status).to eq(302)
  end

  it 'shows the game finished because ran out of time' do
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

  it 'edits a user' do
    post '/login', {
      username: 'testuser',
      password: 'testuserpassword',
      email: 'testuser@example.com'
    }
    follow_redirect!
    expect(last_response.status).to eq(200)
    expect(last_request.path).to eq('/menu')

    get '/edit-profile'
    expect(last_request.path).to eq('/edit-profile')
    expect(last_response.body).to include('Delete User')
  end

  it 'resets score user' do
    post '/login', {
      username: 'testuser',
      password: 'testuserpassword',
      email: 'testuser@example.com'
    }

    follow_redirect!
    expect(last_response.status).to eq(200)
    expect(last_request.path).to eq('/menu')
    
    get '/edit-profile'
    expect(last_response.status).to eq(200)
    expect(last_request.path).to eq('/edit-profile')

    post'/user/reset-score', {
      user_score: 0
    }
    expect(last_request.path).to eq('/user/reset-score')

    get '/edit-profile'
    expect(last_response.status).to eq(200)
    expect(last_request.path).to eq('/edit-profile')
    expect(last_response.body).to include('Reset Score')
  end 

  it 'Redirect to finish page when user runs out of time' do
    post '/login',{
      username: 'testuser',
      password: 'testuserpassword',
      email: 'testuser@example.com  '
    } 

    follow_redirect!
    expect(last_response.status).to eq(200)

    question = Question.create(description: "Test question", event: 1)
    incorrect_answer = Answer.create(description: "Incorrect answer", is_correct: false, question: question)

    session_data = {
      user_score: 0,
      question_count: 0,
      username: 'testuser',
      user_time: -1,
      processed_questions: [],
      selected_event: 1 
    }

    get '/questions',{}, 'rack.session' => session_data

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

    question = Question.create(description: "Test question", event: 1)
    correct_answer = Answer.create(description: "Correct answer", is_correct: true, question: question)

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

    question = Question.create(description: "Test question", event: 1)
    correct_answer = Answer.create(description: "Correct answer", is_correct: true, question: question)

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


  it 'choose an event and read its material.' do
    post '/login',
    {
      username: 'testuser',
      password: 'testuserpassword',
      mail: 'testuser@example.com'
    }
    follow_redirect!
    expect(last_response.status).to eq(200)

    session_data = {
      username: 'testuser',
      question_count: 0,
      user_score: 0,
      processed_questions: [],
      selected_event: 1
    }
    
    post'/events',{},'rack.session' => session_data
    expect(last_response.status).to eq(200)
    expect(last_response.body).to include('Star')
    expect(last_response.body).to include('Learn')
    expect(last_response.body).to include('Back')

    get '/learn-event'
    expect(last_response.status).to eq(200)
    expect(last_request.path).to eq('/learn-event')
    expect(last_response.body).to include('Back')
  end

  it 'password resets with created user' do
    post '/register', {
      username: 'testuser2', 
      password: 'testuserpassword2', 
      confirm_password: 'testuserpassword2', 
      email: 'testuser2@example.com',
      names: 'Test User'
    }
    expect(last_response.status).to eq(302)
    follow_redirect!
    expect(last_request.path).to eq('/login')

    get '/password_resets/new'

    post '/password_resets', {
      username: 'testuser2',
      password: 'testuserpassword2',
      email: 'testuser2@example.com'
    }

    follow_redirect!
    expect(last_response.status).to eq(200)
    expect(last_request.path).to eq('/password_resets/notice')
    expect(last_response.body).to include('A password reset email has been sent to your email address')
    expect(last_response.body).to include('Back To Login')

  end 

  it 'password resets with non-existent user' do
    post '/password_resets' ,{
      username: 'testuser2',
      password: 'testuserpassword2',
      email: 'testuser2@example.com'
    }
    follow_redirect!
    expect(last_response.status).to eq(200)
    expect(last_request.path).to eq('/password_resets/notice')
    expect(last_response.body).to include('This email address is not registered')
    expect(last_response.body).to include('Back To Login')
  end

  it 'renders the password reset form when token is valid' do
    user = User.create(
      username: 'testuser',
      email: 'testuser@example.com',
      password: 'password',
      password_reset_token: 'validtoken',
      password_reset_sent_at: 1.hour.ago
    )

    post '/login', {
      username: 'testuser',
      password: 'testuserpassword',
      email: 'testuser@example.com'
    }
    follow_redirect!
    expect(last_response.status).to eq(200)

    get "/password_resets/#{user.password_reset_token}/edit"

    expect(last_response.status).to eq(200)
    expect(last_response.body).to include('New Password')
  end

  it 'redirects to the notice page when token has expired' do
    user = User.create(
      username: 'testuser',
      email: 'testuser@example.com',
      password: 'password',
      password_reset_token: 'expiredtoken',
      password_reset_sent_at: 3.hours.ago
    )

    post '/login', {
      username: 'testuser',
      password: 'testuserpassword',
      email: 'testuser@example.com'
    }
    follow_redirect!
    expect(last_response.status).to eq(200)

    get "/password_resets/#{user.password_reset_token}/edit"

    expect(last_response).to be_redirect
    follow_redirect!
    expect(last_request.path).to eq('/password_resets/notice')
    expect(last_response.body).to include('The token has expired, please try again')
  end

  it 'resets the password successfully when token is valid' do
    user = User.create(
      username: 'testuser',
      email: 'testuser@example.com',
      password: 'oldpassword',
      password_reset_token: 'validtoken',
      password_reset_sent_at: 1.hour.ago
    )

    post '/login', {
      username: 'testuser',
      password: 'testuserpassword',
      email: 'testuser@example.com'
    }
    follow_redirect!
    expect(last_response.status).to eq(200)

    patch "/password_resets/#{user.password_reset_token}", { password: 'newpassword' }

    expect(user.reload.authenticate('newpassword')).to be_truthy
    expect(user.password_reset_token).to be_nil
    expect(user.password_reset_sent_at).to be_nil

    expect(last_response).to be_redirect
    follow_redirect!
    expect(last_request.path).to eq('/password_resets/notice')
    expect(last_response.body).to include('The password has been successfully reset')
  end

  it 'redirects to the notice page when token is invalid' do
    post '/login', {
      username: 'testuser',
      password: 'testuserpassword',
      email: 'testuser@example.com'
    }
    follow_redirect!
    expect(last_response.status).to eq(200)
    patch "/password_resets/invalidtoken", { password: 'newpassword' }

    expect(last_response).to be_redirect
    follow_redirect!
    expect(last_request.path).to eq('/password_resets/notice')
    expect(last_response.body).to include('This email address is not registered')
  end

  it 'clears the password reset token and timestamp' do
    user = User.create(
      username: 'testuser',
      email: 'testuser@example.com',
      password: 'password',
      password_reset_token: 'sometoken',
      password_reset_sent_at: 1.hour.ago
    )

    user.clear_password_reset_token!

    expect(user.password_reset_token).to be_nil
    expect(user.password_reset_sent_at).to be_nil

    reloaded_user = User.find(user.id)
    expect(reloaded_user.password_reset_token).to be_nil
    expect(reloaded_user.password_reset_sent_at).to be_nil
  end
end
