class User < ActiveRecord::Base
  attr_accessible :email, :code_id
  belongs_to :code

  def update_with_code(code)
    update_attribute(:code_id, code.id)
  end
end
