class AddInformationToVariousModels < ActiveRecord::Migration
  def self.up
    add_column :chapters, :number, :integer
    add_column :scene_data, :dialogue, :text
  end

  def self.down
    remove_column :chapters, :number
    remove_column :scene_data, :dialogue
  end
end # AddInformationToVariousModels
