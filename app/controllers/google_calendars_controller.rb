# frozen_string_literal: true

class GoogleCalendarsController < ApplicationController

  def index
  end

  def redirect_to_google_calendar_auth
    uri = URI("https://accounts.google.com/o/oauth2/auth")
    uri.query = URI.encode_www_form(uri_params)
    redirect_to uri.to_s, allow_other_host: true
  end

  private

    def uri_params
      {
        access_type: "offline",
        client_id: Rails.application.credentials.google_calendar[:client_id],
        redirect_uri: google_authorization_url,
        response_type: "code",
        scope: "https://www.googleapis.com/auth/calendar"
      }
    end
end
