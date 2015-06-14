class TablesController < ApplicationController
  def copy_data
    Masker.copy_data(params[:from], params[:to], params[:table])
    redirect_to database_show_path(db_key: params[:from])
  end
end
