# frozen_string_literal: true

class AddGoogleAuthenticationToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :google_authentication, :jsonb, default: {}
  end
end
