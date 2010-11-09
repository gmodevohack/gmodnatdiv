class WwwuserOrganism < ActiveRecord::Base

  belongs_to :wwwuser
  belongs_to :organism

  validates_presence_of( :wwwuser_id, :organism_id )
  validates_uniqueness_of( :wwwuser_id, :scope => [:organism_id], :message => "seems to already be an entry for this wwwuser + organism" )

  set_table_name "wwwuser_organism"
  set_primary_key "wwwuser_organism_id"

end
