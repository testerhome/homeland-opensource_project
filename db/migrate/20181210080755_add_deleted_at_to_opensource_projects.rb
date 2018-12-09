class AddDeletedAtToOpensourceProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :opensource_projects, :deleted_at, :datetime
    add_index :opensource_projects, :deleted_at
  end
end
