class GoogleAuthorizationsController < ApplicationController

  def redirect_from_google_calendar_auth
    # Redirect from the google acces concent page with "code"
    client.code = params[:code]
    # Using google authorization "code" to get the access_token and refresh_token
    response = client.fetch_access_token!
    current_user.update(google_authentication: response)
    redirect_to root_path
  end

  def revoke_google_calendar_access
    uri = URI("https://accounts.google.com/o/oauth2/revoke")
    params = { token: current_user.google_authentication.dig("refresh_token") }
    uri.query = URI.encode_www_form(params)
    response = Net::HTTP.get(uri)
    result = JSON.parse(response)
    if result['error'].present?
      redirect_to root_path, notice: result['error']
    else
      current_user.update(google_authentication: {})
      redirect_to root_path, notice: "Access Revoked Successfully"
    end
  end

  private

    def client
      @client ||= Signet::OAuth2::Client.new(client_options)
    end

    def client_options
      {
        client_id: Rails.application.credentials.google_calendar[:client_id],
        client_secret: Rails.application.credentials.google_calendar[:client_secret],
        token_credential_uri: "https://accounts.google.com/o/oauth2/token",
        scope: "https://www.googleapis.com/auth/calendar",
        redirect_uri: google_authorization_url
      }
    end

end
