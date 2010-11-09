class FeaturepropPub < ActiveRecord::Base
    belongs_to :featureprop, :class_name => 'Featureprop', :foreign_key => :featureprop_id
    belongs_to :pub, :class_name => 'Pub', :foreign_key => :pub_id
    
end
