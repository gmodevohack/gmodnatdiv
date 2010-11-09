class Feature < ActiveRecord::Base
  
  set_table_name "feature"
  set_primary_key "feature_id"
  
  belongs_to :cvterm, :foreign_key => "type_id"
  belongs_to :dbxref, :class_name => 'Dbxref', :foreign_key => :dbxref_id
  belongs_to :organism, :class_name => 'Organism', :foreign_key => :organism_id
  has_and_belongs_to_many :dbxrefs, :join_table => :feature_dbxref
  has_and_belongs_to_many :features, :class_name => "Feature", :join_table => "feature_relationship", :foreign_key => "object_id", :association_foreign_key => "subject_id"
  has_and_belongs_to_many :synonyms, :join_table => :feature_synonym
  has_many :analysisfeatures , :foreign_key => :feature_id
  has_many :arraydesigns 
  has_many :cell_line_features , :foreign_key => :feature_id
  has_many :cell_lines 
  has_many :cvterms 
  has_many :dbxrefs 
  has_many :elements , :foreign_key => :feature_id
  has_many :expressions 
  has_many :feature_cvterms , :foreign_key => :feature_id
  has_many :feature_dbxrefs , :foreign_key => :feature_id
  has_many :feature_expressions , :foreign_key => :feature_id
  has_many :feature_genotypes , :foreign_key => :feature_id
  has_many :feature_phenotypes , :foreign_key => :feature_id
  has_many :feature_pubs , :foreign_key => :feature_id
  has_many :feature_synonyms , :foreign_key => :feature_id
  has_many :featurelocs , :foreign_key => :feature_id # has_many because a feature should be able to have many locations, not just one
  has_many :featuremaps 
  has_many :featurepos , :foreign_key => :feature_id
  has_many :featureprops , :foreign_key => :feature_id
  has_many :featureranges , :foreign_key => :feature_id
  has_many :genotypes 
  has_many :libraries 
  has_many :library_features , :foreign_key => :feature_id
  has_many :nd_reagents
  has_many :phenotypes 
  has_many :phylonodes , :foreign_key => :feature_id
  has_many :pubs 
  has_many :studyprop_features , :foreign_key => :feature_id
  has_many :studyprops 
  has_many :synonyms 
  has_many :wwwuser_features

  # TODO: abstract out
  after_save :update_timelastmodified

  validates_presence_of( :uniquename, :organism_id, :type_id )
  validates_uniqueness_of( :uniquename )
  
  def update_timelastmodified
    self.timelastmodified = Time.now
  end 

  def update_timeaccessioned
    self.time_timeaccessioned = Time.now
  end 

end
