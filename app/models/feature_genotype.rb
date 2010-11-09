class FeatureGenotype < ActiveRecord::Base
    belongs_to :feature, :class_name => 'Feature', :foreign_key => :feature_id
    belongs_to :genotype, :class_name => 'Genotype', :foreign_key => :genotype_id
    belongs_to :cvterm, :class_name => 'Cvterm', :foreign_key => :cvterm_id
    
end
