json.array!(@e911_contexts) do |e911_context|
  json.extract! e911_context, :id, :user_id, :e911id, :name, :houseNumber, :houseNumExt, :streetDir, :streetDirSuffix, :street, :streetNameSuffix, :unit, :city, :state, :zip, :addressAdditional, :comments, :isAddressConfirmed
  json.url e911_context_url(e911_context, format: :json)
end
