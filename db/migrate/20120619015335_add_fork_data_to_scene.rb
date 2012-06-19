class AddForkDataToScene < ActiveRecord::Migration
  def self.up
    add_column :scenes, :fork_text, :string
    add_column :scenes, :fork_number, :integer, :default => 0
  end # up

  def self.down
    remove_column :scenes, :fork_text
    remove_column :scenes, :fork_number
  end # down
end # AddForkDataToScene
