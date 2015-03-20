require 'test/unit'
require_relative '../../models/connection'

class MyTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    @current_state = [
        {:id=>1, :room_name=>"lab1", :connected=>true, :ip_range=>"192.168.11.0/24", :down_time=>nil, :up_time=>nil},
        {:id=>2, :room_name=>"lab2", :connected=>false, :ip_range=>"192.168.12.0/24", :down_time=>"23/03/2015 08:38:00", :up_time=>"24/03/2015 09:38:00"}]
    Connection.sync @current_state
    @hash = [
        {:id=>1, :room_name=>"lab1", :connected=>false, :ip_range=>"192.168.11.0/24", :down_time=>"19/03/2015 11:38:40", :up_time=>"19/03/2015 16:38:40"},
        {:id=>2, :room_name=>"lab2", :connected=>false, :ip_range=>"192.168.12.0/24", :down_time=>"20/03/2015 13:20:20", :up_time=>"20/03/2015 14:20:20"}]
  end

  def test_sync

    lab1 = Connection.first(room_name: "lab1")
    assert_equal(lab1.down_time, nil)
    assert_equal(lab1.up_time, nil)
    assert_true(lab1.connected)
    assert_equal(lab1.ip_range, "192.168.11.0/24")

    lab2 = Connection.first(room_name: "lab2")
    assert_equal(lab2.down_time.strftime("%d/%m/%y %H:%M:%S"),"23/03/15 08:38:00")
    assert_equal(lab2.up_time.strftime("%d/%m/%y %H:%M:%S"),"24/03/15 09:38:00")
    assert_false(lab2.connected)
    assert_equal(lab2.ip_range, "192.168.12.0/24")


    assert_nothing_raised do
      Connection.sync @hash
    end

    lab1 = Connection.first(room_name: "lab1")
    assert_equal(lab1.down_time.strftime("%d/%m/%y %H:%M:%S"),"19/03/15 11:38:40")
    assert_equal(lab1.up_time.strftime("%d/%m/%y %H:%M:%S"),"19/03/15 16:38:40")
    assert_false(lab1.connected)
    assert_equal(lab1.ip_range, "192.168.11.0/24")

    lab2 = Connection.first(room_name: "lab2")
    assert_equal(lab2.down_time.strftime("%d/%m/%y %H:%M:%S"),"20/03/15 13:20:20")
    assert_equal(lab2.up_time.strftime("%d/%m/%y %H:%M:%S"),"20/03/15 14:20:20")
    assert_false(lab2.connected)
    assert_equal(lab2.ip_range, "192.168.12.0/24")

  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.
  #
  def teardown
    Connection.sync @current_state
  end

  # Fake test
  # def test_fail
  #
  #   fail('Not implemented')
  # end
end