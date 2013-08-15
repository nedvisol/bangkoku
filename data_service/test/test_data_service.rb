require 'test/unit'
require 'data_service'

class DataServiceTest < Test::Unit::TestCase
  def test_hello
    ds = DataService.new
    ds.hello
  end
end