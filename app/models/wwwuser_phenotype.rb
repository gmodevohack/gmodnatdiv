class WwwuserPhenotype < ActiveRecord::Base

  belongs_to :wwwuser
  belongs_to :phenotype

  validates_presence_of( :wwwuser_id, :phenotype_id )
  validates_uniqueness_of( :wwwuser_id, :scope => [:phenotype_id], :message => "seems to already be an entry for this wwwuser + phenotype" )

  set_table_name "wwwuser_phenotype"
  set_primary_key "wwwuser_phenotype_id"

end
