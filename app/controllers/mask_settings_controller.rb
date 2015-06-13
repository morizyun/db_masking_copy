class MaskSettingsController < ApplicationController
  before_action :set_mask_setting, only: [:update]

  # POST /mask_settings
  # POST /mask_settings.json
  def create
    @mask_setting = MaskSetting.new(mask_setting_params)

    respond_to do |format|
      if @mask_setting.save
        format.html { redirect_to database_show_path(database: params[:mask_setting][:database]), notice: 'Mask setting was successfully created.' }
        format.json { render :show, status: :created, location: @mask_setting }
      else
        format.html { render :new }
        format.json { render json: @mask_setting.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /mask_settings/1
  # PATCH/PUT /mask_settings/1.json
  def update
    respond_to do |format|
      if @mask_setting.update(mask_setting_params)
        format.html { redirect_to database_show_path(database: params[:mask_setting][:database]), notice: 'Mask setting was successfully updated.' }
        format.json { render :show, status: :ok, location: @mask_setting }
      else
        format.html { render :edit }
        format.json { render json: @mask_setting.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mask_setting
      @mask_setting = MaskSetting.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mask_setting_params
      params.require(:mask_setting).permit(:database, :table, :column, :mask_type, :fixed_value)
    end
end
