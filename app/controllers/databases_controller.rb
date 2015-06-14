class DatabasesController < ApplicationController
  def index
    @database = Database.new
  end

  def show
    @tables = Database.new.generate_models(params[:db_key])
  end

  def copy_schema
    Database.new.copy_schema(params[:from], params[:to])
    redirect_to database_show_path(db_key: params[:from])
  end

  def copy_data
    from_tables = Database.new.generate_models(params[:from])
    to_tables = Database.new.generate_models(params[:to])
    tables = (from_tables.to_set & to_tables.to_set).to_a
    tables.each { |table| Masker.copy_data(params[:from], params[:to], table)}

    redirect_to database_show_path(db_key: params[:from])
  end
end
