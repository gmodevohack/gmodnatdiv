class ProjectRelationship < ActiveRecord::Base
  belongs_to :cvterm, :foreign_key => 'type_id'
  belongs_to :parent, :class_name => "Project"
  belongs_to :child, :class_name => "Project"
  
  validates_presence_of :subject_project_id, :object_project_id, :type_id
end
