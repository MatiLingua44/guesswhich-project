class CreateUsersTable < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :names
      t.string :username
      t.string :email
      t.string :password
      t.integer :score
      t.string :password_digest

      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
