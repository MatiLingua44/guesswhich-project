# frozen_string_literal: true

# models/answer.erb
class Answer < ActiveRecord::Base
  belongs_to :question
end
