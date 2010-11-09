class Organism < ActiveRecord::Base

  has_many :cell_lines , :foreign_key => :organism_id
  has_many :features , :foreign_key => :organism_id
  has_many :dbxrefs 
  has_many :libraries , :foreign_key => :organism_id
  has_many :organism_dbxrefs , :foreign_key => :organism_id
  has_many :dbxrefs 
  has_many :organismprops , :foreign_key => :organism_id
  has_many :phenotype_comparisons , :foreign_key => :organism_id
  has_many :pubs 
  has_many :phylonode_organisms , :foreign_key => :organism_id
  has_many :phylonodes 
  has_many :stocks , :foreign_key => :organism_id
  has_many :dbxrefs 
  has_many :features

  validates_presence_of( :genus, :species )
  validates_uniqueness_of( :genus, :scope => [:species], :message => "seems to already be an entry for this genus + species" )

  set_table_name "organism"
  set_primary_key "organism_id"

end
