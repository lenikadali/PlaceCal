require 'test_helper'

class AdminControllerTest < ActionDispatch::IntegrationTest
  setup do
    @root = create(:root)
    @turf_admin = create(:turf_admin)
    @partner_admin = create(:partner_admin)
    @citizen = create(:user)
    host! 'admin.lvh.me'
  end

  # Anyone logged in sees the admin index page with contextual data
  it_allows_access_to_index_for(%i[root turf_admin partner_admin citizen]) do
    get admin_root_url
    assert_response :success
  end

  # If not logged in, redirect to a login page
  test 'redirect if guest' do
    get admin_root_url
    assert_redirected_to new_user_session_url
  end
end