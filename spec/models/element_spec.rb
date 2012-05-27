require 'spec_helper'
require 'factories'

describe Element do
  describe "creation" do
    it "should allow a naked creation" do 
      root = Element.create
      root.should_not be_nil
    end # it
  end # creation
end


# == Schema Information
#
# Table name: elements
#
#  id         :integer(4)      not null, primary key
#  created_at :datetime
#  updated_at :datetime
#  metadata   :string(255)
#

