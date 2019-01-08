require 'minitest/autorun'
require 'minitest/pride'
require './lib/market'
require './lib/vendor'

class MarketTest < Minitest::Test

  def setup
    @SPSFM = Market.new("South Pearl Street Farmers Market")
    @vendor_1 = Vendor.new("Rocky Mountain Fresh")
    @vendor_2 = Vendor.new("Ba-Nom-a-Nom")
    @vendor_3 = Vendor.new("Palisade Peach Shack")
  end

  def test_it_exists
    assert_instance_of Market, @SPSFM
  end

  def test_it_has_attributes
    assert_equal "South Pearl Street Farmers Market", @SPSFM.name
    assert_equal [], @SPSFM.vendors
  end

  def test_it_adds_vendors
    @SPSFM.add_vendor(@vendor_1)
    @SPSFM.add_vendor(@vendor_2)
    @SPSFM.add_vendor(@vendor_3)

    assert_equal [@vendor_1, @vendor_2, @vendor_3], @SPSFM.vendors
  end

  def test_it_knows_vendor_names
    @SPSFM.add_vendor(@vendor_1)
    @SPSFM.add_vendor(@vendor_2)
    @SPSFM.add_vendor(@vendor_3)

    expected = ["Rocky Mountain Fresh", "Ba-Nom-a-Nom", "Palisade Peach Shack"]
    assert_equal expected, @SPSFM.vendor_names
  end

  def test_it_knows_vendors_that_sell
    @SPSFM.add_vendor(@vendor_1)
    @SPSFM.add_vendor(@vendor_2)
    @SPSFM.add_vendor(@vendor_3)
    @vendor_1.stock("Peaches", 35)
    @vendor_1.stock("Tomatoes", 7)
    @vendor_2.stock("Banana Nice Cream", 50)
    @vendor_2.stock("Peach-Raspberry Nice Cream", 25)
    @vendor_3.stock("Peaches", 65)

    assert_equal [@vendor_1, @vendor_3], @SPSFM.vendors_that_sell("Peaches")
    assert_equal [@vendor_2], @SPSFM.vendors_that_sell("Banana Nice Cream")
  end

  def test_it_sorts_items
    @SPSFM.add_vendor(@vendor_1)
    @SPSFM.add_vendor(@vendor_2)
    @SPSFM.add_vendor(@vendor_3)
    @vendor_1.stock("Peaches", 35)
    @vendor_1.stock("Tomatoes", 7)
    @vendor_2.stock("Banana Nice Cream", 50)
    @vendor_2.stock("Peach-Raspberry Nice Cream", 25)
    @vendor_3.stock("Peaches", 65)

    expected = ["Banana Nice Cream", "Peach-Raspberry Nice Cream", "Peaches", "Tomatoes"]

    assert_equal expected, @SPSFM.sorted_item_list
  end

  def test_it_checks_total_market_quantity_of_an_item
    @SPSFM.add_vendor(@vendor_1)
    @SPSFM.add_vendor(@vendor_2)
    @SPSFM.add_vendor(@vendor_3)
    @vendor_1.stock("Peaches", 35)
    @vendor_1.stock("Tomatoes", 7)
    @vendor_2.stock("Banana Nice Cream", 50)
    @vendor_2.stock("Peach-Raspberry Nice Cream", 25)
    @vendor_3.stock("Peaches", 65)

    assert_equal 100, @SPSFM.total_market_quantity("Peaches")
    assert_equal 50, @SPSFM.total_market_quantity("Banana Nice Cream")
  end

  def test_it_knows_total_inventory
    @SPSFM.add_vendor(@vendor_1)
    @SPSFM.add_vendor(@vendor_2)
    @SPSFM.add_vendor(@vendor_3)
    @vendor_1.stock("Peaches", 35)
    @vendor_1.stock("Tomatoes", 7)
    @vendor_2.stock("Banana Nice Cream", 50)
    @vendor_2.stock("Peach-Raspberry Nice Cream", 25)
    @vendor_3.stock("Peaches", 65)

    expected = { "Peaches"=>100,
                 "Tomatoes"=>7,
                 "Banana Nice Cream"=>50,
                 "Peach-Raspberry Nice Cream"=>25 }

    assert_equal expected, @SPSFM.total_inventory
  end

  def test_it_knows_it_can_sell
    @SPSFM.add_vendor(@vendor_1)
    @SPSFM.add_vendor(@vendor_2)
    @SPSFM.add_vendor(@vendor_3)
    @vendor_1.stock("Peaches", 35)
    @vendor_1.stock("Tomatoes", 7)
    @vendor_2.stock("Banana Nice Cream", 50)
    @vendor_2.stock("Peach-Raspberry Nice Cream", 25)
    @vendor_3.stock("Peaches", 65)

    assert_equal false, @SPSFM.sell("Peaches", 200)
    assert_equal false, @SPSFM.sell("Onions", 1)
    assert_equal true, @SPSFM.sell("Banana Nice Cream", 5)
    assert_equal true, @SPSFM.sell("Peaches", 40)
  end

  def test_it_reduces_vendor_quantities
    @SPSFM.add_vendor(@vendor_1)
    @SPSFM.add_vendor(@vendor_2)
    @SPSFM.add_vendor(@vendor_3)
    @vendor_1.stock("Peaches", 35)
    @vendor_1.stock("Tomatoes", 7)
    @vendor_2.stock("Banana Nice Cream", 50)
    @vendor_2.stock("Peach-Raspberry Nice Cream", 25)
    @vendor_3.stock("Peaches", 65)

    @SPSFM.sell("Banana Nice Cream", 5)
    assert_equal 45, @vendor_2.check_stock("Banana Nice Cream")

    @SPSFM.sell("Peaches", 40)
    assert_equal 0, @vendor_1.check_stock("Peaches")
    assert_equal 60, @vendor_3.check_stock("Peaches")
  end

end
