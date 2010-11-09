class FeatureCvtermPub < ActiveRecord::Base
    belongs_to :feature_cvterm, :class_name => 'FeatureCvterm', :foreign_key => :feature_cvterm_id
    belongs_to :pub, :class_name => 'Pub', :foreign_key => :pub_id
    
end
