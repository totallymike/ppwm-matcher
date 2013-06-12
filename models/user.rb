class User < ActiveRecord::Base
  attr_accessible :email, :code_id
  belongs_to :code
end
