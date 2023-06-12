require "test_helper"

class AgenciesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @agency = agencies(:one)
  end

  test "should get index" do
    get agencies_url, as: :json
    assert_response :success
  end

  test "should create agency" do
    assert_difference("Agency.count") do
      post agencies_url, params: { agency: { name: @agency.name, region_id: @agency.region_id } }, as: :json
    end

    assert_response :created
  end

  test "should show agency" do
    get agency_url(@agency), as: :json
    assert_response :success
  end

  test "should update agency" do
    patch agency_url(@agency), params: { agency: { name: @agency.name, region_id: @agency.region_id } }, as: :json
    assert_response :success
  end

  test "should destroy agency" do
    assert_difference("Agency.count", -1) do
      delete agency_url(@agency), as: :json
    end

    assert_response :no_content
  end
end
