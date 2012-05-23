class AddDefaultsToStories < ActiveRecord::Migration
  def self.up
    # stories
    remove_column :stories, :title
    remove_column :stories, :summary
    add_column :stories, :title, :string, :default => "Untitled"
    add_column :stories, :summary, :string, :default => "Unwritten"
    
    # chapters
    remove_column :chapters, :title
    add_column :chapters, :title, :string, :default => "Untitled"
  end

  def self.down
    remove_column :stories, :title
    remove_column :stories, :summary
    add_column :stories, :title, :string
    add_column :stories, :summary, :string
    
    remove_column :chapters, :title
    add_column :chapters, :title, :string
  end
end
