class AddTextToScene < ActiveRecord::Migration
  def self.up
    add_column :scenes, :texts, :text
  end

  def self.down
    remove_column :scenes, :texts
  end
end
