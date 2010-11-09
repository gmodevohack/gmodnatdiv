class WwwuserProject < ActiveRecord::Base

  belongs_to :wwwuser
  belongs_to :project

  validates_presence_of( :wwwuser_id, :project_id )
  validates_uniqueness_of( :wwwuser_id, :scope => [:project_id], :message => "seems to already be an entry for this wwwuser + project" )

  set_table_name :wwwuser_project
  set_primary_key :wwwuser_project_id

end
