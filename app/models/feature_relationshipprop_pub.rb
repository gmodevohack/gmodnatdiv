class FeatureRelationshippropPub < ActiveRecord::Base
    belongs_to :feature_relationshipprop, :class_name => 'FeatureRelationshipprop', :foreign_key => :feature_relationshipprop_id
    belongs_to :pub, :class_name => 'Pub', :foreign_key => :pub_id
    
end
