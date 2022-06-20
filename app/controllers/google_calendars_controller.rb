# frozen_string_literal: true

class GoogleCalendarsController < ApplicationController
  def index
    @events = current_user.events
  end

  def redirect_to_google_calendar_auth
    client = Signet::OAuth2::Client.new(client_options)
    redirect_to client.authorization_uri.to_s, allow_other_host: true
  end

  def create_notification_channel
    response = Google::NotificationChannel.new(user_id: current_user.id).create_event_notification_channel
    session[:resource_id] = response.resource_id
    session[:uuid] = response.id
    redirect_to root_path
  end

  def stop_notification_channel
    Google::NotificationChannel.new(user_id: current_user.id).stop_event_notification_channel(
      session[:uuid],
      session[:resource_id])
    session[:resource_id] = nil
    session[:uuid] = nil
    redirect_to root_path
  rescue => e
    render :index, notice: e.message
  end

  private

    def client_options
      {
        client_id: Rails.application.credentials.google_calendar[:client_id],
        client_secret: Rails.application.credentials.google_calendar[:client_secret],
        authorization_uri: "https://accounts.google.com/o/oauth2/auth",
        token_credential_uri: "https://accounts.google.com/o/oauth2/token",
        scope: "https://www.googleapis.com/auth/calendar",
        redirect_uri: google_authorization_url,
        refresh_token: current_user.google_authentication.dig("refresh_token")
      }
    end
end
