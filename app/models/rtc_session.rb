class RTCSession < ActiveRecord::Base
  include BelongsToUser

  belongs_to :user

  before_create :start_session


  def start_session
    resp = start_response
    p resp
  end
  
  def start_url
    "#{cfg.fqdn}#{start_path}"
  end

  def start_session_data
    {
      mediaType: "dtls-srtp",
      ice:  "true",
      services: [
                 "ip_voice_call",
                 "ip_video_call"
                ]
    }
  end

  def start_data
    {
      session: start_session_data
    }
  end

  def start_body
    start_data.to_json
  end


  def start_path
#var GW_URL = "https://api.att.com",SERVICE_NAME="RTC",version="v1", REGISTER_RESOURCE = "sessions";
#var registerURL = GW_URL + "/" + SERVICE_NAME + "/" + version + "/" + REGISTER_RESOURCE;

    "/RTC/v1/sessions"
  end

  def cfg
    @cfg ||= Settings.auth_att
  end

  def access_token
    authorization.try(:access_token)
  end

  def authorization
    user.authorizations.authorized.first
  end

  def e911id
    authorization.try(:e911id)
  end

  def start_response
    RestClient.reset_before_execution_procs
    RestClient.add_before_execution_proc do |req, params|
      req['Authorization'] = "Bearer #{access_token}"
      req["x-e911id"] = self.e911id
    end

    begin
      RestClient.post(start_url, 
                      start_body, 
                      content_type: 'application/json', 
                      accept: 'application/json',
                      #authorization: "Bearer #{access_token}"
                      )
    rescue => e
      Rails.logger.error("**ERROR** #{e}")
      raise
    end
  end

end

		# req.open("POST", registerURL, true);
		# req.setRequestHeader("content-type", "application/json");
		# req.setRequestHeader("accept", "application/json");
		# req.setRequestHeader("x-e911id", xE911Id);
		# req.setRequestHeader("authorization", "Bearer " + accessToken);

#var GW_URL = "https://api.att.com",SERVICE_NAME="RTC",version="v1", REGISTER_RESOURCE = "sessions";
#var registerURL = GW_URL + "/" + SERVICE_NAME + "/" + version + "/" + REGISTER_RESOURCE;

