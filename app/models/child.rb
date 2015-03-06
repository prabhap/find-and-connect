class Child < ActiveRecord::Base
  mount_uploader :avatar, AvatarUploader
end
