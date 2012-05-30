class AddAuthorToEverything < ActiveRecord::Migration
  def self.up
    add_column :chapters, :owner_id, :integer
    add_index :chapters, :owner_id
    
    add_column :scenes, :owner_id, :integer
    add_index :scenes, :owner_id
  end # up

  def self.down
    remove_index :chapters, :owner_id
    remove_column :chapters, :owner_id
    
    remove_index :scenes, :owner_id
    remove_column :scenes, :owner_id
  end # down
end # AddAuthorToEverthing
