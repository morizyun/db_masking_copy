module MaskSettingHelper

  # Select or new MaskSetting
  def select_or_new_mask_setting(settings, db_key, table, column)
    setting = settings.select { |_| _.column == column }.first
    setting.presence || MaskSetting.new(db_key: db_key, table: table, column: column)
  end

end
