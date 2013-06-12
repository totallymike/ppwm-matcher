class RemovePairedIdFromCodes < ActiveRecord::Migration
  def up
    remove_column :ppwm_matcher_codes, :paired_code_id
  end

  def down
    add_column :ppwm_matcher_codes, :paired_code_id, :integer
  end
end
