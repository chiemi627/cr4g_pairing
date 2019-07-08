require 'test_helper'

class PairingsControllerTest < ActionDispatch::IntegrationTest
  test "root_pathが表示できる" do
    get pairings_pair_url
    assert_response :success
    assert_select "title","Pairing for Coderetreat"
  end

  test "CSVファイルがアップロードできる" do
    post pairings_pair_url, params: {file: fixture_file_upload('files/sample.csv','text/csv')}
    assert_response :success
    assert_select "table > tr", :count => 2
    assert_select "table > tr > td", :count=>5

  end

end
