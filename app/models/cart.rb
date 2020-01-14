class Cart
  attr_reader :contents, :applied_coupon

  def initialize(contents, applied_coupon)
    @contents = contents || {}
    @contents.default = 0
    @applied_coupon = applied_coupon || Hash.new
  end

  def add_item(item_id)
    @contents[item_id] += 1
  end

  def less_item(item_id)
    @contents[item_id] -= 1
  end

  def count
    @contents.values.sum
  end

  def items
    @contents.map do |item_id, _|
      Item.find(item_id)
    end
  end

  def grand_total
    grand_total = 0.0
    @contents.each do |item_id, quantity|
      grand_total += subtotal_of(item_id)
    end
    grand_total
  end

  def discount_amount(item)
    if @applied_coupon['merchant_id'] == item.merchant_id
      (item.price * @contents[item.id.to_s]) * (@applied_coupon['discount'] / 100)
    else
      0
    end
  end

  def total_discount
    items.sum {|item| discount_amount(item)}
  end

  def count_of(item_id)
    @contents[item_id.to_s]
  end

  def subtotal_of(item_id)
    item = Item.find(item_id)
    (@contents[item_id.to_s] * item.price) - discount_amount(item)
  end

  def limit_reached?(item_id)
    count_of(item_id) == Item.find(item_id).inventory
  end

  def eligible_code?(code)
    ids = items.pluck(:merchant_id)
    codes = Coupon.where(merchant_id: ids)
                  .pluck(:code)
    codes.include?(code)
  end

  def apply_coupon(coupon_info)
    @applied_coupon = coupon_info
  end
end
