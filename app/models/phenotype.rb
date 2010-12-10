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


  named_scope :with_observable, lambda {|*args| {:joins => "JOIN cvterm ON observable_id = cvterm.cvterm_id", :conditions => ["cvterm.name = ?", args[0]]}}

  named_scope :with_observable_like, lambda {|*args| {:joins => "JOIN cvterm ON observable_id = cvterm.cvterm_id", :conditions => ["cvterm.name like ?", args[0]]}}

  named_scope :with_cvalue, lambda {|*args| {:joins => "JOIN cvterm ON cvalue_id = cvterm.cvterm_id", :conditions => ["cvterm.name = ?", args[0]]}}

  named_scope :with_project_id, lambda {|*args| {:joins => "JOIN nd_experiment_phenotype USING (phenotype_id) JOIN nd_experiment_project USING (nd_experiment_id) JOIN project USING (project_id)", :conditions => ["project.id = ?", args[0]]}}

  named_scope :with_project_name, lambda {|*args| {:joins => "JOIN nd_experiment_phenotype USING (phenotype_id) JOIN nd_experiment_project USING (nd_experiment_id) JOIN project USING (project_id)", :conditions => ["project.name = ?", args[0]]}}


  named_scope :limit, :limit => 100

#  validates_uniqueness_of :uniquename 

def as_json(options = {})
  { 
    :id => phenotype_id,
    :uniquename => uniquename,
    :observable => observable.as_json,
    :attribute => attr.as_json,
    :value => value,
    :cvalue => cvalue.as_json
  }
end

#  def to_json(options={})
#    {
#   if options.empty?
#     super(:only => [:uniquename, :phenotype_id, :value], :include => {:observable => {:only => :name, :include => {:dbxref => {:only => :accession} } } })
#   else
#     super
#   end
#    }
#  end


end
