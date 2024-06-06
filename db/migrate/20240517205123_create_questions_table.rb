class CreateQuestionsTable < ActiveRecord::Migration[7.1]
  def change
    create_table :questions do |t|
      t.string :description
      t.integer :event

      t.timestamps
    end
  end
end
