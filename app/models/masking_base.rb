class MaskingBase < ActiveRecord::Base
  establish_connection(Rails.env)
end
