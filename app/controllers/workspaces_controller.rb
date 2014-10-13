class WorkspacesController < ApplicationController
  before_filter :authenticate_user!, except: [:show]
  
  def new
    @workspace = Workspace.new
  end
  
  def create
    @workspace = current_user.workspaces.new(workspace_params)
    if @workspace.save
      flash[:notice] = "Workspace created."
      redirect_to @workspace
    else
      flash[:error] = @workspace.errors
      render :new
    end
  end
  
  def show
    @workspace = Workspace.find(params[:id])
  end
  
  def edit
    @workspace = current_user.workspaces.find(params[:id])
  end
  
  def update
    @workspace = current_user.workspaces.find(params[:id])
    if @workspace.update_attributes(workspace_params)
      flash[:notice] = "Workspace updated."
      redirect_to @workspace
    else
      flash[:error] = @workspace.errors
      render :edit
    end
  end
  
  def destroy
    workspace = current_user.workspaces.find(params[:id])
    workspace.destroy
    flash[:notice] = "Workspace removed."
    redirect_to root_path
  end
  
  private
  
  def workspace_params
    params.require(:workspace).permit(:title, :company, :location)
  end
end