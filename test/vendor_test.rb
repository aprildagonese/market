require 'minitest/autorun'
require 'minitest/pride'
require './lib/vendor'

class VendorTest < Minitest::Test

  def setup
    @RMF = Vendor.new("Rocky Mountain Fresh")
  end

  def test_it_exists
    assert_instance_of Vendor, @RMF
  end

  def test_it_has_attributes
    assert_equal "Rocky Mountain Fresh", @RMF.name

    expected = {}
    assert_equal expected, @RMF.inventory
  end

  def test_it_checks_stock
    assert_equal 0, @RMF.check_stock("Peaches")
  end

  def test_it_adds_stock
    @RMF.stock("Peaches", 30)
    assert_equal 30, @RMF.check_stock("Peaches")

    @RMF.stock("Peaches", 25)
    assert_equal 55, @RMF.check_stock("Peaches")
  end

  def test_it_accumulates_inventory
    @RMF.stock("Peaches", 30)
    @RMF.stock("Peaches", 25)
    @RMF.stock("Tomatoes", 12)

    expected = { "Peaches"=>55, "Tomatoes"=>12 }
    assert_equal expected, @RMF.inventory
  end

end
