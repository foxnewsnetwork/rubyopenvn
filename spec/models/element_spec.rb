require 'spec_helper'
require 'factories'

describe Element do
  describe "creation" do
    it "should allow a naked creation" do 
      root = Factory(:element)
      root.should_not be_nil
    end # it
  end # creation
	describe "attachment" do
	  describe "success" do
      it "should allow attachment of png" do
        element = Factory(:element)
        element.save.should eq(true)
      end # it
      it "should allow attachment of gif" do
      
      end # it
    end # success
    describe "failure" do
      it "should not allow random extension attachments" do
      
      end # it
    end # failure
    describe "retrieval" do

    end # retrieval
	end # attachment
end # Element



# == Schema Information
#
# Table name: elements
#
#  id                   :integer(4)      not null, primary key
#  created_at           :datetime
#  updated_at           :datetime
#  metadata             :string(255)
#  picture_file_name    :string(255)
#  picture_content_type :string(255)
#  picture_file_size    :integer(4)
#  picture_updated_at   :datetime
#

