class Featurepos < ActiveRecord::Base
    belongs_to :featuremap, :class_name => 'Featuremap', :foreign_key => :featuremap_id
    belongs_to :feature, :class_name => 'Feature', :foreign_key => :feature_id
    
end
