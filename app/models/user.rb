class User < ActiveRecord::Base

  has_many :authorizations, :dependent => :destroy
  has_many :e911_contexts, :dependent => :nullify
  has_many :rtc_sessions, :dependent => :destroy

  enum role: [:user, :vip, :admin]
  after_initialize :set_default_role, :if => :new_record?

  def set_default_role
    self.role ||= :user
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
