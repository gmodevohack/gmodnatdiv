class PhenotypeCvterm < ActiveRecord::Base

    belongs_to :phenotype, :class_name => 'Phenotype', :foreign_key => :phenotype_id
    belongs_to :cvterm, :class_name => 'Cvterm', :foreign_key => :cvterm_id
    
end
