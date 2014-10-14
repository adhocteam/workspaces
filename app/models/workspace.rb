class Workspace < ActiveRecord::Base
  belongs_to :user
  has_many :workspace_images
  validates_presence_of :title, :company, :location
end
