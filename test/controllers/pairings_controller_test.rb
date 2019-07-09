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

  test "jpgファイルを読み込むとエラーメッセージが出る" do
    post pairings_pair_url, params: {file: fixture_file_upload('files/sample.jpg','image/jpg')}
    assert_response :success
    assert_match "CSVファイルを読み込んでください", flash[:danger]
  end

  test "拡張子がcsvなjpgファイルを読み込むとエラーメッセージが出る" do
    post pairings_pair_url, params: {file: fixture_file_upload('files/sample-jpg.csv','text/csv')}
    assert_response :success
    assert_match "データを正しく読み込めませんでした", flash[:danger]
  end

  test "出席者(id=3)はpairingリストの中に入る" do
    post pairings_pair_url, params: {file: fixture_file_upload('files/sample.csv','text/csv')}
    assert_select "table > tr > td#3",1  
  end

  test "欠席者(id=4)はpairingリストの中に入らない" do
    post pairings_pair_url, params: {file: fixture_file_upload('files/sample.csv','text/csv')}
    assert_select "table > tr > td#4", false
  end

  test "id=2とid=3はメンター同士なのでpairingされない" do
    10.times {
      post pairings_pair_url, params: {file: fixture_file_upload('files/sample.csv','text/csv')}
      assert_select "td#2 + td#3", false  
    }
  end


end
