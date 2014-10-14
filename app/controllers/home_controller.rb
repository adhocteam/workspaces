class HomeController < ApplicationController
  
  def index
    workspaces_with_images = Workspace.joins(:workspace_images).group("workspaces.id").having("count(workspace_images.id) > 0")
    @workspace = workspaces_with_images.offset(rand(workspaces_with_images.length)).first if workspaces_with_images.length > 0
  end  
end