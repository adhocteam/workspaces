class CreateWorkspaceImages < ActiveRecord::Migration
  def change
    create_table :workspace_images do |t|
      t.references :workspace, index: true

      t.timestamps
    end
    add_attachment :workspace_images, :image
  end
end
