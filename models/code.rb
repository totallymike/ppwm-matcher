module PpwmMatcher
  class Code < ActiveRecord::Base
    self.table_name_prefix = "ppwm_matcher_"

    attr_accessible :value, :paired_code_id

    belongs_to :paired_code, :class_name => "Code", :foreign_key => "paired_code_id"
    has_many :users

    # Create two codes and link them as pairs.
    def self.create_pair
      first  = Code.create!(:value => generate_string)

      second = Code.create!(:value => generate_string,
                            :paired_code_id => first.id)

      first.update_attribute(:paired_code_id, second.id)

      [first, second]
    end

    # Generate a random 6 character code.
    def self.generate_string
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
