class AddUniqueToCodesValue < ActiveRecord::Migration
  def up
    add_index :ppwm_matcher_codes, :value, unique: true
  end

  def down
    remove_index :ppwm_matcher_codes, :value
  end
end
