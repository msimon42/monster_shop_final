class Merchant::CouponsController < Merchant::BaseController
  def index
    @coupons = current_user.merchant.coupons
  end

  def create
    merchant = current_user.merchant
    coupon = merchant.coupons.create(coupon_params)
    if coupon.save
      flash[:success] = 'Coupon created'
      redirect_to '/merchant/coupons'
    else
      flash[:danger] = coupon.errors.full_messages.to_sentence
      redirect_back fallback_location: '/merchant/coupons/new'
    end
  end

  def update
    coupon = Coupon.find(params[:id])
    coupon.update(coupon_params)
    if coupon.save
      flash[:success] = 'Coupon updated'
      redirect_to '/merchant/coupons'
    else
      flash[:danger] = coupon.errors.full_messages.to_sentence
      redirect_back fallback_location: "/merchant/coupons/#{coupon.id}/edit"
    end
  end

  def new

  end

  def show

  end

  def edit
    @coupon = Coupon.find(params[:id])
  end

  private

  def coupon_params
    params.permit(:name, :code, :percent_off)
  end
end
