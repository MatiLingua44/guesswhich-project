# models/answer.erb
class Answer < ActiveRecord::Base
  belongs_to :question
end