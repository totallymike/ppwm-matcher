class CreateUser < ActiveRecord::Migration
  def up
    create_table :ppwm_matcher_users do |t|
      t.string :email
      t.integer :code_id
      t.timestamps
    end
  end

  def down
    drop_table :ppwm_matcher_users
  end
end
