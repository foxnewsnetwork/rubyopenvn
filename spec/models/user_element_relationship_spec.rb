require 'spec_helper'

describe UserElementRelationship do
  describe "ownership" do
    before(:each) do
      @user = Factory(:user)
      @element = Factory(:element)
    end # before
    
    it "should support the fork command" do
      @user.fork(@element)
      @user.elements.should include(@element)
      @element.users.should include(@user)
    end # it
    
    it "should support a forked_by command" do
      @element.forked_by(@user)
      @user.elements.should include(@element)
      @element.users.should include(@user)
    end # it
  end # ownership
end # UserElementRelationship

# == Schema Information
#
# Table name: user_element_relationships
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  element_id :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

