# == Schema Information
# Schema version: 20081110184646
#
# Table name: authentication_providers
#
#  id               :integer(4)      not null, primary key
#  name             :string(255)     default(""), not null
#  type             :string(255)     default("AuthenticationProvider"), not null
#  label            :string(255)
#  logo             :string(255)
#  button           :string(255)
#  description      :text
#  active           :boolean(1)      default(TRUE), not null
#  display_sequence :integer(4)
#  created_at       :datetime
#  updated_at       :datetime
#

class WindowsLiveIdProvider < AuthenticationProvider
  
end
