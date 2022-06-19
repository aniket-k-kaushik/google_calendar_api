class GoogleAuthorizationsController < ApplicationController

  def redirect_from_google_calendar_auth
    client.code = params[:code]
    response = client.fetch_access_token!
    current_user.update(google_authentication: response)
    redirect_to root_path
  end

  private

    def client_options
      {
        client_id: Rails.application.credentials.google_calendar[:client_id],
        client_secret: Rails.application.credentials.google_calendar[:client_secret],
        authorization_uri: "https://accounts.google.com/o/oauth2/auth",
        token_credential_uri: "https://accounts.google.com/o/oauth2/token",
        scope: Google::Apis::CalendarV3::AUTH_CALENDAR,
        refresh_token: current_user.google_authentication.dig("refresh_token"),
        redirect_uri: google_authorization_url
      }
    end

    def client
      @client ||= Signet::OAuth2::Client.new(client_options)
    end

end
