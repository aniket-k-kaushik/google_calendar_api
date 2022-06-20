# frozen_string_literal: true

class CreateUserEventJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_join_table :users, :events do |t|
      t.index [:user_id, :event_id]
      t.index [:event_id, :user_id]
    end
  end
end
