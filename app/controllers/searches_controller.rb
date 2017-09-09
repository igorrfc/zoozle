class SearchesController < ApplicationController
  def index
    if search_params[:description].present?
      Searches::Processor.call(
        search_params[:description],
        remote_ip: request.remote_ip
      )
    end

    head :ok
  end

  private

  def search_params
    params.require(:search).permit(:description)
  end
end
