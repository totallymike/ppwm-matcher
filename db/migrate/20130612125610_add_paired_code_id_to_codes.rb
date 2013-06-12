class AddPairedCodeIdToCodes < ActiveRecord::Migration
  def up
    add_column :codes, :paired_code_id, :integer
  end

  def down
    remove_column :codes, :paired_code_id
  end
end
