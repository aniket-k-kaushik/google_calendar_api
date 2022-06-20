# frozen_string_literal: true

module GoogleCalendarsHelper
  def create_or_stop_channel_path
    session[:uuid].present? ? stop_channel_path : create_channel_path
  end

  def create_stop_channel_link_text
    session[:uuid].present? ? "Stop 2 ways sync" : "Create 2 ways sync"
  end
end
