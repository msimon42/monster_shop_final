class MerchantsController < ApplicationController
  def index
    @merchants = Merchant.all
  end

  def show
    @merchant = Merchant.find(params[:id])
  end

  def destroy
    merchant = Merchant.find(params[:id])
    if merchant.order_items.empty?
      merchant.destroy
    else
      flash[:notice] = "#{merchant.name} can not be deleted - they have orders!"
    end
    redirect_to '/merchants'
  end

  private

  def merchant_params
    params.permit(:name, :address, :city, :state, :zip)
  end
end
