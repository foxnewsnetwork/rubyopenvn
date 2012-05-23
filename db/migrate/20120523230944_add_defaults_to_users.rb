class AddDefaultsToUsers < ActiveRecord::Migration
  def self.up
    remove_column :users, :points
    remove_column :users, :name
    add_column :users, :points, :integer, :default => 0
    add_column :users, :name, :string, :default => "anonymous"
  end

  def self.down
    remove_column :users, :points
    remove_column :users, :name
    add_column :users, :points, :integer
    add_column :users, :name, :string
  end
end
