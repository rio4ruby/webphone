class E911Context < ActiveRecord::Base
  include BelongsToUser

  has_many :authorizations_e911_contexts, :dependent => :destroy
  has_many :authorizations, :through => :authorizations_e911_contexts

  validates_presence_of :user
  validates_presence_of :name, :houseNumber, :street, :city, :state, :zip


  before_create :lookup_e911id


  def lookup_e911id
    self.e911id = get_e911id
    p "LOOKUP #{self.e911id.inspect}"
    Rails.logger.info("E911ID: #{e911id}")
  rescue RuntimeError => e
    p "RuntimeError=#{e}"
    errors[:base] << "Check Address. E911 lookup failed. (#{e})"
    false
  end



  def has_e911id?
    e911id.present?
  end

  def get_e911id
    ans_json = client_response or raise RuntimeError.new("Client returned nil")
    ans = JSON.parse(ans_json)
    p "ANSANSANS=#{ans}"
    raise RuntimeError.new(ans) unless ans["e911Locations"] && ans["e911Locations"]["addressIdentifier"]
    ans["e911Locations"]["addressIdentifier"]
  end

  def access_token
    user.authorizations.authorized.first.try(:access_token)
  end


  def client_response
    RestClient.reset_before_execution_procs
    RestClient.add_before_execution_proc do |req, params|
      req['Authorization'] = "Bearer #{access_token}"
    end

    begin
      RestClient.post(e911_url, 
                      e911_body, 
                      content_type: 'application/json', 
                      accept: 'application/json',
                      #authorization: "Bearer #{access_token}"
                      )
    rescue => e
      Rails.logger.error("**ERROR** #{e}")
      raise
    end
  end




  def e911_data
    {
      e911Context: {
        address: address_data,
        isAddressConfirmed: "false"
      }
    }
  end

  def address_data
    address_hash = [:name, :houseNumber, :street, :city, :state, :zip].map do |fld|
      [fld, self.send(fld)]
    end.to_h
  end

  def e911_data0
    {
      e911Context: {
        address: {
          name: "Code Snip",
          houseNumber: "16621",
          street: "72nd way",
          city: "Redmond",
          state: "WA",
          zip: "98052"
        },
        "isAddressConfirmed": "false"
      }
    }
  end

  def e911_url
    "#{cfg.fqdn}#{e911_path}"
  end

  def e911_body
    e911_data.to_json
  end

  def e911_path
    "/emergencyServices/v1/e911Locations"
  end

  def auth_header
    { "Authorization" => "Bearer #{access_token}"}
  end

# "https://api.att.com/emergencyServices/v1/e911Locations"
# var e911Context=
# 		{
# 			address:{
# 						name: "Code Snip",
# 		            	houseNumber: "16621",
# 		            	street: "72nd way",
# 		            	city: "Redmond",
# 		            	state: "WA",
# 		            	zip: "98052"
# 		            },
# 		        "isAddressConfirmed": "false"
# 		};
# req.open("POST", serviceURL, true);
# 		req.setRequestHeader("content-type", "application/json");
# 		req.setRequestHeader("accept", "application/json");
# 		req.setRequestHeader("authorization", "Bearer " + accessToken);
# / Success response 201 Created


  def cfg
    @cfg ||= Settings.auth_att
  end

end
