class Code < ActiveRecord::Base
  attr_accessible :value, :paired_code_id

  belongs_to :code, :foreign_key => "paired_code_id"

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
end
