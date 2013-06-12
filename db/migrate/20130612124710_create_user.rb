class CreateUser < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string :email
      t.integer :code_id
      t.timestamps
    end
  end

  def down
    drop_table :users
  end
end
