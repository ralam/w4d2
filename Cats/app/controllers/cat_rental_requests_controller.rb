class CatRentalRequestsController < ApplicationController

  def new
    render :new
  end

  def create
    @request = CatRentalRequest.new(crr_params)
    if @request.save
      redirect_to cat_path(params[:cat_rental_request][:cat_id])
    else
      render(
        json: @request.errors.full_messages, status: 422
      )
    end
  end

  # def show
  #   @requests = CatRentalRequest.where(cat_id: cat_id)
  #   redirect_to cat_path(cat_id)
  # end

  private

  def crr_params
    params.require(:cat_rental_request).permit(:start_date, :end_date, :cat_id)
  end

end
