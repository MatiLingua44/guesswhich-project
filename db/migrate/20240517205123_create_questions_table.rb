class CreateQuestionsTable < ActiveRecord::Migration[7.1]
  def change
    create_table :questions do |t|
      t.string :description
      t.integer :event

      t.integer :correct_answered
      t.integer :incorrect_answered

      t.timestamps
    end
  end
end
