class MakingElementsIndependent < ActiveRecord::Migration
  def self.up
    remove_column :elements, :scene_data_id
    add_column :elements, :metadata, :string
  end

  def self.down
    add_column :elements, :scene_data_id, :integer
    remove_column :elements, :metadata
  end
end
