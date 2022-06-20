# frozen_string_literal: true

class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.string :name
      t.datetime :start_time
      t.datetime :end_time
      t.string :attendees, array: true, default: []
      t.string :google_event_id
      t.string :status, default: "cancelled"

      t.timestamps
    end
  end
end
