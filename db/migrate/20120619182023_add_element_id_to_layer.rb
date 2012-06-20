class AddElementIdToLayer < ActiveRecord::Migration
  def self.up
    add_column :layers, :element_id, :integer
  end # up

  def self.down
    remove_column :layers, :element_id
  end # down
end # AddElementIdToLayer
