require 'test/unit'
require './lib/service/Account.rb'

class AccountTest < Test::Unit::TestCase
  def test_register
    aaa = Service::Account.new()
    aaa.check()
  end
end