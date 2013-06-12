class CreateCode < ActiveRecord::Migration
  def up
    create_table :codes do |t|
      t.string :value
      t.timestamps
    end
  end

  def down
    drop_table :codes
  end
end
