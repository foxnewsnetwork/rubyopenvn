class CreateElementRelationships < ActiveRecord::Migration
  def self.up
    create_table :element_relationships do |t|
      t.float :width, :default => 0
      t.float :height, :default => 0
      t.float :left, :default => 0
      t.float :top, :default => 0
      t.integer :pid
      t.integer :cid
      t.integer :sid
      t.timestamps
    end
    add_index :element_relationships, :sid
    add_index :element_relationships, :pid
    add_index :element_relationships, :cid
    add_index :element_relationships, [:pid, :cid]
    add_index :element_relationships, [:sid, :pid, :cid], :unique => true
    
  end

  def self.down
    drop_table :element_relationships
  end
end
