class Masker
  # ------------------------------------------------------------------
  # Public Class Method
  # ------------------------------------------------------------------
  def self.copy_data(from, to, table)
    from_model = Database.get_model(from, table)
    to_model = Database.get_model(to, table)

    hash_list = []
    from_model.all.each do |record|
      hash = {}
      record.class.column_names.each_with_index do |col, row_num|
        setting = MaskSetting.where(database: from, table: table, column: col).first
        hash[col.to_sym] = mask_value(setting, record, col, row_num)
      end
      hash_list << hash
    end

    to_model.transaction do
      to_model.connection.execute("delete from #{to_model.table_name}")
      hash_list.each { |_| to_model.create(_) }
    end
  end

  private
  # ------------------------------------------------------------------
  # Private Class Method
  # ------------------------------------------------------------------

  def self.mask_value(setting, record, column, row_num = nil)
    case setting.try(:mask_type)
      when MaskSetting::MASK_TYPE_NULL
        nil
      when MaskSetting::MASK_TYPE_FIXED
        setting[:fixed_value]
      when MaskSetting::MASK_TYPE_FIXED_INCREMENT
        setting[:fixed_value].gsub('@', "+#{(record[:id].presence || row_num.to_s)}@")
      when MaskSetting::MASK_RANDOM_ADDRESS
        Gimei.address.kanji
      when MaskSetting::MASK_RANDOM_NAME
        Gimei.name.kanji
      when MaskSetting::MASK_RANDOM_PHONE
        Faker::PhoneNumber.phone_number
      else
        record[column.to_sym]
    end
  end
end
