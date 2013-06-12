class AddPairedCodeIdToCodes < ActiveRecord::Migration
  def up
    add_column :ppwm_matcher_codes, :paired_code_id, :integer
  end

  def down
    remove_column :ppwm_matcher_codes, :paired_code_id
  end
end
