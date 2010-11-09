class Dbxref < ActiveRecord::Base

  set_table_name "dbxref"
  set_primary_key "dbxref_id"

  # TODO: class_name is correct capitalized?
  belongs_to :db, :class_name => 'Db', :foreign_key => :db_id
  belongs_to :feature, :foreign_key => "feature_id"
  has_and_belongs_to_many :features, :join_table => :feature_dbxref
  has_many :arraydesigns , :foreign_key => :dbxref_id
  has_many :assays , :foreign_key => :dbxref_id
  has_many :biomaterial_dbxrefs , :foreign_key => :dbxref_id
  has_many :biomaterials , :foreign_key => :dbxref_id
  has_many :cell_line_dbxrefs , :foreign_key => :dbxref_id
  has_many :cell_lines 
  has_many :contacts 
  has_many :cvs 
  has_many :cvterm_dbxrefs , :foreign_key => :dbxref_id
  has_many :cvterms 
  has_many :dbxrefprops , :foreign_key => :dbxref_id
  has_many :elements , :foreign_key => :dbxref_id
  has_many :feature_cvterm_dbxrefs , :foreign_key => :dbxref_id
  has_many :feature_cvterms 
  has_many :feature_dbxrefs , :foreign_key => :dbxref_id
  has_many :features 
  has_many :features , :foreign_key => :dbxref_id
  has_many :libraries 
  has_many :library_dbxrefs , :foreign_key => :dbxref_id
  has_many :organism_dbxrefs , :foreign_key => :dbxref_id
  has_many :organisms 
  has_many :phylonode_dbxrefs , :foreign_key => :dbxref_id
  has_many :phylonodes 
  has_many :phylotrees , :foreign_key => :dbxref_id
  has_many :protocols , :foreign_key => :dbxref_id
  has_many :pub_dbxrefs , :foreign_key => :dbxref_id
  has_many :pubs 
  has_many :stock_dbxrefs , :foreign_key => :dbxref_id
  has_many :stocks , :foreign_key => :dbxref_id
  has_many :studies , :foreign_key => :dbxref_id
  has_one :cvterm , :foreign_key => :dbxref_id
  
  validates_presence_of( :db_id, :message => "is blank, dbxref must be associated with a db" )

end
