# frozen_string_literal: true

class CreateQuestionsTable < ActiveRecord::Migration[7.1]
  def change
    create_table :questions do |t|
      t.string :description
      t.integer :event

      t.integer :correct_answered, default: 0
      t.integer :incorrect_answered, default: 0

      t.timestamps
    end
  end
end
