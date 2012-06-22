class RenameTextsToTextInScenes < ActiveRecord::Migration
  def self.up
  	remove_column :scenes, :texts
  	add_column :scenes, :text, :text
  end

  def self.down
  	remove_column :scenes, :text
  	add_column :scenes, :texts, :text
  end
end 
