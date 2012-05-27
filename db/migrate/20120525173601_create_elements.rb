class CreateElements < ActiveRecord::Migration
  def self.up
    create_table :elements do |t|
      t.integer :scene_data_id

      t.timestamps
    end
    add_index :elements, :scene_data_id
  end

  def self.down
    drop_table :elements
  end
end
