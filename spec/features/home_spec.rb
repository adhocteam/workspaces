require 'rails_helper'

RSpec.describe "Home page" do
  describe "GET /" do
    context "when the user is not logged in" do
      it "should show the home page with a link to log in with Twitter" do
        visit root_path
        expect(page).to have_content 'Workspaces'
        expect(page).to have_link 'Sign in with Twitter', href: user_omniauth_authorize_path("twitter")
      end
    end
    
    context "when the user is logged in" do
      before do
        login_as(create(:user), scope: :user)
      end
      
      it "should greet the user and provide links to create new workspaces and logout" do
        visit root_path
        expect(page).to have_content 'Workspaces'
        expect(page).to have_content 'Hello, joeworker'
        expect(page).to have_link 'Sign out', href: destroy_user_session_path
        expect(page).to have_link 'New Workspace', href: new_workspace_path
      end
    end
  end
end