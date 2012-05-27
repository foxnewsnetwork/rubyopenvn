class AddNumberToScenesAndZIndex < ActiveRecord::Migration
  def self.up
    add_column :element_relationships, :zindex, :integer, :default => 0
    add_column :scene_data, :zindex, :integer, :default => 0
    add_column :scenes, :number, :integer
  end

  def self.down
    remove_column :element_relationships, :zindex
    remove_column :scene_data, :zindex
    remove_column :scenes, :number
  end
end
