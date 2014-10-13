class Workspace < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :title, :company, :location
end
