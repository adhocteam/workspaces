class AddOmniauthColumnesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :provider, :string
    add_column :users, :uid, :string
    add_index :users, [:provider, :uid], :unique => true
    add_column :users, :screen_name, :string
  end
end
