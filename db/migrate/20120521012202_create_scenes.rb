class CreateScenes < ActiveRecord::Migration
  def self.up
    create_table :scenes do |t|
      t.integer :chapter_id
      t.integer :parent_id

      t.timestamps
    end
  end

  def self.down
    drop_table :scenes
  end
end
