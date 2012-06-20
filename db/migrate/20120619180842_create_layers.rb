class CreateLayers < ActiveRecord::Migration
  def self.up
    create_table :layers do |t|
      t.integer :scene_id
      t.float :width, :default => 0.0
      t.float :height, :default => 0.0
      t.float :x, :default => 0.0
      t.float :y, :default => 0.0
      
      t.timestamps
    end
    add_index :layers, :scene_id
  end

  def self.down
    remove_index :layers, :scene_id
    drop_table :layers
  end
end
