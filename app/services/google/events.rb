# frozen_string_literal: true

module Google
  class Events
    attr_reader :user_id

    def initialize(user_id:)
      @user_id = user_id
    end

    def fetch
      @events = []
      page_token = nil
      begin
        result = calendar.list_events(
          "primary", page_token: page_token, show_deleted: true)
        @events += result&.items
        page_token = if result.next_page_token != page_token
          result.next_page_token
        end
      end while(!page_token.nil?)
      @events
    end

    private

      def calendar
        return @calendar if @calendar.present?

        @calendar = Google::Apis::CalendarV3::CalendarService.new
        @calendar.authorization = client
        @calendar
      end

      def client
        @client ||= Signet::OAuth2::Client.new(client_options)
      end

      def user
        @user ||= User.find_by(id: user_id)
      end

      def client_options
        {
          client_id: Rails.application.credentials.google_calendar[:client_id],
          client_secret: Rails.application.credentials.google_calendar[:client_secret],
          authorization_uri: "https://accounts.google.com/o/oauth2/auth",
          token_credential_uri: "https://accounts.google.com/o/oauth2/token",
          scope: "https://www.googleapis.com/auth/calendar",
          refresh_token: user.google_authentication.dig("refresh_token")
        }
      end
  end
end
