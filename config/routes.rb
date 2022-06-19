# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root "google_calendars#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
end
