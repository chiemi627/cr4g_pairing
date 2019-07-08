require 'test_helper'

class PairingsControllerTest < ActionDispatch::IntegrationTest
  test "root_pathが表示できる" do
    get pairings_pair_url
    assert_response :success
    assert_select "title","Pairing for Coderetreat"
  end


end
