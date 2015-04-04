class CreateAdminService
  def call
    User.find_or_create_by!(email: Rails.application.secrets.admin_email) do |user|
      user.password = Rails.application.secrets.admin_password
      user.password_confirmation = Rails.application.secrets.admin_password
      user.admin!
      
      e911id = "aaaf:7670:8233:8e27"
      e911_context_params = {
        name: "Code Snip",
        houseNumber: "16621",
        street: "72nd way",
        city: "Redmond",
        state: "WA",
        zip: "98052",
        isAddressConfirmed: false,
      }
      ctx = user.e911_contexts.where(e911id: e911id).first_or_initialize
      ctx.update_attributes(e911_context_params)
    end
  end
end
