# frozen_string_literal: true

class Event < ApplicationRecord
  has_and_belongs_to_many :users
end
