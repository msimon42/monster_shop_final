class Admin::MerchantsController < Admin::BaseController
  def show
    @merchant = Merchant.find(params[:id])
  end

  def index
    @merchants = Merchant.all
  end

  def new
  end

  def edit
    @merchant = Merchant.find(params[:id])
  end

  def update
    @merchant = Merchant.find(params[:id])
    if @merchant.update(merchant_params)
      redirect_to "/admin/merchants/#{@merchant.id}"
    else
      generate_flash(@merchant)
      render :edit
    end
  end

  def create
    merchant = Merchant.new(merchant_params)
    if merchant.save
      redirect_to '/admin/merchants'
    else
      generate_flash(merchant)
      render :new
    end
  end

  def update_status
    merchant = Merchant.find(params[:id])
    merchant.update(enabled: !merchant.enabled)
    if merchant.enabled?
      merchant.items.update_all(active: true)
      flash[:notice] = "#{merchant.name} has been enabled"
    else
      merchant.items.update_all(active:false)
      flash[:notice] = "#{merchant.name} has been disabled"
    end
    redirect_to '/admin/merchants'
  end

  private

  def merchant_params
    params.permit(:name, :address, :city, :state, :zip)
  end
end
