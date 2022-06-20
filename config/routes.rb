# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root "google_calendars#index"

  # Response from the google calender after authorization along with access and referesh token
  get "auth/google_oauth2/callback/", to: "google_authorizations#redirect_from_google_calendar_auth", as: :google_authorization

  # To send request to google calneder for authorizing the access request and to get access and referesh token.
  get "/redirect_to_google_calendar_auth", to: "google_calendars#redirect_to_google_calendar_auth"

  get "revoke_google_calendar_access", to: "google_authorizations#revoke_google_calendar_access", as: :revoke_calendar_access
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
end
