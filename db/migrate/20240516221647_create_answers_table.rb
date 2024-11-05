# frozen_string_literal: true

# Migration to create answers table
class CreateAnswersTable < ActiveRecord::Migration[7.1]
  def change
    create_table :answers do |t|
      t.string :description
      t.boolean :is_correct
      t.references :question, null: false, foreign_key: true

      t.timestamps
    end
  end
end
