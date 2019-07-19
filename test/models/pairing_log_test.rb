require 'test_helper'

class PairingLogTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  # 同じイベントのセッションリストが出力できる
  # test イベントcr４gのセッションリストを求めるとs1とs2が返る

  test "イベントcr4gのセッションリストを求めるとs1とs2が返る" do
    sessions = PairingLog.where(event: "cr4g").pluck('name')
    assert_includes(sessions,"s1") 
    assert_includes(sessions,"s2") 
  end
end
