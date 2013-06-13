class AddUniqueToUsersGithubLogin < ActiveRecord::Migration
  def up
    add_index :ppwm_matcher_users, :github_login, unique: true
  end

  def down
    remove_index :ppwm_matcher_users, :github_login
  end
end
