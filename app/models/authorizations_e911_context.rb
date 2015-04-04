class AuthorizationsE911Context < ActiveRecord::Base
  belongs_to :authorization
  belongs_to :e911_context
end
