class Merchant::CouponsController < Merchant::BaseController
  def index
    @coupons = current_user.merchant.coupons
  end

  def create
    coupon = create_coupon
    if coupon.save
      flash[:success] = 'Coupon created'
      redirect_to '/merchant/coupons'
    else
      flash[:danger] = coupon.errors.full_messages.to_sentence
      redirect_back fallback_location: '/merchant/coupons/new'
    end
  end

  def update
    coupon = update_coupon
    if coupon.save
      flash[:success] = 'Coupon updated'
      redirect_to '/merchant/coupons'
    else
      flash[:danger] = coupon.errors.full_messages.to_sentence
      redirect_back fallback_location: "/merchant/coupons/#{coupon.id}/edit"
    end
  end

  def destroy
    coupon = Coupon.find(params[:id])
    if coupon.orders.empty?
      coupon.destroy
      redirect_back fallback_location: '/merchant/coupons'
      flash[:success] = 'Coupon deleted'
    else
      redirect_to '/merchant/coupons'
      flash[:danger] = 'Coupons with orders cannot be deleted'
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
    params.permit(:name, :code, :percent_off, :one_use?)
  end

  def create_coupon
    merchant = current_user.merchant
    case params[:one_use?]
    when 'true'
      merchant.coupons.create(coupon_params.merge!(one_use?: true))
    else
      merchant.coupons.create(coupon_params)
    end
  end

  def update_coupon
    coupon = Coupon.find(params[:id])
    case params[:one_use?]
    when 'true'
      coupon.update(coupon_params.merge!(one_use?: true))
    else
      coupon.update(coupon_params)
    end
    coupon
  end
end
