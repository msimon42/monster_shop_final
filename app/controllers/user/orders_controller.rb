class User::OrdersController < ApplicationController
  before_action :exclude_admin

  def index
    @orders = current_user.orders
  end

  def show
    @order = current_user.orders.find(params[:id])
  end

  def create
    order = current_user.orders.create
    if cart.applied_coupon['id']
      create_order_with_coupon
    else
      create_order_without_coupon
    end
    complete_order
  end

  def cancel
    order = current_user.orders.find(params[:id])
    order.cancel
    redirect_to "/profile/orders/#{order.id}"
  end

  private

  def create_order_with_coupon
    order = current_user.orders.create(coupon_id: cart.applied_coupon['id'])
    cart.items.each do |item|
      order.order_items.create({
        item: item,
        quantity: cart.count_of(item.id),
        price: item.price,
        discount: cart.discount_amount(item),
        revenue: (item.price * cart.count_of(item.id)) - cart.discount_amount(item)
        })
    end
  end

  def create_order_without_coupon
    order = current_user.orders.create
    cart.items.each do |item|
      order.order_items.create({
        item: item,
        quantity: cart.count_of(item.id),
        price: item.price,
        discount: 0,
        revenue: item.price * cart.count_of(item.id)
        })
    end
  end

  def complete_order
    session.delete(:cart)
    session.delete(:coupon)
    flash[:notice] = "Order created successfully!"
    redirect_to '/profile/orders'
  end
end
