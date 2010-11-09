class FeatureRelationshipPub < ActiveRecord::Base
    belongs_to :feature_relationship, :class_name => 'FeatureRelationship', :foreign_key => :feature_relationship_id
    belongs_to :pub, :class_name => 'Pub', :foreign_key => :pub_id
    
end
