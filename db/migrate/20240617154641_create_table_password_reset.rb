# frozen_string_literal: true

# Migration to create password_reset table
class CreateTablePasswordReset < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :password_reset_token, :string
    add_column :users, :password_reset_sent_at, :datetime
  end
end
