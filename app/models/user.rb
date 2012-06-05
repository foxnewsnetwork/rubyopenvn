class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name
  
  # Relationships
  has_many :stories, :foreign_key => :owner_id
  has_many :chapters, :foreign_key => :owner_id
  has_many :scenes, :foreign_key => :owner_id
  has_many :user_element_relationships
  has_many :elements, :through => :user_element_relationships, :foreign_key  => :user_id do
    def create(*data)
      element = Element.create(data)
      proxy_owner.fork(element)
      return element
    end # create
  end # has_many
  
  def self.authenticate(data)
    return nil if data.nil?
    return nil if data[:email].nil?
    return nil if data[:password].nil?
    @user = User.find_by_email( data[:email] )
    return nil if @user.nil?
    return @user if @user.valid_password?( data[:password] )
    return nil
  end # authenticate
  
  # fork
  def fork(element)
    begin
      a = UserElementRelationship.create!(:user_id => self.id, :element_id => element.id)
      return a
    rescue
      return nil
    end # begin-rescue
  end # fork
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

