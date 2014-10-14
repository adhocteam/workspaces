require 'rails_helper'

RSpec.describe "Home page" do
  describe "GET /" do
    context "when the user is not logged in" do
      it "should show the home page with a link to log in with Twitter" do
        visit root_path
        expect(page).to have_content 'Workspaces'
        expect(page).to have_link 'Sign in with Twitter', href: user_omniauth_authorize_path("twitter")
      end
      
      context "when there are workspaces" do
        before do
          @workspace = create(:workspace, user: create(:user))
        end
        
        context "but they don't have images" do
          it "should not show anything on the home page" do
            visit root_path
            expect(page).to have_no_content @workspace.title
            expect(page).to have_no_content @workspace.company
            expect(page).to have_no_content @workspace.location
            expect(page).to have_no_content "by #{@workspace.user.screen_name}"
          end
        end
        
        context "when they do have images" do
          before do
            @workspace.workspace_images << build(:workspace_image)
          end
          
          it "should show a random workspace on the home page" do
            visit root_path
            expect(page).to have_content @workspace.title
            expect(page).to have_content @workspace.company
            expect(page).to have_content @workspace.location
            expect(page).to have_content "by #{@workspace.user.screen_name}"
          end
        end
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