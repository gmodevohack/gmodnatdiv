class FeatureCvtermprop < ActiveRecord::Base
    belongs_to :feature_cvterm, :class_name => 'FeatureCvterm', :foreign_key => :feature_cvterm_id
    
end
