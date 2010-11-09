class FeaturemapPub < ActiveRecord::Base
    belongs_to :featuremap, :class_name => 'Featuremap', :foreign_key => :featuremap_id
    belongs_to :pub, :class_name => 'Pub', :foreign_key => :pub_id
    
end
