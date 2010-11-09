class FeaturelocPub < ActiveRecord::Base
    belongs_to :featureloc, :class_name => 'Featureloc', :foreign_key => :featureloc_id
    belongs_to :pub, :class_name => 'Pub', :foreign_key => :pub_id
    
end
