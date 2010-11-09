class FeaturePhenotype < ActiveRecord::Base
    belongs_to :feature, :class_name => 'Feature', :foreign_key => :feature_id
    belongs_to :phenotype, :class_name => 'Phenotype', :foreign_key => :phenotype_id
    
end
