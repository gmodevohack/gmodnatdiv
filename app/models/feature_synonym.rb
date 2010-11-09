class FeatureSynonym < ActiveRecord::Base
    belongs_to :synonym, :class_name => 'Synonym', :foreign_key => :synonym_id
    belongs_to :feature, :class_name => 'Feature', :foreign_key => :feature_id
    belongs_to :pub, :class_name => 'Pub', :foreign_key => :pub_id
    
end
