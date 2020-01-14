class CartController < ApplicationController
  before_action :exclude_admin

  def add_item
    item = Item.find(params[:item_id])
    session[:cart] ||= {}
    if cart.limit_reached?(item.id)
      flash[:notice] = "You have all the item's inventory in your cart already!"
    else
      cart.add_item(item.id.to_s)
      session[:cart] = cart.contents
      flash[:notice] = "#{item.name} has been added to your cart!"
    end
    redirect_to items_path
  end

  def show
  end

  def empty
    session.delete(:cart)
    session.delete(:coupon)
    redirect_to '/cart'
  end

  def remove_item
    session[:cart].delete(params[:item_id])
    redirect_to '/cart'
  end

  def update_quantity
    if params[:change] == "more"
      cart.add_item(params[:item_id])
    elsif params[:change] == "less"
      cart.less_item(params[:item_id])
      return remove_item if cart.count_of(params[:item_id]) == 0
    end
    session[:cart] = cart.contents
    redirect_to '/cart'
  end

  def validate_coupon
    if cart.eligible_code?(params[:coupon_code])
      coupon = Coupon.find_by(code: params[:coupon_code])
      cart.apply_coupon({merchant_id: coupon.merchant_id, discount: coupon.percent_off, id: coupon.id})
      session[:coupon] = cart.applied_coupon
      redirect_to '/cart'
      flash[:success] = 'Coupon applied'
    else
      flash[:danger] = 'Coupon does not exist or is not valid for these items'
      redirect_to '/cart'
    end
  end
end
