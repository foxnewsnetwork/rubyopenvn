class CreateChapterElementRelationships < ActiveRecord::Migration
  def self.up
    create_table :chapter_element_relationships do |t|
      t.integer :chapter_id
      t.integer :element_id

      t.timestamps
    end
    add_index :chapter_element_relationships, :chapter_id
    add_index :chapter_element_relationships, :element_id
    add_index :chapter_element_relationships, [:chapter_id, :element_id], :unique => true
  end

  def self.down
    drop_table :chapter_element_relationships
  end
end
