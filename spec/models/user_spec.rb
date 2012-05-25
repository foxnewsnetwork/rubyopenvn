require 'spec_helper'

describe User do
  describe "Validations testing" do
  end # Validatiosn testing
  
  describe "tokens" do
    before(:each) do
      @attr = { 
        :name => "Alice",
        :email => "alice@alice.alice" ,
        :password => "1234567" ,
        :password => "1234567"
      }
      @attr2 = { 
      	:email => "alice" + rand(123).to_s + "@asdf.asdf" ,
      	:password => "123041jt01jt"
      }
      @user = User.create!(@attr)
    end # before
    
  end # describe
end # User


# == Schema Information
#
# Table name: users
#
#  id                     :integer(4)      not null, primary key
#  email                  :string(255)     default(""), not null
#  encrypted_password     :string(128)     default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer(4)      default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  points                 :integer(4)      default(0)
#  name                   :string(255)     default("anonymous")
#

