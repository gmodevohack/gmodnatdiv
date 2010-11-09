class Cvterm < ActiveRecord::Base

  belongs_to :cv, :class_name => 'Cv', :foreign_key => :cv_id
  belongs_to :dbxref, :class_name => 'Dbxref', :foreign_key => :dbxref_id
  has_many :assays, :class_name => "Phenotype", :foreign_key => "assay_id"
  has_many :attrs, :class_name => "Phenotype", :foreign_key => "attr_id"
  has_many :cell_line_cvterms , :foreign_key => :cvterm_id
  has_many :cvalues, :class_name => "Phenotype", :foreign_key => "cvalue_id"
  has_many :cvterm_dbxrefs , :foreign_key => :cvterm_id
  has_many :cvtermprops , :foreign_key => :cvterm_id
  has_many :cvtermsynonyms , :foreign_key => :cvterm_id
  has_many :dbxrefs 
  has_many :environment_cvterms , :foreign_key => :cvterm_id
  has_many :environments 
  has_many :expression_cvterms , :foreign_key => :cvterm_id
  has_many :expressions 
  has_many :feature_cvterms , :foreign_key => :cvterm_id
  has_many :feature_genotypes , :foreign_key => :cvterm_id
  has_many :features 
  has_many :genotypes 
  has_many :libraries 
  has_many :library_cvterms , :foreign_key => :cvterm_id
  has_many :observables, :class_name => "Phenotype", :foreign_key => "observable_id"
  has_many :phenotype_comparison_cvterms , :foreign_key => :cvterm_id
  has_many :phenotype_comparisons 
  has_many :phenotype_cvterms , :foreign_key => :cvterm_id
  has_many :phenotypes 
  has_many :pubs 
  has_many :stock_cvterms , :foreign_key => :cvterm_id
  has_many :stocks
  has_and_belongs_to_many :cvterms, :class_name => "Cvterm", :join_table => "cvterm_relationship", :foreign_key => "object_id", :association_foreign_key => "subject_id"
  has_and_belongs_to_many :cvtermpaths, :class_name => "Cvterm", :join_table => "cvtermpath", :foreign_key => "object_id", :association_foreign_key => "subject_id"

  set_table_name "cvterm" # habtm requires set_table_name to be underneath habtm declaration
  set_primary_key "cvterm_id"

end
