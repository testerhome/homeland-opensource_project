class AddSuggestedAtToOpensourceProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :opensource_projects, :suggested_at, :datetime
    add_index :opensource_projects, :suggested_at
  end
end
