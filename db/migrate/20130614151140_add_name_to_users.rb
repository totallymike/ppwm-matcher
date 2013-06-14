class AddNameToUsers < ActiveRecord::Migration
  def up
    add_column :ppwm_matcher_users, :name, :string
  end

  def down
    remove_column :ppwm_matcher_users, :name
  end
end
