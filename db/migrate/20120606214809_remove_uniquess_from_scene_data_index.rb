class RemoveUniquessFromSceneDataIndex < ActiveRecord::Migration
  def self.up
    remove_index :scene_data, [:scene_id, :element_id]
    add_index :scene_data, [:scene_id, :element_id]
  end

  def self.down
    remove_index :scene_data, [:scene_id, :element_id]
    add_index :scene_data, [:scene_id, :element_id], :unique => true
  end
end
