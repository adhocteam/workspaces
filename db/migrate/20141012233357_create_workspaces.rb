class CreateWorkspaces < ActiveRecord::Migration
  def change
    create_table :workspaces do |t|
      t.string :title
      t.string :company
      t.string :location
      t.references :user, index: true

      t.timestamps
    end
  end
end
