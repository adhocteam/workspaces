class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :rememberable, :trackable, :omniauthable, :omniauth_providers => [:twitter]
  has_many :workspaces
  
  class << self
    
    def from_omniauth(auth)
      user = find_by_provider_and_uid("twitter", auth.uid)
      user = create(provider: 'twitter', uid: auth.uid, screen_name: auth.info.nickname) unless user
      user
    end
  end
end
