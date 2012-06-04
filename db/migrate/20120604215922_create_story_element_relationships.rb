class CreateStoryElementRelationships < ActiveRecord::Migration
  def self.up
    create_table :story_element_relationships do |t|
      t.integer :story_id
      t.integer :element_id

      t.timestamps
    end
    add_index :story_element_relationships, :story_id
    add_index :story_element_relationships, :element_id
    add_index :story_element_relationships, [:story_id, :element_id], :unique => true
  end

  def self.down
    drop_table :story_element_relationships
  end
end
