class Masker
  # ------------------------------------------------------------------
  # Public Class Method
  # ------------------------------------------------------------------
  def self.copy_data(from, to, table)
    from_model = Database.get_model(from, table)
    to_model = Database.get_model(to, table)

    hash_list = []
    settings = MaskSetting.where(db_key: from, table: table)
    from_model.all.each do |record|
      hash = {}
      record.class.column_names.each_with_index do |col, row_num|
        hash[col.to_sym] = mask_value(settings, record, col, row_num)
      end
      hash_list << hash
    end

    to_model.transaction do
      to_model.connection.execute("delete from #{to_model.table_name}")
      upsert_or_create(hash_list, to_model)
    end
  end

  private
  # ------------------------------------------------------------------
  # Private Class Method
  # ------------------------------------------------------------------

  def self.mask_value(settings, record, column, row_num = nil)
    setting = settings.select { |s| s.column == column }.first
    case setting.try(:mask_type) || MaskSetting::MASK_TYPE_DEFAULT
      when MaskSetting::MASK_TYPE_NULL
        nil
      when MaskSetting::MASK_TYPE_FIXED
        setting.fixed_value
      when MaskSetting::MASK_TYPE_FIXED_INCREMENT
        if setting.fixed_value.is_email?
          setting.fixed_value.gsub('@', "+#{(record[:id].presence || row_num.to_s)}@")
        else
          setting.fixed_value + "#{(record[:id].presence || row_num.to_s)}"
        end
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

  # create / update hash_list to model
  def self.upsert_or_create(hash_list, model)
    if model.column_names.include?('id')
      upsert(hash_list, model)
    else
      hash_list.each { |_| model.create(_) }
    end
  end

  # Bulk insert / update (mass upsert)
  def self.upsert(hash_list, model)
    model.connection_pool.with_connection do |c|
      Upsert.batch(c, model.table_name) do |upsert|
        hash_list.each do |hash|
          hash.merge!(updated_at: Time.now.iso8601, created_at: Time.now.iso8601)
          upsert.row({id: hash[:id]}, hash)
        end
      end
    end
  end
end
