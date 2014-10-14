require 'rails_helper'

RSpec.describe "Workspace Images" do
  before do
    @user = create(:user)
    @workspace = create(:workspace, user: @user)
  end
  
  describe "GET /workspaces/:workspace_id/workspace_images/new" do
    context "when the user is not logged in" do
      it "should redirect them" do
        visit new_workspace_workspace_image_path(@workspace)
        expect(page).to have_content 'Workspaces'
        expect(page).to have_content 'You need to sign in or sign up before continuing.'
      end
    end
    
    context "when the user is logged in" do
      before do
        login_as @user, scope: :user
      end
      
      context "when the user is the owner of the workspace" do
        it "should allow the user to add images to the workspace" do
          visit new_workspace_workspace_image_path(@workspace)
          expect(page).to have_content 'Add an image of your Workspace'
          attach_file 'Image', Rails.root.to_s + "/spec/files/images/ostp.jpg"
          click_button 'Upload Workspace Image'
          expect(page).to have_content "Workspace: #{@workspace.title}"
          expect(page).to have_xpath("//img[@alt='Ostp']")
          expect(page).to have_link 'Delete Image', href: workspace_workspace_image_path(@workspace, @workspace.workspace_images.first)
          click_link 'Delete Image'
          expect(page).to have_no_xpath("//image[@alt='Ostp']")
          expect(page).to have_no_link 'Delete Image'
        end
      end
      
      context "when the user is not the owner of the workspace" do
        before do
          @other_user = create(:user, uid: '456', screen_name: 'OtherUser')
          @other_workspace = create(:workspace, user: @other_user)
        end
        
        it "should not let the user upload an image" do
          visit new_workspace_workspace_image_path(@other_workspace)
          expect(page).to have_content 'Record not found, or you do not have access to that record.'
        end
      end
    end
  end
end