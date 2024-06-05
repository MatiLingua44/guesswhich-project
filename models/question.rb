# models/questions.rb
class Question < ActiveRecord::Base
    has_many :answers

    validates :event, presence: true
    validates :description, presence: true
end 