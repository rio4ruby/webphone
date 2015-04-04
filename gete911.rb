require 'rest-client'
require 'json'
require 'yaml'

def get_implicit_at
  config = YAML.load_file('config.yml')
  
  auth_url = "https://api.att.com/oauth/v4/authorize"
  auth_body = {
    grant_type: 'authorization_code',
    client_id: config['client_id'],
    client_secret: config['client_secret'],
    scope: 'webrtcmobile',
    response_type: 'code',
    authorize: 'true'
  }
  response = begin
               RestClient.post auth_url, auth_body
             rescue => e
               e.response
             end
  p response
  result = JSON.parse(response)
  result["access_token"]
end
access_token = get_implicit_at
  
puts "AT=#{access_token}"

__END__
def get_client_at
  config = YAML.load_file('config.yml')
  
  auth_url = "https://api.att.com/oauth/v4/token"
  auth_body = {
    grant_type: 'client_credentials',
    client_id: config['client_id'],
    client_secret: config['client_secret'],
    scope: 'webrtc',
  }
  response = begin
               RestClient.post auth_url, auth_body
             rescue => e
               e.response
             end
  result = JSON.parse(response)
  result["access_token"]
end

#access_token = get_client_at
  
#puts "AT=#{access_token}"
  
  

access_token = "BF-ACSI~3~20150326135115~gLMst82GbTxvOWnsXua3foWzEwM628i6"
e911_url = "https://api.att.com/emergencyServices/v1/e911Location"


e911_body = {
  address: {
    first_name: 'John',
    last_name: 'Doe',
    house_number: '16221',
    street: 'NE 72nd Way',
    unit: '',
    city: 'Redmond',
    state: 'WA',
    zip: '98052',
  },
  is_confirmed: 'false',
}.to_json

#RestClient.add_before_execution_proc do |req, params|
#  req.make_headers( {
#    "Authorization" => "Bearer #{access_token}"
#  })
#end

response = begin
             RestClient.post e911_url, e911_body, 
             :content_type => :json, 
             :accept => :json, 
             :headers => {"Authorization" => "Bearer #{access_token}"}
           rescue => e
             e.response
           end

puts response

__END__


    # dhs.createE911Id({
    #   token: token,
    #   address: address,
    #   is_confirmed: is_confirmed,
    #   success: function (response) {
    #     console.log('Success in creating e911 id: ', response);

    #     res.json(200, response);
    #   },
    #   error: function (error) {
    #     console.log('Error in creating e911 id: ', error);

    #     res.json(400, error);
    #   }
    # });

# "POST emergencyServices/v1/e911Location"
# function createE911Id () {
#     ATT.rtc.dhs.createE911Id({
#         token: e911AccessTokenResult.value,
#         address: {
#                     first_name: 'John',
#                     last_name: 'Doe',
#                     house_number: '16221',
#                     street: 'NE 72nd Way',
#                     unit: '',
#                     city: 'Redmond',
#                     state: 'WA',
#                     zip: '98052',
#                     is_confirmed: 'true'
#         },
#         success:    function (e911Data) {
#                     e911IDInput.value = e911Data.e911Locations.addressIdentifier;
#                     e911IdButton.disabled = true;
#                     createUserAccessTokenButton.disabled = false;
#                     userTokenResult.value = "Next create a user access token";
#                     },
#         error: onError
#     });
# }
