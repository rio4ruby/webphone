module BelongsToUser
  extend ActiveSupport::Concern

  included do
    belongs_to :user
  end
  
  module ClassMethods

    def for_user(user)
      where(user: user)
    end

  end
end
