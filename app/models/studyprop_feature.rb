class StudypropFeature < ActiveRecord::Base
    belongs_to :studyprop, :class_name => 'Studyprop', :foreign_key => :studyprop_id
    belongs_to :feature, :class_name => 'Feature', :foreign_key => :feature_id
    
end
