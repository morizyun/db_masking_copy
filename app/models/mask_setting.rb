class MaskSetting < ActiveRecord::Base

  # ------------------------------------------------------------------
  # Constants
  # ------------------------------------------------------------------
  MASK_TYPE_COPY = 'copy'.freeze
  MASK_TYPE_NULL = 'null'.freeze
  MASK_TYPE_FIXED = 'fixed_value'.freeze
  MASK_TYPE_FIXED_INCREMENT = 'fixed_value_increment'.freeze
  MASK_RANDOM_ADDRESS = 'random_address'.freeze
  MASK_RANDOM_NAME = 'random_name'.freeze
  MASK_RANDOM_PHONE = 'random_phone'.freeze

  enum mask_type: { copy: MASK_TYPE_COPY,
                    null: MASK_TYPE_NULL,
                    fixed_value: MASK_TYPE_FIXED,
                    fixed_value_increment: MASK_TYPE_FIXED_INCREMENT,
                    random_address: MASK_RANDOM_ADDRESS,
                    random_phone: MASK_RANDOM_PHONE,
                    random_name: MASK_RANDOM_NAME}

end
