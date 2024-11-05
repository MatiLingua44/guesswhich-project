# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/activerecord'

# The QuestionController is responsible for managing the actions related to the questions,
# such as answering them, adding new questions and
# also how to display the general statistics of the questions.
class QuestionController < Sinatra::Base
  set :views, File.expand_path('../views', __dir__)

  # Shows the question statistics
  get '/question-statistics' do
    @correct_questions = Question.all.order('correct_answered DESC')
    @incorrect_questions = Question.all.order('incorrect_answered DESC')
    erb :'/question-statistics'
  end

  # Shows the questions with their answers
  get '/questions' do
    selected_event = session[:selected_event]
    @score = session[:user_score] ||= 0
    @extra_time_streak = session[:extraTimeStreak] ||= false
    @skip_question_streak = session[:skipQuestionStreak] ||= false
    @second_chance_streak = session[:secondChanceStreak] ||= false
    processed_questions = session[:processed_questions]

    @questions = Question.where(event: selected_event.to_i)
                         .where.not(description: processed_questions)
                         .order('RANDOM()').first

    if @questions.nil?
      session[:title] = if session[:question_count] == 15
                          'Congratulations, You won!'
                        else
                          'You answered all the questions.'
                        end
      redirect '/finish'
    else
      session[:title] = 'You ran out of time!'
      session[:processed_questions] << @questions.description
      @answers = @questions.answers.all
      @correct_answer_id = @answers.find_by(is_correct: true).id
      erb :'questions/show'
    end
  end

  post '/questions' do
    if session[:username]
      user = User.find_by(username: session[:username])
      existing_answer = Answer.find_by(id: params['answer'])
      @question = Question.find_by(id: existing_answer.question)

      if existing_answer&.is_correct
        handle_correct_answer(user)
      else
        handle_incorrect_answer(user)
      end
    end
  end

  get '/add-questions' do
    erb :'questions/add-questions'
  end

  post '/add-questions' do
    question = params[:question]
    correct_answer = params[:correct_answer]
    incorrect_answer1 = params[:incorrect_answer1]
    incorrect_answer2 = params[:incorrect_answer2]
    incorrect_answer3 = params[:incorrect_answer3]
    event = session[:selected_event]
    existing_question = Question.find_by(description: question)
    if existing_question
      @result = session[:result] = 'The question is already in the database.'

    else
      question = Question.create(description: question, event: event)

      Answer.create(description: correct_answer, question: question, is_correct: true)
      Answer.create(description: incorrect_answer1, question: question, is_correct: false)
      Answer.create(description: incorrect_answer2, question: question, is_correct: false)
      Answer.create(description: incorrect_answer3, question: question, is_correct: false)
      @result = session[:result] = 'Question added successfully'
    end
    erb :'questions/question_status'
  end
end

private

def handle_correct_answer(user)
  increment_session_counters
  update_streak_flags
  update_user_score(user)

  if session[:question_count] == 15
    session[:title] = 'Congratulations, You won!'
    redirect '/finish'
  else
    @question.update(correct_answered: @question.correct_answered + 1)
    erb :'questions/game-stats'
  end
end

def handle_incorrect_answer(user)
  user.update(score: user.score - 5)
  @question.update(incorrect_answered: @question.incorrect_answered + 1)
  user.update(score: 0) if user.score.negative?
  session[:title] = 'Your answer is not correct, you lost!'
  redirect '/finish'
end

def increment_session_counters
  session[:question_count] = increment_counter(:question_count)
  session[:user_score] = increment_score
  session[:count] = increment_counter(:count)

  @score = session[:user_score]
  @count = session[:count]
end

def increment_counter(counter)
  session[counter] ||= 0
  session[counter] += 1
end

def increment_score
  session[:user_score] ||= 0
  session[:user_score] += 10
end

def update_streak_flags
  session[:extraTimeStreak] = true if @count == 3
  session[:skipQuestionStreak] = true if @count == 5
  session[:secondChanceStreak] = true if @count == 8
  @extra_time_streak = session[:extraTimeStreak]
  @skip_question_streak = session[:skipQuestionStreak]
  @second_chance_streak = session[:secondChanceStreak]
end

def update_user_score(user)
  user.update(score: session[:user_score]) if user.score < session[:user_score]
end
