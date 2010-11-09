class Project < ActiveRecord::Base
  has_many :nd_assay_projects
  has_many :projectprops

  validates_presence_of( :name, :description )
end
