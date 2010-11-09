class FeatureRelationshipprop < ActiveRecord::Base
    belongs_to :feature_relationship, :class_name => 'FeatureRelationship', :foreign_key => :feature_relationship_id
    has_many :feature_relationshipprop_pubs , :foreign_key => :feature_relationshipprop_id
    has_many :pubs 
    
end
