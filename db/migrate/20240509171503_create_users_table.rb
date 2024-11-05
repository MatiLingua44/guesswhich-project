# frozen_string_literal: true

# Migration to create users table
class CreateUsersTable < ActiveRecord::Migration[7.1]
  # rubocop:disable Metrics/MethodLength
  def change
    create_table :users do |t|
      t.string :names
      t.string :username
      t.string :email
      t.string :password
      t.integer :score
      t.string :password_digest
      t.boolean :is_admin, default: false

      t.datetime :created_at
      t.datetime :updated_at
    end
  end
  # rubocop:enable Metrics/MethodLength
end
