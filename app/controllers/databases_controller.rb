class DatabasesController < ApplicationController
  def index
    @database = Database.new
  end

  def show
    @tables = Database.new.generate_models(params[:database])
  end

  def copy_schema
    Database.new.copy_schema(params[:from], params[:to])
    redirect_to database_show_path(database: params[:from])
  end

  def copy_data
    from_tables = Database.new.generate_models(params[:from])
    to_tables = Database.new.generate_models(params[:to])
    tables = (from_tables.to_set & to_tables.to_set).to_a
    tables.each do |table|
      MaskSetting.copy_with_mask(params[:from], params[:to], table)
    end

    redirect_to database_show_path(database: params[:from])
  end
end
