class WwwuserGenotype < ActiveRecord::Base

  belongs_to :wwwuser
  belongs_to :genotype

  validates_presence_of( :wwwuser_id, :genotype_id )
  validates_uniqueness_of( :wwwuser_id, :scope => [:genotype_id], :message => "seems to already be an entry for this wwwuser + genotype" )

  set_table_name "wwwuser_genotype"
  set_primary_key "wwwuser_genotype_id"

end
