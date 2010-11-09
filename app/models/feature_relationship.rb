class FeatureRelationship < ActiveRecord::Base
    has_many :feature_relationship_pubs , :foreign_key => :feature_relationship_id
    has_many :pubs 
    has_many :feature_relationshipprops , :foreign_key => :feature_relationship_id

  belongs_to :parent, :class_name => "Feature"
  belongs_to :child, :class_name => "Feature"

  set_table_name "feature_relationship"
  set_primary_key "feature_relationship_id"

end
