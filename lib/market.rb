class Market
  attr_reader :name, :vendors

  def initialize(name)
    @name = name
    @vendors = []
  end

  def add_vendor(vendor)
    @vendors << vendor
  end

  def vendor_names
    @vendors.map do |vendor|
      vendor.name
    end
  end

  def vendors_that_sell(item)
    @vendors.find_all do |vendor|
      vendor.check_stock(item) > 0
    end
  end

  def sorted_item_list
    @vendors.map do |vendor|
      vendor.inventory.keys
    end.flatten.uniq.sort
  end

  def total_inventory
    total_inventory = {}
    sorted_item_list.each do |item|
      total_inventory[item] = total_market_quantity(item)
    end
    total_inventory
  end

  def total_market_quantity(item)
    @vendors.sum do |vendor|
      vendor.check_stock(item)
    end
  end

  def sell(item, quantity)
    if total_market_quantity(item) < quantity
      false
    else
      reduce_vendor_quantities(item, quantity)
      true
    end
  end

  def reduce_vendor_quantities(item, quantity)
    needed = quantity

    until needed == 0
      @vendors.each do |vendor|
        if vendor.check_stock(item) > 0 && vendor.check_stock(item) > needed
          vendor.inventory[item] -= needed
          needed = 0
        elsif vendor.check_stock(item) > 0
          needed -= vendor.inventory[item]
          vendor.inventory[item] = 0
        end
      end
    end
  end

end
