require 'test/unit'
require 'command'

class TestCommand < Test::Unit::TestCase
  
  def test_create
    Command.create 'test' 
    assert_nothing_thrown do
      assert_kind_of Class, Command::TEST
      assert_equal CommandBase, Command::TEST.superclass
    end
  end

  def test_param
    Command.create 'testparam' do
      param :test1
      
      #should also work with array
      param :test2, :test3
    end

    test_object = Command::TESTPARAM.new 
    assert_respond_to test_object, :test1
    assert_respond_to test_object, :test2
    assert_respond_to test_object, :test3
  end

  def test_default
    Command.create 'testdefault' do
      param :test1 do
        default 'test1'
      end
      
      param :test2, :test3 do
        default 'test2'
      end
    end

    test_object = Command::TESTDEFAULT.new
    assert_equal 'test1', test_object.test1
    assert_equal 'test2', test_object.test2
    assert_equal 'test2', test_object.test3

    test_object.test3='test3'
    assert_equal 'test2', test_object.test2
    assert_equal 'test3', test_object.test3
  end

  def test_comma_separated_array
    Command.create 'testarray' do

      comma_separated_array :array

    end

    test_object = Command::TESTARRAY.new
    assert_equal [], test_object.array

    test_object.array = [1,2,3,4]
    assert_equal "TESTARRAY 1,2,3,4", test_object.to_irc
  end

  def test_parse
    Command.create 'testparse' do
      parse ":param1 [:param2] : :param3"    
      
      # we must specify param2 here or else our order is wrong
      param :param1, :param2, :param3
      comma_separated_array :param2
    end

    test_object = Command::TESTPARSE.new

    test_object.parse_irc_input 'hello 4,2,1,3 :testing last param'
    assert_equal 'hello', test_object.param1
    assert_equal ['4','2','1','3'], test_object.param2
    assert_equal 'testing last param', test_object.param3
    assert_equal 'TESTPARSE hello 4,2,1,3 :testing last param', test_object.to_irc 
  end

end
