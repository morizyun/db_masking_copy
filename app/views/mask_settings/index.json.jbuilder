json.array!(@mask_settings) do |mask_setting|
  json.extract! mask_setting, :id, :database, :table, :column, :mask_type, :fixed_value
  json.url mask_setting_url(mask_setting, format: :json)
end
