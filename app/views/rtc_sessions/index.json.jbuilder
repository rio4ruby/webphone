json.array!(@rtc_sessions) do |rtc_session|
  json.extract! rtc_session, :id, :user_id, :sessionId, :started_at
  json.url rtc_session_url(rtc_session, format: :json)
end
