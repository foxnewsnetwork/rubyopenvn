class RemoveOwnerFromStory < ActiveRecord::Migration
  def self.up
    remove_column :stories, :owner
  end

  def self.down
    add_column :stories, :owner, :string
  end
end
