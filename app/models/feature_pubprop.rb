class FeaturePubprop < ActiveRecord::Base
    belongs_to :feature_pub, :class_name => 'FeaturePub', :foreign_key => :feature_pub_id
    
end
