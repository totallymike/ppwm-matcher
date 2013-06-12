module PpwmMatcher
  class Code < ActiveRecord::Base
    self.table_name_prefix = "ppwm_matcher_"

    has_many :users

    before_create :ensure_value

    def ensure_value
      self.value ||= generate_string
    end

    # Generate a random 6 character code.
    def generate_string
      (0...6).map{(65+rand(26)).chr}.join
    end

    def pair_claimed?
      !!paired_user
    end

    def paired_user
      paired_code.user
    end
  end
end
