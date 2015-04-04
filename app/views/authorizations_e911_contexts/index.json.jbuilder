json.array!(@authorizations_e911_contexts) do |authorizations_e911_context|
  json.extract! authorizations_e911_context, :id, :authorization_id, :e911_context_id
  json.url authorizations_e911_context_url(authorizations_e911_context, format: :json)
end
