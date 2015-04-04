class Authorization < ActiveRecord::Base
  include BelongsToUser

  has_many :authorizations_e911_contexts, :dependent => :destroy
  has_many :e911_contexts, :through => :authorizations_e911_contexts

  scope :authorized, -> { where("authorizations.access_token IS NOT NULL") }

  def auth_url
    "#{cfg.fqdn}#{auth_path}?" + URI.encode_www_form(auth_params)
  end

  def authorized?
    access_token.present?
  end

  def e911id
    e911_contexts.first.try(:e911id)
  end

  def has_e911id?
    e911id.present?
  end

  def exchange_code
    content_type = 'application/x-www-form-urlencoded'
    puts "URL: #{token_url} PARAMS=#{token_params}"
    json_ans = RestClient.post(token_url, token_params, content_type: content_type, accept: 'application/json')
    ans = JSON.parse(json_ans)
    puts "ANS=#{ans}"
    access_token, refresh_token = ans['access_token'], ans['refresh_token']
    self.update_attributes(access_token: access_token, refresh_token: refresh_token, expires_in: ans['expires_in'])
  end


  private 

  def auth_header
    { "Authorization" => "Bearer #{access_token}"}
  end


  def auth_params
    {
      #scope: cfg.scope,
      scope: "WEBRTCMOBILE,EMERGENCYSERVICES",
      response_type: 'code',
      client_id: cfg.client_id,
      redirect_uri: cfg.redirect_uri,
      state: self.id.to_s
    }.with_indifferent_access
  end

  def token_params
    {
      client_id: cfg.client_id,
      client_secret: cfg.client_secret,
      grant_type: 'authorization_code',
      redirect_uri: cfg.redirect_uri,
      code: self.auth_code,
    }
  end

  def token_url 
    "#{cfg.fqdn}#{token_path}"
  end

  def auth_path
    "/oauth/v4/authorize"
  end

  def token_path
    "/oauth/token"
  end

  def cfg
    @cfg ||= Settings.auth_att
  end

end
