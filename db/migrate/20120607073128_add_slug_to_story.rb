class AddSlugToStory < ActiveRecord::Migration
  def self.up
    add_column :stories, :slug, :string
  end

  def self.down
    remove_column :stories, :slug
  end
end
