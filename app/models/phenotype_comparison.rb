class PhenotypeComparison < ActiveRecord::Base
    belongs_to :pub, :class_name => 'Pub', :foreign_key => :pub_id
    belongs_to :organism, :class_name => 'Organism', :foreign_key => :organism_id
    has_many :phenotype_comparison_cvterms , :foreign_key => :phenotype_comparison_id
    has_many :pubs 
    has_many :cvterms 
    
end
