# frozen_string_literal: true

require 'test_helper'

class AdminHomeIntegrationTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @admin = create(:root)
  end

  test "Admin home page can't be accessed without a login" do
    @default_site = create_default_site
    get "http://admin.lvh.me"
    assert_redirected_to "http://lvh.me/users/sign_in"
    sign_in @admin
    get "http://admin.lvh.me"
    assert_response :success
    assert_select 'h2', text: "Welcome back, #{@admin.full_name}"
  end
end