module PpwmMatcher
  class Code < ActiveRecord::Base
    self.table_name_prefix = "ppwm_matcher_"

    has_many :users

    validate :cannot_have_more_than_two_users

    def cannot_have_more_than_two_users
      if users(true).length > 2
        errors.add(:users, "can't have more than 2 users")
      end
    end

    def assign_user(user)
      users << user
    end

    def create_or_update
      ensure_value
      super
    end

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
