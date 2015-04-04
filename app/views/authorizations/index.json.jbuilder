json.array!(@authorizations) do |authorization|
  json.extract! authorization, :id, :references, :carrier, :access_token, :refresh_token, :authorized_at, :e911id
  json.url authorization_url(authorization, format: :json)
end
