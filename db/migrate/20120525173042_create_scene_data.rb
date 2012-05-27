class CreateSceneData < ActiveRecord::Migration
  def self.up
    create_table :scene_data do |t|
      t.integer :scene_id
      t.integer :element_id
      t.float :width, :default => 0
      t.float :height, :default => 0
      t.float :left, :default => 0
      t.float :top, :default => 0
      t.timestamps
    end
    add_index :scene_data, :scene_id
    add_index :scene_data, :element_id
    add_index :scene_data, [:scene_id, :element_id], :unique => true
  end

  def self.down
    drop_table :scene_data
  end
end
