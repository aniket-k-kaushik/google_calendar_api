class GoogleNotificationsController < ActionController::API

  def fetch_events
    @events = Google::Events.new(user_id: current_user.id).fetch
  end

  def callback
    return if user_id.blank?
    events = Google::Events.new(user_id: user_id).fetch
    create_events(events)
    render json: {events: events}, status: 200
  end

  private

    def request_headers
      @request_headers ||= request.headers
    end

    def user_id
      return if request_headers['HTTP_X_GOOG_CHANNEL_TOKEN'].blank?
      JSON.parse(request_headers['HTTP_X_GOOG_CHANNEL_TOKEN'])&.dig('user_id')
    end

    def create_events(events)
      events.map { |event| create_event(event) } if events.present?
    end

    def create_event(event)
      session = user.events.find_or_create_by(google_event_id: event&.id)
      if event.status == 'cancelled'
        session.destroy
      else
        session.update!(name: event&.summary,
                        start_time: event&.start&.date_time,
                        end_time: event&.end&.date_time,
                        attendees: event&.attendees&.map(&:email),
                        status: event.status)
      end
    end

    def user
      @user = User.find_by(id: user_id) || current_user
    end

    def client
      @client ||= Signet::OAuth2::Client.new(client_options)
    end

    def client_options
      {
        client_id: Rails.application.credentials.google_calendar[:client_id],
        client_secret: Rails.application.credentials.google_calendar[:client_secret],
        authorization_uri: "https://accounts.google.com/o/oauth2/auth",
        token_credential_uri: "https://accounts.google.com/o/oauth2/token",
        scope: "https://www.googleapis.com/auth/calendar",
        redirect_uri: google_authorization_url,
        refresh_token: user.google_authentication.dig("refresh_token")
      }
    end
end
