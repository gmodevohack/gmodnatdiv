class Pub < ActiveRecord::Base
 
  set_table_name :pub
  set_primary_key :pub_id

  has_many :cell_line_cvterms , :foreign_key => :pub_id
  has_many :cell_line_features , :foreign_key => :pub_id
  has_many :cell_line_libraries , :foreign_key => :pub_id
  has_many :cell_line_pubs , :foreign_key => :pub_id
  has_many :cell_line_synonyms , :foreign_key => :pub_id
  has_many :cell_lineprop_pubs , :foreign_key => :pub_id
  has_many :cell_lineprops 
  has_many :cell_lines 
  has_many :contacts 
  has_many :cvterms 
  has_many :dbxrefs 
  has_many :environments 
  has_many :expression_pubs , :foreign_key => :pub_id
  has_many :expressions 
  has_many :feature_cvterm_pubs , :foreign_key => :pub_id
  has_many :feature_cvterms , :foreign_key => :pub_id
  has_many :feature_expressions , :foreign_key => :pub_id
  has_many :feature_pubs , :foreign_key => :pub_id
  has_many :feature_relationship_pubs , :foreign_key => :pub_id
  has_many :feature_relationshipprop_pubs , :foreign_key => :pub_id
  has_many :feature_relationshipprops 
  has_many :feature_relationships 
  has_many :feature_synonyms , :foreign_key => :pub_id
  has_many :featureloc_pubs , :foreign_key => :pub_id
  has_many :featurelocs 
  has_many :featuremap_pubs , :foreign_key => :pub_id
  has_many :featuremaps 
  has_many :featureprop_pubs , :foreign_key => :pub_id
  has_many :featureprops 
  has_many :features 
  has_many :genotypes 
  has_many :libraries 
  has_many :library_cvterms , :foreign_key => :pub_id
  has_many :library_pubs , :foreign_key => :pub_id
  has_many :library_synonyms , :foreign_key => :pub_id
  has_many :libraryprop_pubs , :foreign_key => :pub_id
  has_many :libraryprops 
  has_many :organisms 
  has_many :phendescs , :foreign_key => :pub_id
  has_many :phenotype_comparison_cvterms , :foreign_key => :pub_id
  has_many :phenotype_comparisons , :foreign_key => :pub_id
  has_many :phenotypes 
  has_many :phenstatements , :foreign_key => :pub_id
  has_many :phylonode_pubs , :foreign_key => :pub_id
  has_many :phylonodes 
  has_many :phylotree_pubs , :foreign_key => :pub_id
  has_many :phylotrees 
  has_many :protocols , :foreign_key => :pub_id
  has_many :pub_dbxrefs , :foreign_key => :pub_id
  has_many :pubauthors , :foreign_key => :pub_id
  has_many :pubprops , :foreign_key => :pub_id
  has_many :stock_cvterms , :foreign_key => :pub_id
  has_many :stock_pubs , :foreign_key => :pub_id
  has_many :stock_relationship_pubs , :foreign_key => :pub_id
  has_many :stock_relationships 
  has_many :stockprop_pubs , :foreign_key => :pub_id
  has_many :stockprops 
  has_many :stocks 
  has_many :studies , :foreign_key => :pub_id
  has_many :synonyms 
  has_many :wwwuser_pubs
  
  validates_length_of :volume, :allow_nil => true, :maximum => 255
  validates_length_of :series_name, :allow_nil => true, :maximum => 255
  validates_length_of :issue, :allow_nil => true, :maximum => 255
  validates_length_of :pyear, :allow_nil => true, :maximum => 255
  validates_length_of :pages, :allow_nil => true, :maximum => 255
  validates_length_of :miniref, :allow_nil => true, :maximum => 255
  validates_presence_of :uniquename
  validates_inclusion_of :is_obsolete, :in => [true, false], :allow_nil => true, :message => ActiveRecord::Errors.default_error_messages[:blank]
  validates_length_of :publisher, :allow_nil => true, :maximum => 255
  validates_length_of :pubplace, :allow_nil => true, :maximum => 255

  
end
