require 'test_helper'

class PairingLogTest < ActiveSupport::TestCase

  test "イベントcr4gのセッションリストを求めるとs1とs2が返る" do
    sessions = PairingLog.where(event: "cr4g").pluck('name')
    assert_includes(sessions,"s1") 
    assert_includes(sessions,"s2") 
  end

  # s1: [1,3],[2,4]でs2: [1,4],[2,3]だとすると
  test "イベントcr4gで1がペアを組んだのは3と4" do
    log = PairingLog.new
    partners = log.past_partners("cr4g",1)
    assert_includes(partners,3)
    assert_includes(partners,4)
  end

end
