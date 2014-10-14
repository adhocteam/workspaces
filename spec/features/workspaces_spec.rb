require 'rails_helper'

RSpec.describe "Workspaces" do
  describe "GET /workspaces/new" do
    context "when the user is not logged in" do
      it "should redirect the user to the home page" do
        visit new_workspace_path
        expect(page).to have_content 'Workspaces'
        expect(page).to have_content 'You need to sign in or sign up before continuing.'
      end
    end
    
    context "when the user is already logged in" do
      before do
        login_as create(:user), scope: :user
      end
      
      context "when the user provides all the required information" do
        it "should allow them to create a new workspace" do
          visit new_workspace_path
          fill_in 'Title', with: 'My workspace'
          fill_in 'Company', with: 'Acme, Inc.'
          fill_in 'Location', with: 'Anytown, USA'
          click_button 'Create Workspace'
          expect(page).to have_content 'Workspace created.'
          expect(page).to have_content 'Workspace: My workspace'
          expect(page).to have_content 'Company: Acme, Inc.'
          expect(page).to have_content 'Location: Anytown, USA'
        end
      end
      
      context "when the user does not provide all the required information" do
        it "should display an error message" do
          visit new_workspace_path
          click_button 'Create Workspace'
          expect(page).to have_content 'Title can\'t be blank'
          expect(page).to have_content 'Company can\'t be blank'
          expect(page).to have_content 'Location can\'t be blank'
        end
      end
    end
  end
  
  describe "GET /workspaces/:id" do
    before do
      @user = create(:user)
      @workspace = create(:workspace, user: @user)
    end
    
    context "when the user is not logged in" do
      it "should show the workspace page, without management options" do
        visit workspace_path(@workspace)
        expect(page).to have_content "Workspace: #{@workspace.title}"
        expect(page).to have_content "Company: #{@workspace.company}"
        expect(page).to have_content "Location: #{@workspace.location}"
        expect(page).to have_no_link 'Edit Workspace', href: edit_workspace_path(@workspace)
        expect(page).to have_no_link 'Delete Workspace', href: workspace_path(@workspace)
        expect(page).to have_no_link 'Add new Image to Workspace', href: new_workspace_workspace_image_path(@workspace)
      end
    end
    
    context "when the user is logged in, and owns the workspace" do
      before do
        login_as @user, scope: :user
      end
      
      it "should show the workspace with management options" do
        visit workspace_path(@workspace)
        expect(page).to have_content "Workspace: #{@workspace.title}"
        expect(page).to have_content "Company: #{@workspace.company}"
        expect(page).to have_content "Location: #{@workspace.location}"
        expect(page).to have_link 'Edit Workspace', href: edit_workspace_path(@workspace)
        expect(page).to have_link 'Delete Workspace', href: workspace_path(@workspace)
        expect(page).to have_link 'Add new Image to Workspace', href: new_workspace_workspace_image_path(@workspace)
      end
      
      context "when the workspace has images" do
        before do
          @workspace.workspace_images.create(image_file_name: 'ostp.jpg', image_content_type: 'image/jpg', image_file_size: 68500)
        end
        
        it "should show image management options" do
          visit workspace_path(@workspace)
          expect(page).to have_link 'Delete Image', href: workspace_workspace_image_path(@workspace, @workspace.workspace_images.first)
        end
      end
    end
    
    context "when the user is logged in, but is not the owner of the workspace" do
      before do
        login_as create(:user, uid: '456', screen_name: 'janeworker')
      end
      
      it "should show the workspace, but without management options" do
        visit workspace_path(@workspace)
        expect(page).to have_content "Workspace: #{@workspace.title}"
        expect(page).to have_content "Company: #{@workspace.company}"
        expect(page).to have_content "Location: #{@workspace.location}"
        expect(page).to have_no_link 'Edit Workspace', href: edit_workspace_path(@workspace)
        expect(page).to have_no_link 'Delete Workspace', href: workspace_path(@workspace)
        expect(page).to have_no_link 'Add new Image to Workspace', href: new_workspace_workspace_image_path(@workspace)
      end
    end
  end
  
  describe 'GET /workspaces/:id/edit' do
    before do
      @user = create(:user)
      @workspace = create(:workspace, user: @user)
    end
    
    context "when the user is not logged in" do
      it "should redirect the user" do
        visit edit_workspace_path(@workspace)
        expect(page).to have_content 'You need to sign in or sign up before continuing.'
      end
    end
    
    context "when the user is logged in and owns the workspace" do
      before do
        login_as @user, scope: :user
      end
      
      it "should allow the user to edit the workspace" do
        visit edit_workspace_path(@workspace)
        expect(page).to have_field 'Title', with: @workspace.title
        expect(page).to have_field 'Company', with: @workspace.company
        expect(page).to have_field 'Location', with: @workspace.location
        fill_in 'Title', with: 'My old workspace'
        fill_in 'Location', with: 'Othertown, USA'
        click_button 'Update Workspace'
        expect(page).to have_content 'Workspace: My old workspace'
        expect(page).to have_content "Company: #{@workspace.company}"
        expect(page).to have_content 'Location: Othertown, USA'
      end
    end
    
    context "when the user is logged in but does not own the workspace" do
      before do
        login_as create(:user, uid: '456', screen_name: 'janeworker')
      end
      
      it "should not allow the user to edit the workspace" do
        visit edit_workspace_path(@workspace)
        expect(page).to have_content 'Record not found, or you do not have access to that record.'
      end
    end
  end
  
  describe "DELETE /workspaces/:id" do
    before do
      @user = create(:user)
      @workspace = create(:workspace, user: @user)
      login_as @user, scope: :user
    end
    
    it "should destroy the workspace" do
      visit workspace_path(@workspace)
      click_link 'Delete Workspace'
      expect(page).to have_content 'Workspace removed.'
      expect(page).to have_link 'New Workspace', href: new_workspace_path
      visit workspace_path(@workspace)
      expect(page).to have_content 'Record not found, or you do not have access to that record.'
    end
  end
end