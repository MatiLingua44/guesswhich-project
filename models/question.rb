# models/questions.rb
class Question < ActiveRecord::Base
    enum difficulty: { easy: 0, medium: 1, hard: 2 }
    has_many :answers

    validates :description, presence: true
    validates :difficulty, presence: true
end 