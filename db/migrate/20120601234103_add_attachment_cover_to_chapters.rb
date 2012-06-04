class AddAttachmentCoverToChapters < ActiveRecord::Migration
  def self.up
    add_column :chapters, :cover_file_name, :string
    add_column :chapters, :cover_content_type, :string
    add_column :chapters, :cover_file_size, :integer
    add_column :chapters, :cover_updated_at, :datetime
  end

  def self.down
    remove_column :chapters, :cover_file_name
    remove_column :chapters, :cover_content_type
    remove_column :chapters, :cover_file_size
    remove_column :chapters, :cover_updated_at
  end
end
