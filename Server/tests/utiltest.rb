require 'test/unit'
require 'securerandom'
require './lib/util.rb'

class UtilTest < Test::Unit::TestCase
  def test_get_uuid
    uuid1 = Util.get_uuid('PREFIX')
    uuid2 = Util.get_uuid('PREFIX')
    puts "#{uuid1} #{uuid2}"
    assert_not_equal(uuid2,uuid1,'Generated same UUID')
    
  end
end