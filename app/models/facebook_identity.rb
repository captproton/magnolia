# == Schema Information
# Schema version: 20090107200544
#
# Table name: facebook_identities
#
#  id          :integer(4)      not null, primary key
#  facebook_id :integer(4)
#  user_id     :integer(4)
#  created_at  :datetime
#  updated_at  :datetime
#

class FacebookIdentity < ActiveRecord::Base
  belongs_to :user
end
