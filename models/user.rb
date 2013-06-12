module PpwmMatcher
  class User < ActiveRecord::Base
    self.table_name_prefix = "ppwm_matcher_"

    attr_accessible :email, :code_id
    belongs_to :code

    def update_with_code(code)
      update_attribute(:code_id, code.id)
    end
  end
end
