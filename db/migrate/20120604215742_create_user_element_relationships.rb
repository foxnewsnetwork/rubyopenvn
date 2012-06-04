class CreateUserElementRelationships < ActiveRecord::Migration
  def self.up
    create_table :user_element_relationships do |t|
      t.integer :user_id
      t.integer :element_id

      t.timestamps
    end
    add_index :user_element_relationships, :user_id
    add_index :user_element_relationships, :element_id
    add_index :user_element_relationships, [:user_id, :element_id], :unique => true
  end

  def self.down
    drop_table :user_element_relationships
  end
end
