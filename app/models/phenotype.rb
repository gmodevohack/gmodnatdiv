class Phenotype < ActiveRecord::Base

  belongs_to :assay, :class_name => 'Assay', :foreign_key => :assay_id
  belongs_to :assay_id,     :class_name => "Cvterm", :foreign_key => "assay_id"
  belongs_to :attr_id,       :class_name => "Cvterm", :foreign_key => "attr_id"
  belongs_to :cvalue_id,     :class_name => "Cvterm", :foreign_key => "cvalue_id"
  belongs_to :observable, :class_name => 'Observable', :foreign_key => :observable_id
  belongs_to :observable_id, :class_name => "Cvterm", :foreign_key => "observable_id"
  has_many :cvterms 
  has_many :environments 
  has_many :feature_phenotypes , :foreign_key => :phenotype_id
  has_many :features 
  has_many :genotypes 
  has_many :phenotype_cvterms , :foreign_key => :phenotype_id
  has_many :phenstatements , :foreign_key => :phenotype_id
  has_many :pubs 
  has_many :nd_assay_phenotypes

end
