class Admin::MerchantsController < Admin::BaseController
  def show
    @merchant = Merchant.find(params[:id])
  end

  def index
    @merchants = Merchant.all
  end

  def new
  end

  def create
    merchant = Merchant.new(merchant_params)
    if merchant.save
      redirect_to '/merchants'
    else
      generate_flash(merchant)
      render :new
    end
  end

  def update
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
end
