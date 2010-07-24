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

end
