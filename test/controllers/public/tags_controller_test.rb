require 'test_helper'

class Public::TagsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get public_tags_new_url
    assert_response :success
  end

  test "should get show" do
    get public_tags_show_url
    assert_response :success
  end

  test "should get edit" do
    get public_tags_edit_url
    assert_response :success
  end

end
