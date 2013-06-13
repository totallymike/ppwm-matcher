class CreatePpwmMatcherTables < ActiveRecord::Migration
  def change
    create_table :ppwm_matcher_codes do |t|
      t.string :value
      t.timestamps
    end
    create_table :ppwm_matcher_users do |t|
      t.string :email
      t.integer :code_id
      t.timestamps
    end
  end
end
