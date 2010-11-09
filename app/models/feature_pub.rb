class FeaturePub < ActiveRecord::Base
    belongs_to :feature, :class_name => 'Feature', :foreign_key => :feature_id
    belongs_to :pub, :class_name => 'Pub', :foreign_key => :pub_id
    has_many :feature_pubprops , :foreign_key => :feature_pub_id
    
end
