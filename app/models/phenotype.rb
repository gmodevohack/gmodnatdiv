class Phenotype < ActiveRecord::Base

  belongs_to :assay,      :class_name => 'Assay', :foreign_key => :assay_id
  belongs_to :attr,       :class_name => "Cvterm", :foreign_key => :attr_id
  belongs_to :cvalue,     :class_name => "Cvterm", :foreign_key => :cvalue_id
  belongs_to :observable, :class_name => "Cvterm", :foreign_key => :observable_id
 
  has_many :phenotype_cvterms, :foreign_key => :phenotype_id
  has_many :cvterms, :through => :phenotype_cvterms, :order => 'phenotype_cvterm.rank'
  has_many :environments 
  has_many :feature_phenotypes, :foreign_key => :phenotype_id
  has_many :features 
  has_many :genotypes 
  has_many :phenstatements, :foreign_key => :phenotype_id
  has_many :pubs # has_many :nd_assay_phenotypes # TODO: doesn't exist in current schema?

  named_scope :ordered_by_number_of_cvterms, :joins => :phenotype_cvterms, :select => "phenotype.*, COUNT(phenotype_cvterm.cvterm_id) as cvterm_count", :group => Phenotype.column_names.collect{|column_name| "phenotype.#{column_name}"}.join(","), :order => "cvterm_count DESC"

  named_scope :limit, :limit => 100

  validates_uniqueness_of :uniquename 

end
