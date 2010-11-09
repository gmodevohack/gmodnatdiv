class PhenotypeComparisonCvterm < ActiveRecord::Base
    belongs_to :phenotype_comparison, :class_name => 'PhenotypeComparison', :foreign_key => :phenotype_comparison_id
    belongs_to :cvterm, :class_name => 'Cvterm', :foreign_key => :cvterm_id
    belongs_to :pub, :class_name => 'Pub', :foreign_key => :pub_id
    
end
