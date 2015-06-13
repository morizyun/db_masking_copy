class MaskSetting < ActiveRecord::Base
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

  def self.copy_with_mask(from, to, table)
    from_model = Database.get_model(from, table)
    to_model = Database.get_model(to, table)


    hash_list = []
    from_model.all.each do |item|
      hash = {}
      item.class.column_names.each_with_index do |col, idx|
        setting = self.where(database: from, table: table, column: col).first
        hash[col.to_sym] = case setting.try(:mask_type)
                             when MASK_TYPE_NULL
                               nil
                             when MASK_TYPE_FIXED
                               setting[:fixed_value]
                             when MASK_TYPE_FIXED_INCREMENT
                               setting[:fixed_value].gsub('@', "+#{(item[:id].presence || idx)}@")
                             when MASK_RANDOM_ADDRESS
                               Gimei.address.kanji
                             when MASK_RANDOM_NAME
                               Gimei.name.kanji
                             when MASK_RANDOM_PHONE
                               Faker::PhoneNumber.phone_number
                             else
                               item[col.to_sym]
                           end
      end
      hash_list << hash
    end

    to_model.transaction do
      begin
        to_model.connection.execute("delete from #{to_model.table_name}")
        hash_list.each { |_| to_model.create(_) }
      rescue => e
        binding.pry
      end
    end
  end
end
