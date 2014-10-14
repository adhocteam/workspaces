class WorkspaceImagesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :assign_workspace
  
  def new
    @workspace_image = @workspace.workspace_images.new
  end
  
  def create
    @workspace_image = @workspace.workspace_images.new(workspace_image_params)
    if @workspace_image.save
      redirect_to @workspace, notice: 'Image added to Workspace'
    else
      flash[:alert] = 'Error adding image to Workspace'
      render :new
    end
  end
  
  def destroy
    workspace_image = @workspace.workspace_images.find(params[:id])
    workspace_image.destroy if workspace_image
    redirect_to @workspace
  end
  
  private
  
  def assign_workspace
    @workspace = current_user.workspaces.find(params[:workspace_id])
  end
  
  def workspace_image_params
    params.require(:workspace_image).permit(:image)
  end
end